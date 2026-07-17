---
title: "Lark Approval - AI-Powered Approval Management for Feishu/Lark"
date: 2026-07-17
draft: false
tags:
  - Lark Approval
  - AI Agent Skills
  - Workflow Automation
  - Approval Management
description: "Manage Lark/Feishu approval workflows through your AI agent. View pending approvals, approve or reject requests, track approval history, and handle complex multi-step approvals — all from your AI coding assistant."
version: "1.0.72"
author: "larksuite"
repo_url: "https://github.com/larksuite/cli"
install_cmd: "npx skills add https://open.feishu.cn"
compatibility:
  - Claude Code
  - Cursor
  - Codex
  - GitHub Copilot
category: "coding"
rating: 4
github_stars: 15600
github_forks: 1100
installs: 426700
last_updated: "2026-07-17"
ai_friendliness:
  score: 85
  documentation: 80
  setup: 88
  config: 82
---

## Overview

Lark Approval is an AI-powered skill for managing approval workflows inside Lark (Feishu). It lets your AI agent interact with approval requests directly — viewing pending approvals, checking approval details, taking action on requests, and tracking the full history of approval instances. Instead of switching to the Lark mobile app or web interface every time a pending approval notification pops up, you can handle it right from your terminal through your AI coding assistant.

The skill is part of the [larksuite/cli](https://github.com/larksuite/cli) ecosystem, which packs over 200 commands and 20+ AI agent skills covering Lark's core business domains. Lark Approval specifically handles approval instances — think expense reports, leave requests, purchase orders, and custom approval flows your team has set up in Lark.

## Key Features

- **View pending approvals** — list all approval tasks waiting for your decision in real time
- **Approve and reject** — take action on approval instances with a single command
- **Transfer and delegate** — forward approvals to another person or delegate responsibility
- **Withdraw and recall** — pull back approval requests you sent out that haven't been fully processed
- **Urge and remind** — send reminders for pending approvals that are stuck
- **Add approvers and CC** — add signing parties or copy others on approval instances
- **Check approval history** — view details of completed approval flows and past decisions
- **Multi-step approvals** — handle complex approval chains with sequential or parallel nodes

## Compatibility

Lark Approval works with any AI agent that supports the skills protocol. The [larksuite/cli](https://github.com/larksuite/cli) tool manages authentication and permission handling, so your AI agent can talk to Lark's approval API through the skill interface. Major supported platforms include Claude Code, Cursor, Codex, and GitHub Copilot.

## Installation

```bash
npx skills add https://open.feishu.cn
```

After adding the source, the lark-approval skill becomes available alongside other Lark skills in the [larksuite/cli](https://github.com/larksuite/cli) package. Make sure your Lark account has the appropriate approval management permissions before using the skill.

## AI-Friendliness Score

The lark-approval skill scores high on AI-friendliness — 85/100 overall. The documentation is thorough and the setup process is smooth once you understand Lark's permission model. The skill's command structure is predictable and follows standard Lark CLI patterns, making it easy for AI agents to navigate without hallucinating flags or parameters.

## Why Use Lark Approval with AI?

Approval workflows are one of those tasks that seem simple but eat up a surprising amount of time. You get a notification, open Lark, find the approval, read it, decide, click — repeat. With the lark-approval skill, your AI agent can batch-process pending approvals, summarize the details of each request, and execute decisions faster than you can navigate Lark's UI. For teams processing dozens of approvals daily, this translates to real time saved.

The skill shines in scenarios where approvals are routine and predictable — expense reports under a certain threshold, standard leave requests, recurring purchase orders. Your AI agent can handle the bulk of these without human intervention, surfacing only the edge cases that need a closer look.
