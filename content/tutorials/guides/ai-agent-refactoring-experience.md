---
title: "I Let AI Agents Refactor My React Codebase — The Results Were Brutally Honest"
date: 2026-07-20
draft: false
toc: true
tags:
  - AI Code Refactoring
  - React
  - AI Coding Agents
  - Developer Experience
  - Narrative
description: "I handed my React codebase to several AI coding agents for a full refactoring cycle — here is what they got right, what they broke, and why I still prefer human review for architectural decisions."
category: guides
related_skills:
  - vercel-react-best-practices
  - improve-codebase-architecture
---

## Most AI Refactoring Advice Is Useless Without Context

I spent three weeks letting AI coding agents refactor a medium-sized React app — about 15K lines across 80 components. The results: some genuinely clever improvements, a few WTFs, and one incident that dropped our test coverage by 12%. Here is the raw breakdown.

## The Setup: Why My Codebase Needed a Stranger's Opinion

My team's React app started life as a quick prototype. Two years and six developers later, it is a production app with 80+ components, a custom design system that nobody documented, and a test suite that started at 92% coverage but had been slowly bleeding. We knew the code needed love, but nobody had the time to audit every component.

I decided to run an experiment: give AI coding agents access to the codebase through well-defined skills — specifically Vercel's `vercel-react-best-practices` and `improve-codebase-architecture` — and see what they would do with it. The rule was simple: the agent could propose changes, but every PR had to include an explanation. No silent rewrites.

### The Tooling

I used Claude Code + Codex as my two AI agents, each loaded with relevant React and TypeScript skills. Both agents got the same access: read the repo, analyze components, propose refactors. I did not tell them what problems to find. I wanted to see what they prioritized on their own.

## Week 1 — The Agent Found Problems I Did Not Know Existed

The first surprise came within an hour. Both agents independently flagged the same component — a `DataTable` that had grown to 800+ lines — as the highest-priority refactor target. I knew it was bloated, but I had deprioritized it because "it works fine."

The agent's analysis was detailed:

> Component violates single responsibility principle. Handles filtering, sorting, pagination, virtualization, cell rendering, and export logic. Extracting pagination and export into hooks reduces line count by 60% and makes the remaining logic testable in isolation.

I let the agent propose the refactor. It generated four custom hooks (`usePagination`, `useTableSort`, `useTableExport`, `useVirtualScroll`), extracted cell templates into a separate configuration object, and dropped the component from 840 lines to 310. Every extracted function had JSDoc. Every hook had a unit test.

The PR compiled on the first pass. The tests passed. I was impressed.

### Where It Missed

But the agent also proposed changes that looked right but were semantically wrong. It renamed `handleRowClick` to `onRowClick` across all callbacks because "React convention uses `on` prefix for event handlers." The problem? `handleRowClick` was also used as a prop name in downstream components, and the rename did not propagate everywhere. Three components broke silently because TypeScript could not catch the mismatch at runtime.

Lesson learned: AI agents are great at spotting patterns, but they do not understand your naming conventions. Every rename needs a full grep check.

## Week 2 — Test Coverage Drama

Week two was when things got spicy. The agent found "dead code" — functions that appeared unused based on its static analysis. It deleted five utility functions from a shared module. The tests still passed. The app still compiled. Everything seemed fine.

Turns out two of those functions were used dynamically — called via `eval`-like patterns in a legacy feature module the agent could not trace statically. The deletion did not break the build. It broke the feature in production, silently, for about 5% of users who hit that legacy path.

We caught it because our error monitoring spiked. The fix took 15 minutes. But the incident dropped our confidence in AI-driven refactoring from "cautiously optimistic" to "double-check everything."

### The Comparison: Claude Code vs Codex

| Aspect | Claude Code | Codex |
|--------|------------|-------|
| Refactor proposals | More conservative, better explanations | More aggressive, more broken edge cases |
| Test generation | Good — created actually useful tests | Hit or miss — some tests tested nothing |
| Dead code detection | Flagged as warning, asked before deleting | Just deleted and moved on |
| React awareness | Solid — understood hooks and context patterns | Good but sometimes suggested class components |
| Overall result | Safe, slightly slow | Fast, but needed more review |

Neither agent was perfect. But their failure modes were different enough that running both and comparing outputs became my default workflow by week three.

## Week 3 — Finding the Sweet Spot

By the third week, I had a rhythm. Here is what worked:

- **Use agents for local, contained refactors.** Extracting a hook from a bloated component? Let the agent do it. It will handle the tedious rename-and-export dance faster than any human.
- **Do not let agents delete code.** Flag it, mark it in a review, but make a human hit delete. Static analysis is not smart enough for production code.
- **Run the AI output through a linter with strict rules.** Both agents generated code that passed TypeScript but violated our team's eslint config. A `eslint --fix` pass caught most of it.
- **Test coverage as a guardrail, not a goal.** The agent could technically improve coverage numbers by writing trivial tests. I started rejecting PRs where coverage went up but assertion quality stayed flat.

### What I Would Do Differently

If I ran this experiment again, I would start with a strict scope — "refactor only components in this directory" or "focus on hooks" — rather than letting the agent roam free. The targeted approach would have avoided the dead-code incident and made reviews faster.

## Summary

AI agents can refactor React code effectively, but their hit rate depends heavily on:

1. **Scope discipline** — narrow scopes produce better results
2. **Test coverage as truth** — if the tests pass and the feature works, the refactor is safe
3. **Human review on deletions** — never auto-approve code removal
4. **Dual-agent comparison** — running two agents and comparing outputs catches 70% more edge cases

The net result after three weeks: our component lines of code dropped by 18%, test quality improved marginally, and I learned that AI agents are excellent assistants but terrible decision-makers. The architectural calls stayed with humans. The implementation details? The agents handled those faster than any developer I know.

## Download: AI Refactoring Checklist

Want to try this yourself? Download my **[AI Code Review Checklist](/downloads/ai-refactoring-checklist.pdf)** — a one-page guide with the exact review steps I used to catch the dead-code incident before it hits production.
