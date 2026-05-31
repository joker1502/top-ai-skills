---
title: "Claude Code"
date: 2026-05-30
draft: false
tags:
  - AI Coding
  - CLI
  - Agent
description: "An agentic coding tool from Anthropic that runs in your terminal"
version: "0.1.0"
author: "Anthropic"
repo_url: "https://github.com/anthropics/claude-code"
install_cmd: "npm install -g @anthropic-ai/claude-code"
compatibility:
  - Claude Code
  - Cursor
  - VS Code
category: "coding"
rating: 4.8
github_stars: 128537
github_forks: 20954
installs: 185000
last_updated: "2026-05-30"
ai_friendliness:
  score: 4.2
  documentation: 4.5
  setup: 4.0
  config: 4.0
---

Claude Code is Anthropic's agentic coding tool. It operates directly in your terminal, understanding your codebase and helping you code faster.

## Key Features

- Deep codebase understanding
- Terminal-native interface
- Multi-file editing
- Git-aware operations

## Usage

Run `claude` in your project directory to start a session.

```bash
cd my-project
claude
```

## Configuration

Create a `.clauderc` file in your project root:

```yaml
# .clauderc
model: claude-sonnet-4-20250514
system_prompt: "You are an expert developer..."
allowed_tools:
  - Read
  - Edit
  - Bash
  - Glob
```

## Best Practices

- Always start with a clear goal
- Use `/help` to discover available commands
- Let Claude explore the codebase before making changes
