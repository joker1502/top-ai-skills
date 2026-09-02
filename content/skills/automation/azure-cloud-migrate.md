---
title: "azure-cloud-migrate: Microsoft's 8-Scenario Migration Skill"
date: 2026-09-02
draft: false
tags:
  - Azure
  - Cloud Migration
  - Container Apps
description: "Inside Microsoft's azure-cloud-migrate skill (491K installs, #67): an 8-scenario router that assesses and converts Lambda, Kubernetes, and Spring Boot apps."
version: "1.3.2"
author: "Microsoft"
repo_url: "https://github.com/microsoft/azure-skills"
install_cmd: "npx skills add https://github.com/microsoft/azure-skills --skill azure-cloud-migrate"
compatibility:
  - Claude Code
  - Cursor
  - GitHub Copilot
category: "automation"
rating: 4.5
github_stars: 1442
github_forks: 241
installs: 491400
last_updated: "2026-09-02"
ai_friendliness:
  score: 4.5
  documentation: 4.5
  setup: 4.0
  config: 4.0
---

Migrate a Lambda function to Azure and most agents start rewriting handler code from memory. Microsoft's azure-cloud-migrate skill does the opposite: it demands an assessment report *before* any code conversion, then routes you into one of eight scenario-specific guides. I read the current SKILL.md (v1.3.2, MIT) plus the full 37-file reference tree — three service families, per-runtime migration rules, and a progress-tracking convention — then pulled install numbers from the skills.sh leaderboard on 2026-09-02.

## Eight Scenarios, One Sequential Router

The skill covers exactly eight source-to-target pairs, each with its own reference file: AWS Lambda → Azure Functions, Elastic Beanstalk → App Service, Heroku → App Service, Google App Engine → App Service, Fargate → Container Apps, GKE/EKS/self-hosted Kubernetes → Container Apps, Cloud Run → Container Apps, and Spring Boot → Container Apps. The SKILL.md is a router, not a tutorial — it picks the scenario file and enforces three rules on every run: follow phases sequentially, generate the assessment before migrating anything, and use the latest supported runtime for the target service.

The output convention is unusual. Everything lands in `<workspace-root-basename>-azure/` at the workspace root — the skill uses the top-level directory's own name, not a subdirectory — and it repeats the rule in bold: never modify the source directory. A `migration-status.md` file inside the output directory tracks phases with literal emoji states (⬜ Not Started → 🔄 In Progress → ✅ Complete → ❌ Failed), and the agent must update it as it works. The flow ends with an explicit ask — "Migration complete. Test locally or deploy to Azure?" — before handing off to the azure-prepare skill for infrastructure and deployment.

## The Service-Discovery Audit Most Migrations Skip

Rule 8 is the sharpest detail in the file. Kubernetes DNS names like `http://order-service:3001` do not resolve inside Container Apps, and the skill makes the agent audit application code for hardcoded hostnames and ports during assessment, flagging each one for env-var-driven URL injection. That is a real failure mode: a K8s workload that worked fine in-cluster silently breaks after migration because internal service names die with the cluster.

The K8s assessment guide backs it up with a compatibility matrix that separates blockers from tolerable losses. StatefulSets, DaemonSets, custom CRDs, and node/host networking are hard "no" — state has to move to Cosmos DB or SQL, DaemonSets become sidecars or external agents. The limits table is honest about the ceiling: 4 vCPU and 8 GiB per container (versus 64+ and 256+ in typical clusters), 300 replicas per revision, and a 240-second default request timeout that forces long-running requests to be redesigned. The guide writes the assessment to `k8s-migration-assessment.md` with an executive summary, workload inventory, and a Low/Medium/High complexity verdict before any conversion starts.

## Where the Reference Depth Pays Off

The Lambda → Functions guide contains traps that only appear when someone actually ran these migrations. On Flex Consumption, a blob trigger with `source: 'EventGrid'` needs three infrastructure requirements handled *before* deploy, or the trigger fails silently: an `alwaysReady` instance so the blob extension is running to create its own Event Grid subscription (a chicken-and-egg problem), the storage queue endpoint enabled because the extension uses queues for poison-message tracking, and the Event Grid subscription declared in Bicep rather than created via CLI — the CLI's webhook validation handshake times out on cold start with "response code Unknown". The guide even names the exact constructor error you hit without the queue endpoint.

The same file pins two other gotchas: `DefaultAzureCredential()` without arguments tries SystemAssigned first and fails under a user-assigned identity, so you must pass `managedIdentityClientId`; and the Computer Vision package `@azure-rest/ai-vision-image-analysis` is still beta — the `^1.0.0` semver does not resolve, so pin `1.0.0-beta.3` explicitly. Rekognition returns relative 0-1 coordinates; Azure returns pixels, and the guide includes the sharp conversion snippet to reconcile them.

## How It Sits in the Pack

azure-cloud-migrate is the pack's planner: it assesses and converts before deployment, then hands off to azure-prepare. That puts it opposite [azure-compute](/skills/automation/azure-compute/) (sizing and creation) and [azure-diagnostics](/skills/automation/azure-diagnostics/) (fixing what already exists) — migrate thinks about workloads landing *in* Azure, never about operating them afterward.

The numbers tell the same pack story the other intros documented. My 2026-09-02 scrape puts azure-cloud-migrate at #67 with 491.4K installs and weekly [15,802 → 17,019 peak → 13,686], a curve that matches azure-messaging (547.3K), azure-diagnostics, and azure-compute (501.3K) wave for wave — the same pack-level counter wearing different labels. First seen on skills.sh: 2026-02-28. The star count moved (1,442, pushed 2026-09-02), confirming the repo is actively maintained, but the leaderboard total stays a pack counter, not a per-skill signal.

## When to Add This Skill

If you manage any cross-cloud estate — Lambda stacks, Heroku apps, or Kubernetes clusters that need to land in Azure — this skill replaces memory-based porting with a documented assessment-first pipeline. Run `npx skills add https://github.com/microsoft/azure-skills --skill azure-cloud-migrate` to install the router alone, and keep azure-prepare from the same pack wired in, since the workflow ends by handing off to it. Try it on a small stateless service first: let the agent write the assessment report before it touches a single line of code, and check whether the service-discovery audit finds the hostname you forgot was hardcoded.