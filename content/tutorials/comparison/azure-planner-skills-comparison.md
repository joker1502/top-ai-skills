---
title: "Azure Planner Skills: infra-planner vs cloud-migrate"
date: 2026-09-04
toc: true
draft: false
tags:
  - Azure
  - Infrastructure as Code
  - Cloud Migration
category: "comparison"
description: "Which Azure planner fits: infra-planner architects greenfield Bicep/Terraform; cloud-migrate ports Lambda, K8s, Spring Boot. Phase gates, install data compared."
---

Microsoft's azure-skills pack carries two planning skills, and people install the wrong one constantly. azure-enterprise-infra-planner architects landing zones; azure-cloud-migrate ports existing workloads from AWS, GCP, and K8s. I read both SKILL.md files in full (planner v1.4.1, migrator v1.3.2, both MIT), worked through the planner's phase-gate workflow and the migrator's 37-file reference tree, then scraped the skills.sh leaderboard on 2026-09-04: infra-planner sits at #121 with 398.4K installs, cloud-migrate at #68 with 495.6K.

## One Architects a Landing Zone, the Other Ports a Workload

The planner runs a 7-phase gated pipeline: extract insights, research best practices, research resources, generate a plan, verify with the user, generate IaC, deploy. Input gets triaged into greenfield or referenced mode — if you hand it a live resource, an existing IaC file, or a requirements doc, it inventories what exists, wires the new workload in, and never recreates or destroys the referenced pieces. Output lands as `.azure/insights.json`, a plan file that moves `draft → approved → deployed`, and `infra/main.bicep` plus modules — or the Terraform equivalent. Six MCP tools back the research phases, including `bicepschema_get` for latest API versions and a WAF service guide lookup, and everything aligns to the Well-Architected Framework.

The migrator covers exactly eight source-to-target pairs — Lambda to Functions, Elastic Beanstalk/Heroku/App Engine to App Service, Fargate/GKE/EKS/Cloud Run/Spring Boot to Container Apps — and its SKILL.md is a router, not a tutorial. Three hard rules bind every run: follow phases sequentially, generate the assessment before migrating anything, use the latest supported runtime. Everything writes to a `<workspace-basename>-azure/` output directory, a `migration-status.md` tracks phases with literal emoji states (⬜ Not Started → 🔄 In Progress → ✅ Complete → ❌ Failed), and the run ends by asking whether to test locally or deploy — then hands off to azure-prepare.

Neither skill writes a single line of hand-rolled how-to for you. Both produce artifacts an engineer reviews.

## The Gates Separate Substance From Cosmetic

The planner's Phase 6 is the strictest gate I've seen in any skill file. Generated IaC must be secure-by-default — private endpoints with public access disabled on data services, managed identity plus RBAC instead of keys, no secrets in code, Key Vault soft-delete with purge protection, TLS 1.2 minimum — then validated with `az bicep build` or `terraform validate` to zero errors, then scanned with `checkov` until no unresolved high or critical findings remain. The rule that matters most is procedural: paste the actual command output into the response, and never claim a gate passed from memory. Phase 5 needs explicit user approval; Phase 7 needs a risk-acknowledged confirm before any deployment. In referenced mode, deployment is additive only — incremental changes, a what-if preview, no destroy of anything pre-existing.

The migrator's sharpest rule comes from its K8s assessment: internal DNS names like `http://order-service:3001` do not resolve inside Container Apps, so the agent audits code for hardcoded hostnames and flags each for env-var-driven injection. Its compatibility matrix names real blockers — StatefulSets, DaemonSets, custom CRDs, node networking are all "no" — and its limits table admits the ceiling honestly: 4 vCPU and 8 GiB per container versus 64+ in a typical cluster, 300 replicas per revision, and a 240-second default request timeout. Both skills demand an assessment artifact before action; both gate deployment behind human confirmation. The planner gates the *quality of the code*, the migrator gates the *honesty of the discovery*.

## Match the Job, Not the Install Count

Choose by what you hold in your hands right now. Greenfield infrastructure — a hub-spoke network, a multi-region DR topology, subscription-scope Bicep, a landing zone — belongs to the planner. An existing workload on Lambda, Heroku, GKE, or Spring Boot heading into Azure belongs to the migrator. A plan/SKU change on infrastructure already inside Azure belongs to neither — that's azure-upgrade's lane. If your workflow is app-centric rather than infrastructure-centric, the planner's own description tells you to prefer azure-prepare.

The two chain together cleanly. The migrator lands your Lambda service on Functions; the planner architects the VNet, private endpoints, and RBAC layer around it. Both end in the same place geometrically — azure-prepare — from opposite directions. The install gap (495.6K vs 398.4K) looks meaningful but isn't: both moved +1.9K in the same 24-hour window on my 09-03 → 09-04 snapshots, same as every other skill in the pack. That's one pack-level counter wearing two labels, so rank the split by job fit, not raw totals.

## Install the One That Matches Your Workflow

Start with the question "is this existing or unborn?" — then run `npx skills add https://github.com/microsoft/azure-skills --skill azure-enterprise-infra-planner` for greenfield architecture, or the same command with `--skill azure-cloud-migrate` for the port. I'd suggest testing the planner on a fake architecture brief first and watching whether its Phase 6 gate actually stops and shows you output when `checkov` flags something. That behavior — proving the gate, not asserting it — is the real difference between these two tools and every other "architect-for-me" skill on the market. See our earlier walkthrough of [azure-cloud-migrate](/skills/automation/azure-cloud-migrate/) for the eight-scenario detail, and [azure-compute](/skills/automation/azure-compute/) if sizing and creation are your actual bottleneck.