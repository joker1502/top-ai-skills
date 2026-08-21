---
title: "Code Review Skill: Two-Axis Review That Keeps Standards and Spec Honest"
date: 2026-08-21
draft: false
tags:
  - Code Review
  - AI Agent
  - Engineering
description: "Matt Pocock's Code Review skill checks Standards and Spec in parallel sub-agents against a 12-smell Fowler baseline, so one axis can't mask the other."
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
installs: 30000
last_updated: "2026-08-21"
ai_friendliness:
  score: 4.7
  documentation: 4.8
  setup: 4.6
  config: 4.6
---

A code review that only checks "does this look clean?" misses the more expensive failure: code that follows every standard but implements the wrong thing. Matt Pocock's Code Review skill fixes that by running **two reviews in parallel** — one against the repo's coding standards, one against the originating spec — and reporting them side by side, never merged. It comes from the [mattpocock/skills](https://github.com/mattpocock/skills) family (228K stars), which already powers [handoff](/skills/general/handoff/), [prototype](/skills/general/prototype/), and [domain-modeling](/tutorials/guides/domain-modeling-procedural-guide/). I read the actual SKILL.md line by line, and the two-axis split is the sharpest idea in it.

## The Two Axes That Refuse to Mask Each Other

The core move is a distinction most reviews blur: **Standards** (does this code follow the repo's documented conventions?) and **Spec** (does it do what the issue asked for?) are separate questions, so they run as separate sub-agents with separate context. Each brief caps its report under 400 words, so neither drowns out the other.

The reason for the split is a failure mode that's easy to miss in a one-pass review. A change can perfectly obey every lint rule and convention while implementing the wrong feature — that's **Standards pass, Spec fail**. Or it can nail the spec while breaking the project's architecture — **Spec pass, Standards fail**. If you merge them into one "quality" score, the axis that passes carries the axis that fails. The skill's instruction is blunt: never rerank or merge the two reports.

## The 12-Smell Baseline That Works Even on a Bare Repo

Here's the part I found most useful in practice. The Standards axis doesn't depend on a repo having good docs. It carries a fixed baseline of **twelve Fowler code smells** from *Refactoring* chapter 3, applied to every diff even when the repo documents nothing: Mysterious Name, Duplicated Code, Feature Envy, Data Clumps, Primitive Obsession, Repeated Switches, Shotgun Surgery, Divergent Change, Speculative Generality, Message Chains, Middle Man, Refused Bequest.

Two rules keep the baseline sane. First, **the repo overrides**: a documented repo standard always wins, so if the repo explicitly endorses something the baseline would flag, the smell is suppressed. Second, **every smell is a labelled judgement call** ("possible Feature Envy"), never a hard violation — and anything the tooling already enforces gets skipped entirely. That prevents the classic trap of an agent enumerating smells the linter already caught.

## Spec Sourcing: Finding the Issue Before Reviewing the Code

Before either sub-agent runs, the skill spends real effort tracking down the originating spec. It looks in this order: issue references in commit messages (`#123`, `Closes #45`, GitLab `!67`) via the repo's issue-tracker, a path the user passed, a spec file under `docs/` / `specs/` / `.scratch/` matching the branch name, and finally a question to the user. If there's genuinely no spec, the Spec sub-agent doesn't fabricate one — it reports "no spec available" and skips, which is more honest than pretending a review happened.

## Real Talk: What the Source Reveals

Two details stand out that the README doesn't stress. First, the skill **fails fast on the fixed point**: it runs `git rev-parse` and checks the diff is non-empty *before* spawning the two sub-agents, because a bad ref or empty diff should fail once, not twice at parallel cost. Second, the three-dot diff is deliberate — `git diff <fixed-point>...HEAD` compares against the merge-base, not just the branch head, so the review covers exactly the forks' share of work and nothing your collaborator hasn't touched.

## Bottom Line

Code Review solves the two most common review failures at once: reviews that only check style, and reviews that let a passing axis carry a failing one. You get a Standards report against both the repo's docs and a 12-smell Fowler baseline, a Spec report against the actual issue, and a side-by-side presentation that forbids merging them. It costs nothing — the whole repo is MIT — and slots straight into the mattpocock pipeline: [domain-modeling](/tutorials/guides/domain-modeling-procedural-guide/) sharpens the model, [prototype](/skills/general/prototype/) answers risky questions cheaply, [tdd](/tutorials/guides/i-tried-tdd-with-an-ai-assistant/) builds it test-first, and this skill reviews the result on both axes. Run `npx skills@latest add mattpocock/skills` and select `code-review`, then point it at any branch, PR, or `HEAD~N` and watch it report the two axes separately. Next time a teammate says "looks good to me," ask whether that was a Standards pass or a Spec pass too.
