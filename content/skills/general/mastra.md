---
title: "Mastra: Official AI Agent Skills for the Mastra Framework"
date: 2026-07-12
draft: false
tags:
  - General
  - Mastra
  - AI Framework
  - TypeScript
description: "Official Mastra agent skills for AI coding agents. Install with npx skills add mastra-ai/skills. Supports Claude Code, Cursor, and Codex."
version: "1.0"
author: "mastra-ai"
repo_url: "https://github.com/mastra-ai/skills"
install_cmd: "npx skills add mastra-ai/skills"
compatibility:
  - Claude Code
  - Cursor
  - Codex
  - GitHub Copilot
  - Windsurf
  - Cline
category: "general"
rating: 5
github_stars: 67
github_forks: 4
installs: 24050
last_updated: "2026-07-12"
ai_friendliness:
  score: 9
  documentation: 9
  setup: 9
  config: 8
---

The Mastra skill is the official agent skill for developers building with the <a href="https://mastra.ai" rel="nofollow">Mastra framework</a>. Mastra is a modern TypeScript framework for building AI-powered applications and agents. This skill gives your coding agent deep knowledge of Mastra's APIs, project setup, migrations, and troubleshooting — right inside your editor.

## What It Does

Instead of alt-tabbing to docs or asking a generic model about Mastra, your agent pulls from structured reference files included in the skill. It covers four main areas:

- **Setup & Installation** — walks through CLI-based project creation with `npx create-mastra`, plus manual configuration for custom setups.
- **Embedded Docs Lookup** — your agent reads API docs straight from `node_modules/@mastra/*/dist/docs/`, so answers stay version-specific.
- **Remote Docs Lookup** — falls back to the latest docs at `https://mastra.ai/llms.txt` when local docs are outdated or missing.
- **Troubleshooting & Migrations** — common error patterns and version upgrade workflows, like the alpha-to-beta migration path.

## Installation

```bash
npx skills add mastra-ai/skills
```

Or use the `.well-known` discovery endpoint:

```bash
npx skills add https://mastra.ai/
```

The skill works with any agent that supports the skills.sh protocol. If your agent can run `npx` commands, you're good.

## Why Use the Mastra Skill?

Mastra's framework is growing fast — 26K+ GitHub stars and 2.4K forks on the main repo. The agent skill keeps your coding environment in sync with that evolution. Instead of guessing which API is current or which migration step you missed, your agent checks the skill's reference files and gives you answers backed by the official docs.

The progressive disclosure design means the skill stays lean for simple questions but goes deep when you need it. Ask "how do I set up a Mastra agent?" and it hits the setup reference. Ask "what changed in the v0.2 API?" and it routes to the migration guide automatically.

## Compatibility

Tested with Claude Code, Cursor, Codex, GitHub Copilot, Windsurf, and Cline. The skill follows the <a href="https://agentskills.io" rel="nofollow">Agent Skills Specification</a>, so any agent implementing the standard can load it.

## Related Skills

Want to explore more skills for your agent stack? Check out the <a href="https://skills.sh" rel="nofollow">full collection on skills.sh</a>. For more skill intros and tutorials, visit [topaiskills.com](https://topaiskills.com) — a curated directory of the best AI agent skills.
