---
title: "Improve Codebase Architecture"
date: 2026-06-04
draft: false
tags:
  - Architecture
  - Code Quality
  - Refactoring
  - Coding
description: "Matt Pocock's skill for finding deep architectural improvements in your codebase based on domain language and ADRs"
version: "1.0.0"
author: "Matt Pocock"
repo_url: "https://github.com/mattpocock/skills"
install_cmd: "npx skills@latest add mattpocock/skills"
compatibility:
  - Claude Code
  - Codex
  - Cursor
category: "coding"
rating: 5.0
github_stars: 138739
github_forks: 12037
installs: 205000
last_updated: "2026-06-18"
ai_friendliness:
  score: 5.0
  documentation: 5.0
  setup: 4.0
  config: 4.0
---

## What It Is

Makes AI scan your codebase to find deep architectural improvement opportunities based on domain language and ADRs (Architecture Decision Records). Not surface-level refactoring like extracting functions or renaming variables — it identifies module coupling, responsibility blur, and abstraction mismatches.

## What's Actually Different

Ask AI to "optimize my code" and it usually does local improvements. This skill makes AI first understand your domain model, then find architecture-level issues. Works best with the CONTEXT.md file from Matt Pocock's suite — so AI knows what your project's terms mean.

## Who It's For

Teams with codebases that have grown past the "new project" stage and are showing technical debt. If your code works but keeps getting harder to change, this skill systematically identifies what to refactor.

## Bottom Line

AI doesn't just write code — it helps you find where your architecture is broken.
