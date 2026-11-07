---
title: "caveman-compress: Guardrails Tested Against a Local Stub"
date: 2026-11-07
toc: true
draft: false
tags:
  - Token Efficiency
  - Agent Skills
  - Testing
category: "guides"
description: "I pointed caveman-compress at a local stub endpoint and ran its guardrails. Secrets refused, code masked, but a dropped bullet only warns — and then ships."
---

caveman-compress rewrites a memory file like CLAUDE.md into terse "caveman" English to cut input tokens, and it ships real safety rails: a secret denylist, credential scanning, code-block masking, and a validator that can refuse to overwrite. I wanted to know whether those rails hold, without spending a token finding out. So I gave it a fake model.

The trick: the skill supports any OpenAI-compatible endpoint, so a 40-line stub server on `127.0.0.1:8899` can stand in for the LLM. Every guardrail runs. Only the "compression" is canned — which is fine, because I was testing the guards, not the prose quality.

## Step 1: wire it to a stub, spend nothing

```
XDG_DATA_HOME=/tmp/xdg \
CAVEMAN_COMPRESS_PROVIDER=openai-compat \
CAVEMAN_COMPRESS_MODEL=stub-model \
CAVEMAN_COMPRESS_ENDPOINT=http://127.0.0.1:8899/v1 \
python3 -m scripts /path/to/CLAUDE.md
```

Two things worth pinning down before you run it. The provider default is `claude` — the Claude Code CLI, not an API key — so on a machine without that binary every run dies at `❌ Error: claude CLI not found on PATH`. And `XDG_DATA_HOME` matters: backups land outside the source tree on purpose, so skill auto-loaders don't re-ingest the `.original.md` copy as a live file.

My stub logged every prompt and replied from a control file. That log turned out to be the most interesting artifact in the whole exercise.

## Step 2: what it refuses before reading a byte

Nine files, one run each. Results, verbatim:

| File | Detected | Outcome |
|:--|:--|:--|
| `.env` | — (refused first) | `Refusing to compress … filename looks sensitive` |
| `aws.md` with an `AKIA…` key on line 4 | natural_language | `line 4 looks like a AWS access key` |
| `placeholder.md` with `$OPENAI_API_KEY` and `sk-...` | natural_language | proceeded to the provider |
| `main.py` | code | `Skipping: file is not natural language` |
| `CMakeLists.txt` | code | skipped, despite the `.txt` suffix |
| `.cursorrules` | natural_language | proceeded |
| `journal.rtf` | unknown | skipped |
| extensionless file holding JSON | config | skipped |
| extensionless file holding prose | natural_language | proceeded |

The order of checks is the whole design. Filename refusal fires before file-type detection, because detection reads extensionless files to sniff them — the code comment says so explicitly. Credential scanning fires after the read but before any network call, and reports the line number without echoing the match.

`CMakeLists.txt` skipping is the detail I did not expect. A bare-basename list (`cmakelists.txt`, `dockerfile`, `makefile`, `gemfile`, `justfile`…) is checked before extension rules, so a prose-content file with a code name never gets compressed.

And the placeholder case is deliberate precision over recall. `sk-...` and `$OPENAI_API_KEY` are shapes you find in every setup guide; the credential patterns want `sk-` followed by 40+ characters, or a real `AKIA` + 16 uppercase. False positives on documentation were judged worse than a miss.

## Step 3: what actually leaves the machine

The SKILL.md warning says compression "sends the file's full text to the model provider". My stub's log says otherwise:

```
## Install

@@CAVEMAN_PRESERVED_CODE_0_3b237bca3b6100f5@@

See https://example.com/docs/setup for the full guide, and open `src/config.yaml` when the build fails.
```

The fenced `bash` block was replaced by a hash marker before the request left. `mask_code_blocks()` swaps fenced blocks, four-space-indented blocks, block-level HTML comments and `<!-- nocompress -->` regions for opaque line markers, then restores them after the model replies. Your install commands and config dumps do not go to the provider on the compress call.

