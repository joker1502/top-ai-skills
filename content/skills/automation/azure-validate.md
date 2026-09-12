---
title: "azure-validate: The Gatekeeper Skill for Azure Deployments"
date: 2026-09-12
draft: false
tags:
  - Azure
  - DevOps
  - Azure Developer CLI
category: "automation"
description: "azure-validate (576K installs) runs nine validation gates before deployment, enforces data-plane RBAC checks, and alone may mark a plan Validated."
---

Most Azure failures surface at deploy time, when they cost hours. Microsoft's azure-validate skill (v1.2.2) exists to move that discovery earlier — it runs nine validation gates against your plan, your infrastructure code, and your role assignments before anything ships. I read the full SKILL.md, the workflow script, the role-verification reference, and the azd recipe in [microsoft/azure-skills](https://github.com/microsoft/azure-skills). The 2026-09-12 skills.sh scrape put it at 576,757 installs, rank 24. The deploy trio — azure-prepare 577,556, azure-deploy 577,309, azure-validate 576,757 — each grew by roughly 12,000 installs in the six days since our last scrape, gaps between them barely moving.

## Validation Runs as a State Machine, Not a Checklist

Azure-validate refuses to start unless azure-prepare already finished. Its prerequisite check demands `.azure/deployment-plan.md` exists with status `Approved` or later; missing plan means STOP and invoke azure-prepare first. The SKILL.md then routes through `references/scripts/workflow.sh`, which behaves like a tiny state machine. First run: `bash references/scripts/workflow.sh --workspace-path <path>`. The script prints one action, and you do it, then re-run with `--completed-step <step>`. Each loop writes progress to `.azure/validate-status.json` and returns the next step name to pass back. Nine steps in order: LoadPlan, AddValidationSteps, RunValidation, BuildVerification, StaticRoleVerification, RecordProof, ResolveErrors, UpdateStatus. The loop ends only when the script reports the workflow complete.

The status write is the interesting part. The skill declares itself the officially verified way to set the plan status to `Validated` — no other skill may do it. Azure-deploy is explicitly forbidden from touching that status; I documented that rule in the [azure-deploy procedural guide](/tutorials/guides/azure-deploy-procedural/). An agent that skips the loop and edits the status to `Validated` by hand is violating the contract the entire chain depends on.

## The RBAC Trap: Contributor Cannot Read Blobs

Step five, Static Role Verification, is a code review of role assignments — not a query against live Azure. The reference table maps service operations to their required roles and lists the common mistakes. Read blobs needs Storage Blob Data Reader; its sibling Data Contributor covers reads plus writes. SAS generation via user delegation needs Storage Blob Delegator *and* a data role, and teams forget the Delegator half. Key Vault secrets want Key Vault Secrets User, not Key Vault Reader, which grants no secret access. Cosmos DB reads and writes go through Cosmos DB Built-in Data Contributor, Service Bus sends through Azure Service Bus Data Sender, and queue reads through Storage Queue Data Reader — a blob role does not cover queues.

The warning the skill repeats: generic management-plane roles carry no data access. Contributor on a storage account cannot read a single blob. That is the most common RBAC mistake in the file, and it fails at runtime with cryptic auth errors, not at provisioning. The review itself is mechanical — search Bicep for `Microsoft.Authorization/roleAssignments` or Terraform for `azurerm_role_assignment`, then verify each identity has a role whose scope matches its data operations. Live role verification against provisioned resources happens later, as step 8 of azure-deploy, not here.

## Twelve Checks for azd Projects — and the Error You Must Not Fix

For Azure Developer CLI projects, the [azure-prepare](/skills/automation/azure-prepare/) recipe runs twelve named checks: azd version, schema validation of azure.yaml, environment setup, `azd auth login --check-status`, `azd env get-values` for subscription and location, and a provision preview via `azd provision --preview --no-prompt`, which handles both Bicep and Terraform by detecting the provider. Build verification comes next, then a Docker build-context check with a real trap: if a service's Dockerfile runs `npm ci`, a missing `package-lock.json` in that directory kills the build later — the recipe generates one with `npm install --package-lock-only`. Packaging (`azd package --no-prompt`) and Azure Policy validation round out the list, with .NET Aspire projects getting extra pre- and post-provisioning checks.

One error demands attention: `unsupported resource type` from the provision preview. The recipe orders you to stop immediately and not fix it — no `.ExcludeFromManifest()` workaround, no source edits. The AppHost contains custom resource types with no Azure deployment target; the app is designed for local development, and suppressing the error produces a deployment that does not represent the application. Record the blocker and inform the user. It is one of the few places where the skill bans a workaround outright.

## Who Owns Which Gate

The three-skill chain splits responsibility cleanly. Azure-prepare writes the plan and walks the status ladder from Planning to Deployed. Azure-validate proves the plan: every check passes, proof lands in Section 7, status flips to `Validated`. Azure-deploy then executes the ten-step runbook and reports fully-qualified HTTPS URLs. After all checks pass, one decision remains — if the user explicitly asked to deploy, invoke azure-deploy and never run `azd up` yourself; if they only asked to validate, stop after setting `Validated` and report results. Destructive actions anywhere in the chain require `ask_user` confirmation per the pack's global rules.

Validation proof is the deliverable that matters. Fill Section 7 with the commands you ran and their output, because that section is what azure-deploy checks before it executes anything. If your next deployment keeps failing at the last minute, run the workflow script once before blaming Azure — the state machine will tell you exactly which gate you skipped.

*Covered alongside: [azure-prepare — plan-first deployment](/skills/automation/azure-prepare/), [azure-deploy — the 10-step runbook](/tutorials/guides/azure-deploy-procedural/).*