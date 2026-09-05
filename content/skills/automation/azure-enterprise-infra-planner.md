---
title: "azure-enterprise-infra-planner: Gated 7-Phase Azure IaC"
date: 2026-09-05
draft: false
tags:
  - Azure
  - Infrastructure as Code
  - Bicep
category: "automation"
description: "Microsoft's azure-enterprise-infra-planner (399K installs) plans Azure infra via a gated 7-phase pipeline, then generates checkov-clean Bicep or Terraform."
---

Most Azure IaC gets written like a rough draft: resource names invented on the spot, secrets in variables, public endpoints everywhere because private ones are work. Microsoft's azure-enterprise-infra-planner treats that draft as a failure state. It runs a 7-phase pipeline that refuses to deploy until the generated code passes a security scan, and it forces the agent to show you the receipts. I read the current SKILL.md (v1.4.1, MIT) plus the workflow, referenced-workload, and WAF checklist references in [microsoft/azure-skills](https://github.com/microsoft/azure-skills), then pulled install numbers off the skills.sh leaderboard on 2026-09-05: rank #121, 399.3K installs.

## Seven Phases, Zero Skippable Gates

The pipeline: Extract insights → Research best practices → Research resources → Generate plan → Verify → Generate IaC → Deploy. Every phase ends at a gate. Insights must land in `.azure/insights.json`; every resource needs an ARM type, naming rules, and pairing constraints; the plan is written to `.azure/infrastructure-plan.json` with a status that walks `draft` → `approved` → `deployed`. Verify (Phase 5) stops the run dead until you approve the plan — the error table lists "Plan approval missing" as a hard stop before IaC generation — and Phase 7 waits for an explicit, risk-acknowledged confirmation. Two phrases repeat across the workflow files like a mantra: *never claim a gate passed without proof* (run the command, paste its output) and *never assume knowledge and cut corners*.

## Greenfield vs Referenced: The Never-Recreate Rule

Input triage decides the flow. Pure new requirements run greenfield, straight through the phases. Everything else — a live resource, an existing Bicep/Terraform/ARM file, a requirements doc — flips the run into referenced mode, which loads `referenced-workload.md` and changes the rules of the game. Existing resources get inventoried completely (from `az resource list` / `az graph query` for live state, from parsing the IaC for declared state), then each one gets a role: **reference + integrate**, **retain**, or **ignore**. The file's sharpest sentence: *never emit a new `resource` for a resource that already exists.* Deployment in referenced mode is additive-only: Bicep runs incremental, never `--mode Complete` (that would delete anything absent from the template — including the referenced resources), Terraform `apply` must show no destroy against them, and a `--what-if` / `terraform plan` preview comes first. One agent-specific rule stands out: the skill is answer-first. It summarizes what exists, states what it will add, then generates the deployable IaC in the same turn — it never ends a response with only a question. The confirmation gate governs deployment, not artifact production.

## Phase 6: The Gate That Demands Receipts

workflow.md restates the hardening step inline because it is mandatory even when reference files aren't loaded. Secure-by-default first: private endpoints with public network access disabled on PaaS/data services, managed identity plus RBAC instead of keys, storage shared-key access off, Key Vault with soft-delete and purge protection, AKS local accounts disabled, TLS 1.2 minimum. Then validation: `az bicep build --file infra/main.bicep` for Bicep, `terraform init -backend=false` + `terraform validate` for Terraform, then `checkov -d infra/`. Fix, re-run, repeat until every command passes, and paste the actual output — if a tool is genuinely unavailable, the skill says so and self-reviews against the secure-by-default list instead of pretending. Phase 6 closes with a pass/fail self-check covering validation output, checkov findings, secure-by-default coverage, and (in referenced mode) proof that no existing resource was recreated. The WAF checklist drives the planning side: identity, secrets, monitoring, networking, encryption, resilience, auth hardening, tagging — each row either adds resources or gets documented as a tradeoff.

## How It Sits in the Pack

| Skill | Job | Boundary |
|-------|-----|----------|
| **azure-enterprise-infra-planner** | Architect landing zones, hub-spoke, DR topologies; generate Bicep/Terraform | Infrastructure topology and greenfield architecture |
| [azure-upgrade](/skills/automation/azure-upgrade/) | Change plans/SKUs and modernize SDKs on existing workloads | Starts where the planner's greenfield job ends |
| [azure-cloud-migrate](/skills/automation/azure-cloud-migrate/) | Port Lambda, Kubernetes, Heroku workloads **into** Azure | Migration of existing workloads, not new architecture |
| azure-prepare | App-centric workflows (the planner's own frontmatter says "PREFER azure-prepare FOR app-centric workflows") | Application onboarding, not topology design |

My 2026-09-05 scrape puts the planner at #121 with 399,300 installs and a weekly series of [15,756, 16,402, 17,041, 16,276, 16,011, 14,897, 13,353, 13,837] — the same lockstep rhythm every live skill in the pack traces. The total is pack-level signal, not solo popularity. It also confirms the deeper [planner vs migrator comparison](/tutorials/comparison/azure-planner-skills-comparison/) from last week: while [azure-cloud-migrate](https://github.com/microsoft/azure-skills/tree/main/skills/azure-cloud-migrate) evaluates and ports, this skill architects from scratch.

## Start With a Workload Description

Install it with `npx skills add https://github.com/microsoft/azure-skills --skill azure-enterprise-infra-planner`, then hand it a real workload — "two apps, a hub-spoke VNet, private endpoints, three regions" — and watch what lands in `.azure/` and `infra/`. The deliverable worth keeping is the plan file, not the first `terraform apply`: an architecture where Phase 6's checks pass before anything touches a subscription.