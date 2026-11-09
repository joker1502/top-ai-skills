---
title: "cavecrew: Three Subagents and the Contracts That Drift"
date: 2026-11-09
toc: true
draft: false
tags:
  - Agent Skills
  - Context Management
  - Delegation
category: "general"
description: "cavecrew delegates to three 400-token subagents. I measured the layer at 3,045 tokens and found its SKILL.md contracts disagree with the agent files."
version: "4.1.0"
author: "juliusbrussee"
repo_url: "https://github.com/juliusbrussee/caveman"
install_cmd: "curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/v4.1.0/install.sh | bash"
compatibility:
  - Claude Code
  - Codex
  - Gemini CLI
  - OpenCode
  - Aider
  - Hermes
---

A subagent does not save context by existing. It saves context when the thing it hands back is smaller than the thing you would have read yourself, and most delegation presets miss that detail entirely. `cavecrew` is built around exactly that detail, and reading its five files turned up something its README never mentions: the output contract in `SKILL.md` is not the contract the three agents actually follow.

## A Router That Costs More Than the Agents It Routes To

`cavecrew` is a decision guide, not a slash command. The repo has no `commands/cavecrew.toml` — `cavecrew` lives in `skills/` next to 28 siblings, and it is listed in `registry.json` under `preserved_skill_ids` for the v2.2.0 native pack. It activates when a conversation mentions delegation, spawning, or saving context.

I tokenized the whole layer with `cl100k_base`:

| File | Bytes | Tokens |
| --- | --- | --- |
| `skills/cavecrew/SKILL.md` | 4,021 | 1,016 |
| `skills/cavecrew/README.md` | 2,873 | 727 |
| `agents/cavecrew-investigator.md` | 1,640 | 477 |
| `agents/cavecrew-reviewer.md` | 1,601 | 441 |
| `agents/cavecrew-builder.md` | 1,478 | 384 |

3,045 tokens for the full layer. The odd part is the distribution. The router is 1,016 tokens and the three agents average 434 — the file describing *when* to delegate costs 2.3x the files that do the work. Only the router sits in your main context, so the effective load is the small number, but the table you actually pay for is heavier than the crew.

Three agents, three narrow jobs. `cavecrew-investigator` locates code and refuses to suggest fixes. `cavecrew-builder` takes a bounded edit of one or two files and hard-refuses three or more. `cavecrew-reviewer` produces one line per finding with a severity emoji and no architecture opinions. The routing table is honest about the alternatives: vanilla `Explore` when you want commentary, `Code Reviewer` when you want rationale, main thread for a one-line answer you already know.

## The Published Contract Is Looser Than the Real One

`SKILL.md` publishes output contracts — "what main thread can rely on per agent." I diffed them against the three agent files line by line. Four gaps, all of them the kind that break a parser rather than a human:

| Contract element | `SKILL.md` says | The agent file says |
| --- | --- | --- |
| Header | Always emits `<Header>:` | Only at 3+ rows; a single hit is one bare line, no header |
| Totals | Always emits `totals: <counts>.` | Omitted entirely when the count is 0 or 1 |
| Refusal tokens | Four bare words: `too-big.` / `needs-confirm.` / `ambiguous.` / `regressed.` | Each carries a required payload: `split:`, `op:`, `ask:`, `revert path:line. cause:` |
| Reviewer totals | Four fixed slots `N🔴 N🟡 N🔵 N❓` | The example drops zero counts: `totals: 1🔴 1🟡 1❓` |

Take the two-hit case. The investigator's own example answers a question with three grouped sections and closes `2 defs, 3 callers, 1 test file.` A two-hit answer, per the agent file, arrives as two bullet lines with no header above them and no totals below. Anyone who wrote a downstream check against the router's contract would see a malformed response that is, in fact, correct.

