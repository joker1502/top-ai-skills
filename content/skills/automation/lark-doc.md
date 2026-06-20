---
title: "LarkDoc"
date: 2026-06-15
draft: false
tags:
  - Lark
  - Feishu
  - Documents
  - Collaboration
description: "AI skill for reading, creating, and editing Lark/Feishu documents directly from your coding assistant. Part of the larksuite CLI ecosystem with 26 agent skills."
version: "2.0.0"
author: "larksuite"
repo_url: "https://github.com/larksuite/cli"
install_cmd: "npx skills add https://github.com/larksuite/cli --skill lark-doc"
compatibility:
  - Claude Code
  - Cursor
  - Codex
category: "automation"
rating: 4.5
github_stars: 14424
github_forks: 994
installs: 236820
last_updated: "2026-06-20"
ai_friendliness:
  score: 4.5
  documentation: 5.0
  setup: 4.0
  config: 4.0
---

## What It Is

A skill inside the larksuite CLI that gives your AI agent direct access to Lark (Feishu) documents. Your assistant can fetch document content, create new docs, append or update blocks, insert images, and generate whiteboards — all through natural language commands instead of clicking through the web UI.

## What's Actually Different

Most document automation tools require custom API wrappers or Zapier-style integrations that break on the first auth refresh. This skill is part of a purpose-built CLI with 200+ commands and 26 agent skills, all sharing a single authentication session. The same login that lets your agent read a document also lets it create Base records, manage calendar events, and send chat messages. Compared to building bespoke API calls, you get a tested, maintained integration that stays in sync with Lark's platform updates.

## Who It's For

Worth installing if your team uses Lark for documentation and you want your AI assistant to retrieve, summarize, or produce documents from your coding session. If you're the person who writes meeting notes in Lark and then pastes them into your AI tool for summarization, this eliminates the copy-paste step. Skip it if you don't use Lark — it's tightly coupled to the platform.

## Bottom Line

Your AI assistant reads and writes Lark documents as naturally as it reads your source code.
