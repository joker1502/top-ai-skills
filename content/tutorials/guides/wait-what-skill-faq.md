---
title: "Wait-What Skill FAQ: When Your Agent's Message Doesn't Land"
date: 2026-08-27
toc: true
draft: false
tags:
  - Wait-What
  - Agent Communication
  - Prompting
description: "Straight answers on mattpocock's wait-what skill: why three lines beat four hundred, why 'wait' outworks 'be concise', and what 146K installs signal."
category: "guides"
faq:
  - question: "What does the wait-what skill actually do?"
    answer: "You type /wait-what, and the agent re-pitches its last message: it adds the context you were missing, drops the jargon, writes in ASD-STE100 Simplified Technical English, and uses the project's vocabulary from CONTEXT.md. The body is three lines long on purpose. The whole skill is a single leading word — 'wait' — plus instructions about how to re-explain."
  - question: "Why is the skill only three lines long?"
    answer: "The design doc says it plainly: skills that fight verbosity fail by growing. A 400-line concision skill still leaves the model verbose, because the model reads the volume, not the plea. Three lines carry one precise instruction and nothing else. The length is the mechanism, not a placeholder."
  - question: "Why does it say 'wait' instead of 'be concise'?"
    answer: "Because 'be concise' names the agent's output, and the model obeys by clipping words — which loses you further. 'Wait' names your state: comprehension failed here. An agent that hears 'be brief' writes telegrams. An agent that hears 'wait, you lost me' backs up and explains. The skill even names the counter-examples: /tldr, /no-fluff, and /talk-normal all over-correct into a caveman register that is shorter and no clearer."
  - question: "What is ASD-STE100 Simplified Technical English?"
    answer: "It's the aerospace maintenance writing standard — a controlled vocabulary and grammar rules designed so non-native speakers read maintenance manuals without ambiguity. The skill borrows it as the register for re-pitches: plain words, one meaning per term, no invented abbreviations. The vocabulary half of the sentence comes from your project instead."
  - question: "Do I need a CONTEXT.md for the skill to work?"
    answer: "No. The skill still works without one; you only lose the domain-vocabulary half. With one, re-pitches use the ubiquitous language you already agreed on. In repos that index multiple contexts, the skill follows CONTEXT-MAP.md to pick the right CONTEXT.md — that support landed in the 2026-08-19 update."
  - question: "Why won't the agent trigger it by itself?"
    answer: "Two flags lock it down: disable-model-invocation: true in the skill frontmatter and allow_implicit_invocation: false in the OpenAI binding. The design is explicit that only you know when you stopped following, so the agent never reaches for it on its own. You type /wait-what."
  - question: "Can I use it twice in a row?"
    answer: "Yes, and the design doc lists what 'working' looks like: the re-pitch is shorter and clearer, not shorter and blunter; it adds the premise you were missing instead of only deleting words; project nouns from CONTEXT.md replace invented ones; and a second use does not degrade into terseness."
  - question: "How is it different from grill-with-docs?"
    answer: "Timing. wait-what repairs the conversation you're already in — it fixes one message after the fact. grill-with-docs prevents the jargon from arriving at all by building the shared language upfront: a grilling session that runs domain-modeling as it goes and lands the agreed words in CONTEXT.md. Same vocabulary system, opposite ends of the pipeline."
  - question: "When does it not help?"
    answer: "When the message didn't land because the agent stated something wrong, not because it skipped context — wait-what re-explains, it does not fact-check. It also can't inject vocabulary that was never captured anywhere, so if you have no CONTEXT.md and the agent invented its own nouns, the re-pitch fixes phrasing but not the missing glossary. And if you've lost the thread of the whole session, a re-pitch of one message is the wrong tool; that's a restart or a handoff doc."
  - question: "Is the 146K install number real?"
    answer: "Yes — skills.sh showed wait-what at #266 with 146,544 all-time installs on 2026-08-27. Its weekly series reads 0, 0, 0, 0, 0, 34,647, 42,010, 43,703: the skill hit the public board in early August and has grown every week since. That puts it just behind writing-for-agents (151,867) and to-questionnaire (206,673), its siblings in the same conversation-repair family."
---

{{< faq-schema >}}

## Why a Wait-What FAQ Exists

Matt Pocock's wait-what skill is the youngest member of the [mattpocock/skills](https://github.com/mattpocock/skills) family, and most write-ups skip it because a three-line skill looks like nothing to say. It isn't. Git history shows it graduated into the productivity bucket on 2026-08-05, and its design document reads like a manifesto against verbose skills. I pulled the SKILL.md, that doc, the changeset, and the live leaderboard on 2026-08-27 — every claim below traces to one of those files.

