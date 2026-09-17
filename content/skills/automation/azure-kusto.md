---
title: "azure-kusto: The KQL Skill for Azure Data Explorer"
date: 2026-09-17
draft: false
tags:
  - Azure
  - Kusto
  - Data Analytics
category: "automation"
description: "azure-kusto (585K installs) runs KQL over Azure Data Explorer: four MCP tools, five query patterns, and a CLI fallback that lists clusters but cannot query them"
---

Azure Data Explorer holds your telemetry, and querying it still means learning KQL. Microsoft's azure-kusto skill (v1.2.1, MIT) is supposed to remove that layer — it turns plain-English requests into Kusto Query Language against ADX clusters. I read the full SKILL.md, then scraped skills.sh on 2026-09-17: 585,014 installs, rank 58, with a weekly curve that sits 78 installs below azure-aigateway — the same pack-level lockstep counter we keep finding across microsoft/azure-skills.

## Four MCP Tools, Zero Management

The skill exposes exactly four tools, and every one of them reads. `kusto_cluster_list` enumerates clusters in your subscription, `kusto_database_list` drills into their databases, `kusto_table_schema_get` returns table structure for query planning, and `kusto_query` executes KQL. Each call needs a `subscription` plus either `cluster`/`database` for listing or `query`/`table` for analysis; `resource-group` and `tenant` stay optional.

That read-only shape matters. There is no ingestion tool, no cluster provisioning, no retention policy editor. The skill answers "what's in my Kusto database" and "run this query on it" — anything that creates or changes resources lives in the plan-first azure-prepare lane instead. [azure-prepare](/skills/automation/azure-prepare/) owns deployment; this skill owns introspection.

## The CLI Fallback That Can't Query

Here's the trap the SKILL.md buries in its fallback table. If the MCP tools time out, the skill tells you to switch to Azure CLI — but `az kusto` has no query command at all. The CLI reference covers only `cluster list`, `cluster show`, `database list`, and `database show`. To actually run KQL you must skip the CLI entirely and POST to the Kusto REST endpoint:

```bash
az rest --method post \
  --url "https://<cluster>.<region>.kusto.windows.net/v1/rest/query" \
  --body "{ \"db\": \"<database>\", \"csl\": \"<kql-query>\" }"
```

So the "fallback" for the core operation is a hand-built REST call, not a CLI command. Plan for that when you wire this skill into an agent: the MCP path is the real path, and the escape hatch assumes you can construct a JSON body with the cluster's region baked into the URL.

The timeout rule defines when to fall back: MCP queries taking over 60 seconds, "service unavailable" errors, auth failures, or empty responses from a database you know has data. Empty results more often mean an over-restrictive time filter than missing data.

## Five Patterns Cover Most Kusto Work

The SKILL.md concentrates its value in five query patterns you can lift directly. Basic retrieval filters recent rows with `where Timestamp > ago(1h) | take 100`. Aggregation summarizes by a dimension and time bucket — `summarize count() by EventType, bin(Timestamp, 1h)` for top-N event analysis. Time series rolls latency percentiles into 5-minute buckets and renders a timechart. Join-and-correlation pairs an error table with a critical log table on `CorrelationId` for root-cause tracing. Schema discovery runs `kusto_table_schema_get` before you write anything.

The supporting best-practices list is short and worth keeping as a checklist: filter early with `where`, always bound time on time-series data, use `summarize` instead of client-side aggregation, `project` only the columns you need, and store repeated queries as database functions. Query results come back with columns, rows, execution stats, and a rendering hint (`timechart`, `barchart`) that the client can consume directly.

## What Actually Bites in Production

| Symptom | Root cause | Fix |
|:--------|:-----------|:----|
| Access denied | Below Viewer role | Viewer is the minimum for queries; grant it on the database |
| Query timeout | No time filter, huge result set | Add `ago()`/`between()`, `take` early, or raise the 60s limit |
| Cluster not found | `.kusto.windows.net` suffix included | Pass the bare cluster name — the suffix is assumed |
| Empty results | Time range too narrow, wrong table | Loosen the window, confirm the table name |
| High CPU | Query too broad | Tighten filters, shrink time range, cap aggregations |
| Stale data | Streaming ingestion | Expect 1–30 seconds of delay depending on the ingestion method |

That cluster-name rule is the sneakiest one. The skill's own parameter spec says the cluster name, and the failure mode note spells out that appending `.kusto.windows.net` breaks the lookup — include it and the agent chases a phantom resource for a while.

## Where to Start

Install it with `npx skills add https://github.com/microsoft/azure-skills --skill azure-kusto`, then ask it "what tables are in my Kusto database" on a test cluster and watch whether it returns schema before it touches data — the workflow insists on schema discovery ahead of querying. If your symptoms are security events or APM metrics, the [azure-ai](/skills/automation/azure-ai/) and [azure-diagnostics](/skills/automation/azure-diagnostics/) skills cover the troubleshooting edge; azure-kusto handles the data plane in front of them.

*Covered alongside: [azure-aigateway — six steps to govern OpenAI calls](/tutorials/guides/azure-aigateway-procedural/) — the other 585K lockstep sibling from the same pack.*