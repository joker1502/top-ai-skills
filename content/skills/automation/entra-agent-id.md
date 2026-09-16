---
title: "entra-agent-id: One Azure Identity Per AI Agent Instance"
date: 2026-09-16
draft: false
tags:
  - Azure
  - Entra ID
  - AI Agents
category: "automation"
description: "Microsoft's entra-agent-id skill gives each agent instance its own Entra identity via Blueprint, BlueprintPrincipal, and the two-step fmi_path token exchange."
---

Most AI agents on Azure still share one service principal. Every instance logs in as "the bot," writes to the same mailbox, and leaves no way to tell which run did the damage. Microsoft's entra-agent-id skill (v1.1.1, MIT) kills that pattern: it provisions a distinct Entra identity per agent instance, each with its own `sub` claim, its own permission grants, and its own audit trail. I read the SKILL.md and its runtime-token-exchange.md reference in full, then pulled skills.sh on 2026-09-16: rank 189, 305,269 all-time installs, weekly curve off a 16,986 peak down to 12,678.

## Three Objects, and One That Isn't Auto-Created

The object model has three layers. **Agent Identity Blueprint** is an application that defines a type of agent. **BlueprintPrincipal** is its service principal. **Agent Identity** is a service-principal-only identity for a single instance — agent-1, agent-2, agent-3, each its own SP.

The trap hides at layer two, and the skill's best-practice list puts it first for a reason. Creating a Blueprint does NOT create its service principal. Skip the explicit BlueprintPrincipal POST and provisioning dies with `400: The Agent Blueprint Principal for the Agent Blueprint does not exist`. Real-world fix: make the script idempotent — always check for the BlueprintPrincipal even when the Blueprint already exists.

Sponsors behave differently per layer, which catches people too. Blueprint creation requires a **User** as sponsor. Agent Identities accept **Users or Groups**. Both go in via `sponsors@odata.bind` bind syntax, so a copy-pasted Blueprint snippet breaks at the Agent Identity step.

## The fmi_path Exchange: Two Steps, Both With /.default

Runtime auth is a two-step token exchange against the standard Entra token endpoint. It works in Azure, on-prem, and local dev — not just inside Foundry. Step 1 sends Blueprint credentials plus `fmi_path` and gets back a parent token with `aud: api://AzureADTokenExchange`. Step 2 presents that parent token as a `client_assertion` and receives the Graph token that actually does work.

The `fmi_path` parameter is the Agent Identity's **appId**, not its SP object ID, and it's what makes per-instance audit possible: the final Graph token carries `sub = <that Agent Identity's appId>`. Each agent run leaves its own fingerprint instead of blending into one shared principal.

Three mistakes dominate the troubleshooting table:

- **RFC 8693 token-exchange grant** → `AADSTS82001`. Use `client_credentials` with `fmi_path`, not `urn:ietf:params:oauth:grant-type:token-exchange`.
- **Individual scopes** like `User.Read Mail.Send` at either step → `AADSTS65001`. Both steps take `/.default` only.
- **OBO user token aimed at Graph** → `AADSTS50013`. The user token must target the Blueprint as its audience: `api://{blueprint_app_id}/access_as_user`.

Cross-tenant flows have their own rule: **step 1 targets the Agent Identity's home tenant, not the Blueprint's.** Point it at the Blueprint's tenant and step 2 dies with `AADSTS700211: No matching federated identity record found`.

## Credentials Live on the Blueprint, Not the Agent

Agent Identities cannot hold credentials. Try to attach one and Graph returns `PropertyNotCompatibleWithAgentIdentity`. All secrets, certs, and federated identity credentials sit on the Blueprint; every agent instance beneath it authenticates through them.

Production prefers **Managed Identity + Workload Identity Federation** (FIC on the Blueprint), which removes static secrets entirely. Local dev and tests use a client secret. For the MI path, the managed identity acquires a token for `api://AzureADTokenExchange` first, then presents it as `client_assertion` in step 1 — the parent token stays an intermediate either way.

One rule the SKILL.md states in bold: **`DefaultAzureCredential` is not supported.** Azure CLI tokens carry `Directory.AccessAsUser.All`, which Agent Identity APIs hard-reject with 403. Standard Entra identity skills tell you to reach for DefaultAzureCredential; this one tells you to register a dedicated app with `client_credentials`, or `Connect-MgGraph` with explicit delegated scopes like `AgentIdentityBlueprint.Create`.

## Permission Grants Are Per Instance, Not Per Blueprint

Grants scope to individual Agent Identities. Autonomous agents get application permissions via `appRoleAssignments`; OBO agents get delegated grants via `oauth2PermissionGrants` with `consentType: AllPrincipals`. The reference is blunt: browser-based admin consent URLs do not work for Agent Identities — programmatic `oauth2PermissionGrants` is the path.

Permissions need required Entra roles — Agent Identity Developer, Agent Identity Administrator, or Application Administrator — and application permissions need `az ad app permission admin-consent`. After consent, new claims can take 30–120 seconds to land; the skill says retry with exponential backoff instead of assuming failure.

Real talk on .NET: `Microsoft.Identity.Web.AgentIdentities` wraps both the FIC management and the two-step exchange, so C# services skip the raw HTTP. Polyglot teams (Python, Node, Go, Java) run the Entra SDK for AgentID sidecar container — keep it on localhost and never behind a LoadBalancer or Ingress, per its own security guidance.

## Where It Stops

The DO NOT USE FOR list keeps the skill honest. Standard app registration with redirect URIs, scopes, and user sign-in? That's [entra-app-registration](/skills/automation/entra-app-registration/)'s job — the two skills route cleanly instead of overlapping. Foundry agent authoring goes to microsoft-foundry. entra-agent-id handles one thing: provisioning OAuth-capable identities for agents and exchanging tokens on their behalf.

## Give One Agent Its Own Identity

Install it with `npx skills add https://github.com/microsoft/azure-skills --skill entra-agent-id`, then ask your agent to provision one Blueprint, one BlueprintPrincipal, and two Agent Identities, and exchange tokens with `fmi_path`. Watch whether it posts to the typed endpoints (`/applications/microsoft.graph.agentIdentityBlueprint`, not raw `/applications`), whether it creates the principal without prompting, and whether it uses `/.default` in both steps. Those three checks separate a setup that works from one that 400s an hour later. Put the result behind an [azure-validate](/skills/automation/azure-validate/) pass before anything production touches that mailbox.