## The Short Answers

- **It's a re-pitch command, not a style command.** `/wait-what` says "you lost me," which is different from "be shorter."
- **Three lines is the design.** A longer skill teaches the model that verbosity matters.
- **The agent never fires it.** Both invocation flags forbid implicit triggering; only you type it.
- **CONTEXT.md is optional.** Without it you lose only the vocabulary half of the repair.
- **It fixes the past; grill-with-docs fixes the future.** Use both, in that order of urgency.

## Three Lines, by Design

The skill body, verbatim: *"Wait, I don't understand where you've got to here. Re-pitch that: give me a little bit of context, talk in ASD-STE100 Simplified Technical English, and use the ubiquitous language from CONTEXT.md (follow CONTEXT-MAP.md to the right one if the repo has more than one)."*

Two details in that sentence do most of the work. The first is **"that"** — not "that last message." What lost you is usually bigger than one paragraph, so the agent decides how far back to go. The second is **"wait"** itself. Every popular verbosity fix names the output — `/tldr`, `/no-fluff`, `/talk-normal` — and the model dutifully over-corrects into a register that is shorter and no clearer. Naming the listener asks for both halves at once: fewer words *and* the context you were missing.

The skill also plugs into language you already have. It reuses the leading words from your global CLAUDE.md and your project's CONTEXT.md, so invoking it isn't a new instruction — it's a reminder of one the agent already agreed to. If the repo has several context files, CONTEXT-MAP.md routes the agent to the right one; that support arrived in the 2026-08-19 update, which also removed every em-dash from the repo and quoted the description to fix a YAML issue. Small history, but it shows how seriously the family treats this three-liner.

## What the Install Numbers Say

The snapshot from 2026-08-27 puts wait-what at #266 with 146,544 installs and a weekly curve that has climbed every single week since it appeared: 34,647 → 42,010 → 43,703. Compare it with its conversation-repair siblings:

| Skill | All-time installs | Last week | What it does |
|:--|--:|--:|:--|
| [to-questionnaire](/tutorials/guides/ask-matt-wayfinder-to-tickets-roundup/) | 206,673 | 43,485 | turns vague requests into structured questionnaires |
| writing-for-agents | 151,867 | 46,171 | teaches agents to write for other agents |
| wait-what | 146,544 | 43,703 | re-pitches a message that didn't land |
| [grill-with-docs](/skills/general/grill-with-docs/) | 840,134 | 62,108 | builds the shared language upfront |

The pattern worth noticing: the prevention skill (grill-with-docs) out-installs the repair skill by nearly 6x. People install the cure before they install the first aid kit. The weekly numbers also put to-questionnaire, writing-for-agents, and wait-what within a few thousand of each other — the family's newest cohort is acquiring users at almost the same rate, which suggests one skill's growth drags the others along.

## Common Mistakes to Avoid

**Mistake #1: Waiting until you're lost for ten minutes.** The design doc says use it the second you notice you're skimming. The agent has drifted into jargon it invented, stacked five acronyms, or explained a decision whose premise you never saw. That's the moment, not after the third paragraph of damage.

**Mistake #2: Using it to fact-check.** If the agent stated something wrong, wait-what re-explains the same wrong thing more clearly. Check the claim yourself, or ask a pointed question, then re-pitch if needed.

**Mistake #3: Expecting vocabulary from nowhere.** With no CONTEXT.md, the re-pitch is clearer but stays generic. The skill's own doc admits you lose only the domain-vocabulary half — so don't blame the skill when invented nouns survive a re-pitch. That's the shared-language job, and it belongs to [grill-with-docs](/skills/general/grill-with-docs/) and [domain-modeling](/tutorials/guides/domain-modeling-procedural-guide/).

**Mistake #4: Treating it as a substitute for context capture.** wait-what repairs one message after the fact. If messages keep not landing, the fix is a CONTEXT.md that captures the words you both use — prevention, not repair.

## Start With the Next /wait-what

Install the family with `npx skills@latest add mattpocock/skills` — wait-what ships with the rest ([handoff](/skills/general/handoff/), [grill-with-docs](/skills/general/grill-with-docs/), and the engineering set come along in the same install). Next time the agent's answer makes you skim, don't ask it to be concise. Type `/wait-what` and watch it back up and re-pitch with the context you were actually missing. If the re-pitch is shorter *and* clearer, and your project's real nouns come back, it worked — and it'll work again the minute you need it.