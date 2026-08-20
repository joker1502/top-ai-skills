---
title: "Prototype vs TDD: When to Explore Throwaway and When to Go Test-First"
date: 2026-08-20
toc: true
draft: false
tags:
  - Prototype vs TDD
  - Agent Skills
  - Engineering Workflow
category: "comparison"
description: "The Matt Pocock skills offer two ways to build something new: Prototype throws code away to answer a question, TDD locks it down test-first. Pick right."
---

The same idea can be built two radically different ways inside the Matt Pocock skills family, and picking wrong wastes a day. [Prototype](/skills/general/prototype/) makes you write throwaway code that answers one question and then throw it away. [TDD](/tutorials/guides/i-tried-tdd-with-an-ai-assistant/) makes you lock behavior down test-first, from the first line. Both live in [mattpocock/skills](https://github.com/mattpocock/skills) (223K stars), both rank in the top ~15 on skills.sh, and both solve "turn an idea into code" — but they're built for opposite moments. I read the actual SKILL.md files for prototype, tdd, to-spec, implement, and code-review, and the boundary between them is sharper than the descriptions suggest.

## What Each Skill Actually Demands

[Prototype](/skills/general/prototype/) (skills.sh #12, ~34K weekly installs) forces a branch decision up front: is the question "does this logic feel right?" or "what should this look like?" The logic branch produces a single, self-contained HTML file a non-developer double-clicks. The UI branch produces three structurally different variants of one route, switchable with a floating bar. Its hard rules are the opposite of production discipline: **no tests, no persistence by default, no polish, no abstractions**. Its capture step is the tell — the validated decision folds into real code, and the prototype itself goes to a throwaway branch, out of main.

[TDD](/tutorials/guides/i-tried-tdd-with-an-ai-assistant/) (skills.sh #6, ~726K installs) is the red→green loop turned into a reference. Its core constraint is the **seam**: the public boundary where you observe behavior without reaching inside. The skill refuses to write a single test at an unconfirmed seam — "test only at pre-agreed seams" is the rule. Tests verify behavior through public interfaces, never implementation details, and a good test reads like a specification: "user can checkout with valid cart" tells you exactly what capability exists and survives refactors.

The difference is in the intent. Prototype treats uncertainty about the *idea* as the job; TDD treats uncertainty about the *implementation's correctness* as the job.

## Where the Boundary Actually Lives

The boundary isn't "prototyping is early, TDD is late." It's about **what's uncertain** and **what must survive**.

Prototype is for the question that can't be answered on paper — a state model that only feels wrong when you push it through real cases, or a layout you can't judge until it butts up against real data. The whole point is that the artifact is disposable. Prototype's own anti-patterns make this explicit: "a prototype that needs tests is no longer a prototype," and "don't generalise" — no "what if we wanted to support X later."

TDD is for the moment the shape is settled and you need it to *stay* right. Its investment is in the seam: finding the highest public boundary, confirming it with the user before writing anything, then locking behavior there so refactors don't silently break it.

So here's the decision I landed on: **prototype when the answer is unknown and the code is discardable; TDD when the behavior is agreed and the code must be durable.** If you prototype with TDD's discipline, you've crossed into building and you're no longer exploring cheaply. If you TDD an unagreed idea, you write tests for behavior you're about to throw away.

## The Family Coordinates Between the Two

What makes the comparison real is that the family *connects* them rather than just offering both. The pipeline reads like a relay instead of competing tools. [to-spec](/tutorials/guides/domain-modeling-procedural-guide/) and [domain-modeling](/tutorials/guides/domain-modeling-procedural-guide/) sharpen the model and write the spec — this is where prototype's verdict gets folded in as a real decision. Then [to-tickets](/skills/general/to-prd/) breaks the spec into tracer-bullet vertical slices, [implement](/tutorials/guides/how-to-build-first-ai-automation-workflow/) runs the work using TDD "where possible, at pre-agreed seams," and a code-review pass checks the diff along two axes: standards and spec.

The shared vocabulary is the giveaway that they're one system. Prototype's logic module is a pure reducer `(state, action) => state` — deliberately sketched so it can "lift into the real module on its own." That's the same shape TDD wants to test at. And code review checks "does the code faithfully implement the originating spec?" — the spec that to-spec produced and prototype de-risked. Each skill hands off to the next instead of fighting it.

## Real Talk: Where I'd Use Each

The source reveals one thing the descriptions bury: prototype is cheap *because* it skips tests, and that's a feature only when you're willing to discard. The moment you think "we could probably ship this variant," you've left Prototype's contract and entered implement territory — and the skill tells you to rewrite it properly when you fold it in, because "the variant code was written under prototype constraints."

TDD, by contrast, is the skill you reach for when the cost of being wrong compounds. Its anti-pattern list — tests that mock internal collaborators, verify through side channels, or break on refactor — is written for the codebase you'll live in for months.

My working rule after reading all five: **build the throwaway if you're not sure the idea is good, build the test-first production path if you're sure the idea is good and need it to hold.** And never confuse the two — the mattpocock family handles both, but treating prototype output as shippable, or TDD as a way to explore an unknown idea, is where both fail.

## Which One Fits You

Reach for [Prototype](/skills/general/prototype/) when the question is "how should this even work" — a state machine that feels off on paper, a dashboard you can't judge in a vacuum. Reach for [TDD](/tutorials/guides/i-tried-tdd-with-an-ai-assistant/) (via [implement](/tutorials/guides/how-to-build-first-ai-automation-workflow/)) when the behavior is agreed and you're committing to a durable change. If you already run the [setup-matt-pocock-skills](/skills/general/setup-matt-pocock-skills/) family, both are one install away — and the [domain-modeling](/tutorials/guides/domain-modeling-procedural-guide/) and [handoff](/skills/general/handoff/) skills wire the work between them. The honest answer for most features is a small prototype first, then TDD to carry the validated answer home.
