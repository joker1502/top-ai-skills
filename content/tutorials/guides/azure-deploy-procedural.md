---
title: "Deploy to Azure Without Surprises: The 10-Step azure-deploy Runbook"
date: 2026-09-06
toc: true
draft: false
tags:
  - Azure
  - Deployment
  - Azure Developer CLI
category: "guides"
description: "A procedural guide to Microsoft's azure-deploy (565K installs): the 10-step runbook, five pre-deploy traps, and the Container Apps AcrPull propagation gate."
---

Your Container App revision hangs in provisioning for fifteen minutes, then fails: the image-pull permission exists on paper but had not propagated. Failures like that are why Microsoft's azure-deploy skill (v1.2.1, 565.4K installs) refuses to run until validation has written receipts, and why its runbook puts a propagation gate between provisioning and image deployment. I read the SKILL.md, its 508-line pre-deploy checklist, and the troubleshooting reference in [microsoft/azure-skills](https://github.com/microsoft/azure-skills). The 2026-09-06 skills.sh scrape put it at 565,378 installs — fifty short of its prepare sibling.

## Three Gates Decide Whether azure-deploy Runs at All

The skill checks prerequisites before a single command executes: `.azure/deployment-plan.md` must exist, its status must read `Validated`, and the Validation Proof section must contain actual commands with timestamps. An empty proof section means validation was bypassed — the skill says so explicitly and routes you back to azure-validate. Only azure-validate may write that status; azure-deploy is forbidden from setting it manually, and it warns that agents who edit the status to save time end up with deployments that fail. The trigger phrases are the operational ones — "run azd up", "go live", "ship it", "push to production" — and "create and deploy" belongs to azure-prepare, not here.

Once admitted, execution follows ten steps: check the plan, complete the pre-deploy checklist, load the recipe (azd, AZCLI, Bicep, Terraform, or CI/CD) from the plan's `recipe.type`, run the RBAC health check where required, then execute the deploy. Post-deploy steps cover SQL managed identity and EF migrations, error handling from the recipe's `errors.md`, endpoint and live-role verification, and reporting fully-qualified `https://` URLs — the skill bans bare hostnames on principle.

## Five Pre-Deploy Traps That Look Like Luck

The checklist orders its steps deliberately, and each one kills a specific silent failure. Environment first: run `azd env new <name> --no-prompt` before anything else, never `mkdir .azure` by hand, because the environment name becomes part of the resource group name (`rg-<env-name>`). Resource group location: check `az group show --name rg-<env-name>` before choosing a location, or you hit "Invalid resource group location" errors. Tag conflicts: azd locates deployment targets inside the target RG through `azd-service-name` tags, so duplicate tags in that RG break the deploy — a fresh environment beats deleting resources. Container Apps drift: if the RG already exists, list existing environments first, because an unchecked `azd up` can silently spin up a new Container Apps environment named something like `deployment-prod`, stretching the deploy and drifting state. And set every environment variable before `azd up`, not during error recovery. For azd + Terraform there is a sixth: run the grep check for Go-style `{{ .Env.VAR }}` templates, which must be `${VAR}` syntax, or deployment dies on unresolved variables.

The checklist's own mistakes table is worth quoting, since each row pairs a common failure with its fix. `azd up --location eastus2` fails where `azd env set AZURE_LOCATION eastus2` succeeds; `azd up` with no environment fails where `azd env new` comes first; assuming a location without checking the RG fails where `az group show` comes before; skipping the Container Apps environment check fails where `az containerapp env list` runs pre-deploy.

## The AcrPull Gate: Why Container Apps Time Out for 900 Seconds

The sharpest finding in the reference set is the RBAC propagation gate. Container Apps that pull images from ACR using a managed identity must follow a two-phase flow: provision first with a public placeholder image (`mcr.microsoft.com/azuredocs/containerapps-helloworld:latest`), wait for the `AcrPull` role assignment to propagate, then deploy the real image. Skip the gate and the revision times out around 900 seconds waiting for image-pull permission — Azure RBAC propagation delay, documented in the checklist as a known behavior. The two paths differ in mechanics but share the gate:

| Phase | Path A — Bicep (azd) | Path B — Terraform (CLI) |
|-------|----------------------|--------------------------|
| 1. Provision | `azd provision` | `terraform apply` (placeholder image, no `registry` block) |
| 2. Gate | Poll role assignment for `AcrPull` (up to 5 min) | Same polling loop |
| 3. Deploy | `azd deploy --no-prompt` | `az acr build` → `az containerapp registry set` → `az containerapp update` |

Note the command that must not appear: `azd up`. It combines provisioning and deployment, which skips the propagation gate entirely. Path A runs `azd provision`, checks the role, then `azd deploy --no-prompt`. Path B builds and pushes the real image with `az acr build`, links it to the Container App's system-assigned identity with `az containerapp registry set --identity system`, and switches the revision with `az containerapp update --image <acr>/<image>:<tag>`.

## What the Error Recovery Actually Fixes

The troubleshooting reference reads like a logbook of real-world failures. `language: html` and `language: static` are not valid values for azd — omit the language field for static web apps, and the valid values are `python`, `js`, `ts`, `java`, `dotnet`, `go`. Static Web Apps path config has its own table: framework in root wants `project: .` with `dist: dist|build|out`, but `project: .` forbids `dist: .`, so pure static files go in a `public/` folder with `dist: public`. The "resource not found" error surfaces when infrastructure lacks the tag azd uses to link services: a Bicep block missing `tags: union(tags, { 'azd-service-name': 'web' })` produces `unable to find a resource tagged with 'azd-service-name: web'`. The fix is to add the tag and re-run `azd provision`. `LocationNotAvailableForResourceType` for Static Web Apps means the region is unsupported — the reference lists `westus2`, `centralus`, `eastus2`, `westeurope`, and `eastasia`. Missing infrastructure parameters surface as interactive prompts; the fix is `azd env set STORAGE_SKU <value>` or a mapping added to `infra/main.parameters.json`. Live role verification caps the run: after deploy, the skill queries Azure to confirm the provisioned RBAC roles actually exist and suffice, then reports endpoints with the `https://` scheme.

## When to Use It

The pack numbers tell the chain's story: azure-deploy 565,378 installs on 2026-09-06 against azure-prepare 565,497 and azure-validate 564,844, with near-identical weekly curves peaking around 17.3K and settling near 13.6K. That is the same pack-level counter signature this site documented for [azure-enterprise-infra-planner](/skills/automation/azure-enterprise-infra-planner/). Use this skill exactly when the runbook matches your state: prepared app, `azure.yaml` and `infra/` present, validation passed. Install it with `npx skills add https://github.com/microsoft/azure-skills --skill azure-deploy`. For the planning side that produces the plan file this skill refuses to deploy without, see the [azure-prepare skill intro](/skills/automation/azure-prepare/).