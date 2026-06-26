---
title: "Find Skills"
date: 2026-06-01
draft: false
tags:
  - Search
  - AI Search
  - Discovery
description: "Helps Claude Code discover and install agent skills from the open ecosystem, acting as a package manager for AI capabilities"
version: "1.0.0"
author: "Vercel"
repo_url: "https://github.com/vercel-labs/skills"
install_cmd: "npx skills add vercel-labs/skills"
compatibility:
  - Claude Code
  - Cursor
  - Codex
  - Perplexity
category: "search"
rating: 4.0
github_stars: 23588
github_forks: 1911
installs: 1800000
last_updated: "2026-06-25"
ai_friendliness:
  score: 4.0
  documentation: 4.0
  setup: 4.0
  config: 4.0
---

## What It Is + Verdict

Find Skills is Vercel's official skill for discovering and installing other skills. It turns Claude into a skill package manager — search, evaluate, and install capabilities without leaving your terminal.

## The One Thing That Matters

The skill enforces a quality gate before recommending anything. It checks install counts, source reputation, and GitHub stars, and explicitly warns against recommending skills under 100 installs or from unknown authors. This trust layer is what separates it from a raw search tool.

## What's Actually Different

Unlike browsing skills.sh manually, Find Skills works inside your existing Claude session. When you ask "is there a skill for X", Claude runs the search, filters results through quality checks, and presents options with install commands ready to copy. The skill also knows the leaderboard top performers by category, so common requests resolve instantly without a network call.

## Who It's For

Anyone who uses Claude Code regularly and wants to extend its capabilities without interrupting their flow. Especially useful for users who know what they want to accomplish but don't know which skill does it. Less relevant if you already know exactly which skills you need and just install them directly.

## Bottom Line

Find Skills is the on-ramp to the entire agent skill ecosystem, and every Claude Code user should have it installed.
