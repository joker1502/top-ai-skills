---
title: "Using Microsoft Foundry Skill to Deploy AI Models via CLI"
date: 2026-06-09
toc: true
draft: false
tags:
  - Azure
  - AI Models
  - Deployment
description: "Microsoft's official Azure skill for AI model management — browse, deploy, and configure models through your AI assistant using MCP"
category: "guides"
rating: 4
related_skills:
---

## What Microsoft Foundry Does

Azure AI Foundry is Microsoft's platform for browsing, testing, and deploying AI models. This skill is part of the `azure-skills` plugin and gives your AI assistant direct MCP access to your Azure Foundry — checking available models, deploying endpoints, configuring agent workflows, all without touching the Azure Portal.

## Who Should Install This

Developers and teams building on Azure who need to frequently manage AI model deployments. If you're prototyping AI applications and switching between different models to test performance, this skill eliminates a lot of Portal clicking.

If you only occasionally call an API, the prerequisites (Azure subscription + CLI auth) might be more setup than you need.

## Setting It Up

### Prerequisites

1. An Azure subscription with AI Foundry access
2. Azure CLI installed and authenticated:

```bash
az login
```

3. Your AI coding tool (Claude Code, Cursor, or Codex)

### Installation

```bash
npx skills add microsoft/azure-skills
```

The plugin installs multiple skills — Foundry is one of them. Once installed, the MCP server connects to your Azure subscription.

### Verify

Ask your AI assistant: "List the AI models available in my Azure Foundry project." If it returns a list of models with deployment options, the connection is working.

## What You Can Do

**Browse models**: Ask your AI to show available models, their pricing tiers, and deployment regions. It queries the Foundry catalog directly.

**Deploy models**: Say "Deploy GPT-4o to my Foundry project in East US." The skill creates the deployment and returns the endpoint URL. No manual Portal navigation.

**Check quotas and limits**: "What's my token quota for the gpt-4o deployment?" — useful when you're hitting rate limits and need to diagnose the bottleneck.

**Configure agent workflows**: Set up routing between models, configure fallback chains, and manage API keys through conversation.

## Things to Watch Out For

The skill requires Azure CLI authentication. If your token expires, the MCP connection breaks silently — your AI will fail to fetch data but won't always give a clear error message. Run `az login` again if things stop working.

Some operations (creating new Foundry projects, managing access control) still require the Portal or `az` commands directly. The skill covers model management, not full Azure resource administration.

## Microsoft Foundry vs Direct API

If you just need to call OpenAI or Azure OpenAI endpoints, configure the API key directly in your environment variables and skip this skill. The overhead of Azure CLI + MCP setup isn't worth it for simple API calls.

This skill pays off when you're managing multiple model deployments, comparing models, or building applications that need to switch models dynamically. The conversational interface makes the exploration phase much faster than clicking through the Portal.

## What's Next

Pair this with model evaluation skills to test deployed models against benchmarks. If you're building a multi-model application, the skill's ability to list and compare models side by side makes the selection process faster.
