---
title: "Getting Started with Claude Code: A Complete Tutorial"
date: 2026-05-30
draft: false
tags:
  - tutorial
  - AI Coding
  - CLI
description: "Learn how to install, configure, and master Claude Code for AI-assisted development"
related_skills:
  - claude-code
category: "guides"
rating: 5
---

Claude Code is Anthropic's agentic coding tool. This tutorial will get you up and running.

## Installation

```bash
npm install -g @anthropic-ai/claude-code
```

Or use the direct method:

```bash
# Using the install script
curl -sS https://claude.ai/install | bash
```

## Basic Usage

Navigate to your project and start a session:

```bash
cd my-project
claude
```

## Key Commands

- `/help` — Show available commands
- `/clear` — Clear conversation history
- Cost mode — Monitor token usage

## Pro Tips

1. **Let it explore** — Claude Code reads your entire codebase before making changes
2. **Use git** — Claude Code is git-aware and will suggest commits
3. **Be specific** — The more context you give, the better the results
