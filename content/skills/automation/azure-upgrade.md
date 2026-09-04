---
title: "azure-upgrade: Assess, Then Migrate Azure Plans and SKUs"
date: 2026-09-04
draft: false
tags:
  - Azure
  - Azure Functions
  - Cloud Migration
category: "automation"
description: "What Microsoft's azure-upgrade skill (424K installs) automates: Consumption to Flex, Redis to Managed Redis, Java SDK rewrites - gated by assessment first."
---

Most Azure upgrades get attempted as a chain of CLI commands typed from memory. Microsoft's azure-upgrade skill refuses that pattern: it produces an assessment report before it changes anything, and it documents rollback before it executes. I read the current SKILL.md (v1.2.1, MIT), the workflow-details and global-rules files, plus the functions, Redis, and Java scenario references, then pulled install numbers off the skills.sh leaderboard on 2026-09-04.

## The Seven-Step Flow Gates Every Upgrade

The pipeline runs Identify → Assess → Pre-migrate → Upgrade → Validate → Ask User → hand off. No phase is skippable, and a failure inside any phase stops the run: log it in `upgrade-status.md`, do not proceed, tell the user what broke, offer retry or rollback.

The assessment step writes `upgrade-assessment-report.md` with fixed section headings and a readiness verdict — Ready, Needs Attention, or Blocked. That verdict decides whether the run continues. The skill repeats its core rule three separate times: assess before you upgrade, confirm the target plan with the user, never delete or stop the original app without explicit confirmation. Global rules add a rollback policy that says the same thing from the other side: document rollback steps before executing, keep the original app alive until the new one validates, and route every destructive action through `ask_user`. For a tool whose whole job is changing plans and SKUs, the emphasis lands on restraint, not speed.

## Flex Consumption Upgrade: Where the Real Rules Live

The flagship scenario moves a function app from Consumption to Flex Consumption, and the reference file reads like a list of things you'd only learn by breaking them. The migration is **Linux-only** — Windows support is still marked "planned for the future" — and Linux Consumption itself is being retired on September 30, 2028. Your function code stays the same; the skill creates a new app alongside the old one in the same resource group, and you control the timing of the switchover.

Azure CLI ships the automation: `az functionapp flex-migration list` returns `eligible_apps` and `ineligible_apps` arrays, and `az functionapp flex-migration start` creates the new app and migrates most configuration. The compatibility table is where the surprises live. Deployment slots are not supported in Flex Consumption. TLS/SSL certificates are not supported yet. Blob triggers using container polling must be converted to the EventGrid source, or they run on a polling model Flex doesn't offer — the skill checks for them explicitly with a query filter on `source!='EventGrid'`. .NET in-process (`dotnet` stack) is a hard no; you migrate to the isolated worker model first. Linux Consumption packages even sit in a `scm-releases` blob container in `squashfs` format if you need to recover a deployment artifact, which is a detail no quick-start guide mentions.

## The Redis Router and the Java Rewrite Track

The Redis scenario exposes how the skill's authors draw their own boundaries. Migrating Azure Cache for Redis to Azure Managed Redis (AMR) is the biggest scenario in the trigger table, yet `azure-upgrade` ships **no SKU specs, no pricing scripts, no ARM automation** for it. The reference file is a router: it disambiguates ACR (the ~97% of the fleet on Basic/Standard/Premium, resource type `Microsoft.Cache/redis`, TLS port 6380) from ACRE (the ~3% on Enterprise tiers, `Microsoft.Cache/redisEnterprise`, TLS port 10000), then points you at dedicated, versioned skills owned by the Azure Managed Redis team — `amr-migration-skill` for ACR, `acre-to-amr-migration-skill` for ACRE. Pick the wrong one and you get wrong guidance, because the two products differ in ARM types, APIs, and migration mechanics. The AMR path does offer one genuinely nice property: migrations switch DNS while keeping the old hostname working, so traffic keeps flowing during cutover.

The Java track is a separate machine entirely: a source-code modernization flow that rewrites `com.microsoft.azure.*` (end-of-support since 2023) to `com.azure.*`. It generates a run identifier like `azure-sdk-upgrade-20260904-093000`, creates a git branch per run, follows precheck → plan → execute → validate, and demands 100% test pass before summarizing. The workflow file carries a lazy-loading instruction — load each reference file only when its phase starts — which reads like a token-budget optimization from someone who watched an agent burn its context window on onboarding reads. The target is `com.azure.*` and nothing else: the file explicitly warns not to use this flow for .NET, Python, JavaScript, or Go SDK upgrades.

## How It Sits in the Pack

| Skill | Job | Boundary |
|-------|-----|----------|
| **azure-upgrade** | Plan/SKU/tier changes and SDK modernization *within* Azure | Stops at Azure's edge — see its own note: "This is NOT for cross-cloud migration" |
| [azure-cloud-migrate](/skills/automation/azure-cloud-migrate/) | Ports Lambda, Kubernetes, Heroku, Cloud Run workloads **into** Azure | Starts where azure-upgrade refuses to |
| azure-enterprise-infra-planner | Architects greenfield landing zones and generates Bicep/Terraform | Plans infrastructure, not existing workloads |

The leaderboard data matches the pack story told in earlier intros. My 2026-09-04 scrape puts azure-upgrade at #107 with 423.9K installs; the 2026-09-03 snapshot showed 422,046. That +1.85K daily delta is identical to azure-enterprise-infra-planner's +1.86K and azure-kubernetes' +1.9K over the same 24 hours — three skills, three different ranks, one shared counter. Treat the totals as pack-level signal, not per-skill popularity.

## Start With the Assessment

If you manage Azure Functions, Redis caches, or Java SDKs, this skill replaces "upgrade by instinct" with a documented sequence. Install it with `npx skills add https://github.com/microsoft/azure-skills --skill azure-upgrade`, then run it on a staging function app first and watch what the assessment report objects to before you touch production. That report — not the migration commands — is the deliverable worth keeping.