---
title: "Azure AI"
date: 2026-06-26
draft: false
tags:
  - AI Automation
  - Azure
  - AI Search
  - OpenAI
description: "Azure AI is a skills.sh skill that exposes Azure AI Search, Speech, OpenAI, and Document Intelligence as agent-callable tools through a single MCP server interface."
version: "1.1.73"
author: "microsoft"
repo_url: "https://github.com/microsoft/azure-skills"
install_cmd: "npx skills add https://github.com/microsoft/azure-skills --skill azure-ai"
compatibility:
  - Claude Code
  - Cursor
  - Codex
  - GitHub Copilot
  - Windsurf
  - Gemini
  - Cline
  - OpenCode
category: "automation"
rating: 4.0
github_stars: 1238
github_forks: 194
installs: 415000
last_updated: "2026-06-26"
ai_friendliness:
  score: 4.5
  documentation: 4.5
  setup: 4.0
  config: 4.0
---

## What It Is

Azure AI is a skill that bridges your coding agent to four Azure AI services — AI Search, Speech, OpenAI, and Document Intelligence — through a unified MCP server interface. Instead of flipping between the Azure Portal, CLI, and SDK docs, you invoke these services directly from your agent's chat context.

The skill lives inside microsoft/azure-skills, a monorepo of Azure-focused agent capabilities. You install it with a `--skill` flag targeting the specific module you need.

## What's Actually Different

Most Azure AI workflows involve hopping between tools: `az search` for index queries, the Speech Studio for transcription, separate SDK calls for OpenAI embeddings. Azure AI collapses all four into a single `npx skills add` command. Your agent gets structured tool access — search results come back as queryable data, speech streams transcribed text to your conversation, and document extraction happens without manual file uploads.

Compared to writing ad-hoc API wrappers for each service, this skill routes through an MCP server when available and falls back to CLI or SDK when MCP isn't supported. The agent handles the routing; you just describe what you need.

## Who It's For

Get this if you work with Azure services regularly and want your coding agent to query search indexes, transcribe meeting recordings, or pull data from invoices without leaving the conversation. It saves real time when you're debugging an Azure-hosted app and need to check a search index mid-session.

Skip it if you don't use Azure or if your cloud interactions are limited to infrastructure-as-code tools where the Portal or CLI already fits.

## Bottom Line

Four Azure services, one install, your agent calls them on demand.
