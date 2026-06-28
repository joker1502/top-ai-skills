---
title: "Lark Base"
date: 2026-06-21
draft: false
tags:
  - Lark
  - Feishu
  - Base
  - Database
  - Collaboration
description: "AI skill for reading and managing Lark/Feishu Base records and tables from your coding assistant. Part of the larksuite CLI with 26 agent skills."
version: "1.0.0"
author: "larksuite"
repo_url: "https://github.com/larksuite/cli"
install_cmd: "npx skills add https://github.com/larksuite/cli --skill lark-base"
compatibility:
  - Claude Code
  - Cursor
  - Codex
category: "automation"
rating: 4.0
github_stars: 14780
github_forks: 1018
installs: 80000
last_updated: "2026-06-28"
ai_friendliness:
  score: 4.0
  documentation: 4.5
  setup: 3.5
  config: 4.0
---

## What It Is

A skill inside the larksuite CLI that gives your AI agent structured access to Lark Base — the spreadsheet-database hybrid in Lark's productivity suite. Your assistant can query records, create and update rows, list tables, and search across bases, all through natural language instead of clicking through the web UI or writing raw API calls.

## What's Actually Different

Most database queries from an AI agent require either a SQL connection string in your environment or a custom API wrapper that breaks every time the schema changes. Lark Base uses the same shared authentication as the other 25 skills in the larksuite CLI — the same login that reads documents, manages wikis, and creates calendar events also handles Base operations. Compared to setting up a direct database connection, you get row-level access control through Lark's permission model, schema-aware queries that respect field types, and no credential sprawl across your tooling.

## Who It's For

Install this if your team uses Lark Base to track project tasks, customer data, inventory, or anything structured — and you want your AI assistant to query or update that data mid-conversation without context-switching to a browser. Skip it if you don't use Lark, or if your data lives in a traditional SQL database where direct querying would be simpler.

## Bottom Line

Your AI assistant queries and updates Lark Base tables as naturally as it reads your source code.
