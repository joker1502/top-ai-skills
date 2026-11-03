---
title: "Caveman Deleted Its Own 65% Token Claim — Here Is the Eval"
date: 2026-11-03
draft: false
tags:
  - Productivity
  - Token
  - AI Agent
description: "The caveman skill ships its own eval. Measured against a plain 'Answer concisely.' control, caveman cuts 3% at the median — not 65%. Here are the real numbers."
version: "4.0.1"
author: "JuliusBrussee"
repo_url: "https://github.com/JuliusBrussee/caveman"
install_cmd: "curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh | bash"
compatibility:
  - Claude Code
  - Cursor
  - Codex
  - Windsurf
  - Cline
  - Copilot
category: "general"
rating: 4.0
github_stars: 117131
github_forks: 6807
installs: 607500
last_updated: "2026-11-03"
ai_friendliness:
  score: 5.0
  documentation: 5.0
  setup: 4.5
  config: 4.5
---

Somewhere along the way, every "save tokens with AI" listicle picked up the same fact: caveman cuts 65% of your bill. That number came from a hardcoded constant in the project's own statusline. The maintainer has since written it out of the code and out of the docs, then shipped an eval you can run yourself that says something far less exciting — 3% fewer output tokens at the median, measured against the two words "Answer concisely."

I pulled the repo on 2026-11-03 (117,131 stars, 16 entries in `skills/registry.json`), cloned the eval harness, and ran the committed snapshot through `evals/measure.py` to check the arithmetic myself. Everything below is either a number I reproduced locally or a line I read in the repo.

## The Scoreboard the Repo Publishes Now

Three arms, ten developer questions, one run per pair, `claude-opus-5-5`, tokens counted with `tiktoken o200k_base`. No system prompt at all costs 6,983 tokens across those ten answers. A plain "Answer concisely." control drops it to 4,334 — a 38% cut for free, before any skill loads.

Then the skills land on top of that control:

| Skill | Median vs terse | Mean | Worst prompt | Tokens (skill / terse) |
|---|---|---|---|---|
| ultracave | +35% | +38% | +27% | 2,693 / 4,334 |
| megacave | +9% | +14% | −12% | 3,683 / 4,334 |
| caveman | +3% | +5% | −16% | 4,119 / 4,334 |

Read the worst-prompt column twice. On at least one of the ten questions, plain `caveman` produced 16% *more* output than the two-word control. Standard deviation across prompts sits at 12%. So "up to 65%" was never a median, and it was never measured against a control that also asked for brevity.

`docs/HONEST-NUMBERS.md` states it without hedging: earlier stats releases "applied a fixed 65% output ratio without a committed reviewed result." Current releases ignore those `est_saved_*` fields. `/caveman-stats` still prints output and cache-read counts, and explicitly refuses to print savings — "the transcript has no measured comparison without Caveman."

## What It Actually Changes in a Session

The skill body is 4,678 bytes, roughly 1,158 tokens in `o200k_base`. It gets injected into every call while the skill stays active. I counted all three files: ultracave is 608 tokens, megacave 764.

Do that subtraction and the ranking inverts. Ultra saves about 1,641 output tokens per answer over the control and adds 608 input tokens. The flagship `caveman` saves about 215 output tokens per answer and adds 1,158. Output tokens usually bill higher than input, so 215 out against 1,158 in is a trade few people would take on a one-shot question. Long sessions with the skill body cached shift the math — and the maintainer's "when caveman loses" section points at issue #145, where a user measured a net loss on terse coding Q&A.

Three outside A/Bs get listed there too, each naming the version it tested. LemonCrow, 300 runs per arm on `claude-opus-4-8`: −44.1% billed output and **+0.06% total cost**. edubraqd across 662 Claude Code sessions found output was 0.3% of all tokens and caveman's net effect on the bill stayed inside ±0.2%. JetBrains ran 86 paired coding tasks and got 8.5% fewer output tokens with no measurable quality drop (p = 0.82). Every one of those is an output-token win and a rounding error on the invoice, because an agent run is mostly input and cache re-reads.

## Where the Real Compression Lives

If you want tokens back, response style is the wrong lever. `caveman-compress` is the right one, and its benchmark is measured in input: 33.2% total input reduction across five fixtures, 22.8% to 49.1% per file. It rewrites a memory file such as `CLAUDE.md` into caveman speak, keeps a human-readable backup out of the tree at `$XDG_DATA_HOME/caveman-compress/backups/`, and refuses filenames that look like secrets before it reads them. It also ships the file's text to a model provider, which the SKILL.md warns about in a blockquote at the top.

The rest of the registry is a different product than the hype describes. Sixteen skills, most of them engineering workflows rather than speech styles: `investigate-first`, `surgical-patch`, `verify-and-stop`, `lean-build`, `safe-refactor`, `migration`. `caveman-explore` reads repos read-only with compact file citations. `caveman-discover` labels every LLM call site in a codebase. The voice skill is the shop window, not the inventory.

Two quirks worth knowing before install. `ultracave` and `megacave` are reached as aliases, `/caveman ultra` and `/caveman wenyan`, and `megacave` writes in Classical Chinese with technical terms kept verbatim — that is the +9% median, and its −12% worst prompt is a real regression on at least one question. Rule 9 of the voice skill bans performing caveman: no "me think", no `Caveman:` prefix, no decorative tables. It is a terseness instruction wearing a costume, not a costume.

## Bottom Line

Install it for readable output, not for a smaller bill. The honest ceiling on the voice skill is a few percent at the median over asking plainly for brevity, with a couple of prompts going the wrong way. If your own A/B shows caveman costing more on your workload, turn it off — that is the maintainer's rule of thumb, printed at the bottom of the page he wrote to kill his own headline number.

Load the response skill when you want shorter answers. Reach for `caveman-compress` when you want fewer tokens, and check provider billing before believing any percentage.

Related: [cavecrew](/skills/general/cavecrew/) for the sub-agent side, and the [wait-what FAQ](/tutorials/guides/wait-what-skill-faq/) on why most brevity skills never fire when they should.
