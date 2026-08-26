---
title: "Unread Matt Pocock Skills: ask-matt, wayfinder, to-tickets"
date: 2026-08-26
draft: false
toc: true
description: "Three of Matt Pocock's most-installed skills rarely covered: ask-matt the router, wayfinder the fog mapper, to-tickets the slicer, read from their SKILL.md."
keywords:
  - ask-matt skill
  - wayfinder skill
  - to-tickets skill
  - Matt Pocock skills roundup
  - AI agent workflow skills
tags:
  - Matt Pocock
  - AI Workflow
  - Roundup
category: "guides"
---

Three of the biggest install counts in Matt Pocock's skill family belong to skills this site has never covered — and that most write-ups skip. I pulled the leaderboard on 2026-08-26: ask-matt sits at 443,187 installs (#70), wayfinder at 390,800 (#111), to-tickets at 371,679 (#123). The intro articles went to the builders and reviewers. These three are the connective tissue that turns a pile of skills into a pipeline. I read all three SKILL.md files from the [mattpocock/skills](https://github.com/mattpocock/skills) repo (237K stars) and compared what each one actually forces the agent to do. All three ship with `disable-model-invocation: true` — none of them ever fires on its own. A human has to ask.

## ask-matt: The Router for Skill Amnesia

**If you've ever stared at a blank prompt wondering which skill fits, ask-matt is the one you install first — its whole body is a map of the family, and it exists so the agent can route instead of guess.** Its own description is five words: "You don't remember every skill, so ask." The body lays out one main flow (idea → ship): `/grill-with-docs` sharpens the idea, `/handoff` bridges a prototype detour in both directions, `/to-spec` publishes the agreed plan, `/to-tickets` splits it, `/implement` builds each ticket by driving `/tdd` internally, `/code-review` closes out. Two on-ramps merge in: `/triage` for issues you didn't create, `/diagnosing-bugs` for things that broke.

The detail worth stealing is the context hygiene rule. Steps one through three — grilling, spec, tickets — run in **one unbroken context window**, because they must build on the same thinking; each `/implement` then starts fresh from its ticket, since a self-contained ticket makes the previous session's context disposable. The ceiling is what the skill calls the smart zone: roughly 150K tokens on state-of-the-art models, beyond which reasoning degrades. Hit it before `/to-tickets` and you `/compact` at the nearest phase boundary instead of pushing on degraded. That's a much more honest account of context limits than any "just clear and restart" advice floating around, because it names the tradeoff between continuity and sharpness.

## wayfinder: Mapping Fog, One Decision at a Time

**For a greenfield build or a feature too big for one session, wayfinder is the only skill in the family that plans the route itself — it charts a map of decision tickets and resolves them one at a time until the way is clear.** Its opening scenario reads like the pitch for the whole skill: a loose idea, too big for one agent session, wrapped in fog. The map is a single issue labelled `wayfinder:map`; the tickets are child issues carrying `wayfinder:<type>` labels — `research`, `prototype`, `grilling`, `task` — and every ticket splits into **HITL** (human in the loop, worked live) or **AFK** (agent-alone). Blocking uses the tracker's native dependency edges so the frontier renders visually in the tracker UI: the open, unblocked, unclaimed tickets are what anyone can grab.

Two rules here are worth copying into any planning workflow. First, the **fog-of-war test**: ticket something when you can state the question precisely, not when you can answer it — sharpness, not answerability, decides what leaves the fog. Second, wayfinder **never resolves more than one ticket per session** (research excepted), because each resolution is a decision that resets the map. And it produces decisions, not deliverables: when the map clears, it hands off to `/to-spec`, which collapses the linked decisions into a buildable plan. The pull to just build is the signal you've reached the edge of the map. The data matches the positioning — it's the fastest grower of the three, weekly installs climbing from 10,843 to over 52,000 across the last eight weeks.

## to-tickets: Slicing Specs Into Buildable Steps

**Once the plan exists, to-tickets is the skill that makes it executable — it breaks a spec into tracer-bullet vertical slices, each declaring its blocking edges, and won't publish until you approve the granularity.** The slicing rules are explicit: each slice cuts a narrow but complete path through every layer (schema, API, UI, tests), is demoable on its own, and fits in a single fresh context window. Prefactoring comes first — "make the change easy, then make the easy change." Then it quizzes you on the proposed breakdown: granularity, blocking edges, merges and splits, iterating until you approve.

The mechanical gem is the **wide refactor exception**. A mechanical change like renaming a shared symbol fans out across the whole codebase, so no vertical slice can land green. The skill refuses to force it into a tracer bullet; it sequences **expand–contract** instead. Expand: add the new form beside the old so nothing breaks. Migrate: move call sites in batches sized by blast radius, each batch its own ticket blocked by the expand, CI staying green batch to batch. Contract: delete the old form once no caller remains. If even batches can't stay green alone, they share an integration branch that blocks a final integrate-and-verify ticket — green is promised only there.

Its backstory shows up in the numbers. to-tickets' own weekly install series starts with a single `2`, then jumps to 41,155 — the index caught it mid-flight, matching the repo history where the older to-issues skill was replaced by this one. Nobody's installing to-issues anymore; the 352K total tracked for the old name now belongs to to-tickets' 371,679 and climbing.

## Which One Do You Actually Need?

| Skill | Failure it fixes | Reach for it when | Key rule | Weekly installs |
|:------|:-----------------|:------------------|:---------|:----------------|
| ask-matt | Skill amnesia — you don't know which skill fits | You hesitate before every workflow decision | One unbroken context window until tickets exist | ~43–55K |
| wayfinder | Fog — the effort is too big to see the route | Greenfield or a feature beyond one session | One decision ticket per session; decisions, not deliverables | ~49–60K, rising |
| to-tickets | Granularity — the plan is too coarse to build | Fresh out of to-spec, before implement | Vertical slices; wide refactors go expand–contract | ~48–58K |

Honest caveat: none of these three adds capability on its own. ask-matt adds recall of the map, wayfinder adds structure to fog, to-tickets adds shape to plans. That's why they're human-invoked and why they're easy to underrate — they make the build skills dependable rather than writing anything themselves.

## Bottom Line

Install the family with `npx skills@latest add mattpocock/skills`, run `/setup-matt-pocock-skills` once to configure the tracker, then add ask-matt first — it costs the least and makes every other skill reachable. When a project outgrows a single session, chart it with wayfinder instead of improvising; when the spec's agreed, slice it with to-tickets instead of coding from the top down. The trio chains exactly where the family's other skills leave off — and the ones they hand off to are already covered here: [implement](/skills/general/implement/) executes each ticket, [code-review](/skills/general/code-review/) audits the result, and the [triage narrative](/tutorials/guides/triage-backlog-narrative-experience/) shows the on-ramp for incoming issues. If the ticket-format rules remind you of spec discipline, the [domain-modeling guide](/tutorials/guides/domain-modeling-procedural-guide/) is the vocabulary layer these skills assume you already have.