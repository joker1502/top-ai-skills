---
title: "azure-compute: Microsoft's Four-Workflow VM and VMSS Skill"
date: 2026-09-01
draft: false
tags:
  - Azure
  - Virtual Machines
  - Cloud Operations
description: "Inside microsoft's azure-compute skill (499K installs): four VM workflows, an unauthenticated pricing API, a banned quota MCP server, and pack-curve math."
version: "2.5.1"
author: "Microsoft"
repo_url: "https://github.com/microsoft/azure-skills"
install_cmd: "npx skills add https://github.com/microsoft/azure-skills --skill azure-compute"
compatibility:
  - Claude Code
  - Cursor
  - GitHub Copilot
category: "automation"
rating: 4.5
github_stars: 1438
github_forks: 242
installs: 499134
last_updated: "2026-09-01"
ai_friendliness:
  score: 4.5
  documentation: 4.5
  setup: 4.0
  config: 4.0
---

Ask "which VM should I pick?" and most agents guess from memory. Azure's answer is a 2,619-byte router called azure-compute that refuses to guess: it classifies your intent, opens one of four workflow files, and only then touches references. I read the current SKILL.md (v2.5.1, MIT) plus all four workflows and four reference guides, then pulled install numbers from the skills.sh leaderboard on 2026-09-01 — the file is a router, the numbers are a pack counter, and both deserve explaining.

## One Skill, Four Workflows, Zero Direct Reference Hits

azure-compute splits every VM request into four lanes. The **VM Recommender** handles "which size and family", the **VM Creator** handles "spin one up", a **Capacity Reservation** lane covers CRG creates, associates, and disassociates, and an **Essential Machine Management** lane deals with subscription-level machine enrollment. The SKILL.md is explicit that you never route straight to a reference file. Open the workflow first, and load references only when that workflow asks for them. Unclear intent? Ask one clarifying question instead of guessing.

The Recommender works without an Azure subscription. Its data sources are public Microsoft docs and the Retail Prices API, which is unauthenticated — I checked the reference, and there is no Azure CLI command for it at all. The skill tells agents to hit `https://prices.azure.com/api/retail/prices` with a `$filter` string via curl or PowerShell. Family fit comes from a table mapping workloads to series: D-series for balanced web workloads, B-series burstable for dev/test (the cheapest option), F-series for CI/CD, E-series for relational DBs, M-series up to 4 TB for SAP workloads, NC/ND/NV/NG for GPU training and VDI, DC/EC for confidential compute, HB/HC/HX for HPC with InfiniBand.

## What the Creator and the Reservation Lane Actually Do

The Creator's cleverest piece is a depth probe. It classifies your first one or two messages into Beginner, Networking-deep, Spec-deep, Cost-deep, or Security-deep, then asks only the questions in that branch's matrix. Beginners get sensible defaults spelled out in a "defaults ladder" — pick or say "I have specifics". Nobody gets interrogated about storage IOPS they don't care about. Before the agent can show a Plan Card, a validation gate runs Azure MCP read-only tools: SKU exists in the region, image is current, quota headroom, region availability. Near the limit, past 80% quota, it proceeds with a warning. Fresh out of quota or missing SKU, it proposes an alternate SKU or region and generates nothing.

The reservation lane exists for workloads where deployment failure is unacceptable: launches, migrations, in-demand SKUs. Real talk about billing: a Capacity Reservation Group starts charging pay-as-you-go the moment you create it, whether any VM sits behind it or not. The workflow never infers quantity — it always asks. It also warns PowerShell users to swap backslash line continuations for backticks, which tells you exactly which agents kept tripping on this file.

## The Quota Map, the EMM Preview, and What 499,134 Installs Mean

Two details read like lessons learned. First, vm-quotas.md opens with "NEVER use the azure-quota MCP server as it is unreliable" — the skill tells agents to use `az vm list-usage` instead, which returns usage and limit in one call. It also warns against normalizing quota-name casing and against guessing names from SKUs. Second, Essential Machine Management is public preview with a hard `api-version=2025-07-28-preview` in its status endpoint; a 200 with `provisioningState: Succeeded` means enrolled, a 404 means not. The routing rule there is oddly specific: only load the portal guide when the user says the word "portal".

On the install side, keep the siblings in mind. My 2026-09-01 scrape puts azure-compute at 499,134 installs with weekly [15,822 → 17,210 peak → 13,402], and that curve matches azure-diagnostics (558K), azure-messaging (545K), and azure-cloud-migrate (489K) wave for wave. These are the same counter wearing different labels, the same pattern the [azure-diagnostics](/skills/automation/azure-diagnostics/) and [azure-messaging](/skills/automation/azure-messaging/) intros documented. The per-skill number worth trusting is the file itself — 2,619 bytes, v2.5.1, repo touched on 2026-09-01, 1,438 stars on GitHub — not the leaderboard total.

## How It Compares With Its Siblings

azure-compute is the only member of the pack built around shared workflow files plus a depth probe. azure-diagnostics owns troubleshooting depth for every Azure service; azure-messaging routes Event Hubs and Service Bus SDK errors to per-language guides. Compute's edge is decision support: it tells you what to buy, where it fits, and whether your subscription can hold it, all before a single VM exists. It stays out of deployment entirely — the moment you want to deploy an application rather than bare infrastructure, the file itself hands you off to azure-prepare. Pick compute for sizing, pricing, and creation questions; pick diagnostics when the VM you already built is broken.

## When to Add This Skill

If your agent fielded one "what VM should I use" question in the last month, this skill pays for itself. It replaces memory-based SKU guesses with a documented decision path that ends in a validated SKU or an honest "no quota". `npx skills add https://github.com/microsoft/azure-skills --skill azure-compute` installs the router alone, but pair it with the rest of the pack if you already manage Azure with agents — sibling skills keep the same workflow-first discipline, and you will want the diagnostics tree the day a VM misbehaves. Start with one question: ask it "pick a VM, don't guess" and watch which workflow file it opens.