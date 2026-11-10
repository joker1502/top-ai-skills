---
title: "caveman-help: Four Skills on the Card, 22 in the Repo"
date: 2026-11-10
toc: true
draft: false
tags:
  - Agent Skills
  - Context Management
  - Prompt Engineering
category: "general"
description: "caveman-help costs 708 tokens and lists four skills. The repo ships 22 SKILL.md files, and the installer only lands nine of them on your host. Here is the gap."
version: "2.2.0"
author: "juliusbrussee"
repo_url: "https://github.com/JuliusBrussee/caveman"
install_cmd: "curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/v4.1.0/install.sh | bash"
compatibility:
  - Claude Code
  - Codex
  - Gemini CLI
  - OpenCode
  - Aider
  - Hermes
---

`caveman-help` is the cheapest way to find out what the caveman pack does, and it is also the most out of date document in the repository. I tokenized it at 708 tokens, then walked `skills/`, `registry.json` and `installer/install.js` to see what it leaves out. The card lists four skills. The repository ships twenty-two.

That is not a bug report about a typo. It is a map that stops at the first generation of a tool that has since grown three layers, and the layers it never mentions are the ones with real per-session cost.

## What the Card Actually Ships

The file is 2,771 bytes and behaves like a printed reference: show it, change nothing, persist nothing. Its own first paragraph is the strictest part — "One-shot — do NOT change mode, write flag files, or persist anything."

Three modes get a table: `caveman` (default, every fact kept), `ultracave` (grammar stripped), `megacave` (文言文, fewer characters, technical terms verbatim). Then four skills: commit, review, compress, help itself. Then a deactivate line, a language rule, and the config resolution order — env var, repo config, user config, built-in default, with `off` and `manual` as startup policies rather than modes.

One detail the card never explains: the pack's frontmatter draws a hard line between modes and everything else. `skills/ultracave/SKILL.md` (2,513 bytes, 608 tokens) and `skills/megacave/SKILL.md` (2,858 bytes, 764 tokens) both set `disable-model-invocation: true`, and their descriptions say "Invoke only with /ultracave or /caveman ultra." None of the other seven frontmatter files in the pack sets that flag — not `caveman`, not `caveman-commit`, not `caveman-compress`, not `caveman-review`, not `cavecrew`, not `caveman-stats`, and not `caveman-help`. Modes are user-only; every skill around them, the reference card included, can be model-invoked.

## Four on the Card, Twenty-Two in the Tree

`skills/` holds 24 directories. Two of them — `generated/` and `native/` — are not skills; the other 22 each carry a `SKILL.md`. `registry.json` splits them into two groups that never appear on the card:

| Layer | Count | Members |
| --- | --- | --- |
| `preserved_skill_ids` | 6 | `cavecrew`, `caveman-commit`, `caveman-compress`, `caveman-help`, `caveman-review`, `caveman-stats` |
| `skills[]` with `delivery: cli` or `cli+web` | 10 | `caveman`, `caveman-discover`, `caveman-explore`, `caveman-learn`, `caveman-manage`, `caveman-optimize`, `caveman-evidence-review`, `caveman-setup`, `ultracave`, `megacave` |
| `skills[]` with `delivery: native` | 6 | `investigate-first`, `lean-build`, `migration`, `safe-refactor`, `surgical-patch`, `verify-and-stop` |

The card documents the four prompt-facing members of group one and stops. `cavecrew` and `caveman-stats` share that group and get no line at all, and the sixteen registry entries get nothing either.

The installer makes the split concrete. `HERMES_SKILL_DIRS` and `OPENCODE_SKILL_DIRS` are the same nine-entry array: `caveman`, `ultracave`, `megacave`, `caveman-commit`, `caveman-review`, `caveman-help`, `caveman-stats`, `caveman-compress`, `cavecrew`. Nine files land on disk as invocable skills. The other thirteen reach you through the `cli` or `native` delivery channel instead, which is why the card reads like an inventory even though it is really a subset.

Cost of the six `native` skills is the interesting part. They do not ship as separate files on hosts that take the native pack; they collapse into `skills/native/native-core.md`, which measures 1,667 bytes and 303 tokens against a declared `core_prompt_token_budget` of 560. Six workflow rules for 54% of the stated budget.

## Where the Card Is Right, and Where It Goes Quiet

The compress line is the card's only hard number: "33.2% fewer tokens on the repo's five test files." I checked it against `docs/HONEST-NUMBERS.md`, which states 33.2% total input reduction across five fixtures, 22.8% to 49.1% per file, measured with `tiktoken` `o200k` and reproducible via `skills/caveman-compress/scripts/benchmark.py`. The card quotes the honest figure, not the inflated one the older marketing copy used. Credit where due.

Then it goes silent exactly where users get burned. `/caveman-stats` exists, has its own `commands/caveman-stats.toml`, and its own skill description, but the card never mentions it. That matters because it is the skill that answers "how much did caveman actually save me" — and its answer is no:

> Savings are unknown: the transcript has no measured comparison without Caveman. Do not infer saved tokens, percentages, dollars, rule overhead, or a net result from output counts or the current mode.

So the card sells a compression feature, omits the tool that measures it, and that tool refuses to report savings. Anyone who installs help and stops there will believe a number the pack's own docs disown.

There is a second gap in the command layer. `commands/` ships seven TOML files — `caveman`, `ultracave`, `megacave`, `caveman-commit`, `caveman-review`, `caveman-stats`, `caveman-init`. No `caveman-help.toml` and no `caveman-compress.toml`. On Claude Code the pack installs through `claude plugin install` and picks up skills from the plugin bundle, so both still work; but if you are wiring the pack into a host that reads command files only, the card's own trigger is the one with no command behind it.

| Card claim | Repo fact |
| --- | --- |
| "Quick-reference for the three caveman skills" | 22 `SKILL.md` files, 9 installed as host skills |
| 3 modes listed | 3 modes, 2 of them shipped as skills with `disable-model-invocation: true` |
| 4 skills listed | 6 preserved + 16 registry entries |
| Compress saves 33.2% | 33.2% total, 22.8–49.1% per file, `o200k`, five fixtures |
| No stats mention | `caveman-stats` 1,964 bytes, 404 tokens, ships its own command |
| Trigger `/caveman-help` | No `caveman-help.toml` in `commands/` |

## What I Would Do With It

Read the card first, because the mode table and the config resolution order are correct and compact. Then treat it as a doorway, not a manifest: run `ls skills/` after install and you will see twenty-two names the card never told you about.

For the compression workflow specifically, pair it with the [guardrail test](/tutorials/guides/caveman-compress-guardrails-tested/) that shows which validator failures are warnings and which actually stop the write, and read [caveman-review](/skills/general/caveman-review/) if you want the token math on what the pack's terse output style really buys. The family is cheap per file — nothing here costs more than 1,344 tokens — but 419.3K installs on a 708-token card that lists four of twenty-two files is how people end up running a quarter of the tool they downloaded.

The card is accurate about what it covers. The problem is what it stops covering, and no line in the document tells you the map ends early.