They do go on the fix call. When validation fails, `build_fix_prompt()` carries the body unmasked so the model can restore what it dropped — and the repair is then checked with `any(block.rstrip("\n") not in fixed_body ...)`, so a fix that paraphrases a code block gets thrown away.

If your CLAUDE.md is mostly commands and configuration, the "data leaves the machine" warning overstates what ships. If it is mostly prose with secrets typed into it, the warning understates the risk.

## Step 4: the validator's severity is uneven, and one hole is real

Six validators run on every candidate. Their severities are not the same, and the difference decides whether your file gets overwritten:

| Check | Failure severity | Message |
|:--|:--|:--|
| Headings — count | error | `Heading count mismatch: 2 vs 1` |
| Headings — text or order | error | `Heading text/order changed: lost=[…]` |
| Headings — level only | warning | `Heading levels changed` |
| Code blocks | error | `Code blocks not preserved exactly` |
| URLs | error | `URL mismatch: lost={…}, added={…}` |
| File paths | error | (never a warning, per the docstring) |
| Inline code — lost | error | `Inline code lost: {…}` |
| Inline code — added | warning | `Inline code added: {…}` |
| **Bullets** | **warning** | **`Bullet count changed too much: 3 -> 2`** |

I fed it a compression that dropped one of three bullets. Threshold is a relative change above 15%; losing one of three is 33%. Output:

```
Validation attempt 1
Validation passed
   ⚠️ Bullet count changed too much: 3 -> 2

Compression completed successfully
```

Passed. Wrote the file. The bullet is gone, permanently, and the tool called it a success. Bullets are how most CLAUDE.md files carry their actual rules, so this is the one failure mode I would not ship: either promote the warning to an error for large drops, or refuse the write when bullets are lost and the file is a rules file.

Heading discipline, by contrast, is tight. Renaming `# Configuration Options` to `# Config` is an error, not a warning — the comment explains why: every in-document anchor points at a heading's slug, so a rename breaks all of them silently. That fix came from a real bug where a run renamed every heading and still reported "Validation passed".

## Step 5: when it does fail, your file survives

Dropping the `## Install` heading entirely produced a hard failure and a repair attempt:

```
Validation attempt 1
❌ Validation failed:
   - Heading count mismatch: 2 vs 1
Fixing with openai-compat...
❌ Fix attempt aborted: output changed a preserved code or <!-- nocompress --> block.
   Skipping this attempt.

Validation attempt 2
❌ Validation failed:
   - Heading count mismatch: 2 vs 1
Failed after retries: original left untouched
```

Exit code 2, source file byte-identical to before, and the backup it had written was deleted on the way out — so a later retry is not blocked by a stale `.original.md`. Successful runs exit 0. Provider errors exit 1 and leave the source alone.

The backup path is worth knowing: `$XDG_DATA_HOME/caveman-compress/backups/run1-2cc532c1ac0f/CLAUDE.original.md`. Parent directory name plus a hash, not the old parent-name-only scheme that let two same-named files on one machine collide.

One residue: the lock file stays behind. `$XDG_DATA_HOME/caveman-compress/locks/d535a1a70c303f3b.lock` was still on disk after both the success and the failure. Harmless — the lock is an advisory `flock` on the file descriptor, and the next run reuses it — but it does mean the directory accumulates one file per path you have ever compressed.

## What I'd change before pointing it at a real CLAUDE.md

Three things, in order.

Read your backup location once and confirm it is not inside a synced folder — the whole point is to keep the original out of the loader path.

Run it on a copy first. Not because the tool is fragile, but because the bullet path above will happily delete a rule with a warning as its only trace.

And prefer a provider you control. The `openai-compat` path works with Ollama, llama.cpp, vLLM and LM Studio as well as a stub, which turns "compress my memory file" from an API spend into a local job you can re-run until validation passes.

For the token-economics side of the same family, [caveman-commit](/skills/general/caveman-commit/) applies the same terse style to git messages and holds up better under audit. If you are building the skill side rather than compressing the output, [skill-creator](/skills/general/skill-creator/) ships Anthropic's validator and packaging loop.
