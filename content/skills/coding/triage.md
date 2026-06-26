---
title: "Triage"
date: 2026-06-24
draft: false
tags:
  - Issue Management
  - Project Management
  - Automation
description: "Matt Pocock's triage skill moves GitHub issues through a state machine of roles: categorize, verify, and write agent-ready briefs automatically."
version: "1.0.0"
author: "Matt Pocock"
repo_url: "https://github.com/mattpocock/skills"
install_cmd: "npx skills@latest add mattpocock/skills"
compatibility:
  - Claude Code
  - Codex
  - Cursor
category: "coding"
rating: 4.5
github_stars: 146808
github_forks: 12705
installs: 241000
last_updated: "2026-06-25"
ai_friendliness:
  score: 4.5
  documentation: 5.0
  setup: 3.0
  config: 4.0
---
## What It Is

An issue triage skill that turns your AI agent into a dedicated maintainer. It reads each issue or pull request, categorizes it as bug or enhancement, moves it through a state machine with five states, and writes a structured agent brief when an issue is ready to be picked up by another agent.

The workflow: an issue enters `needs-triage`, moves to `needs-info` if details are missing, advances to `ready-for-agent` or `ready-for-human` when it's fully specified, or closes as `wontfix`. The skill handles external PRs as issues with attached code, following the same flow.

## What's Actually Different

Most project management tools rely on humans to triage everything manually. GitHub Actions bots can auto-label based on keywords, but they don't read issues or understand context. Triage does more than label — it reads the full issue body, checks the codebase for existing implementations, scans `.out-of-scope` docs for prior rejections, and for bugs, reproduces the issue before writing a brief. It's more thorough than any automated labeler and faster than a human doing it alone.

## Who It's For

Maintainers of open-source or internal projects who get more issues than they can personally evaluate. The skill saves real time above ~20 open issues. Below that threshold, the setup — configuring issue labels and connecting your tracker — takes longer than the time it saves. Get it if you're spending 30 minutes per issue just figuring out what it is. Skip it if your project sees five issues a month.

## Bottom Line

Let AI do the first pass on every issue so you only look at ones that are already categorized, verified, and briefed.
