---
title: "Microsoft Foundry"
date: 2026-06-03
draft: false
tags:
  - Azure
  - AI Models
  - Deployment
description: "Part of Microsoft's official azure-skills plugin. Gives AI agents direct access to Microsoft Foundry for model discovery, deployment, and agent workflow management via MCP."
version: "1.1.64"
author: "Microsoft"
repo_url: "https://github.com/microsoft/azure-skills"
install_cmd: "npx skills add microsoft/azure-skills"
compatibility:
  - Claude Code
  - Cursor
  - Codex
  - GitHub Copilot
category: "automation"
rating: 4.0
github_stars: 1166
github_forks: 179
installs: 365000
last_updated: "2026-06-04"
ai_friendliness:
  score: 5.0
  documentation: 5.0
  setup: 3.0
  config: 3.0
---

## What It Is

A skill within Microsoft's official azure-skills plugin that connects AI agents to Microsoft Foundry — their AI model platform for discovering, deploying, and managing models. Through the Foundry MCP server, your AI assistant can browse available models, deploy endpoints, and configure agent workflows directly in your Azure subscription.

## What's Actually Different

Most AI coding tools can tell you how to call an OpenAI API, but they can't actually deploy a model endpoint for you. This skill gives AI agents real execution capability via MCP — it can check your subscription quotas, deploy models, and return working endpoint URLs. It's not documentation-based advice; it's actual Azure resource management through your authenticated CLI session.

## Who It's For

Teams building on Azure who need to frequently deploy and manage AI models. If you're prototyping AI applications and iterating on model selection, this eliminates hours spent clicking through the Azure Portal. Not worth the setup if you only call APIs occasionally — the Azure subscription and CLI prerequisites are non-trivial.

## Bottom Line

Your AI assistant becomes an Azure operator for AI model management — deploy and iterate on models through conversation.
