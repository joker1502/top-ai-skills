---
title: "Lark Skills Roundup: Slides XML, Task GUIDs, Whiteboard CLI, OKR Locks, Minutes Shim"
date: 2026-09-30
draft: false
toc: true
tags:
  - Lark
  - Feishu
  - Agent Skills
category: "guides"
description: "Five Feishu lark skills, read from their files: a 15-line shim, task GUID traps, slides XML gates, whiteboard npm deps, OKR score locks — 718–738K installs."
---

Feishu's lark family still has five skills this site had not cracked open, so I read every file in the repo and scraped skills.sh on 2026-09-30. The pack counters sit at **737.4K–737.8K installs for lark-minutes, lark-slides, lark-task, and lark-whiteboard (all first seen Apr 14 2026), with lark-okr lagging at 718.1K (first seen Apr 17)**. Weekly installs locked step again: across all eight buckets the five track in an 81–229 spread, tightest on the oldest week — the pack-counter signature lark-im, lark-sheets, and lark-base showed earlier. The file sizes tell the real story — a 464-byte shim next to a 27.8KB XML protocol — so here is what each one actually forces an agent to do.

## The 15-Line Shim: lark-minutes

[lark-minutes](https://github.com/larksuite/cli/tree/main/skills/lark-minutes) is the thinnest file in the family: 15 lines, 464 bytes of frontmatter and a routing note. Its description says use it only when the user or an upstream config explicitly names `lark-minutes`; everything else routes to [lark-meeting](/tutorials/guides/lark-meeting-skill-faq/). The body demands a full read of `../lark-meeting/SKILL.md` and execution per that skill's routing. Same compatibility pattern as lark-vc-agent's 466-byte shim — the family keeps old names alive as pointers, not copies. If your config references lark-minutes and you see "Minutes" versus "Notes" confusion, the answer is in the meeting skill, not here: `minute_token` is its own entity, and local audio can generate Minutes without any meeting attached.

## Task GUIDs and the Search-Vs-List Trap: lark-task

[lark-task](https://github.com/larksuite/cli/tree/main/skills/lark-task) (v2, 13.6KB) opens with a progressive-discovery rule: never construct a `+verb` from guesswork. Match the intent against the shortcut table; no match means `lark-cli task --help`, then the exact token, then `schema` before any call. An `unknown_subcommand` error means stop guessing and re-discover.

Two traps will bite automation. First, the `guid` used by every update/complete/assign call is the global unique identifier — the one in the `guid=` query of a task applink — **not** the displayed task number (`t104121`, `suite_entity_num`). Feed the display number to `+update` and you touch the wrong object. Second, `+search` does not judge relevance to the caller: "search my tasks" needs the current user's `open_id` resolved and passed explicitly as `--assignee`, `--creator`, or `--follower`, or you get everyone's matches. Scope words are not queries either — "tasks this year" is a list scope (`+get-my-tasks` / `+get-related-tasks`), not a full-text search, and time expressions must never become the `query` value. The skill even arbitrates the word "todo": if the context is a meeting transcript or a `minute_token`, `minutes +todo` belongs to lark-meeting and `task +create` is forbidden. One more rule: `repeat_rule` and `reminder` only exist when `due` is set, and `start` must be ≤ `due`.

## Slides Runs on an XML Protocol: lark-slides

[lark-slides](https://github.com/larksuite/cli/tree/main/skills/lark-slides) (v1, 27.8KB, 310 lines) is the heavyweight — the skill tells you to read it twice. Slides live on a 960×540 canvas and editing means writing slide XML: `references/xml/slides_xml_schema_definition.xml` is the only protocol authority. New decks and large rewrites require a `.lark-slides/plan/<deck>/slide_plan.json` planning artifact first, and every `<slide>` XML must pass `scripts/xml_lint.py` with `summary.error_count === 0` before any API call.

The edit verbs map to damage levels: `+replace-slide` does block-level replace/insert without touching page order; `+update-slide` overwrites an entire page — anything missing from `--content` is **deleted**. Images must be uploaded Drive `file_token`s; raw `http(s)` URLs render as broken images because the slides renderer never proxies external links, and media tops out at 20MB with no chunking. History revert accepts `history_version_id`, never `revision_id`, and wiki links (`/wiki/TOKEN`) resolve to an `obj_token` that must pass an `obj_type == "slides"` check. Two routing quirks stand out: a `doubao.com` `/slides/` URL is handled by this skill — routing keys on the path pattern and token, not the domain — and gradients must use `rgba()` with stops, because `rgb()` or missing stops silently fall back to white. Emoji are banned on every slide.

## Whiteboard Brings Its Own npm Package: lark-whiteboard

[lark-whiteboard](https://github.com/larksuite/cli/tree/main/skills/lark-whiteboard) (v1.0.0, 3.1KB) is the only lark skill with a second runtime dependency: before anything, it makes you verify `npx -y @larksuite/whiteboard-cli@^0.2.13 -v` alongside `lark-cli`. The decision table splits read-only from write first. `+export --output-type preview|svg|source` pulls rendered images, vectors, or the board's Mermaid/PlantUML source without mutating anything. Writes go through `+update` with `--input_format` taking a single value — `mermaid`, `plantuml`, or `svg` — and overwriting a non-empty existing board requires an explicit "this rebuilds the whole board" confirmation. Editing an existing board with SVG walks `routes/svg-edit.md` first because that path is lossy. Identity defaults to `--as user`; bot identity exists only for app-account uploads.

## OKR: Score, Progress, and Weight Locks: lark-okr

[lark-okr](https://github.com/larksuite/cli/tree/main/skills/lark-okr) (v2, 15.2KB) reads a cycle list first (`+cycle-list`), drills into `+cycle-detail`, then edits. Its sharpest rule is semantic: `score` is 0–1 with one decimal and only changes when the user actually says 分数/评分/打分/score. "Progress", "completion", "we're at 75%" means `+indicator-update` or a progress record — never `+patch --score`. Alignment carries validation: an objective cannot align to itself, and the two cycles must overlap in time. Weight and position endpoints are all-or-nothing: `key_results_position` rejects unless every KR id of the cycle is present, and `key_results_weight` requires updating all KRs with weights summing to exactly 1. Comments (create/patch/delete/solve/reopen) are user-identity only, while `+comment-detail` aggregates a whole cycle's comments in one call. Around it sits the usual family routing: todos go to lark-task, meetings to lark-calendar — OKR is only OKR.

## The Pack Is Still One Counter

The five files vary 60× in size but move as a unit: this week's numbers — lark-slides 17,762, lark-task 17,790, lark-whiteboard 17,731, lark-minutes 17,561, lark-okr 17,732 — sit inside one 229-wide band. The 19.7K gap in lark-okr's counter, tied to its Apr 17 first-seen, is the same three-day offset signature seen inside every family wave. Practical takeaway: when a lark pack counter moves, all six move; treat any single skill's "growth" as pack noise until the sibling curves diverge. Slides is the one to schedule real time for, minutes the one to delete from your routing table — its answer lives in [lark-meeting](/tutorials/guides/lark-meeting-skill-faq/), and the messaging layer in [lark-im](/skills/automation/lark-im/).