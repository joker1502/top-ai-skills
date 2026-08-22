---
title: "Codebase Design Skill: Deep Modules That Earn Their Interface"
date: 2026-08-22
draft: false
tags:
  - Codebase Design
  - AI Agent
  - Engineering
description: "Matt Pocock's Codebase Design standardizes deep-module vocabulary — depth, seams, adapters, the deletion test — so agents build interfaces with real leverage."
version: "1.0"
author: "Matt Pocock"
repo_url: "https://github.com/mattpocock/skills"
install_cmd: "npx skills@latest add mattpocock/skills"
compatibility:
  - Claude Code
  - Codex
  - Cursor
category: "general"
rating: 4.7
github_stars: 228813
github_forks: 19571
installs: 455600
last_updated: "2026-08-22"
ai_friendliness:
  score: 4.7
  documentation: 4.8
  setup: 4.6
  config: 4.6
---

Most "design" skills tell an agent to write cleaner code. Matt Pocock's Codebase Design skill instead hands it a fixed vocabulary — module, interface, depth, seam, adapter — and forbids substitutions. I pulled the SKILL.md from the [mattpocock/skills](https://github.com/mattpocock/skills) repo (228K stars, same family as [code-review](/skills/general/code-review/) and [handoff](/skills/general/handoff/)) and the strict glossary is the whole trick: you can't design a boundary if \"boundary\" means three different things.

## The Vocabulary: Precision Is the Feature

The skill defines **module** as anything with an interface and an implementation — deliberately scale-agnostic: a function, class, package, or tier-spanning slice qualifies. **Interface** means everything a caller must know to use it correctly: the type signature, plus invariants, ordering constraints, error modes, config, and performance characteristics. **Depth** is leverage at the interface: how much behavior a caller or test can exercise per unit of interface they must learn.

The glossary exists because vague words destroy the conversation. \"API\" and \"signature\" get rejected as too narrow — they cover only the type-level surface. \"Boundary\" is banned outright for being overloaded by DDD's bounded context. \"Service\" and \"component\" are banned because they smuggle in structural assumptions. When an agent calls something a module, every later instruction about it means the same thing.

## The Deletion Test: Does the Module Earn Its Keep?

Here's the sharpest tool in the file. To judge any module, imagine deleting it. If complexity vanishes, it was a pass-through — an interface no thinner than its implementation. If the complexity reappears scattered across N callers, the module was earning its keep: one implementation paying back across many call sites.

The skill pairs this with the **one-adapter rule**: a single adapter means a hypothetical seam, two adapters means a real one. I found this the easiest rule to see in practice — teams routinely wrap one Postgres repo in an interface \"for testability\" and then mock it everywhere, which is a seam in search of a second adapter that never arrives.

## Design for the Test Surface, Not Around It

The interface is the test surface: callers and tests cross the same seam. If you want to test *past* the interface, the module has the wrong shape. Three rules follow directly. Accept dependencies, don't create them — a function that constructs `new StripeGateway()` inside is untestable while one that takes the gateway as a parameter isn't. Return results, don't produce side effects — `calculateDiscount(cart): Discount` beats `applyDiscount(cart): void` every time. Keep the surface small; fewer methods means fewer tests, fewer params means simpler setups.

Internally, a deep module can be made of small, swappable parts with **internal seams** used only by its own tests. Depth is a property of the interface, not the implementation — the internals stay private.

## What the Skill Rejects, Deliberately

The file is refreshingly explicit about rejected framings. Ousterhout's depth-as-ratio — implementation lines divided by interface lines — gets refused because it rewards padding the implementation. The skill uses depth-as-leverage instead. Depth-as-lines also breaks down on adapters: a Postgres repository is a small adapter with a large implementation, an in-memory fake is a large adapter with a small implementation, and both are legitimate.

```text
Deep module   = small interface + lots of implementation
Shallow module = large interface + thin implementation  (avoid)
```

## Bottom Line

Codebase Design converts taste into checkable criteria: a glossary both the human and the agent share, the deletion test to justify existence, the one-adapter rule to time seams, and test surface as the design constraint. It slots into the mattpocock pipeline — [domain-modeling](/tutorials/guides/domain-modeling-procedural-guide/) decides the model, [prototype](/skills/general/prototype/) cheaply tests risky questions, and this skill shapes the modules the rest of the work sits on. Install it with `npx skills@latest add mattpocock/skills`, pick `codebase-design`, then try the deletion test on your most-touched module tonight — I suspect the result surprises you.