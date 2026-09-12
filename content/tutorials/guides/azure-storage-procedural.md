---
title: "Azure Storage: A 5-Step Procedure for Choosing Service, Tier, and Redundancy"
date: 2026-09-12
toc: true
draft: false
tags:
  - Azure
  - Cloud Storage
  - Azure Storage
category: "guides"
description: "A 5-step decision procedure for Azure Storage: pick among blob, file, queue, table, and Data Lake, then access tier, redundancy, and SDK auth defaults."
---

Storage bills surprise people, not the storage itself. Microsoft's azure-storage skill (v1.2.1) ships the actual decision data — five services, four blob access tiers, four redundancy levels — and most teams never open it. I read the SKILL.md, the SDK usage guide, and the auth-best-practices reference in [microsoft/azure-skills](https://github.com/microsoft/azure-skills). The 2026-09-12 skills.sh scrape counted 576,212 installs, rank 25, tucked right behind azure-validate with a nearly identical weekly curve. The procedure below follows the skill's own tables, step by step.

## Step 1–2: Pick the Service, Then the Account Tier

Start with the workload shape, not the brand name. The skill's service table maps each of the five services to a use case. Blob Storage handles objects, files, backups, and static content — the default for anything you upload or serve. File Shares provide SMB access for lift-and-shift workloads. Queue Storage does async messaging and task queues. Table Storage delivers NoSQL key-value, though the skill nudges you to consider Cosmos DB instead. Data Lake Storage serves big-data analytics and needs a hierarchical namespace, managed through `az storage fs`.

Account tier is the second decision and the cheaper one to get right: Standard covers general-purpose and backup workloads at millisecond latency, Premium targets databases and high-IOPS scenarios at sub-millisecond latency. Most new accounts belong in Standard. Choose Premium only when your workload measures latency in microseconds, not when you expect heavy traffic.

## Step 3–4: Blob Access Tier, Then Redundancy

Blob tiers are a cost trade, and the skill states the thresholds plainly. Hot fits frequent access — higher storage cost, lower access cost. Cool targets data accessed after 30+ days. Cold covers rare data after 90+ days. Archive holds rarely touched data after 180+ days at the lowest storage cost, but rehydration is required before reads — hours, not seconds. The pattern to follow: set the tier by *when* the data will be accessed again, and move old data down with lifecycle management instead of leaving everything hot.

Redundancy levels look similar on paper and differ in durability guarantees. LRS gives 11 nines and suits dev/test or recreatable data. ZRS raises that to 12 nines with regional high availability. GRS and GZRS both deliver 16 nines; GRS covers disaster recovery, GZRS adds the best durability when you can justify the price. For production workloads, ZRS is the sensible floor — LRS is one data-center failure away from losing writes.

## Step 5: Verify with MCP, and Mind the SDK Auth Defaults

The skill prefers the Azure MCP server when it is enabled: `azure__storage` exposes `storage_account_list`, `storage_container_list`, `storage_blob_list`, `storage_blob_get`, and `storage_blob_put`. If MCP is off, the CLI fallback is the same five operations through `az storage account`, `container`, and `blob` subcommands. The SDK quick references then cover the six languages — .NET, Java, JavaScript, Python, Go, Rust — with package names per service, and one rule repeats across all of them: use `DefaultAzureCredential` for local development, `ManagedIdentityCredential` in production. Rust breaks the pattern because it has no `DefaultAzureCredential` equivalent and uses `DeveloperToolsCredential` instead.

## When This Skill Should Not Run

The routing rules are as useful as the tables. The skill explicitly says DO NOT USE FOR: SQL databases, Cosmos DB, and messaging via Event Hubs or Service Bus. Cosmos DB routes to [azure-prepare](/skills/automation/azure-prepare/), the plan-first skill that owns the broader architecture; Event Hubs and Service Bus belong to [azure-messaging](/skills/automation/azure-messaging/), which I covered separately. Queue Storage and Event Hubs look interchangeable at a glance — queue for simple async work inside your app, Event Hubs when you need ingestion at scale.

Run this procedure the next time you add storage to a workload: service by workload shape, tier by access frequency, redundancy by durability requirement, auth by environment. Four choices, each grounded in a table the skill itself publishes. The bill at the end of the month is the real test of whether the choices held.

*Related: [azure-messaging — Event Hubs and Service Bus](/skills/automation/azure-messaging/), [azure-prepare — plan-first Azure architecture](/skills/automation/azure-prepare/).*