---
title: "azure-messaging: Microsoft's Event Hubs & Service Bus SDK Skill"
date: 2026-08-31
draft: false
tags:
  - Azure
  - Messaging
  - Cloud Operations
description: "Microsoft azure-messaging (542,562 installs) routes Event Hubs and Service Bus SDK errors to 11 per-language guides. MCP contract and pack-curve audit inside."
version: "1.2.1"
author: "Microsoft"
repo_url: "https://github.com/microsoft/azure-skills"
install_cmd: "npx skills add https://github.com/microsoft/azure-skills --skill azure-messaging"
compatibility:
  - Claude Code
  - Cursor
  - GitHub Copilot
category: "automation"
rating: 4.0
github_stars: 1434
github_forks: 242
installs: 542562
last_updated: "2026-08-31"
ai_friendliness:
  score: 4.5
  documentation: 4.5
  setup: 4.0
  config: 4.0
---

Debug a .NET Event Hubs consumer that lost its lock and you will not find the answer inside azure-messaging. The skill is a 3,282-byte router: it reads the SDK error, picks the right MCP tool, and sends you to eleven language-specific guides that live in its sibling skill. I read the current SKILL.md (v1.2.1, MIT) and pulled installs from skills.sh on 2026-08-31 — the routing table and the pack curve both tell a story the headline number hides.

## The Two Services Under One Skill

azure-messaging owns exactly two Azure services: Event Hubs and Service Bus. Its trigger list reads like a support queue — AMQP link errors, message lock lost, lock renewal batch failures, session locks expired, send timeouts, receivers disconnected, duplicate events, checkpoint offset resets, idle timeouts, slow reconnects, dead-lettering, receive-batch behavior. The workflow stays six steps long and deliberately boring: identify the SDK and version, check namespace health, match the error text, search Microsoft Learn, verify connection config (string, entity name, consumer group), then recommend the fix.

Five MCP tools carry the weight on top of the flow's two service tools. `mcp_azure_mcp_eventhubs` lists namespaces, hubs, and consumer groups; `mcp_azure_mcp_servicebus` lists queues, topics, and subscriptions; `mcp_azure_mcp_monitor` runs KQL diagnostic-log queries; `mcp_azure_mcp_resourcehealth` checks the namespace's health status; `mcp_azure_mcp_documentation` searches Learn for the exact error. No Azure CLI is invoked anywhere — the whole skill is MCP-host-driven, which means the agent that runs it needs a configured MCP gateway, not just a logged-in `az`.

## Where the Real Guides Live (Spoiler: Another Skill)

Read the SKILL.md past the workflow and you hit the most honest line in the file: troubleshooting guides for connectivity, SDK, and auth live in the azure-diagnostics skill under `troubleshooting/messaging/`. I fetched that directory and counted eleven files. Eight of them are per-language deep dives — `azure-eventhubs-dotnet.md`, `-java`, `-js`, `-py`, and the same quartet for Service Bus — plus `auth-best-practices.md`, `service-troubleshooting.md`, and a README. No other skill in the [microsoft/azure-skills](https://github.com/microsoft/azure-skills) repo breaks guides down by language like this; diagnostics routes to topics, messaging routes to SDK runtimes.

That split is the actual design. azure-messaging is the sentry that classifies the error and the SDK, azure-diagnostics is the library that owns the depth, and the two chain together exactly like the [azure-diagnostics](/skills/automation/azure-diagnostics/) intro described: parent routes, sub-files teach. Install one without the other and your agent still finds the language guide — both point at the same `troubleshooting/` tree — but you will want both in the same editor session anyway.

## The Lockstep Curve Says "Pack," Not "Popularity"

Real talk: the install math around this skill needs a footnote. My 2026-08-31 scrape puts azure-messaging at 542,562 installs, rank #57, up from 540,971 a day earlier. That growth is not momentum — it is the pack counter moving again. The weekly curve [15,851 → 17,067 peak → 13,611] traces the same eight-week arc as azure-ai, azure-compute, azure-quotas, and every other live member of the pack, and the totals stay within a few thousand of each other because they are the same counter wearing different labels. Treat 542,562 as "the pack is installed a lot," not "messaging is the most-used skill." The per-skill signal worth trusting is the file itself: 3,282 bytes, version 1.2.1, and an updated sibling directory, which is more than the departed azure-rbac can claim.

## Is It Worth the Install

If your agents touch Event Hubs or Service Bus SDKs, this is the cheapest classification layer you can add: six steps, a service-specific MCP tool for each namespace type, and a routing table that ends in per-language docs instead of generic Azure advice. The honest catch is the dependency — max value requires the diagnostics skill's messaging tree and an MCP host, so budget for both. `npx skills add https://github.com/microsoft/azure-skills --skill azure-messaging` hands you the sentry; pair it with azure-diagnostics and the lock-loss, dead-letter, and session-expiry cases finally get language-specific answers instead of forum chatter. And the next time a pack sibling advertises a scary install count, compare it to azure-ai before you read anything into it.