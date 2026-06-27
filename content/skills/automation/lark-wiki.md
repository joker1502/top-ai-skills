---
title: "Lark Wiki"
date: 2026-06-20
draft: false
tags:
  - Lark
  - Feishu
  - Wiki
  - Knowledge Base
  - Collaboration
description: "AI skill for searching, reading, and managing Lark/Feishu wiki pages and knowledge bases directly from your coding assistant. Part of the larksuite CLI ecosystem with 26 agent skills."
version: "1.0.0"
author: "larksuite"
repo_url: "https://github.com/larksuite/cli"
install_cmd: "npx skills add https://github.com/larksuite/cli --skill lark-wiki"
compatibility:
  - Claude Code
  - Cursor
  - Codex
category: "automation"
rating: 4.0
github_stars: 14753
github_forks: 1016
installs: 192000
last_updated: "2026-06-27"
ai_friendliness:
  score: 4.0
  documentation: 4.0
  setup: 4.0
  config: 4.0
---

## What It Is

Lark Wiki is the knowledge base skill from larksuite's CLI ecosystem — it lets your AI coding assistant search wiki pages, fetch content, create new pages, and manage Lark/Feishu wikis without leaving the terminal. Think of it as having a permanent read-write connection to your team's internal documentation, accessible from any prompt.

## What's Actually Different

The Lark suite spreads across five separate products — Docs, Wiki, Base, Sheets, and Calendar — each a different skill under the same CLI. Lark Wiki specifically handles the tree-structured knowledge base: search across wikis, read page trees, create new pages with markdown content, and list recent updates. What sets it apart from a generic browser-based wiki approach is that your AI agent can search and retrieve wiki content mid-conversation, then reference it in code or decisions without you tabbing out. Compared to exporting wikis as PDFs or copy-pasting, the feedback loop collapses to zero.

## Who It's For

Install this if your team uses Lark/Feishu for internal documentation and you want your AI assistant to actually read it — PR descriptions referencing company policies, code generation that follows internal style guides, or automated wiki updates from CI pipelines. Skip it if your team is on Confluence, Notion, or any wiki outside the Lark ecosystem — this skill only connects to Lark Wiki servers.

## Bottom Line

Lark Wiki makes your AI assistant conversational with your company's internal documentation, as long as your docs live inside Lark.
