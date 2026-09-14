---
title: "azure-cost: Query Your Bill Before You Optimize"
date: 2026-09-14
draft: false
tags:
  - Azure
  - Cost Management
  - FinOps
category: "automation"
description: "azure-cost (382K installs) reads your real bill via the Cost Management API: query, optimize, forecast workflows, hard rate limits, RBAC roles, name-twin trap."
---

Most Azure cost advice tells you to "eliminate waste" and stops there. Microsoft's azure-cost skill (v1.3.1, MIT) works the other way: it reads your actual bill through the Cost Management API before it recommends anything. I read the full SKILL.md plus five sub-files — the cost-query workflow, its guardrails, the optimization workflow, the Azure Quick Review reference, and the tools-and-best-practices file — then scraped skills.sh on 2026-09-14: azure-cost ranks 132 with 382,419 installs.

## Three Workflows, One Router

The SKILL.md file is 1,886 bytes — a routing table, not a tutorial. Three user intents land on three different workflows, each with its own reference tree: "how much am I spending" routes to cost-query, "reduce costs / find waste" to cost-optimization, "project future costs" to cost-forecast. Scopes run the full ladder — subscription, resource group, management group, or billing account — and the routing table explicitly bans the skill from deployment, provisioning, diagnostics, and security audits.

Two REST endpoints carry the work. Both use `api-version=2023-11-01`: `POST {scope}/providers/Microsoft.CostManagement/query` and the sibling `forecast` call. The required role stack is Cost Management Reader plus Monitoring Reader plus Reader on the target scope — the README warns that cost queries fail with 403, not a friendly message, when any of the three is missing.

## The Hard Numbers the Workflow Enforces

The guardrails file reads like a contract, and agents skip these at their own cost. Daily granularity covers at most 31 days; monthly or none covers 12; the absolute API ceiling is 37 months. `GroupBy` takes up to two dimensions, and `ResourceId` grouping works only at subscription and resource group scope — ask for it at management group level and the API rejects the body. Pages return up to 5,000 rows (1,000 by default), so `nextLink` pagination is not optional on big tenants.

The rate limit section is the part most people don't know. Sequential queries to the same scope share a 4-request-per-minute budget. A 429 response carries three `x-ms-ratelimit-microsoft.costmanagement-*-retry-after` headers — `qpu`, `entity`, `tenant` — and the documented rule is to wait the longest value and never retry more than three times. The workflow also bypasses `az costmanagement query` entirely, calling `az rest` with a JSON body file instead, and every request carries a `ClientType=GitHubCopilotForAzure` header.

## Optimization Is a Report, Not a Suggestion

The optimization workflow gates prerequisites before doing any work: the `costmanagement` and `resource-graph` CLI extensions must be installed, and Azure Quick Review (`azqr`) must be present — those three facts are verified with actual commands, not assumed. Step two runs `azqr` to surface orphaned resources, the instant-savings bucket: unattached disks, unused NICs, idle NAT gateways.

The rest is a fixed cadence of evidence. Costs are queried for the last 30 days, utilization metrics for the last 14, and pricing is re-validated from official Azure pricing pages with a free-tier check — the file explicitly flags that many services carry generous free allowances. Output lands as `output/costoptimizereport<YYYYMMDD_HHMMSS>.md` with an executive summary, breakdown, and prioritized recommendations, while each query result is saved as JSON for an audit trail. Service-specific branches exist for Redis, Storage (LRS/GRS/ZRS downgrade analysis), and AKS, which gets its own cost-analysis add-on and anomaly investigation references. One rule stands out for small bills: below $10/month, the skill tells the agent to push operational improvements, not SKU gymnastics.

## The Name-Twin Trap: Two Skills, One Dead

Search "azure cost skill" and you'll find azure-cost-optimization wearing 209,527 installs. It doesn't exist anymore — the raw SKILL.md returns 404 today, and the weekly curve tells the story: [170, 153, 150, 111, 91, 118, 93, 97], the same crash-to-floor pattern we documented for the other removed azure skills. Its name survives as a subfolder inside azure-cost — the `cost-optimization/` directory is where the optimization workflow actually lives.

The install numbers carry a second lesson. azure-cost sits at 382,419 while most of its pack siblings lockstep around 578K — it's one of the few azure skills running on its own counter, and its weekly curve (17,048 → 12,743 across the last eight weeks) still decays in the same shape as theirs. So don't read rank by rank: read intent by intent.

## Install It Before the Next Bill

Run `npx skills add https://github.com/microsoft/azure-skills --skill azure-cost` and test it on a cheap subscription first. Ask "why did my bill spike last month" and watch whether the agent returns a query-backed breakdown or a hand-wavy paragraph — the workflow demands the former. If capacity limits are your actual bottleneck rather than spend, the [azure-quotas procedural guide](/tutorials/guides/azure-quotas-procedural/) covers that lane, and [azure-compute](/skills/automation/azure-compute/) handles VM sizing and pricing decisions when you're spinning something up.

*Covered alongside: [azure-resource-lookup vs azure-resource-visualizer](/tutorials/comparison/azure-resource-lookup-vs-visualizer/) — the inventory and diagram skills that your cost report will keep referencing.*