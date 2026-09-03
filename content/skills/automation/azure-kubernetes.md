---
title: "azure-kubernetes: Microsoft's AKS Day-0 Planning Skill"
date: 2026-09-03
draft: false
tags:
  - Azure
  - Kubernetes
  - AKS
description: "Inside Microsoft's azure-kubernetes skill (389K installs): the Day-0 framework that locks in AKS networking, plus spot and autoscaler hard numbers."
version: "1.2.2"
author: "Microsoft"
repo_url: "https://github.com/microsoft/azure-skills"
install_cmd: "npx skills add https://github.com/microsoft/azure-skills --skill azure-kubernetes"
compatibility:
  - Claude Code
  - Cursor
  - GitHub Copilot
category: "automation"
rating: 4.5
github_stars: 1447
github_forks: 241
installs: 389415
last_updated: "2026-09-03"
ai_friendliness:
  score: 4.5
  documentation: 4.5
  setup: 4.0
  config: 4.0
---

Most AKS tutorials hand you a `az aks create` command and call it done. Microsoft's azure-kubernetes skill does the opposite: it walks you through Day-0 decisions first, because two of them — pod networking and API server access — are effectively permanent after creation. I read the full SKILL.md (v1.2.2, 10.9 KB, the deepest file in the pack I've documented so far) plus all five reference files, and pulled fresh leaderboard numbers on 2026-09-03.

## Day-0 Decisions Lock In Before You Create Anything

The skill divides everything into Day-0 (hard to change later) and Day-1 (safe to enable post-creation), and it treats the pod IP model as the headline Day-0 call. Azure CNI Overlay is the default: pods get IPs from a private overlay range that never touches the VNet, so you can grow past a small subnet. VNet-routable CNI only earns its complexity when pods must be directly addressable from on-prem or the VNet — a niche need. Alongside it, the CLI reference shows the exact creation shape: `--sku automatic`, `--network-plugin azure --network-plugin-mode overlay`, `--enable-oidc-issuer --enable-workload-identity`.

AKS Automatic is the default SKU, and the skill defends that choice. Automatic pre-configures security, reliability, and performance best practices, and its Node Auto-Provisioning (NAP) removes manual node pool management. Standard is explicitly for people with custom networking, autoscaling, or node pool requirements. The file lumps in concrete guardrails most guides omit: a dedicated system node pool with at least 2 nodes tainted `CriticalAddonsOnly`, latest-gen v5/v6 SKUs, a hard ban on B-series burstable VMs for production, a 4-vCPU floor per node, 3 availability zones, and Standard tier for the 99.95% API server SLA.

## The Reference Files Push Past General Advice

The four deep-dive files contain numbers you don't find in Microsoft Learn summaries. The spot pool guide pins the eviction notice at **30 seconds** and recommends `terminationGracePeriodSeconds: 25` plus a 5-second `preStop` sleep to drain in-flight requests — the sample YAML is copy-paste ready. `--spot-max-price -1` means pay up to on-demand price with no cap; set `0.05` to cap hardware spend. Pinned pods with `nodeSelector` stay pending until a spot node returns, while tolerant-but-unpinned pods reschedule onto the regular pool.

Rightsizing has actual thresholds: CPU request over 5× P95 usage drops to `P95 × 1.2`, memory over 3× P95 gets the same treatment, and the metrics ladder tells you what your data is worth — Managed Prometheus gives accurate 7-day P95 history, Container Insights is good, and bare Metrics Server means live `kubectl top` data only. VPA must start in recommendation-only mode (`updateMode: "Off"`), and the file says outright: do not run `Auto` in production without testing. The autoscaler reference ships four tunable profiles — default, cost-optimized (5m/5m), conservative (30m/30m at 0.7 utilization), and aggressive (2m/2m at 0.4) — each with a risk label attached.

## How It Sits in the Pack

This skill plans and configures the cluster; it never deploys into one. That puts it alongside [azure-cloud-migrate](/skills/automation/azure-cloud-migrate/) (which moves workloads *to* Azure) and [azure-diagnostics](/skills/automation/azure-diagnostics/) (which fixes them after), while its own SKILL.md points to an `azure-kubernetes-app-deploy` sub-skill for actual deployments. That sub-skill is the odd part: the repo's `skills/` directory has no such folder, and the skills.sh leaderboard shows no such entry. It looks like a removed skill whose router text survived — the same removal signature I traced for azure-rbac and azure-hosted-copilot-sdk last month.

The numbers match the pack's lockstep pattern. My 2026-09-03 scrape puts azure-kubernetes at 389,415 installs with weekly [15,763 → 17,012 peak → 13,582], tracking azure-upgrade (422,046) and azure-enterprise-infra-planner (396,541) wave for wave — one shared pack counter wearing different labels. Two more entries on today's board confirm the removal pattern: azure-cost-optimization sits at 209,390 with weekly [91, 118], and azure-observability at 98,308 with weekly [10, 6]. Both crashed to near zero, and neither exists in the repo anymore — that makes four confirmed victims in this pack. The repo itself is healthy: 1,447 stars, pushed 2026-09-03.

## When to Add This Skill

About to create a production AKS cluster? Pull up this skill as your checklist — it covers what you'd otherwise assemble from five different docs pages, and it catches the decisions you can't undo. Run `npx skills add https://github.com/microsoft/azure-skills --skill azure-kubernetes` to install it. Next time you create a cluster, let the agent walk the Day-0 list first: pod IP model, egress, system pool, zones. Check the autoscaler reference for the aggressive profile before you assume your idle nodes scale down on their own.