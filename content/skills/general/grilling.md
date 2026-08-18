---
title: "Grilling Skill: Design-Tree Interviews for Plan Stress-Tests"
date: 2026-08-18
draft: false
tags:
  - Grilling Skill
  - Plan Review
  - AI Agent
description: "Matt Pocock's Grilling skill (448.9K installs, skills.sh #60) runs design-tree interviews in rounds — the primitive behind grill-me and grill-with-docs."
version: "1.0"
author: "Matt Pocock"
repo_url: "https://github.com/mattpocock/skills"
install_cmd: "npx skills@latest add mattpocock/skills"
compatibility:
  - Claude Code
  - Codex
  - Cursor
category: "general"
rating: 4.5
github_stars: 221266
github_forks: 19064
installs: 448900
last_updated: "2026-08-18"
ai_friendliness:
  score: 4.5
  documentation: 5.0
  setup: 4.0
  config: 4.0
---

Saying "challenge my plan" to an AI usually gets you three vague questions and a compliment. Matt Pocock built the Grilling skill to fix exactly that: it runs a structured interview where every question has a recommended answer and nothing is left silently assumed. It ranks #60 on the skills.sh all-time leaderboard with 448,900 installs, and it sits underneath [grill-me](/tutorials/guides/grill-me/) and [grill-with-docs](/skills/general/grill-with-docs/) — the two skills people actually type. I pulled the skill files and their long-form docs out of the [mattpocock/skills](https://github.com/mattpocock/skills) repo (221K stars) and read every line, because the README calls it a "primitive" and skips the details that decide whether it works for you.

## The Design Tree, the Frontier, and the Round

The whole skill runs on three ideas. Your plan maps to a **design tree**: every decision branches into the decisions that hang off it. The **frontier** is the set of decisions whose prerequisites are already settled — the only questions anyone can honestly ask right now. A **round** is one frontier, asked in full and answered in full.

Each round, the agent numbers every frontier question and attaches its own recommendation, formatted as `❓` for the question and `➡️` for the answer. You reply by number — "1 yes, 2 the second option, 3 no" — and the tree reshapes. The skill's own docs say thirteen questions typically land in about three rounds rather than thirteen, because a round never contains two questions where one depends on the other. Dependent questions wait for a later round.

This design answers the obvious objection before you raise it: asking a whole round at once can't lose the questions your answers would have raised, because the round only contains questions that don't depend on each other. The next round is recomputed from your actual answers, not pre-written.

## Facts Are the Skill's Job. Decisions Are Yours.

Reading the source, the sharpest design choice is the split between facts and decisions. When a frontier question needs a fact from the environment — a config value, a file's contents, a service's behavior — the agent dispatches a sub-agent to find it instead of asking you. It doesn't stall the round either: a running exploration blocks only the questions downstream of it, and the rest of the frontier proceeds.

Decisions are different. The skill must wait for every one of yours, and answering its own questions is defined in the docs as *"a bug in the run, not the intended behaviour."* The session ends when the frontier is empty, but the skill is not finished then — it stops and asks you to confirm you share the same understanding before it builds anything. If a weaker model skips that gate and starts implementing, the docs' recommended fix is a line in your own `CLAUDE.md` saying never to implement without permission.

One rough edge is documented honestly: the frontier is the agent's judgment, not a computed graph. The agent can ask two questions in one round and only later realize one answer should have changed the other. The docs say to just tell it — the affected branch reopens next round. And the recommendation line sometimes argues *against* the question as worded, so agreeing with it means answering "no." Answer the recommendation and say so.

## Why You'll Rarely Type /grilling Yourself

Here's the counterintuitive part: Grilling is the only skill in its family that the model invokes on its own. The docs are explicit — "It is the only skill in the grilling family that is model-invoked, which is why you rarely type it." Grill-me and grill-with-docs both ship `disable-model-invocation: true`; this skill does not. When your task fits an interview, the agent reaches for it automatically.

That makes it the **primitive**: one shared interview technique, kept in one place, so every skill that needs an interview calls it instead of inventing its own. [grill-with-docs](/skills/general/grill-with-docs/) is a grilling session that also runs [domain-modeling](/tutorials/guides/domain-modeling-procedural-guide/). [Triage](/skills/coding/triage/) grills a vague report into a workable ticket. Wayfinder runs grilling sessions inside decision tickets. [Improve Codebase Architecture](/tutorials/guides/improve-codebase-architecture/) walks the tree once you've picked a candidate to deepen. If `grill-me` or `grill-with-docs` "does nothing" after install, this is the missing dependency — grill-me is a one-line skill whose whole body is "run a /grilling session."

## Grilling vs Grill Me vs Grill with Docs vs Plain Chat

| | Plain chat | Grilling | Grill Me | Grill with Docs |
|:--|:--|:--|:--|:--|
| Interview mechanic | None | Design-tree rounds | Same rounds | Same rounds |
| Model-invoked | — | **Yes** | No | No |
| Writes files | No | No | No | CONTEXT.md + ADRs |
| Best moment | Quick check | Any plan in your head | Before a build, no repo | When decisions outlive the session |
| Installs (skills.sh) | — | 448.9K | 864.3K | 735.2K |

Pick Grilling itself when you want the interview and nothing after it. Pick Grill Me when you want the same interview under a name the agent will never fire by itself — useful if auto-triggering annoys you. Pick Grill with Docs when the answers need to land in files your team reads later.

## Real Talk: What the Source Reveals That the README Hides

Three details from the docs changed how I'd use this. First, the round format has a documented escape hatch: some people genuinely prefer one question at a time, and the skill's own docs support it — add `When grilling, ask one question at a time.` to your global `CLAUDE.md`, and the support is described as "supported rather than tolerated." Second, there is no question cap and deliberately never will be — the docs say some plans need three questions and some need fifty, and a fixed ceiling truncates the hard case or feels arbitrary on the easy one. You steer in plain language instead: tell it to wrap up, or accept the plan where it stands. Third, a real and unfixed bug: a skill that names another skill doesn't reliably cause that skill to load, so `grill-with-docs` sometimes runs without this primitive loaded. The tell is a session asking everything at once with no recommendations attached — that's the model improvising an interview rather than running this one. Asking whether it loaded `grilling` recovers it.

## Bottom Line

Grilling is the interview engine hiding inside the most popular plan-review skills on skills.sh, and it's worth knowing on its own terms. You get numbered rounds with attached recommendations, a hard line between facts and decisions, and a confirmation gate before anything gets built. It costs nothing — the whole mattpocock/skills repo is MIT-licensed — and it needs no config beyond installing it. Run `npx skills@latest add mattpocock/skills` and select `grilling` (plus `setup-matt-pocock-skills` for the config pass), or install the whole set via `claude plugins install mattpocock-skills`. Start a session with a plan you're about to build and answer round one by number — the format forces you to commit to positions you'd otherwise leave fuzzy. If you want the same interview to also produce a glossary and ADRs, read the [Grill with Docs skill intro](/skills/general/grill-with-docs/) before your next session.