---
title: "Skill Creator"
date: 2026-06-01
draft: false
tags:
  - Development
description: "Guides Claude through creating, packaging, and iterating on custom agent skills with progressive disclosure and bundled resources"
version: "1.0.0"
author: "Anthropic"
repo_url: "https://github.com/anthropics/skills"
install_cmd: "npx skills add anthropics/skills"
compatibility:
  - Claude Code
  - Cursor
  - Codex
category: "general"
rating: 4.0
github_stars: 151929
github_forks: 17917
installs: 250700
last_updated: "2026-06-09"
ai_friendliness:
  score: 4.0
  documentation: 4.0
  setup: 4.0
  config: 4.0
---

## What It Is + Verdict

Skill Creator is Anthropic's official guide for building your own agent skills. It documents the skill format, creation workflow, and packaging process — essential reading if you want to publish skills or customize existing ones.

## The One Thing That Matters

The skill teaches progressive disclosure: skill metadata (name + description) is always in context, the SKILL.md body loads when the skill triggers, and bundled resources load on demand. This context-aware design is what keeps skill invocation fast — the model only reads what it needs.

## What's Actually Different

Most skill documentation assumes you learn by reading examples. Skill Creator provides a concrete 6-step process: understand, plan, initialize, edit, package, iterate. It ships with reference files for workflows and output patterns, and provides CLI tools (init_skill.py, package_skill.py) to automate the scaffolding. It treats skill authoring as a development workflow, not a writing exercise.

## Who It's For

Use it if you maintain multiple skills, want to package internal workflows as reusable capabilities, or need to teach others how to create skills. Skip it if you only consume existing skills and never author new ones — you do not need this installed.

## Bottom Line

Skill Creator is the meta-skill for the agent skill ecosystem — it teaches you how to teach your agent.
