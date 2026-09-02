---
title: "Check Azure Quotas Before Deploy: The CLI-First Workflow"
date: 2026-09-02
toc: true
draft: false
tags:
  - Azure
  - Quotas
  - Cloud Operations
description: "A procedural guide to Microsoft's azure-quotas skill (427K installs): install the quota extension, discover real quota names, and file CLI increase requests."
category: "guides"
---

Your deploy fails at the last step with `QuotaExceeded`, and the portal shows "No Limit" for the very resource that just rejected you. That contradiction is the whole story of Azure quota management, and Microsoft's azure-quotas skill (v1.2.1, 427.6K installs, #94 on the skills.sh all-time board) exists to kill it. I read the full SKILL.md, the commands reference, the advanced commands file, and the bundled check-quota scripts, then pulled leaderboard numbers on 2026-09-02. This guide runs the skill's workflow top to bottom.

## Why Deployments Die on Quota Even When Nothing Is Full

Quotas are not an accounting nicety. In Azure they are the actual capacity check: if the subscription has no quota for a region, the resource cannot deploy there, period. The skill's overview states it flat — *if you don't have quota, you cannot deploy resources* — and treats quota checks as a pre-deployment step, not a troubleshooting one.

The trap is that the misleading answer comes from Microsoft's own surfaces. The REST API and the portal can both return "No Limit" or "Unlimited" for supported resources, and that means exactly nothing about capacity: it means the quota API does not cover that resource type, so no number gets reported. The skill warns agents in two separate files, in bold, that "No Limit" is not unlimited capacity. A quota can sit at its true ceiling while every dashboard you check says there is no ceiling at all.

## The Doctrine: Azure CLI First, MCP Server Never

Every quota surface except the CLI carries a warning in this skill. The `azure-quota` MCP server gets the strongest one: "NEVER use this. It is unreliable. Always use `az quota` CLI instead." That matches what the [azure-compute](/skills/automation/azure-compute/) intro found in its own vm-quotas reference — the same ban, from a sibling file. The REST API is "unreliable, do NOT use first", and the portal exists only as a fallback.

There is a second trap hiding deeper: quota resource names do not map 1:1 to ARM resource types. `Microsoft.App/managedEnvironments` is called `ManagedEnvironmentCount` in quota land; `Microsoft.Compute/virtualMachines` fans out into `standardDSv3Family`, `cores`, and `virtualMachines` as separate quotas; public IPs split into `PublicIPAddresses` and `IPv4StandardSkuPublicIpAddresses`. Guess the name and you query a quota that does not exist. The skill's discovery workflow is: list everything with `az quota list --scope /subscriptions/<id>/providers/<Provider>/locations/<region>`, match the row by its human-readable `localizedValue`, then reuse the exact `name` field in every later command.

## Step-by-Step: The Quota Check Workflow

**Step 1 — Install the extension.** `az extension add --name quota`. Without it, every command dies with `ExtensionNotFound`. The bundled scripts check for the extension and install it automatically on first run.

**Step 2 — One call, three columns.** The skill ships `scripts/check-quota.ps1` and `check-quota.sh` precisely so agents stop assembling command chains by hand:

```bash
./scripts/check-quota.sh Microsoft.Compute eastus
```

One call returns a joined table of every compute quota with its limit, current usage, and available capacity — the script runs `az quota list` and `az quota usage list` and merges them by name:

| Resource | Region | Limit | Usage | Available |
|----------|--------|-------|-------|-----------|
| cores | eastus | 100 | 50 | 50 |
| standardDSv3Family | eastus | 350 | 50 | 300 |
| virtualMachines | eastus | 25000 | 5 | 24995 |

Single-resource mode takes a third argument: `./scripts/check-quota.sh Microsoft.Compute eastus standardDSv3Family`.

**Step 3 — Cross-region comparison.** The skill's second workflow loops candidate regions manually:

```bash
for region in eastus eastus2 westus2 centralus; do
  LIMIT=$(az quota show --resource-name standardDSv3Family \
    --scope "/subscriptions/$ID/providers/Microsoft.Compute/locations/$region" \
    --query "properties.limit.value" -o tsv)
  USAGE=$(az quota usage show --resource-name standardDSv3Family \
    --scope "/subscriptions/$ID/providers/Microsoft.Compute/locations/$region" \
    --query "properties.usages.value" -o tsv)
  echo "$region | Limit: $LIMIT | Usage: $USAGE | Available: $((LIMIT - USAGE))"
done
```

**Step 4 — File the increase through the CLI.** When headroom is short, `az quota update` submits the request and returns a request ID:

```bash
az quota update \
  --resource-name standardDSv3Family \
  --scope /subscriptions/<id>/providers/Microsoft.Compute/locations/eastus \
  --limit-object value=500 \
  --resource-type dedicated
```

Track it with `az quota request status list --scope ...` (one-year window, filterable by `requestSubmitTime`, `provisioningState`, or `resourceName`) or `az quota request status show --id <REQUEST_ID>`. Increases are free — you pay for resources, not for quota. Adjustable quotas (VM vCPUs, public IPs, storage accounts) usually auto-approve within minutes; some go to manual review for hours or days; non-adjustable subscription-wide limits never move without an Azure Support ticket.

## What Still Trips You After the Commands Work

Three providers fail differently. `az quota list` on Microsoft.DocumentDB returns `BadRequest` — Cosmos DB quotas live in the portal and the service limits docs, not the quota API. On the supported side the skill confirms Compute, Network, App (Container Apps), Storage, MachineLearningServices, and ContainerService (AKS). Two other errors show up in real use: `MissingRegistration` means the `Microsoft.Quota` provider needs `az provider register --namespace Microsoft.Quota`, and `InvalidScope` means the scope string broke — the accepted shape is `/subscriptions/<id>/providers/<namespace>/locations/<region>`, nothing else.

The skill's own best-practice list reads like lessons from incidents: run `az quota list` first to discover names, check quotas before every deployment, compare regions for capacity, request a 20% buffer over immediate needs, use `--output table` for scanning, and alert at 80% usage.

## Bottom Line

Check quota before you deploy, from the CLI, by the resource name the API actually uses. Install `az extension add --name quota`, run the bundled check script on the target provider and region, and treat "No Limit" in the portal as a missing data point, not a license to proceed. `npx skills add https://github.com/microsoft/azure-skills --skill azure-quotas` grabs the skill and its scripts. The workflow takes about a minute per region, and it turns the most embarrassing Azure failure — the deploy that dies on quota — into a number you checked before you started.