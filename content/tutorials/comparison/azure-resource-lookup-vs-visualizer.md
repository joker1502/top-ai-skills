---
title: "Resource Lookup vs Visualizer: Inventory or Diagram?"
date: 2026-09-14
toc: true
draft: false
tags:
  - Azure
  - Azure Resource Graph
  - Mermaid
category: "comparison"
description: "Two Microsoft skills with nearly identical installs: lookup returns ARG tables and orphan hunts, visualizer returns Mermaid diagrams. Pick by artifact."
---

Two Microsoft skills install at almost the same number — azure-resource-lookup at 578,136 and azure-resource-visualizer at 578,156 on our 2026-09-14 skills.sh scrape — and both answer "what's in my Azure?". They just hand you different artifacts: one returns a table, the other a diagram. I read both SKILL.md files end to end (lookup v1.2.1, visualizer v1.2.2, both MIT), plus the Azure Resource Graph reference file they each ship with, and walked the example diagram the visualizer uses as its template.

## Same ARG Bones, Different Deliverables

Both skills route through Azure Resource Graph, and both ship `references/azure-resource-graph.md` with the same KQL patterns: count resources by type, join `Resources` against `ResourceContainers` for cross-subscription inventories with subscription names, fish out orphaned disks with `isempty(managedBy)`, flag missing tags with `isnull(tags['Environment'])`. Same query language, same `=~` case-insensitive matching rule for type fields, same read-only boundary — neither skill may mutate a resource.

The split comes at the output stage. Lookup executes `az graph query -q "<KQL>" --query "data[].{...}" -o table`, scopes with `--subscriptions` or `--first N`, and formats with JMESPath. Visualizer takes exactly one resource group — it lists your groups, numbers them, and waits for your selection by number or name before touching anything — then analyzes every resource in it and produces a `[resource-group-name]-architecture.md` file with an embedded Mermaid diagram, a resource inventory table, and relationship notes.

## Lookup Earns Its Keep on Coverage and Orphan Hunts

List any resource type you can name: that's lookup's lane. Its SKILL.md carries a coverage matrix for the dedicated MCP tools, and the matrix is honest about gaps. Compute, storage, Cosmos DB, ACR, AKS, Event Hubs, and Service Bus have full list coverage. Key Vault is partial — secrets and keys only, no vault listing — and SQL needs a resource group name before it can answer. App Service and Container Apps have no dedicated list command at all, which is the skill's sharpest rule: "list my web apps" must route through ARG, and anyone reaching for a nonexistent MCP tool gets nowhere.

The orphan patterns are where it actually saves money. Unattached managed disks, public IPs with no `properties.ipConfiguration`, NICs with no attached VM, load balancers with empty backend pools — each maps to a three-line KQL snippet with the exact field to check. The skill pairs well with [azure-cost](/skills/automation/azure-cost/), whose optimization workflow runs the same style of ARG queries to find waste before touching the bill.

## Visualizer Earns Its Keep on Relationships

Lookup answers "what exists". Visualizer answers "how do these talk to each other". Its analysis maps data flow, identity, and network connections — app settings pointing at Key Vault, managed identities reaching storage, peering between VNets — and encodes them into the diagram's connection types: `-->` for data flow or dependency, `-.->` for optional paths, `==>` for the critical primary route. Node labels carry configuration that matters: App Service plan tier (B1 vs P1v2), Function runtime, SQL tier, storage redundancy (Standard LRS), VNet address space, subnet ranges.

One rule in its file keeps diagrams honest: never put real secret values in the diagram. Connection strings, keys, and Key Vault secrets become meaningful placeholders — the example diagram shows `KV[Key Vault]` and `MI[Managed Identity]` connected by labeled arrows, not credentials. For architectures over 50 resources, the guidance is to split the diagram by layer rather than cram everything into one canvas.

## The 20-Install Gap and the One-Box Trap

578,136 versus 578,156 — twenty installs apart, rank #56 and #55, identical weekly curves (17,142 → 12,808 and 17,065 → 12,810). That's the same pack-level counter wearing two labels, the pattern we've now documented across several azure comparisons, so the install numbers tell you nothing about which one you need.

The artifact decides. A resource group with three resources and no networking — one lookup command, done. A thirty-resource group with VNet peering, private endpoints, and an API Management layer that nobody on the team can explain — that's the visualizer's job. The two compose well: lookup finds the orphaned NIC, visualizer shows what it should have connected to.

## Run Both, Use the Right One

Both install with the same command shape: `npx skills add https://github.com/microsoft/azure-skills --skill azure-resource-lookup`, repeated with `--skill azure-resource-visualizer`. Next time someone asks "what do we have?", try the lookup first — one `az graph query` answers most inventory questions outright. Keep the visualizer for the moments where the question shifts from "what" to "why does this depend on that". For troubleshooting rather than inventory, the [azure-diagnostics walkthrough](/skills/automation/azure-diagnostics/) covers that adjacent lane.

*Covered alongside: [azure-cost — query the bill before you optimize](/skills/automation/azure-cost/).*