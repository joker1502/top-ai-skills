---
title: "appinsights-instrumentation: The App Insights Guidance Skill"
date: 2026-09-18
draft: false
tags:
  - Azure
  - Application Insights
  - Telemetry
category: "automation"
description: "appinsights-instrumentation (587K installs): guidance-only telemetry skill. SDK setup for ASP.NET Core, Node.js and Python, plus Container Apps observability"
---

Microsoft's `appinsights-instrumentation` skill (v1.2.1, MIT) is the rare Azure skill that refuses to act. Its SKILL.md opens with a block-quoted rule: if the user wants to *add* App Insights to an app, invoke `azure-prepare` instead — this skill only provides reference material that the orchestrator consumes during its research phase. I read the full SKILL.md plus every reference (auto, ASP.NET Core, Node.js, Python, Container Apps, OpenTelemetry SDK pages, the Bicep example, the CLI script) and scraped skills.sh on 2026-09-18: 587,409 installs, rank 55, weekly curve [17111, 16383, 16130, 14987, 13426, 13612, 12124, 12809] — lockstep with the pack counter we keep seeing across microsoft/azure-skills.

## Two Auto-Instrument Paths, Then Manual

The skill supports exactly two auto-instrumentable stacks: an ASP.NET Core app and a Node.js app, both hosted in Azure App Service. Auto-instrumentation needs zero code changes — the skill hands you a portal URL shaped like `portal.azure.com/#resource/subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.Web/sites/{app}/monitoringSettings` and you flip the switch in the Application Insights blade.

Everything else is manual, and the manual flows split by language. ASP.NET Core: `dotnet add package Azure.Monitor.OpenTelemetry.AspNetCore`, then two lines in Program.cs — `using Azure.Monitor.OpenTelemetry.AspNetCore;` and `builder.Services.AddOpenTelemetry().UseAzureMonitor();` before `builder.Build()`. Node.js: `npm install @azure/monitor-opentelemetry`, then `const { useAzureMonitor } = require("@azure/monitor-opentelemetry");` and `useAzureMonitor();` in the entry file — called after env loading, before anything else. Python is different: telemetry rides the stdlib logger, so you build a module that calls `configure_azure_monitor(logger_name=...)` once, then emit with plain `logging.getLogger(...).info(...)`.

## The Connection String Rule That Kills a Bad Habit

Every reference hammers the same configuration rule: set `APPLICATIONINSIGHTS_CONNECTION_STRING` as an environment variable — never touch `appsettings.json`. The ASP.NET Core reference calls the old appsettings approach "a deprecated way" outright. The connection string comes from the CLI script bundled with the skill:

```bash
az extension add -n application-insights
az monitor log-analytics workspace create --resource-group $rg --workspace-name $lws --location $region
az monitor app-insights component create --app $ai --location $region --resource-group $rg --workspace $lws
az monitor app-insights component show --app $ai --resource-group $rg --query connectionString --output tsv
```

For IaC-driven apps, the env var should live in the Bicep/Terraform template so every deploy reapplies it. The companion Bicep example (`examples/appinsights.bicep`) creates a Log Analytics workspace (PerGB2018, 30-day retention) plus the `Microsoft.Insights/components` resource, and outputs the connection string directly.

## The Container Apps Reference Is the Real Payload

The Container Apps guide is where this skill earns its keep — it packs 7.3KB of the skill's ~21KB total, and it corrects two details most docs get wrong. Table names depend on the log destination: `ContainerAppConsoleLogs_CL` / `ContainerAppSystemLogs_CL` apply to the Log Analytics destination, but environments running the newer Azure Monitor destination drop the `_CL` and `_s` suffixes entirely — query the wrong name and you get nothing. When you wire the connection string as a secret on a container app, the recommended pattern stores it in the app's secret store and references it: `--set-env-vars "APPLICATIONINSIGHTS_CONNECTION_STRING=secretref:appinsights-conn"` keeps the value out of `az` output and portal configuration views.

| Detail | Value |
|:-------|:------|
| SDK packages | `@azure/monitor-opentelemetry` (Node) · `azure-monitor-opentelemetry` (Py) · `Azure.Monitor.OpenTelemetry.AspNetCore` (.NET) |
| Java path | Agent JAR via `JAVA_TOOL_OPTIONS=-javaagent:...` |
| Built-in ACA metrics | Replicas, Requests, UsageNanoCores, WorkingSetBytes, RestartCount, Rx/TxBytes — infra only |
| Dapr tracing | `samplingRate: "1"` = 100%; lower it for production |
| Trace correlation | `operation_Id` in KQL across services |

Built-in Container Apps metrics stop at infrastructure — request-level latency and dependency tracking need the SDK. The reference also warns that its own discovery query for unmonitored apps only catches containers that already have env vars; apps with no env block are invisible to it, so they must be hunted separately.

## Where This Skill Sits in the Pack

It is documentation, deliberately. The SKILL.md lists the user intents that route *elsewhere*: "add telemetry to my app" goes to azure-prepare, and the skill itself is invoked by azure-prepare during research. Install it with `npx skills add https://github.com/microsoft/azure-skills --skill appinsights-instrumentation`. When you need the troubleshooting half of observability — AppLens, KQL starting queries, resource health — that's [azure-diagnostics](/skills/automation/azure-diagnostics/); this skill owns the setup half. If your goal is understanding what telemetry flows exist before touching code, [azure-ai](/skills/automation/azure-ai/) covers the model-inference side of the same monitoring story.