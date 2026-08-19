---
title: "Handoff Skill: Compact a Session for a Fresh Agent"
date: 2026-08-19
draft: false
tags:
  - Handoff Skill
  - Agent Context
  - AI Agent
description: "Matt Pocock's Handoff skill (skills.sh #10) compacts a session into a temp-dir doc with suggested skills, deduped artifact links, and redacted secrets."
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
github_stars: 223295
github_forks: 19218
installs: 37303
last_updated: "2026-08-19"
ai_friendliness:
  score: 4.5
  documentation: 4.5
  setup: 4.5
  config: 4.5
---

Ending an agent session and expecting a fresh one to pick up where you left off usually means retyping half the context into the new prompt. Matt Pocock's Handoff skill standardizes that: it compacts the current conversation into a single handoff document that a brand-new agent can read and continue from. It ranks #10 on the skills.sh all-time leaderboard with roughly 37,000 weekly installs, and it sits inside the [mattpocock/skills](https://github.com/mattpocock/skills) family — 223K stars — alongside [grill-with-docs](/skills/general/grill-with-docs/), [grilling](/skills/general/grilling/), and [domain-modeling](/tutorials/guides/domain-modeling-procedural-guide/). I read the actual SKILL.md and its sibling docs line by line, and the details that decide whether a handoff survives a restart are almost all unstated in the one-line description.

## Where the Document Goes (and Why It Matters)

The skill's first hard rule is the one people ignore: **save the handoff document to the OS temporary directory, not the current workspace.** The reasoning is deliberate — a workspace file gets committed, shared, forgotten, and eventually merged into a repo where it becomes noise. A temp-file handoff is ephemeral by design: it exists for the handoff and nothing else. If you habitually leave handoff docs sitting in a project you'll end up with a graveyard of stale files the agent can't tell apart.

The second rule is about intent. If you pass an argument — "what will the next session be used for?" — the document tailors itself to that focus instead of dumping the whole transcript. Describing what the next session is *for* reshapes what gets compacted, which is the difference between a useful brief and a wall of text.

## The Three Rules That Keep a Handoff Honest

The body of the skill is short, and every line is a constraint with teeth. It demands a **"suggested skills" section** naming which skills the next agent should load via the Skill tool — a handoff that mentions a workflow but not the skill that runs it forces the next session to rediscover the toolchain from scratch. Just as hard is the dedup rule: **do not duplicate content already captured in other artifacts** — specs, plans, ADRs, issues, commits, diffs. Reference them by path or URL instead, because a handoff that reproduces state living elsewhere is a lie waiting to rot. Finally it forces **redaction of sensitive information**: API keys, passwords, and personally identifiable information get stripped before the document is written.

That dedup rule is the sharpest one. A handoff that copies an ADR's content verbatim rots the instant the ADR changes — the copy is now wrong and nobody can tell. A handoff that links to the ADR stays correct forever, because the truth lives in one place.

## Handoff in the Matt Pocock Family

Handoff is deliberately not model-invoked (`disable-model-invocation: true`), so you call it explicitly when you want it, rather than the agent firing it unprompted. In the family's workflow it's the closing move: [grill-with-docs](/skills/general/grill-with-docs/) writes CONTEXT.md and ADRs so decisions outlive the session, [domain-modeling](/tutorials/guides/domain-modeling-procedural-guide/) sharpens the glossary and contracts, and Handoff is what you run when you genuinely have to stop — it bundles everything into one transferable artifact for the next person or agent. [Setup-Matt-Pocock-Skills](/skills/general/setup-matt-pocock-skills/) wires the whole family's config in one pass, so `handoff` is available right after that setup runs.

## Real Talk: What Reading the Source Reveals

Two details stand out from the source that the README doesn't stress. First, the skill is opinionated about scope: it refuses to become a second copy of your project's truth. Because it dedupes against artifacts, it works best when your session already produced artifacts — a solo, no-artifacts session leaves a thin handoff, because there's nothing to reference. Run [grill-with-docs](/tutorials/guides/domain-modeling-procedural-guide/) or capture decisions in an ADR *before* you hand off, and the handoff doc becomes a tight pointer list instead of a novel. Second, the emptiness rule cuts both ways — if you find your handoffs are huge, the fix isn't a longer skill, it's more artifact capture upstream. That framing reshaped how I structure every ended session.

## Bottom Line

Handoff solves a real, recurring problem: context loss at the boundary between sessions. You get a temp-directory document with a suggested-skills section, deduplicated links to real artifacts instead of copied content, and automatic redaction of secrets. It costs nothing — the whole mattpocock/skills repo is MIT-licensed — and needs no config beyond installing it. Run `npx skills@latest add mattpocock/skills` and select `handoff` (plus [setup-matt-pocock-skills](/skills/general/setup-matt-pocock-skills/) for the config pass). Next time you'd normally paste a transcript into a new chat, run `/handoff what the next session will build` and restart from the document instead. To see the upstream piece that makes handoffs worth writing, read the [Grill with Docs intro](/skills/general/grill-with-docs/).
