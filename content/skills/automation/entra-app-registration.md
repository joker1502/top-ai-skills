---
title: "entra-app-registration: OAuth Setup Without Portal Spelunking"
date: 2026-09-15
draft: false
tags:
  - Azure
  - Entra ID
  - OAuth
category: "automation"
description: "entra-app-registration (v1.2.1, 581K installs) turns Entra ID app setup into a five-step CLI workflow with real Graph permission GUIDs baked in."
---

Most Azure tutorials describe app registration as "five clicks in the portal" and leave you guessing which Graph permission GUID goes where. Microsoft's entra-app-registration skill (v1.2.1, MIT) does the opposite: its SKILL.md is a router, and its reference files carry the full CLI grammar — sign-in audiences, permission GUIDs, credential reset warnings — that agents (and humans) actually need. I read the SKILL.md plus cli-commands.md and oauth-flows.md in full, then scraped skills.sh on 2026-09-15: the skill ranks 52 with 581,057 installs, riding the same pack-wide curve as its siblings.

## Five Steps, One Router

The SKILL.md is 8.2KB of routing logic, not a lecture. Every request lands on one five-step workflow — register the app, configure authentication, add API permissions, create client credentials, implement the OAuth flow — and each step points at a dedicated reference file. Registering routes to cli-commands.md with both portal and IaC methods; permissions route to api-permissions.md; the OAuth implementation routes to oauth-flows.md and a console-app-example.md. The skill explicitly nudges you toward Bicep or Terraform when you already manage infrastructure as code, because a registered app in YAML keeps audit history that a portal click never does.

The app-type branching matters more than it looks. Web apps get `--web-redirect-uris`, SPAs get `--spa-redirect-uris`, desktop and mobile apps use `--public-client-redirect-uris`, and services need no redirect URI at all. Mix those up and Entra rejects your callback with a redirect_uri-mismatch error that surfaces only after your users have already hit the login page. The sign-in audience flag (`AzureADMyOrg` vs `AzureADMultipleOrgs` vs `AzureADandPersonalMicrosoftAccount`) controls tenant reach in one switch.

## The Permission GUIDs You Stop Memorizing

The cli-commands.md file is where this skill pays for itself. It carries the Graph resource ID (`00000003-0000-0000-c000-000000000000`) next to the exact permission GUIDs you'd otherwise copy from the portal one at a time: User.Read is `e1fe6dd8-ba31-4d61-89e7-88639da4683d`, Mail.Read is `570282fd-fa5c-430d-a7fd-fc8dc98a9dca`, Mail.Send is `e383f46e-2787-4529-855e-0e479a3ffac0`, Directory.Read.All is `7ab1d382-f21e-4acd-a863-ba3e13f7da61`. Each entry also marks its type — `Scope` for delegated permissions, `Role` for application permissions — because passing the wrong suffix makes `az ad app permission add` fail silently or grant more than you asked for.

It also flags the consent trap: application permissions and some delegated ones require `az ad app permission admin-consent` before they take effect. A daemon that "doesn't work" is usually a `User.Read.All` grant sitting in unattended-consent limbo. The full script example in the file chains create → permission add → admin consent → service principal in one shot, which is a working order most docs never write down.

## The Credential Reset Trap

Real talk: the section on client credentials reads like a disaster list, because every warning is a real incident. `az ad app credential reset` **deletes all existing credentials** — the reference file says it outright in bold. Run it on an app that already has a working secret and you've just rotated everyone out, not added a fresh one. The secret value prints exactly once and then disappears; the file instructs you to store it in Key Vault on the spot. For production the skill pushes certificates over secrets (`--cert "@path/to/cert.pem"`), and it names federated identity credentials as the third option for workloads that authenticate dynamically — useful when you're swapping a static secret for a workload identity that needs no rotation at all.

## Why the References Beat the Portal

The oauth-flows.md file walks four flows with concrete endpoints: authorization code with PKCE, client credentials, device code, and refresh. The PKCE section spells out the code-verifier length (43–128 characters) and the S256 challenge method, which is the flow every SPA should use but many textbook examples skip. The device-code flow shows the `https://microsoft.com/devicelogin` loop with its 5-second poll interval, and the token section drops the timing that bites people: access tokens expire in about an hour while refresh tokens live 14–90 days, and every refresh returns a new refresh token — single-use, so keeping the old one breaks the chain.

The skill's real value is that the references are the full answer, not a pointer to Learn docs. You don't open three browser tabs to combine `az ad app create`, the Graph resource ID, and the permission suffix table — the files already sit next to each other. For the surrounding deployment chain, the [azure-storage procedural guide](/tutorials/guides/azure-storage-procedural/) covers the storage piece, and [azure-validate](/skills/automation/azure-validate/) enforces that whatever you register actually gets verified before release.

## Set Up Your First Registration From the CLI

Install the skill with `npx skills add https://github.com/microsoft/azure-skills --skill entra-app-registration`, then ask your agent to register a small web app with User.Read and walk through the OAuth flow. Watch whether it hands you the exact GUIDs and the `Scope` suffix without you prompting — that's the difference between a tutorial that explains auth and a skill that can actually do it. Start with a throwaway app; the credential-reset warning is a lot easier to respect when nothing production depends on the secret.