---
title: "writing-for-agents: How to Write Docs Agents Actually Read"
date: 2026-08-28
draft: false
tags:
  - AI Skills
  - Documentation
  - Prompt Design
description: "Matt Pocock's writing-for-agents (158K installs, #263) explains why agents ignore AGENTS.md lines: pointer wording, two loads, leading words."
version: "1.0"
author: "mattpocock"
repo_url: "https://github.com/mattpocock/skills"
install_cmd: "npx skills add mattpocock/skills"
compatibility:
  - Claude Code
  - Codex
  - Cursor
category: "writing"
rating: 4.5
github_stars: 233000
github_forks: 0
installs: 158238
last_updated: "2026-08-28"
ai_friendliness:
  score: 4.5
  documentation: 5.0
  setup: 4.0
  config: 4.0
---

Your agent skips half of `AGENTS.md` and still follows a 40-line skill to the letter. The difference is writing, not packaging. Matt Pocock's `writing-for-agents` skill (158,238 installs, #263 on the skills.sh all-time board) is the reference document behind that difference — it codifies how to write any file an agent consumes: skills, `AGENTS.md`, `CLAUDE.md`, or a doc reached by a pointer. I read its 81-line SKILL.md plus SKILL-MECHANICS.md and scraped the live leaderboard on 2026-08-28. What surprised me: the file never mentions output format. It teaches one idea — an agent reads what the *wording* makes reachable, not what you intended to say.

## The Pointer's Wording, Not Its Target, Decides What the Agent Reads

A **context pointer** is any reference sitting in the agent's context that names material living elsewhere: a skill's description, a single line in `AGENTS.md` pointing at a doc, a mention of a file in a prompt. Same object, same job. The skill's first rule is blunt — the pointer's *wording*, never its target, decides when the agent reaches the material and how reliably. A must-have target behind a weakly worded pointer is called a **variance bug**: every run is a coin flip on whether the agent finds it.

So you sharpen the wording first, and inline the material only when sharpening fails. Each pointer carries two jobs: state what the material is, and list every **branch** it handles — a distinct case the document covers, so different runs take different paths through it. The rules that follow are mechanical: front-load the leading word, because the pointer does its triggering work in the opening tokens; keep one trigger per branch, because synonyms that rename one branch are that branch written twice; cut anything the body already says.

## Two Loads, One Index: Context Load vs Cognitive Load

Every document you add spends one of two budgets. **Context load** is the cost of always-loaded material on the agent's window — an `AGENTS.md` line, a skill description, anything sitting there every turn, spending tokens and attention whether or not it fires. **Cognitive load** is the cost on the human: remembering which documents exist and when to reach for each. The skill says it directly: *the human is the index*. Material reached only through a pointer escapes context load at the price of the pointer's own line; material with no pointer at all rides entirely on your memory.

That budget view drives the **information hierarchy**, the ladder that ranks where content sits:

1. **In-file step** — ordered actions the agent performs; the primary tier.
2. **In-file reference** — rules and facts consulted on demand.
3. **Disclosed reference** — pushed into a separate file behind a pointer, loaded only when the pointer fires.

Push too little down and the top bloats; push too much and you hide material the agent needs. **Progressive disclosure** is the deliberate move down the ladder, and branching is the cleanest test of it: inline what every branch needs, push behind a pointer what only some branches reach. Two companion rules: **co-location** keeps a concept's definition, rules, and caveats under one heading so reading one part brings its neighbours; **sprawl** is the failure where a document is simply too long even when every line is live — attention thins across the excess.

## Leading Words Beat Prohibitions — the Negation Trap

A **leading word** is a compact concept already living in the model's pretraining — *lesson*, *fog of war*, *tracer bullets*. Repeat it as a token, never as a sentence, and it accumulates a distributed definition that anchors a whole region of behaviour in the fewest tokens, by recruiting priors the model already holds. A made-up word recruits no priors: you pay in definition tokens what a pretrained word gives free. The file's examples show the refactor: "fast, deterministic, low-overhead" collapses to *tight*, and "a loop you believe in" collapses to *red* — the fuzzy gate turned into a binary observable state (the loop goes red on the bug, or it doesn't).

**Negation** is the failure mode beside this lever. Steering by prohibition drags the forbidden behaviour into context and makes it *more* available, not less — don't think of an elephant, and the elephant is all there is. The skill's instruction is to prompt the positive: state the target behaviour ("write one-line comments"), never the ban it replaces. A prohibition earns its place only as a hard guardrail you cannot phrase positively, and even then it must come paired with the positive target.

The pruning rule sharpens the same knife: a **no-op** is an instruction the model already obeys by default, paying load to say nothing. The test is model-relative — does this sentence change behaviour against the default? — and two people disagreeing about it settle the argument by running the document, not by debate. When a sentence fails the test, delete the whole sentence rather than trimming words from it.

| | Model-invoked skill | User-invoked skill |
|:--|:--|:--|
| Frontmatter | keeps a `description` | `disable-model-invocation: true` |
| Who fires it | the agent autonomously, or another skill | only a human typing its name |
| Context load | permanent — the description stays loaded | zero |
| Cognitive load | low | you are the index that must remember it |

The mechanics file makes the trade explicit. Model-invocation is the default because a description never removes the human's reach — it only adds agent discovery. Pick it when the agent must reach the skill on its own or another skill must call it. If it only ever fires by hand, strip the description and pay no context load; shared reference that two user-invoked skills both need belongs in a plain file outside the skill system, because with no descriptions neither can fire the other.

The leaderboard data backs the design's timing. `writing-for-agents` sat at zero weekly installs for five straight weeks, then jumped 40 → 36,269 → 42,587 → 46,171 across the last four (skills.sh, 2026-08-28). The family's `wait-what` traced the same curve — 0 → 34,647 → 42,010 → 43,703 — and `to-questionnaire` (212,724 all-time) rides it too. The writing skill leads the trio in growth, which makes sense: it's the one the other two invoke.

## Bottom Line

The whole skill rests on a single claim: *wording is a runtime behaviour, not a style choice*. Fix the pointer before you fix the document, spend the two loads consciously, coin leading words instead of spelling out triads, and delete every sentence that doesn't beat the model's default. Do that and the agent reads what you wrote. Install the family with `npx skills@latest add mattpocock/skills`, pick `writing-for-agents`, and rewrite one `AGENTS.md` line tonight — the skill's own [wait-what design doc](/tutorials/guides/wait-what-skill-faq/) is a worked example of the same doctrines, and the [AI Agent Skills FAQ](/tutorials/guides/ai-agent-skills-faq/) covers installation and invocation basics if you're new to the format.