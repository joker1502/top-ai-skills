---
title: "I Ran Azure's Reliability Checks and Its Multi-Region Query Missed Its Own Setup"
date: 2026-09-18
toc: true
draft: false
tags:
  - Azure
  - Reliability
  - High Availability
category: "guides"
description: "Running Microsoft's azure-reliability skill (268K installs): the assessment table, the baseName regex that misses hex-suffixed apps, and the GRS-not-ZRS trap"
---

I spent the morning walking Microsoft's `azure-reliability` skill (v1.1.1) end to end — reading all 12 reference files, then stress-testing its queries against its own example resource names. The skill promises an assessment you can act on, and the assessment machinery is genuinely thoughtful. But I found its multi-region detection query fails on the exact naming pattern the skill's own CLI setup generates. 268,656 installs, rank 218 on skills.sh as of 2026-09-18, weekly curve [16828, 16060, 15873, 14817, 13263, 13449, 11966, 12666] — the same pack-level lockstep signature as the rest of microsoft/azure-skills.

## The Feature-Pivoted Table That Actually Works

The skill's output format is the best part of it. Instead of a per-resource dump, Phase 3 produces a four-row table: zone redundancy on compute, zone-redundant storage, health probes, multi-region failover. Each row gets one status symbol and the specific resources that matter to it:

```
Reliability Feature              Status      Resources
Zone redundancy — compute        🔴 OFF      • plan-web-ii5trxva2ark4 (P1v3)
Zone-redundant storage           🔴 GRS      • stii5trxva2ark4 (defaulted; no SKU set in IaC)
```

Storage gets special status vocabulary — `🔴 LRS`, `🔴 GRS`, `🟢 ZRS` — because the SKU *is* the status. And there's a genuinely sharp rule hidden in the storage checks: **when no SKU is set in IaC at all, ARM/AVM defaults to `Standard_GRS`**, so a storage account showing GRS often means "nobody chose it" rather than "someone picked region redundancy". The skill tells you to treat defaulted GRS as a gap, not a decision. That single heuristic catches more silent misconfigs than any other check in the skill.

The compute table is where the plan tiers bite. App Service: only Premium v2/v3/v4 and Isolated v2 support zone redundancy — Free/Shared/Basic/Standard can't, full stop, no `az resource update` will flip them. Functions: Flex Consumption (FC1) supports ZR with zero cost change, Premium (EP1+) needs `zoneRedundant: true` plus `sku.capacity ≥ 2` plus `minimumElasticInstanceCount ≥ 2` per app, and Consumption (Y1) can't — it's a forced upgrade conversation with cost implications shown before any change.

## The Regex That Misses the Skill's Own Names

Then I hit the multi-region check. Phase 2's discovery query tries to group apps into families by stripping a region suffix from the name:

```kql
| extend baseName = extract('^(.+?)(-[a-z]+\\d*)?$', 1, name)
| summarize regions=make_list(location), regionCount=dcount(location) by baseName, appKind
| where regionCount > 1
```

The regex expects `my-app-eastus` / `my-app-westus` style names — a pure-letter suffix it can strip. I ran that exact regex against the skill's *own* example names and the CLI quick-setup it ships in configure-multi-region.md:

| Name (from the skill's own docs/CLI) | baseName extracted | Detected as multi-region? |
|:---|:---|:---|
| `func-api-ii5trxva2ark4` (SKILL.md example) | `func-api-ii5trxva2ark4` (unchanged) | ❌ |
| `func-api-32mpw2gtw7lye` (CLI quick-setup, `openssl rand -hex 6`) | unchanged | ❌ |
| `app-web-ii5trxva2ark4` | unchanged | ❌ |
| `my-app-eastus` / `my-app-westus` | `my-app` / `my-app` | ✅ |

The CLI quick-setup literally builds the secondary app as `func-api-${RESOURCE_TOKEN}` where `RESOURCE_TOKEN=$(openssl rand -hex 6)`. That token contains digits mid-string (`-a1b2c3d4e5f6`), and the regex's `-[a-z]+\d*` only strips a letter-run *followed immediately by digits at the very end* — hex tokens break it, so both apps keep their full names, get different baseNames, and the `where regionCount > 1` filter returns nothing. The skill would tell you, with confidence, that a textbook active-passive deployment it set up itself is single-region. Worth knowing before you trust a green "multi-region" assessment — or before you wonder why your deliberately multi-region app reports no failover protection.

## GRS Is Not Zone Redundancy, and Other Traps That Are Easy to Miss

The storage reference makes one distinction I'd been sloppy about: **GRS/RA-GRS use LRS inside each region**. Zone-redundant compute on top of GRS storage is still a zone-failure risk — ZRS or GZRS is the actual requirement. The skill's stated minimum: if compute is zone-redundant, storage must be at least ZRS, not GRS. That check alone reclassifies a lot of "redundant-looking" architectures.

Health probes carry their own zoning. `healthCheckPath` is supported on Premium/Dedicated App Service and Premium Functions, and enabling it **restarts the app** — the reference says do it in a maintenance window. The health-check mechanics are specific and useful: 1-minute ping interval, 10 consecutive failures before an instance is marked unhealthy, replacement within 1 hour, one successful response restores it. `WEBSITE_HEALTHCHECK_MAXPINGFAILURES` tunes the threshold. On Flex Consumption there is no platform health check at all — the fix is an HTTP-triggered `/api/health` function in app code (TypeScript v4 model, Python v2 model, or C# isolated worker snippets are all in the reference), behind an explicit user-consent gate because it touches source code.

The remediation flow is staged on purpose: zone redundancy first (in-place property update, no cost on FC1), health probes second, then a hard stop to ask about the storage upgrade — which is a live migration taking hours to days and ~$0.01/GB/month more, and is only supported for Standard general-purpose v2 accounts. Multi-region is never auto-run; it's gated behind explicit consent plus a cost frame (Front Door ~$35/month base, idle FC1 secondary ~$0). And there's an IaC double-deploy rule worth stealing: never bundle the storage SKU patch with the safe patches, because the live migration must complete before the SKU change can deploy — two deploys, quick wins first.

## Where the Skill Draws Its Line

Scope is honest: only Azure Functions and App Service, with Container Apps explicitly "planned for a future version" — unsupported resources get marked `⚪ not assessed (planned)` and the skill refuses to fabricate CLI commands for them. IaC patching handles both Bicep (AVM modules with the parameter-name differences called out, `zoneRedundant`/`skuCapacity` as top-level params) and Terraform (`zone_balancing_enabled = true`). If your deployment already has all core features green, the skill skips the fix-it question entirely and jumps straight to the optional multi-region offer.

Run it on whatever you manage: install with `npx skills add https://github.com/microsoft/azure-skills --skill azure-reliability`, point it at a resource group, and read the four-row table as a literal checklist. Verify its multi-region verdict independently when your app names end in a random token — and if you're standing up new infra, [azure-prepare](/skills/automation/azure-prepare/) owns the plan-first lane this skill feeds from, while [azure-validate](/skills/automation/azure-validate/) holds the deployment gates on the other side.