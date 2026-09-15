---
title: "App Onboard Roundup: Newcomers With Independent Counters"
date: 2026-09-15
toc: true
draft: false
tags:
  - Azure
  - Agent Skills
  - DevOps
category: "guides"
description: "azure-app-onboard and azure-app-onboard-prereq (99K each) are the only azure-skills records with independent install counters and a 10-step read-only pipeline"
keywords:
  - azure-app-onboard
  - azure-app-onboard-prereq
  - azure-skills
  - agent skills
---

Every skill in the [microsoft/azure-skills](https://github.com/microsoft/azure-skills) pack shares one install counter — I've documented that lockstep signature across azure-diagnostics, azure-prepare, azure-validate and the rest. Two records break the rule. azure-app-onboard (99,443 installs, rank 328) and azure-app-onboard-prereq (99,345, rank 329) are the pack's only newcomers tracking their own numbers, and unlike the veterans at ~578K they reached four-digit weekly installs only about a month ago. I read both SKILL.md files plus five reference files — pipeline-rules, approval-gates, build-check, zero-code-path, cloud-sdk-migration — and pulled the full leaderboard on 2026-09-15. Together they form the pack's end-to-end onboarding arm.

## The Pair: Orchestrator and Gate

azure-app-onboard (v1.2.3) is an orchestrator: a ten-step pipeline from empty workspace to deployed resources. Step 1 opens a session and checks Azure login, step 2 triages scope, step 3 hands off to the prereq skill, steps 4-7 gather intent, plan architecture, and scaffold IaC behind an approval gate, steps 8-9 gate and run the deployment, step 10 hands off with cleanup commands. The SKILL.md opens with a rule in bold: every repo goes through the full pipeline, no exceptions, no skipping, no short-circuiting on recognition. Its sibling azure-app-onboard-prereq (v1.2.2) is phase 1 of that pipeline: a read-only evaluation that decides whether your source code is deployable before anyone writes a line of infrastructure.

The weekly curves show the newborn signature I flagged in the [azure-skills pack health roundup](/tutorials/guides/azure-skills-pack-health-roundup-2026/): zero four-digit weeks, then 2,489 → 14,370 → 14,828 in the first three weeks, settling into the 11.5-13K band — the same rhythm the veterans ride, minus the century of accumulated installs. Their last-week numbers (12,376 and 12,373, a gap of three) match the bundles you get from a coordinated registry entry, not from organic discovery.

## The Pipeline That Never Calls azure-deploy

Here's the counterintuitive part: this orchestrator is banned from using the pack's own deployment skill. The SKILL.md is explicit — NEVER invoke `{"skill": "azure-deploy"}`. That skill belongs to a different workflow entirely. AppOnboard deploys through direct CLI: `az deployment sub create` with Bicep, or `terraform apply`, and it must never generate an `azure.yaml` or run `azd up`, `azd provision`, or `azd deploy`. The scaffold phase writes the IaC, a deploy-checklist file lands in the session folder, and only then does the pipeline execute.

The rules file layers on more constraints than any other pack skill I've audited. Writing anything to disk before the user says "Yes" to the scaffold gate is forbidden — no exceptions for trivial apps or free tiers. Modifying IaC the pipeline didn't generate requires separate per-file approval. Phase transitions demand re-reading the next phase's sub-SKILL.md before the first command executes, and after any context compaction the agent must re-read the current phase file plus pipeline-rules and check which artifacts exist on disk. Sessions live in `.copilot-azure/sessions/{uuid}/`, are immutable once the active session moves on, and non-active sessions expire after seven days.

## The Prereq Gate That Refuses to Run Your Build

Real talk: azure-app-onboard-prereq is the most disciplined read-only checker I've seen in this pack, because its first rule is what it will not do. The ABSOLUTE PROHIBITION section bans `npm install`, `npm test`, `npx jest`, `pip install`, `pytest`, `dotnet build`, `dotnet restore`, `go mod download`, `cargo build`, and every package-manager install, build, or test command — the entire prereq phase is static-only evaluation. No test suites, no builds; it cross-checks imports against the dependency manifest instead. The only sanctioned exception is code the agent itself wrote via the zero-code path, and even that requires a specific per-command consent prompt — general prior consent never counts.

The static checks bite where real failures live. It scans source files for imports absent from the manifest (`MODULE_NOT_FOUND` waiting at runtime), flags a missing `main` script, and fails projects pinning dependencies five-plus years old when the ecosystem removed those APIs — the reference names `werkzeug.contrib.*` and `flask.ext.*` explicitly. A cloud SDK early gate greps for `aws-sdk`, `boto3`, `google-cloud`, or `firebase` in functional deps; hit it and the pipeline offers a redirect to azure-cloud-migrate, because planning infrastructure for code that still talks to another cloud is a trap. The evaluation writes a `prereq-output.json` with per-component PASS/WARN/FAIL verdicts, records the `lastScanCommit` SHA as a staleness guard for resumed sessions, and a six-row routing table decides who takes over — the orchestrator, azure-prepare, azure-cloud-migrate, or nobody.

## Two Gates, Never Merged

The approval design deserves its own paragraph. The pipeline enforces two separate gates — scaffold approval and deploy approval — and forbids merging them into one "can I just deploy it" prompt. The scaffold gate authorizes IaC generation only; after it passes, the agent must surface the validation summary and present the deploy gate as a separate response: "🚀 Ready to deploy? (Yes / Run manually / Edit plan / Cancel)". Both gates must show subscription (name and ID), resource group, and region as standalone lines, so the user approves the where, not just the what. Skip the second gate and deploy anyway — that's the exact bad pattern the rules file documents.

For a pack that mostly routes between skills, this pair is the rare vertical: one skill that owns an entire idea-to-production journey and refuses to delegate the parts it can do itself. The rbac role guidance that survived the azure-rbac removal lives in `azure-app-onboard/scaffold/references/rbac-roles.md`, which is why the [azure-rbac intro](/skills/automation/azure-rbac/) still matters as a map. If you want the deployment side of the chain rather than the onboarding side, [azure-deploy procedural](/tutorials/guides/azure-deploy-procedural/) covers the three-gate runbook for infrastructure that already exists.

## Where the Pair Fits

Install azure-app-onboard-prereq first and point it at a messy repo — it will give you a verdict sheet with zero packages installed on your machine, which is the quiet superpower. Then let azure-app-onboard run the full ten steps on a scratch project and watch the two gates actually stop the agent. The independent counters make this the only azure-skills record you can track by its own signal: if the weekly curve keeps its 11-13K band, the onboarding arm is still shipping; if it crashes toward zero like the removed skills did, that's the tell. Pick one small repo, run the pair once, and judge them on whether the pipeline stops where you would have wanted to stop it.