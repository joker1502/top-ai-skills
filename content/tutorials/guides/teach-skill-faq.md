---
title: "Teach Skill FAQ: Personal AI Teaching With Claude Code"
date: 2026-08-17
toc: true
draft: false
tags:
  - Teach Skill
  - Claude Code
  - AI Learning
description: "Practical answers on Matt Pocock's Teach skill: how the teaching workspace works, why lessons ship as HTML, and what learning records do for retention."
category: "guides"
faq:
  - question: "What exactly does the Teach skill do?"
    answer: "Teach turns the directory you run it in into a teaching workspace. It writes a MISSION.md capturing why you want to learn, then produces lessons, reference sheets, and learning records across sessions. It's built for stateful learning — you return to the same workspace each session, and the skill picks up where it left off instead of treating every question like a fresh chat."
  - question: "How is it different from just asking Claude Code to explain something?"
    answer: "A chat reply gives you fluency — the ability to nod along in the moment. Teach is designed around storage strength, the long-term retention that comes from retrieval practice, spacing, and interleaving. Every lesson is one small HTML page with exercises and a feedback loop, and the skill records what you genuinely understand so later sessions teach at the edge of your ability instead of repeating the basics."
  - question: "Where do the lessons and notes actually live?"
    answer: "Everything lives in the working directory you invoked the skill in. Lessons go in lessons/ as numbered HTML files (0001-dash-case.html), cheat sheets in reference/, learning records in learning-records/ (0001-slug.md), plus MISSION.md, RESOURCES.md, and NOTES.md at the root. Reusable components — a shared stylesheet first, then quiz widgets and simulators — sit in assets/. Files are created lazily, so an empty workspace stays empty until there's something to record."
  - question: "Does it work for non-coding topics?"
    answer: "Yes — the skill's own spec cites yoga poses, fitness routines, and theoretical physics as target topics alongside programming syntax. The mission format uses running a half marathon and shipping a Rust CLI as examples. The workspace is plain HTML and markdown files, so nothing about the system assumes code, and the reference format covers algorithms, exercises, and glossaries equally."
  - question: "How does it know what to teach me next?"
    answer: "It computes your zone of proximal development from two inputs: the mission in MISSION.md and the evidence in learning-records/. If you demonstrated real understanding of something, that sets a new floor. If a misconception got corrected, that becomes a predicted stumbling block for related topics. If no mission exists yet, the skill stops and interviews you about why you're learning before it teaches anything — the format file says 'a bad mission is worse than no mission.'"
  - question: "Why does the skill tell the AI to never trust its parametric knowledge?"
    answer: "The SKILL.md instructs the model that before RESOURCES.md is well-populated, its job is finding high-quality external resources, and 'never trust your parametric knowledge.' Lessons should be littered with citations to back every claim. The skill is explicitly built on the assumption that the model's built-in knowledge isn't ground truth — it's a starting point that should be verified against trusted sources you curate."
  - question: "Do I need to join a community to use it?"
    answer: "No, but the skill will suggest one. Wisdom, in its philosophy, comes from real-world interaction, so the default posture is to answer your question and then delegate to a high-reputation community — a subreddit, forum, or local class. If you opt out, the skill respects that and records it in RESOURCES.md so future sessions stop proposing communities."
  - question: "Can I adapt or reuse the generated lessons?"
    answer: "Yes. Installing via skills.sh copies editable files into your project, and the generated lessons are plain HTML you can restyle or rewrite. The asset system is built for reuse — components live in assets/ exactly so later lessons don't duplicate them. Everything is MIT-licensed, and Matt Pocock's stated philosophy for the whole skill family is 'hack around with them, make them your own.'"
  - question: "Is Teach better than Anki or flashcards for retention?"
    answer: "They do different jobs. Anki schedules spaced retrieval of atomic cards you create; Teach is a curriculum engine that decides what to learn next, produces a lesson, and records what you mastered. It uses retrieval practice too — quiz answers are deliberately kept the same length so formatting never leaks the answer — but it doesn't do the interval scheduling Anki is built for. Realistically they're complementary: Teach for what to learn and why, Anki for keeping it loaded."
  - question: "How do I install it, and is it free?"
    answer: "It's free and MIT-licensed. Run 'npx skills@latest add mattpocock/skills' in a terminal and select teach from the list, or use 'claude plugins install mattpocock-skills' for the managed Claude Code plugin. The skill ships with disable-model-invocation, so the model won't trigger it unprompted — you type /teach and state what you want to learn."
---

{{< faq-schema >}}

## Why a Teach Skill FAQ Exists

Matt Pocock's Teach skill sits at #58 on the skills.sh all-time leaderboard with 459,800 installs, yet most coverage of the mattpocock/skills family fixes on the engineering skills — tickets, triage, ADRs — and skips this one entirely. That's a miss, because Teach is arguably the least engineering-shaped skill in the repo, and its actual behavior is easy to guess wrong.

I wrote these answers after pulling the skill folder out of the [mattpocock/skills](https://github.com/mattpocock/skills) repository and reading SKILL.md plus its five format files line by line. Everything below traces to something written in the spec — no hearsay, no marketing copy.

## The Short Answers

- **It's a teaching workspace, not a chatbot.** Files, not transcript, are the output.
- **It's designed for retention research.** Fluency vs. storage strength, desirable difficulty, and the zone of proximal development are baked into the instructions, not buzzwords.
- **It's topic-agnostic.** Yoga, fitness, theory, and code all appear in the skill's own examples.
- **It refuses to teach aimlessly.** No mission, no lessons — it interviews you first.
- **It's free.** MIT license, and the whole thing is plain markdown and HTML you can edit.

## What the Skills.sh Ranking Tells You

459,800 installs is the raw number from the skills.sh all-time snapshot we pulled in mid-August 2026. Context helps: the other members of the family ranked above it are Grill with Docs (#4, 735K) and Setup Matt Pocock's Skills (#9, 631K) — both are one-shot configuration utilities. Teach is the only one of the three built for sustained use over weeks, so its install count likely understates how much real session time it gets. Install counts on skills.sh measure adds, not usage.

## Common Mistakes to Avoid

**Mistake #1: Running it in your main repo.** Teach treats the current directory as the workspace, so running it in a project repository mixes lessons with source code. A dedicated folder per topic keeps MISSION.md and lessons out of commits.

**Mistake #2: Skipping the mission to save time.** The skill interrogates you about why you want to learn for a reason — every later decision on what to teach traces back to it. Pushing through with a vague goal produces the abstract lessons the spec explicitly warns against.

**Mistake #3: Expecting one lesson to cover a topic.** Lessons are intentionally small, one tangible win each, sized for working memory. A single session may produce several lesson files, each building on the last.

**Mistake #4: Deleting old learning records.** Corrected misconceptions are marked 'superseded by LR-NNNN' instead of deleted, because the history of how your understanding shifted is itself signal. Trashing the older records erases that trajectory.

## Start With One Mission

Concrete beats abstract, per the format's own rule. Before you run `/teach`, write down the real-world outcome — "ship a Rust CLI to my team" beats "learn Rust" — and check whether it fits on one screen. Then run `npx skills@latest add mattpocock/skills`, pick `teach`, and start a fresh directory for the topic. The [Teach skill intro](/skills/general/teach/) walks through the workspace layout in detail, and if the family's engineering skills are also on your list, the [Setup Matt Pocock's Skills guide](/skills/general/setup-matt-pocock-skills/) covers the one-time config pass they all share.