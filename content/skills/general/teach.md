---
title: "Teach Skill: Turn Claude Code Into a Personal Teacher"
date: 2026-08-17
draft: false
tags:
  - Teach Skill
  - Claude Code
  - AI Learning
description: "Matt Pocock's Teach skill (459.8K installs, skills.sh #58) turns Claude Code into a personal teacher with HTML lessons, learning records, and references."
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
github_stars: 220105
github_forks: 18960
installs: 459800
last_updated: "2026-08-17"
ai_friendliness:
  score: 4.5
  documentation: 4.5
  setup: 4.0
  config: 4.0
---

Matt Pocock's Teach skill turns Claude Code into a personal teacher that tracks what you know, picks what you should learn next, and leaves a structured workspace in your repo — not just a chat transcript. It ranks #58 on the skills.sh all-time leaderboard with 459,800 installs, and it targets the person who has asked an AI to explain something, nodded along, and lost it two days later. I pulled the skill folder out of the [mattpocock/skills](https://github.com/mattpocock/skills) repo (220K stars) and read every file, because the README undersells how opinionated the teaching system underneath actually is.

## What the Teach Skill Builds in Your Workspace

Type `/teach` and tell the skill what you want to learn, and it reasons over the current directory as a **teaching workspace**. The state of your learning lives in seven files, and six of them are created lazily — nothing appears until it earns its place:

- `MISSION.md` — the reason you're learning. One or two sentences about the real-world outcome you want, plus "success looks like" bullets and explicit out-of-scope topics.
- `RESOURCES.md` — curated, annotated sources for knowledge and communities for wisdom. Every entry gets one line saying what it covers and when to reach for it.
- `reference/*.html` — compressed cheat sheets, syntax references, algorithms, glossaries. The spec says these should print well and survive repeated visits.
- `lessons/*.html` — the primary output. Each lesson is one self-contained HTML page teaching a single tightly-scoped thing, numbered `0001-<dash-case>.html`.
- `learning-records/*.md` — numbered notes like `0001-slug.md` that capture non-obvious lessons and corrected misconceptions. The spec calls them "loosely equivalent to architectural decision records."
- `assets/` — reusable components: a shared stylesheet first, then quiz widgets, simulators, diagram helpers. Reuse is the default; the skill reads this folder before writing any new lesson.
- `NOTES.md` — a scratchpad for your learning preferences.

The split between lessons, references, and learning records is what separates this from a saved conversation. Transcripts rot; these files accumulate and stay machine-readable for the next session.

## The Science Rules That Make It Different From Chatting

The skill is explicit about two learning types: **fluency strength** (in-the-moment retrieval) and **storage strength** (long-term retention). The spec says fluency gives an "illusory sense of mastery," so lessons are deliberately designed for desirable difficulty: retrieval practice, spacing, and interleaving (the last one for skill practice only).

Three rules in the source surprised me. First, the skill tells the model to **never trust its parametric knowledge** — before `RESOURCES.md` is populated, the focus is finding high-quality external resources, and lessons should be "littered with citations" to back every claim. Second, quiz answers must all be the **exact same number of words**, ideally characters, so formatting never hints at the right answer. Third, lessons must be short and fast to complete — working memory is small, and each lesson should deliver "a single tangible win" tied to the mission.

The spec also demands beauty, not just correctness. Lessons should be "clean, readable typography and layout" — the brief literally says "Think Tufte" — because you'll return to them later for review.

## How the Skill Decides What to Teach Next

Teaching is steered by the **zone of proximal development**, and the steering data comes from your learning records. Before each lesson the model reads `learning-records/`, figures out the most relevant thing you could learn next, and aims to challenge you "just enough."

If `MISSION.md` is empty, the skill refuses to teach. Its first job is to interrogate you about why you want to learn the topic — the format file says "A bad mission is worse than no mission." Missions change, and when they do, the shift is recorded in a learning record and confirmed with you before anything else moves. One mission per workspace is enforced: if you want to learn two unrelated things, that's two workspaces.

Misconceptions get special treatment. When the user believes something wrong and it gets corrected, the record is marked with `Status: superseded by LR-NNNN` rather than deleted — the history of how your understanding evolved is treated as useful signal for future lessons.

## Real Talk: What Jumped Out While Reading the Source

Let me share the details that the promotion never mentions.

The skill ships with `disable-model-invocation: true`, same as the rest of the family — the model can't interrupt a conversation to start teaching you. You type the command explicitly. No accidental lectures mid-refactor.

The knowledge/skills/wisdom split shapes everything. Knowledge comes from resources, skills come from interactive lessons with tight feedback loops, and wisdom comes from *communities* — the skill's default posture is to answer questions but ultimately delegate to a subreddit, a forum, or a real-world class. If you opt out of communities, it respects that and records your choice in `RESOURCES.md` so future sessions stop proposing them.

Glossaries are canonical. Once a term enters the workspace glossary, it must be used everywhere — including inside other definitions — and ambiguous usage gets resolved explicitly ("in this workspace, 'set' always means a working set"). The glossary doubles as a learning artifact: compressing a concept into a tight definition is treated as evidence you understand it.

## Teach vs Grill with Docs vs Plain Chat

| | Teach | Grill with Docs | Plain chat |
|:--|:--|:--|:--|
| Goal | Learn a topic over multiple sessions | Interrogate docs before writing an ADR | Answer a question once |
| Output | Lessons, references, learning records | Decisioned ADRs | A transcript |
| State | Persisted in the workspace | Persisted in docs/ | None |
| Trigger | `/teach` on demand | `/grill-with-docs` on demand | Anywhere |

Plain chat handles a single question in minutes and is right for that. Grill with Docs nails one specific moment — understanding a codebase before an architecture decision — and [we covered it earlier](/skills/general/grill-with-docs/). Teach is the only one built for a multi-week learning arc, which is why it ships with learning-state machinery instead of a Q&A loop.

## Bottom Line

Teach is the rare skill where the pedagogy is the product: missions, desirable difficulty, learning records, and a cache of beautiful HTML references you actually revisit. It costs nothing — Matt Pocock's skills are MIT-licensed — and you can adapt the files since they're plain markdown and HTML. For installation, run `npx skills@latest add mattpocock/skills` in a fresh directory and select `teach`, or `claude plugins install mattpocock-skills` for the managed bundle. Want the topic structured as a mission before you start? The [Setup Matt Pocock's Skills intro](/skills/general/setup-matt-pocock-skills/) explains the config pass this family depends on — worth one read before your first lesson.