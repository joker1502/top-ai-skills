---
title: "Tdd"
date: 2026-06-01
draft: false
tags:
description: "Test-driven development workflow using red-green-refactor cycles focused on behavior verification through public interfaces"
version: "1.0.0"
author: "Matt Pocock"
repo_url: "https://github.com/mattpocock/skills"
install_cmd: "npx skills add mattpocock/skills"
compatibility:
  - Claude Code
  - Cursor
  - Codex
category: "general"
rating: 4.0
github_stars: 113627
github_forks: 9956
installs: 0
last_updated: "2026-05-31"
ai_friendliness:
  score: 4.0
  documentation: 4.0
  setup: 4.0
  config: 4.0
---

## What It Is + Verdict

TDD is Matt Pocock's test-driven development skill that enforces a red-green-refactor workflow in Claude Code. It focuses on behavior testing through public interfaces — the most maintainable and effective testing approach.

## The One Thing That Matters

The skill explicitly forbids testing implementation details. Its core teaching is that tests should verify behavior through public APIs, not internal structure. If a rename breaks tests, those tests were testing the wrong thing. This principle alone prevents the most expensive testing anti-pattern — brittle tests that break on every refactor.

## What's Actually Different

Where typical TDD guidance focuses on unit testing isolated functions, this skill favors integration-style tests that exercise real code paths through public APIs. It enforces one-skill-at-a-time: write one failing test, make it pass, refactor, repeat. It also handles the practical challenges of AI-driven TDD — detecting the correct test runner, running targeted tests, and interpreting results without human intervention.

## Who It's For

Developers who want to practice real TDD with Claude, not just generate test files after writing code. Teams that struggle with brittle tests will benefit most from the behavior-first philosophy. Less useful for projects with no test infrastructure or developers who prefer writing implementation first and tests after.

## Bottom Line

TDD makes Claude practice genuine red-green-refactor — writing tests that verify behavior, not implementation.
