---
title: "azure-diagnostics: Microsoft's 553K-Install Debugging Skill"
date: 2026-08-30
draft: false
tags:
  - Azure
  - Debugging
  - Cloud Operations
description: "Microsoft's azure-diagnostics skill (553,878 installs) triages App Service, AKS, VM, and messaging outages via AppLens MCP. Pack-curve audit inside."
version: "1.2.6"
author: "Microsoft"
repo_url: "https://github.com/microsoft/azure-skills"
install_cmd: "npx skills add https://github.com/microsoft/azure-skills --skill azure-diagnostics"
compatibility:
  - Claude Code
  - Cursor
  - GitHub Copilot
category: "automation"
rating: 4.0
github_stars: 1434
github_forks: 242
installs: 553878
last_updated: "2026-08-30"
ai_friendliness:
  score: 4.5
  documentation: 4.5
  setup: 4.0
  config: 4.0
---

Microsoft's azure-diagnostics skill tops its own [microsoft/azure-skills](https://github.com/microsoft/azure-skills) repo's leaderboard right now. 553,878 installs, rank #43 on skills.sh in my 2026-08-30 scrape. The skill doesn't fix your Azure outage. It runs the triage that decides where the fix lives, then hands you the right document and the right MCP tool. I read the current SKILL.md (v1.2.6, MIT, 6,371 bytes) and pulled every azure skill's install curve. The curves turned out to be the more interesting half of this article.

## What azure-diagnostics Actually Does

The skill runs a five-step quick diagnosis flow behind a trigger list that reads like a real incident log: App Service high CPU, AKS nodes not ready, VM RDP timeouts, Event Hubs AMQP failures, image pull failures, cold starts, health probe failures, KQL questions. The steps stay deliberately boring — identify symptoms, check resource health, review logs, analyze metrics, investigate recent changes — and that's the point. Its own rules demand a resource-health check before any deep dive into logs, because the cheapest answer in Azure is "the platform is degrading, stop debugging your code."

The routing table shows the structure. Container Apps, App Service, and Function Apps diagnostics stay in the parent skill. Active AKS incidents route to `troubleshooting/aks/aks-troubleshooting.md`; VM connectivity routes to `troubleshooting/compute/vm-troubleshooting.md`; messaging SDK errors route to `troubleshooting/messaging/README.md`. The parent acts as a sentry, not a library — the depth lives in those subdirectories and in the references folder (`kql-queries.md` at 1,342 bytes, `azure-resource-graph.md` at 3,002 bytes, plus per-service folders).

## The MCP Tool Chain

Three `mcp_azure_mcp_*` tools carry the weight, and the skill quotes the exact JSON contract for each. `mcp_azure_mcp_applens` runs `command: "diagnose"` with a resource ID and returns root cause analysis plus remediation steps. `mcp_azure_mcp_monitor` takes a workspace ID and a KQL query — the skill ships a starter query that grabs the last 50 traces from the past hour. `mcp_azure_mcp_resourcehealth` reads the health status of a single resource. When no MCP host is configured, plain `az` one-liners fill in: `az resource show --ids`, `az monitor activity-log list -g RG --max-events 20`, `az containerapp logs show --follow`, and `az monitor app-insights query` with the same KQL behind it.

## The Pack-Curve Finding Nobody Will Advertise

Real talk: I pulled install data for every microsoft/azure-skills entry on the leaderboard, and the live ones move as one. azure-diagnostics sits at 553,878 installs; azure-ai, a completely different skill, sits at 553,211. Nine skills — azure-ai, azure-messaging, azure-compute, azure-cloud-migrate, azure-quotas, azure-upgrade, azure-kubernetes, azure-enterprise-infra-planner, and azure-diagnostics itself — trace the same eight-week shape, peaking near 17K weekly installs and drifting down to the 13.4K–13.8K band since. The [azure-rbac](/skills/automation/azure-rbac/) story we covered last week deserves a footnote: its crash (11,820 → 2,600 weekly) isn't purely its own departure. azure-hosted-copilot-sdk shows the same 2K–3K floor — and checking the repo today, both of those skill directories 404 on main. The two skills that fell out of the pack are exactly the two whose curves collapsed. The pack behaves like one counter wearing many labels; individual totals mostly tell you which skills existed longest, not which are most used.

## Is It Worth the Install

The skill's whole job is to stop an agent from guessing. Open your editor, ask it to sort an AKS outage, and the routing rules pull the dedicated AKS document instead of improvising — that alone justifies the install, and it mirrors the discipline pattern of the [azure-ai](/skills/automation/azure-ai/) entry point. The repo itself updated today (2026-08-30), so the guidance stays maintained, which is more than the departed azure-rbac can claim. Debug Azure production issues with an agent, and `npx skills add https://github.com/microsoft/azure-skills --skill azure-diagnostics` hands you the sentry, the sub-documents, and the KQL library in one shot. And next time your pack-curve reading disagrees with a skill's headline number, check the siblings before you trust either.