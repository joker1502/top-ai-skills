---
title: "azure-rbac: The 485K-Install Azure Skill That Left Its Repo"
date: 2026-08-26
draft: false
tags:
  - Azure
  - RBAC
  - Cloud Security
description: "Azure's azure-rbac skill hit #62 with 485,620 installs, then got removed from its repo in July 2026. What it did, and where the RBAC guidance went."
version: "1.1.1"
author: "Microsoft"
repo_url: "https://github.com/microsoft/azure-skills"
install_cmd: "npx skills add https://github.com/microsoft/azure-skills --skill azure-rbac"
compatibility:
  - Claude Code
  - Cursor
  - GitHub Copilot
category: "automation"
rating: 4.0
github_stars: 1412
github_forks: 238
installs: 485620
last_updated: "2026-08-26"
ai_friendliness:
  score: 4.5
  documentation: 4.5
  setup: 4.0
  config: 4.0
---

Microsoft's azure-rbac skill still sits at #62 on the skills.sh leaderboard with 485,620 installs — and its SKILL.md no longer exists in the [microsoft/azure-skills](https://github.com/microsoft/azure-skills) repo. I checked the file's history on 2026-08-26: a plugin sync (commit `6f4ff3f2`, "#162 Sync plugin files from GitHub-Copilot-for-Azure", 2026-07-17) deleted `skills/azure-rbac/SKILL.md` from main. The raw URL returns a 404 today, yet the leaderboard's weekly counter kept ticking for eight more weeks. Here's what the skill did while it lived, and where its guidance ended up.

## What azure-rbac Actually Did

The last published version (1.1.1, MIT, 1,686 bytes) chained four MCP-backed tools into a fixed pipeline. Query `azure__documentation` for the minimal built-in role whose permissions match what the user wants to grant. If no built-in role fits, hand `azure__extension_cli_generate` a custom role definition. Then generate the CLI commands to assign the role. Finally, pull `azure__bicepschema` and `azure__get_azure_bestpractices` together to emit a Bicep snippet for the same assignment.

Its trigger list reads like the actual questions people type at work: "role to read blobs", "role for managed identity", "custom role definition", "what role do I need to grant access", "bicep for role assignment". The whole skill fit in less than two printed pages, which is the pattern across Microsoft's official skills — a tight instruction body that leans on the `azure__*` tool suite rather than duplicating Azure docs.

## The Least-Privilege Rule It Enforced

The one hard gate sat at the end. To assign roles to an identity, you need a role carrying `Microsoft.Authorization/roleAssignments/write` — and the skill named exactly three: **User Access Administrator** (least privilege, recommended when all you do is grant), **Owner** (full access, justified only when that's the point), or a **custom role** scoped to that single permission. Grant-only work should never ride on Owner.

That discipline survived the purge. The repo's current reference file `skills/azure-app-onboard/scaffold/references/rbac-roles.md` — loaded by the onboarding patterns — keeps the same doctrine plus the mechanics: deterministic `guid()` naming for reproducible assignments, `principalType: 'ServicePrincipal'` to skip Azure AD graph lookup delays, and a table of role GUIDs for common pairs (AcrPull `7f951dda-…`, Key Vault Secrets User `4633458b-…`, Storage Blob Data Reader `2a2b9908-…`, Cognitive Services OpenAI User `5e0bd9bd-…`, plus Service Bus, Event Hubs, SignalR, and App Configuration entries).

## Where the Repo Sent It

Real talk: the leaderboard is a rearview mirror. skills.sh (checked 2026-08-26) still lists azure-rbac as official at #62, but its weekly installs slope hard downward — 11,820 → 15,863 → 15,682 → 9,640 → 5,611 → 4,296 → 3,111 → 2,600. Nobody is finding it fresh; the count rides on saved configs and old tutorials that still reference the name. The July sync deleted it from both `skills/` and the `.github/plugins/azure-skills/` mirror, so any fresh install attempt hits the 404 I found.

The guidance dispersed into two living files instead. `skills/microsoft-foundry/rbac/rbac.md` covers Foundry resource permissions — user roles, managed identity, service principals for CI/CD — with the Foundry role ladder (Agent Consumer → User → Project Manager → Account Owner → Owner). The `rbac-roles.md` reference above covers the generic app-to-resource pairs. If you're assigning a blob-reader or Key Vault reader role for an app today, the lookup table is still in the repo; only the convenience wrapper skill is gone.

## What to Use Instead

| Need | Replace azure-rbac with | Why |
|:-----|:------------------------|:----|
| App onboarding + role GUIDs | `azure-app-onboard` | Ships the `rbac-roles.md` reference inside its scaffold |
| Identity / Entra setup | `entra-agent-id`, `entra-app-registration` | The two identity skills the repo kept and updated |
| Foundry workspace permissions | `microsoft-foundry` | Has its own RBAC reference for users, MI, and SPs |
| Any AI-driveable Azure work | `azure-ai` | The broad skill that survived and still gets monthly updates |

None of these are drop-in replacements for the deleted four-step pipeline, and that's the honest answer: the pipeline itself is gone. What endures is the least-privilege rule and the GUID table, both readable directly from the repo.

## Bottom Line

Treat any marketplace listing that still shows azure-rbac as stale — the file is 404 on main, and the install count is a delayed echo, not demand. If you came here for "which role lets my app read blobs", the answer is Storage Blob Data Reader (`2a2b9908-6ea1-4ae2-8e65-a410df84e7d1`), and the full table lives in `azure-app-onboard`'s scaffold. Pull that reference straight from the repo instead of installing a dead skill. To see how Microsoft's surviving skills are wired, read the [azure-ai intro](/skills/automation/azure-ai/); if workspace permissions are your actual problem, the [microsoft-foundry intro](/skills/automation/microsoft-foundry/) covers the role ladder that replaced this skill in practice.