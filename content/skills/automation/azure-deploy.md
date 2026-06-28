---
title: "Azure Deploy"
date: 2026-06-27
draft: false
tags:
  - Azure
  - Deployment
  - DevOps
  - Automation
description: "Azure Deploy automates Azure resource provisioning through your coding agent. Describe what you need, it handles templates and dependency ordering."
version: "1.1.73"
author: "microsoft"
repo_url: "https://github.com/microsoft/azure-skills"
install_cmd: "npx skills add https://github.com/microsoft/azure-skills --skill azure-deploy"
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
github_stars: 1241
github_forks: 195
installs: 415900
last_updated: "2026-06-26"
ai_friendliness:
  score: 4.0
  documentation: 4.5
  setup: 3.5
  config: 4.0
---

## What It Is

Azure Deploy is a skill that turns natural-language deployment requests into actual Azure resource provisioning. Instead of writing ARM templates or Bicep files yourself, you describe what you need — "deploy a container app with a PostgreSQL backend" — and the skill translates that into the right deployment commands, parameter sets, and validation steps. It lives in the `microsoft/azure-skills` monorepo alongside siblings like [Azure AI](/skills/automation/azure-ai/) and [Microsoft Foundry](/skills/automation/microsoft-foundry/).

## What's Actually Different

The standard deployment loop involves context-switching between your IDE, the Azure Portal, and the `az` CLI. Azure Deploy collapses that into a single agent conversation. Compared to writing deployment scripts by hand, the skill handles the scaffolding — it knows which resource types need which parents, which SKUs are valid together, and what the default naming conventions look like. It also runs validation through `azure-validate` before executing, so you catch naming collisions and quota issues before they fail mid-deployment.

The real difference is that it works inline with other azure-skills: you can use `azure-prepare` to scaffold, `azure-deploy` to provision, and `azure-upgrade` to evolve — all in the same chat session without switching tools.

## Who It's For

Get this if you deploy Azure resources regularly and want to stay in your agent instead of bouncing between portals and CLIs. It saves the most time on multi-resource deployments where the dependency ordering matters.

Skip it if you already have a mature infrastructure-as-code pipeline with CI/CD that handles provisioning, or if you only deploy through the Portal GUI.

## Bottom Line

Describe what you need, the agent deploys it — no ARM template wrestling.
