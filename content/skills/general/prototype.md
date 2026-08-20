---
title: "Prototype Skill: Throwaway Code That Answers One Question"
date: 2026-08-20
draft: false
tags:
  - Prototype Skill
  - Rapid Iteration
  - AI Agent
description: "Matt Pocock's Prototype skill (skills.sh #12) builds throwaway logic demos or radical UI variants to answer one question, then folds the winner into code."
version: "1.0"
author: "Matt Pocock"
repo_url: "https://github.com/mattpocock/skills"
install_cmd: "npx skills@latest add mattpocock/skills"
compatibility:
  - Claude Code
  - Codex
  - Cursor
category: "general"
rating: 4.6
github_stars: 223295
github_forks: 19218
installs: 34000
last_updated: "2026-08-20"
ai_friendliness:
  score: 4.6
  documentation: 4.6
  setup: 4.5
  config: 4.5
---

Most people treat a prototype as a cheap first draft of production code, then get stuck when the throwaway becomes the thing they ship. Matt Pocock's Prototype skill inverts that. It treats a prototype as **throwaway code that answers a single question**, and it makes that throwaway-ness a hard rule instead of an accident. The skill ranks #12 on the skills.sh all-time leaderboard with about 34,000 weekly installs, inside the [mattpocock/skills](https://github.com/mattpocock/skills) family (223K stars) alongside [handoff](/skills/general/handoff/), [grilling](/skills/general/grilling/), and [domain-modeling](/tutorials/guides/domain-modeling-procedural-guide/). I read the actual SKILL.md, LOGIC.md, and UI.md line by line, and the discipline is tighter than the one-liner suggests.

## Pick a Branch Before You Write a Line

The skill's first move is the one most people skip: it forces you to name **which question the prototype answers**, because the answer changes the artifact completely. Two branches, two very different outputs.

If the question is "does this logic or state model feel right?" you get a **logic prototype** — a single self-contained HTML file a non-developer double-clicks and drives by pressing buttons. If the question is "what should this look like?" you get a **UI prototype** — three structurally different variations of one route, switchable with a floating bar. Getting the branch wrong wastes the whole prototype, so if the user isn't around to decide, the skill says to default by the surrounding code: a backend module points to logic, a page or component points to UI.

That split is the genuine insight. A logic question dressed up as UI work — or vice versa — guarantees a worthless artifact, because the thing being judged isn't what you built.

## The Rules That Keep It Throwaway

Six rules run across both branches, and they read like a contract between you and your future self. The prototype must be **trivially runnable** (one command, or an HTML file you double-click) and **clearly marked as throwaway** — named so a casual reader sees it isn't production. **No persistence by default**: state lives in memory, because persistence is usually the very thing the prototype is testing. **Skip the polish**: no tests, no error handling beyond what makes it runnable, no abstractions. And after every action, **surface the full state** so the user can see exactly what changed.

The sharpest rule is the capture step. When the question's answered, the validated decision folds into the real code, and the prototype itself is committed to a **throwaway branch, out of main**, with a context pointer left on the implementation issue. Main keeps only the validated decision. This is what makes the skill honest: the experiment's evidence survives, but never masquerades as shipped product.

## Why the Logic Module Has to Be Portable

The LOGIC.md branch contains the most transferable idea in the whole skill. It demands you isolate the logic in a **small pure module** — a reducer `(state, action) => state`, a state machine, or a few pure functions — with no DOM, no `document`, no button handlers reaching inside. The HTML page is a thin shell that calls into it, never the reverse.

That purity is what lets the prototype outlive itself. Once the question's answered, the validated reducer lifts straight into the real module, on its own, because it was never tangled with the page. The page is throwaway; the module is the part worth keeping. A logic demo written with the logic tangled into click handlers is useless after the demo — you reimplement it from scratch, and lose the validation that drove it here.

The human side matters too: every label is in **domain language, not code**. A designer or PM should read it like the business, not like a reducer. The skill builds guided walkthroughs — one tab per scenario, with the ordered buttons to press — designed around the awkward cases: the happy path, a tricky edge case, and an attempt at something that should be illegal.

## UI Branch: Three Variants, Not Wallpaper

The UI branch's core rule is that variants must be **structurally different**. Different layout, different information hierarchy, different primary affordance — not three shades of the same card grid. The skill defaults to three variants and caps at five, because beyond that "radically different" collapses into noise. It pushes counterpart advice: if two drafts come out too similar, redo one with explicit "do not use a card grid" guidance.

The clearest detail is sub-shape A over sub-shape B. A UI prototype is far easier to judge when it's **butting up against the rest of the app** — real header, real sidebar, real data, real density. So the default is to mount the variants on an *existing page*, gated by a `?variant=` URL param, and only reach for a fresh throwaway route when there's genuinely nowhere to host them. A variant in a vacuum looks great; the same variant next to real data falls apart fast. That's the whole point.

## Real Talk: What the Source Reveals

Two details stand out that the README doesn't stress. First, the skill **purposefully despises polish**: a prototype that needs tests "is no longer a prototype," and a prototype that needs a framework, bundler, or server defeats "shareable." If you reach for either, you've silently crossed out of prototyping and into building. Second, the coordination story. Prototype is the *front* of a pipeline: [grill-with-docs](/skills/general/grill-with-docs/) and [domain-modeling](/tutorials/guides/domain-modeling-procedural-guide/) sharpen the model first, Prototype answers the risky question cheaply, then [tdd](/tutorials/guides/i-tried-tdd-with-an-ai-assistant/) and [triage](/skills/general/handoff/) carry the validated answer into production. It slots in far earlier and more cheaply than most people expect.

## Bottom Line

Prototype solves the cheap-and-risky moment that sits before real commitment: it turns an unanswerable-on-paper question into a thing someone can click, without turning the click thing into production debt. You get a branch decision that matches the question, a pure logic module that lifts into production, three UI variants that disagree about structure, and a throwaway-branch capture step that keeps experiments out of main. It costs nothing — the whole repo is MIT-licensed — and needs no config. Run `npx skills@latest add mattpocock/skills` and select `prototype`. Next time you're about to spend a day building the "wrong thing that might be right," answer one question first — logic or UI? — and let the skill build you the flingable version. To see the sibling discipline that sharpens the model before you prototype, read the [Domain Modeling guide](/tutorials/guides/domain-modeling-procedural-guide/).
