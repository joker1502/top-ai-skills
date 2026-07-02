---
title: "Agentspace"
date: 2026-07-02
draft: false
tags:
  - File Sharing
  - Collaboration
  - Agent Artifacts
  - Cloud Sync
keywords:
  - Agentspace
  - file sharing AI agent
  - share files from Claude Code
  - agent artifacts sharing
  - agentspace.so
  - AI workspace sharing
  - sync agent files
description: "Agentspace lets AI agents share folders, files, and generated artifacts via a shareable link — no API keys, no cloud account, one command."
version: "1.0.0"
author: "agentspace-so"
repo_url: "https://github.com/agentspace-so/skills"
install_cmd: "npx skills add agentspace-so/skills --skill agentspace -g"
compatibility:
  - Claude Code
  - Cursor
  - Codex
  - Windsurf
category: "general"
rating: 4.0
github_stars: 89
github_forks: 12
installs: 140000
last_updated: "2026-07-02"
ai_friendliness:
  score: 4.5
  documentation: 4.0
  setup: 5.0
  config: 4.5
---

## What It Is

Agentspace is a file-sharing skill for AI coding agents. Instead of copy-pasting output or describing what your agent generated, you say "share this folder" and it returns a URL. Anyone with the link can view or edit the shared workspace — no sign-up, no API key, no cloud account required.

The skill is published by agentspace-so and lives alongside Find Skills in the same [agentspace-so/skills](https://github.com/agentspace-so/skills) repo. It works with Claude Code, Cursor, Codex, and Windsurf. Install it globally with `npx skills add`, then invoke it by telling your agent to share the current folder or specific files.

## What's Actually Different

Most file-transfer workflows with AI agents involve manual steps: copy the file path, switch to a sharing tool, upload, copy the link, switch back. Agentspace eliminates every intermediate step. The agent detects the best install path (`ascli` → `npx` → `curl`), syncs the folder to cloud storage, and returns a link — all from within the chat.

The shareable workspaces keep edit permissions by default, which means another agent (or a teammate) can open the link, see the full project context, and pick up where you left off. This makes it practical for handoffs: give another agent access to the workspace and it can read the files, the conversation history, and the generated artifacts without you re-explaining the context.

It also handles agent-to-agent collaboration. If you're running two agents on different tasks, you can share a workspace between them. The receiving agent reads the files, understands the project structure, and continues working without a human intermediary.

## Who It's For

Install this if you regularly need to share AI-generated artifacts — code, reports, design files, build output — with teammates or other agents. It's especially useful for remote collaboration where describing "what the agent built" takes longer than sharing the workspace itself.

Skip it if you work alone and never share agent output, or if your sharing needs are limited to small text snippets that fit in a chat message. For anything larger than a few hundred lines, the link-based sharing saves time.

## Bottom Line

Share what your agent built with a single command — no tabs, no uploads, no context switching.
