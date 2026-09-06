---
title: "azure-prepare: The Plan-First Azure Deployment Skill"
date: 2026-09-06
draft: false
tags:
  - Azure
  - Azure Developer CLI
  - DevOps
category: "automation"
description: "Microsoft's azure-prepare (565K installs) forces a written plan file before any code, then scaffolds azd, Bicep, or Terraform and hands off to validation."
---

The fix for most Azure deployment failures is a file on disk. Microsoft's azure-prepare skill (v1.3.2, 565.5K installs) writes `.azure/deployment-plan.md` into your workspace as its very first action and refuses to generate any infrastructure until you approve it. The classic failure sequence — wrong region, exhausted quota, secrets in templates — becomes visible before it costs you anything. I read the full SKILL.md plus the plan-template, recipe-selection, specialized-routing, and security references in [microsoft/azure-skills](https://github.com/microsoft/azure-skills). On the 2026-09-06 skills.sh scrape, it held 565,497 installs, the second-highest count in the pack.

## The Plan File Is a Hard Dependency, Not a Formality

Three skills form the deployment chain — azure-prepare → azure-validate → azure-deploy — and the plan file is the handshake between them. azure-prepare writes the skeleton in its very first step, fills it in as Phase 1 analysis progresses, and finalizes it before showing you anything. The template runs nine sections: goal, requirements, detected components, recipe selection, architecture, a provisioning-limit checklist, execution checkboxes, validation proof, and next steps. Its status field walks a fixed ladder — Planning → Approved → Executing → Ready for Validation → Validated → Deployed — with strictly separated write permissions. azure-prepare sets "Ready for Validation", azure-validate sets "Validated", and azure-deploy is forbidden from touching the status at all. Skip the file and the downstream skills fail: both azure-validate and azure-deploy check for it before doing anything else.

The quota section is where this gets real. The provisioning-limit checklist runs in two phases. You inventory every planned resource type with its ARM type and count, then invoke the azure-quotas skill to fetch actual limits through the quota CLI (`az quota list` scoped to the subscription and region). Only providers that answer `BadRequest` — DocumentDB is the file's example — fall back to the official service-limits docs. The hard rule: you cannot present the plan while any cell says "_TBD_". We covered that CLI-first quota workflow in the [azure-quotas procedural guide](/tutorials/guides/azure-quotas-procedural/).

## It Routes You Away Before Generating Anything

Preparation starts with Step 0, a keyword check across your prompt and codebase. Python + App Service code-only requests route out to python-appservice-deploy with the table's highest priority; anything mentioning Lambda, AWS, Fargate, or GCP routes to azure-cloud-migrate; AI gateway requests route to azure-aigateway. The skill keeps Azure Functions, APIM, and durable workflows at home, where it selects the durable recipe and loads the Durable Task Scheduler references itself. Routing order matters: check rows top to bottom, first match wins, and the table scans your prompt text rather than just the code — essential for greenfield repos that have neither.

Recipe selection hides one decision worth memorizing. The default is AZD with Bicep, but the recipe-selection reference says that when Terraform is mentioned for an Azure deployment you should default to **azd + Terraform** rather than standalone Terraform. azd supplies environment management and CI/CD generation for free while still speaking Terraform underneath. Standalone Terraform is reserved for multi-cloud setups or workflows that fight azd conventions; AZCLI gets picked only when existing `az` scripts or AKS demand imperative control. The output side stays compact: `azure.yaml`, `infra/` in Bicep or Terraform, and one Dockerfile per component under `src/<component>/`.

## Preparation Stops Before the First Deploy Command

Phase 2 runs only after your approval. It researches components, confirms subscription and location through `ask_user` (never guessed), generates artifacts, hardens security, verifies the app locally, and updates the plan status to "Ready for Validation" before the mandatory handoff. The skill's scope line states it flatly — deployment execution (`azd up`, `azd deploy`, `terraform apply`) belongs to azure-deploy. I found two security rules that read like absolutes. SQL Server Bicep must never contain `administratorLogin` or `administratorLoginPassword`, not in properties and not in a conditional branch, because Entra-only authentication (`azureADOnlyAuthentication: true`) is required unconditionally. And `azd init -t <template>` is banned inside an existing workspace: modifications touch existing files only, and the project directory is never deleted.

## How It Sits in the Deployment Chain

| Skill | Job | Hands off to |
|-------|-----|--------------|
| **azure-prepare** | Plan + scaffold azd/Bicep/Terraform infra and Dockerfiles | azure-validate |
| azure-validate | Check the plan, run checks, set status to Validated | azure-deploy |
| azure-deploy | Execute deploys with built-in error recovery | production |
| [azure-cloud-migrate](/skills/automation/azure-cloud-migrate/) | Port Lambda/K8s/Heroku workloads into Azure | azure-prepare Phase 1 Step 4 |
| python-appservice-deploy | Code-only Python App Service deploys | — |

The 2026-09-06 scrape puts azure-prepare at 565,497 installs, azure-deploy at 565,378, and azure-validate at 564,844 — three skills separated by 653 installs total. Their weekly curves are near-identical, peaking around 17.3K and drifting to roughly 13.6K. That reproduces the pack-level counter signature we documented for [azure-diagnostics](/skills/automation/azure-diagnostics/) and the rest of the family. The number measures the pack, not the solo skill — it means the prepare→validate→deploy chain is popular even when nobody searches for its parts individually.

## Start With a Real Workload

Install it with `npx skills add https://github.com/microsoft/azure-skills --skill azure-prepare`, point it at a two-service app, and read the plan file before you approve anything. The moment that file hits disk with real quota numbers, deployment stops being a gamble. When you are ready to ship, the [azure-deploy procedural guide](/tutorials/guides/azure-deploy-procedural/) walks the execution side.