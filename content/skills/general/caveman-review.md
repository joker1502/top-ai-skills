---
title: "caveman-review: One Line Per Finding, Measured Against Its Own Examples"
date: 2026-11-08
toc: true
draft: false
tags:
  - Code Review
  - Agent Skills
  - Token Efficiency
category: "general"
description: "caveman-review turns code review into one line per finding. I ran its own three examples through tiktoken: 95 tokens compress to 68, with two a wash."
version: "2.2.0"
author: "juliusbrussee"
repo_url: "https://github.com/juliusbrussee/caveman"
install_cmd: "curl -fsSL https://raw.githubusercontent.com/juliusbrussee/caveman/main/install.sh | bash"
compatibility:
  - Claude Code
  - Cursor
  - Codex
  - Windsurf
  - Cline
  - Gemini CLI
  - OpenCode
---

The review comment you get back is one line: `L42: 🔴 bug: user can be null after .find(). Add guard before .email.` No preamble, no "I noticed that", no closing summary of how the reviewer feels about your architecture. That format is the entire product.

I pulled the skill apart to see what the compression actually buys. Two findings stood out. The token savings are much smaller than the pitch implies — I measured 1.4x on the skill's own examples, and two of the three were token-neutral. The real gain lives somewhere else.

## What Ships: 640 Tokens and Two Rulebooks

`SKILL.md` is 2,515 bytes, roughly 640 `cl100k_base` tokens. Small enough that it does not crowd a long session, which matters more here than in a build skill — review runs happen mid-task, with a diff already eating context.

The rule body is four blocks. **Format** is `<line>: <problem>. <fix>.`, with a `<file>:L<line>:` variant for multi-file diffs. **Severity** adds an optional emoji prefix: 🔴 bug, 🟡 risk, 🔵 nit, or ❓ q — the last one for a real question rather than a suggestion. **Drop** kills the hedging phrases ("I noticed that", "It seems like", "You might want to consider") and tells you to say praise once at the top instead of per comment. **Keep** demands exact line numbers, exact symbol names in backticks, and a concrete fix rather than "consider refactoring".

Then the two guardrails. **Auto-Clarity** drops terse mode for three cases: security findings, architectural disagreements, and onboarding contexts where the author needs the why. **Boundaries** states the skill writes comments only — it does not produce the fix, does not approve or request changes, and does not run linters.

Now the part nobody mentions in the README. There are two entry points, and they encode different rules. `commands/caveman-review.toml` is the slash command, and its prompt says:

> One-line per finding. Format: L<line>: <severity> <problem>. <fix>. Severity: bug, risk, nit, q. Skip praise. Skip obvious. If code look good, say 'LGTM' and stop.

Read that against the skill body. The toml drops the emoji prefixes entirely, drops the `<file>:L<line>:` multi-file form, adds an "LGTM" short-circuit that `SKILL.md` never mentions, and carries no trace of Auto-Clarity or the boundaries. If you type `/caveman-review`, you get the toml's looser spec. If a model loads the skill from its description, you get the full one. Same skill, two behaviors, and the file you read is not always the file that runs. I wrote about the same split in [caveman-commit](/skills/general/caveman-commit/), where the slash command and the body disagree about commit capitalization.

## I Measured the Token Claim on Its Own Examples

The skill ships three before/after pairs to teach the format. I tokenized all six strings with `tiktoken`, `cl100k_base`.

| Example | Verbose | Terse | Ratio |
|:---|:---:|:---:|:---:|
| Null check on `.find()` result | 49 | 21 | 2.3x |
| 50-line function doing four things | 24 | 25 | 1.0x |
| Missing 429 retry | 22 | 22 | 1.0x |
| **Total** | **95** | **68** | **1.4x** |

The long-winded example compresses 2.3x because most of its bytes are throat-clearing — 49 tokens of "I noticed that... you might want to." The other two are a wash. And the reason is visible in the format itself: the compressed line has to keep the exact line number, the exact method name, and a concrete fix. Those are the expensive tokens. Everything the format deletes is cheap filler that a model can generate for free.

So what does the format buy, if not tokens? Scan cost. Three comments, three lines, one severity axis — a reviewer reads the block once and knows which two need action. The verbose versions cost 95 tokens and two re-reads because the actionable sentence sits second in each paragraph. That is a latency win for humans, not a budget win for the context window.

## The Emoji Costs More Than the Hedge You Deleted

A terse line with the severity prefix is 21 tokens; the same line without it is 19. The emoji itself tokenizes to 3 (❓ to 2). Add the prefix across nine findings and you have spent 18 tokens on colored dots.

Cheap, and worth it — one visual channel to sort by beats a word. But it undercuts the framing that this is an extreme compression skill. The real levers in the file are structural: one finding per line, exact locations, no restating the diff. Those save comprehension, and only incidentally tokens.

## When Terse Is the Wrong Answer

Auto-Clarity is the section I would keep if I could keep only one. Security findings get a full paragraph plus a reference, because a CVE-class bug read as `🔴 bug: unsanitized input` is a bug that ships. Architectural disagreements need rationale, not a one-liner — `🔵 nit: wrong layer` tells the author nothing they can act on. New contributors get the why.

The three exemptions map onto a rule I did not expect to find in a compression skill: compress the delivery, never the reasoning. `🟡 risk: no retry on 429. Wrap in withBackoff(3)` works because the reasoning is one inference away. Move two inferences away and the line becomes noise the author has to reverse-engineer.

## Where It Sits in the Family

On skills.sh, `caveman-review` shows 426.2K all-time installs as of 2026-11-08, with a weekly curve of 13,301 → 14,058 → 11,810 → 10,875 → 9,223 → 7,869 → 8,232 → 7,790. That is a 41% slide across eight buckets, and it tracks the pack: the day before, flagship `caveman` read 615.2K and `caveman-commit` 429.6K, all sliding on the same wave. The `registry.json` native pack lists `caveman-review` in `preserved_skill_ids` with a `core_prompt_token_budget` of 560 — the pack treats it as one of six load-bearing skills rather than an add-on.

## Install and First Use

The repo installs through its own shell installer, or copy `skills/caveman-review/SKILL.md` into your agent's skills directory if you want one skill without the pack. Then review a real diff and watch one thing: whether you reach for Auto-Clarity. If a security finding comes back as a single line, the skill is doing damage — the emoji-prefixed format is designed to be pasted straight into a PR, and a one-line security note gets merged.

Pair it with a reviewer that enforces the other direction. The [caveman-compress guardrails test](/tutorials/guides/caveman-compress-guardrails-tested/) covers what happens when the compression runs on your memory files instead of your comments.
