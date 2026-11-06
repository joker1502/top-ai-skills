---
title: "caveman-commit: 200 Commits Tested Against Its Own Rules"
date: 2026-11-06
toc: true
draft: false
tags:
  - Commit Hygiene
  - Git
  - Agent Skills
category: "general"
description: "caveman-commit ships 2,371 bytes of commit rules. I ran them over the repo's own 200 commits: types hold 99%, but one subject in five breaks the 72-char cap."
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

`caveman-commit` writes the commit message and stops there. No staging, no `git commit`, no amend — it hands you a paste-ready block and gets out. The rules behind it fit in 2,371 bytes, which is the whole point: a style guide small enough to survive a long session without being skimmed.

I wanted to know whether those rules survive contact with real work. So I cloned the repo that ships the skill and ran each rule over its last 200 non-merge commits. The answer is uneven in a useful way. Type prefixes hold almost perfectly. Line-length discipline does not.

## What Actually Ships in the Skill

The skill folder is three files: `SKILL.md` at 2,371 bytes, a 1,226-byte `README.md`, and a slash-command definition at `commands/caveman-commit.toml` that compresses the same intent into one prompt line.

The instruction body is a spec, not a personality. Eleven Conventional Commit types. Imperative mood — "add", not "added". Fifty characters as the target, seventy-two as a hard cap. Body wrapped at 72, hyphen bullets, `Closes #42` and `Refs #17` at the end. A never-list: no "This commit does X", no "I", no "we", no "now", no "currently", no emoji, no restating the filename when the scope already says it.

Two passages carry more weight than the rest. **Auto-Clarity** overrides the terse default for four cases — breaking changes, security fixes, data migrations, and reverts — and says outright never to compress those to a subject line. **Boundaries** closes the loop: the skill describes the message only, never runs git, and "stop caveman-commit" puts the agent back in verbose mode.

One inconsistency worth knowing. The toml command says commit subjects should be "lowercase after type". The SKILL.md body says "match project convention for capitalization after the colon". Same repo, two different answers, and only one of them is the rule you get depending on whether you invoke the slash command or let the model read the skill.

## I Ran the Rules Against 200 Real Commits

Here is the repo's own log as of 2026-11-06, checked rule by rule with a small script over `git log --no-merges -n 200`.

| Rule in SKILL.md | What the log shows |
|:---|:---|
| Conventional type prefix | 198 of 200 (99%) |
| Scope in parentheses | 191 of 200 (95.5%) |
| Subject ≤ 50 chars ("when possible") | 41 of 200 (20.5%) |
| Subject ≤ 72 chars ("hard cap") | 160 of 200 (80%) — 40 commits over, longest 94 |
| Body only when the why isn't obvious | 192 of 200 (96%) carry a body |
| Body wrapped and short | Mean 1,016 chars, median 803, 81 bodies past 1,000, longest 4,374 |
| No AI attribution | 135 of 200 carry `Co-Authored-By: Claude Opus 5.5` |
| No emoji | 0 |
| No trailing period | 0 |
| Imperative opening | 0 past-tense openers |
| Opener capitalization | 199 lowercase, 0 uppercase |

The pattern is not carelessness. Look at what holds: everyone types their commits, everyone scopes them, nobody writes "Fixed the thing." and nobody ends with a period. Those are the rules you can check in two seconds at the terminal.

What slips is everything that costs a rewrite. Squeezing a subject from 74 characters to 48 means dropping the qualifier that makes the commit findable later, so people keep the qualifier. `fix(installer): unlink partial dest file on oversized-body and timeout` is 74 characters and exactly right; trimming it to fit a target would make the message worse. The 72-char "hard cap" gets treated the same way — as a preference.

Bodies tell the same story from the other side. The skill says skip the body when the subject is self-explanatory, then adds "why over what". In practice nearly every commit has a body, because the why is rarely obvious six months later. One body runs 4,374 characters explaining which triage findings were defects (#1350) and why. That is the skill's Auto-Clarity instinct applied to ordinary fixes, without the skill needing to say so.

The attribution row is the one to watch in your own repo. 135 commits carry a Claude co-author trailer, and the skill's instruction is to omit AI attribution unless the user's own rule requires it as a trailer. Nothing in the repo's AGENTS.md, CLAUDE.md, or CONTRIBUTING.md asks for the trailer. The tool appends it and the humans leave it — which is a reasonable policy, just not the one written down. If you install this skill expecting clean authorship lines, check whether your harness injects them.

## Where It Sits in a 23-Folder Skill Family

`caveman-commit` is one of 23 skill folders in the repo, and one of only eight that appear on today's skills.sh leaderboard. The install numbers say a lot about how people adopt this family: they take the flagship and stop.

| Skill | Installs | Weekly, first bucket → last |
|:---|:---|:---|
| caveman | 613.6K | 18,867 → 11,908 |
| **caveman-commit** | **428.8K** | **13,593 → 7,804** |
| caveman-compress | 425.8K | 13,406 → 8,294 |
| caveman-review | 424.8K | 13,301 → 7,790 |
| caveman-help | 415.5K | 12,986 → 7,652 |
| cavecrew | 371.5K | 12,812 → 7,538 |
| caveman-stats | 371.1K | 12,874 → 7,550 |

Every row is falling. caveman-commit dropped 43% across eight weekly buckets, and it is not an outlier — the spread between the top and bottom of that table is 242K installs, but the weekly curves move together. One release wave, one audience, one direction.

The packaging detail matters more than the ranking. `skills/registry.json` lists caveman-commit under `preserved_skill_ids` alongside cavecrew, caveman-compress, caveman-help, caveman-review, and caveman-stats, inside a native pack at version 2.2.0 with a core prompt budget of 560 tokens. The six preserved IDs are the stable surface; the rest of the folders belong to the native pack and get recompiled. So this skill is not a side project inside a big repo — it's one of the six things the maintainer promises to keep.

## How to Use It Without Getting Burned

Point the agent at your staged diff and ask for a commit message. Read the block before you paste it. Two checks catch almost every bad output: does the subject survive the 72-character cap, and does the body explain a why the diff cannot show? If the answer to the second is no, delete the body — the skill would have skipped it, and the model padded it.

Three practical notes from the measurement above. Your log will drift toward longer subjects and longer bodies than the spec allows, and that drift is usually correct — the cap exists to stop rambling, not to ban qualifiers. Second, the Auto-Clarity list is the part that earns the skill's keep: for a revert or a migration, the body is the only record of why, and the skill forces it. Third, verify attribution behavior in your harness, because the trailer you get is a tool default, not a skill rule.

If you want the reading behind the style — why the same repo deleted its own 65% token-savings claim — that story is in the [caveman skill breakdown](/skills/general/caveman/). And if you are writing skills of your own, the [skill authoring walkthrough](/tutorials/guides/how-to-create-your-own-ai-agent-skills/) covers the file layout these folders all share.

Install it with the repo's installer, then run `/caveman-commit` on your next staged change and measure the message against the table above. That takes one commit to learn more than the README will tell you.
