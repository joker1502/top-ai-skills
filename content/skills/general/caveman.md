---
title: "Caveman"
date: 2026-06-03
draft: true
tags:
  - Productivity
  - Token
  - AI Agent
  - Coding
description: "Ultra-compressed response mode for AI coding assistants — cuts output tokens by ~75% while keeping technical accuracy, ~3x faster"
version: "1.8.2"
author: "JuliusBrussee"
repo_url: "https://github.com/JuliusBrussee/caveman"
install_cmd: "curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh | bash"
compatibility:
  - Claude Code
  - Cursor
  - Codex
  - Windsurf
  - Cline
  - Copilot
category: "general"
rating: 5.0
github_stars: 69542
github_forks: 3919
installs: 205000
last_updated: "2026-05-20"
ai_friendliness:
  score: 5.0
  documentation: 5.0
  setup: 5.0
  config: 4.0
---

## What It Is

Caveman makes AI coding assistants respond in "caveman style" — all filler words removed, only core technical content remains. Average 75% reduction in output tokens, ~3x faster responses. Four compression levels from light deduplication to telegram-style ultra-minimal. Also includes memory file compression that rewrites CLAUDE.md and similar files, cutting ~46% of input tokens.

## What's Actually Different

Most people add "be concise" to their system prompt, but models ignore it frequently. Caveman installs as a Skill and hard-controls output style with guaranteed results. Unique features include `/caveman-stats` for real-time token/dollar savings tracking, `/caveman-compress` for rewriting memory files, and cavecrew sub-agents that use ~60% fewer tokens.

## Who It's For

Developers using Claude Code or similar tools daily. If you find yourself thinking "that was way too long" after every AI response, install this. Power users can pair it with caveman-shrink (MCP middleware) for compressed tool descriptions and cavecrew sub-agents for reduced sub-task token usage.

## Bottom Line

Same brain, smaller mouth — 75% less filler in every AI response.