The refusal payloads matter more. `SKILL.md` lists `needs-confirm.` as terminal, which reads like the agent just stops. The agent file says it stops *with* the command it wanted to run: `needs-confirm. op: rm -rf build.` The difference between "it refused" and "it refused, here is what it wanted" is the difference between a dead end and a decision you can make in one turn.

One more guardrail that looks stricter than it is. The builder's prompt states "No `Bash` available — cannot shell out, cannot push, cannot delete." None of the three agent files declare a `tools:` key in their frontmatter — only `name`, `description`, and for two of them `model`. So nothing at the harness level removes Bash from the builder. The restriction lives in prose, and prose is a request. The reviewer's `Bash` limit ("only for `git diff`/`git log -p`/`git show`") rests on the same footing.

## Only the Cheap Model Gets Pinned

Frontmatter tells you where the author spent money. `cavecrew-investigator` and `cavecrew-reviewer` both carry `model: haiku`. `cavecrew-builder` carries no `model:` line at all, so it inherits whatever the session default is.

Read that as design, not oversight. Searching and reviewing are pattern work against a fixed output shape; editing a file with no context of its own needs the better model. The consequence is that two thirds of the crew runs cheap and the one agent that mutates your source runs at full price.

Overrides exist per agent and patch a single line:

```sh
export CAVECREW_REVIEWER_MODEL=sonnet
```

The README is precise about the mechanics: the override rewrites only the `model:` line in the *installed* agent frontmatter, the prompt body keeps receiving upstream updates, an empty variable does nothing, and the patch survives until the next plugin update or reinstall. Whether it does anything at all depends on your install path — only plugin installs leave local agent files to edit.

`tests/test_cavecrew_model_overrides.js` is where I found the part the docs skip. It has cases for replacing an existing model line, inserting one into the builder which has none, and rejecting values that are empty, whitespace-only, contain a newline, or carry a NUL byte. Someone got burned by `export CAVECREW_BUILDER_MODEL="sonnet "` before that test existed.

## cavecrew vs the Vanilla Agents It Replaces

| Situation | `cavecrew` | Vanilla |
| --- | --- | --- |
| "Where is X defined, what calls Y" | `cavecrew-investigator`, `path:line` table | `Explore` with prose |
| Surgical edit, 1–2 files, scope obvious | `cavecrew-builder` + receipt | main thread |
| Feature work, 3+ files, cross-cutting refactor | refuses (`too-big.`) | main thread or architect agent |
| "Review this diff for bugs" | `cavecrew-reviewer`, one line per finding | `Code Reviewer` with rationale |
| "Give me your take on this architecture" | not supported, by design | `Code Reviewer` |

The skill states its own heuristic as a ratio: pick cavecrew "if you'd want the subagent's output in 1/3 the tokens." The README, same repo, says the opposite thing in a sentence worth quoting: "This skill publishes no universal reduction rate." Both statements are load-bearing. The ratio is a routing rule for the model reading the table; the disclaimer is what keeps the repo from claiming a benchmark it never ran. If you cite a number to your team, cite the second one.

The other honest note is the one about absence claims. `SKILL.md` warns against accepting `No match.` or `No issues.` without one targeted check of the file or diff. A compressed reviewer that finds nothing produces a single reassuring token, and a single reassuring token is exactly what a wrong answer looks like.

## What to Do With It

Install it if you already delegate and want the returns compressed. Skip it if your subagent output goes to a human — terse `path:line` tables are miserable to read as prose, and the skill says so itself.

Two moves on first install. Read `agents/cavecrew-investigator.md` rather than the router, since that file is the real contract. Then add a `tools:` line to `cavecrew-builder.md` if your harness honors it, so "cannot shell out" becomes a fact instead of a request.

The rest of the family is covered elsewhere on this site: [caveman-review](/skills/general/caveman-review/) for the one-line review format, [caveman-compress guardrails](/tutorials/guides/caveman-compress-guardrails-tested/) for the compression side, and [caveman itself](/skills/general/caveman/) for the output style all three agents speak.
