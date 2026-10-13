---
title: "google-agents-cli-deploy: Deploy ADK Agents to Cloud Run"
date: 2026-10-13
draft: false
tags:
  - Google Cloud
  - ADK
  - Deployment
category: "automation"
description: "Google's agents-cli-deploy skill ships the target matrix, the secrets-flag asymmetry, and the 403 map that eats deploy days. 492K installs since July."
---

Google ships seven skills for `agents-cli`, and `google-agents-cli-deploy` is the one that keeps your agent from deploying to the wrong target or losing a service account's IAM bindings halfway through. I read the full SKILL.md (v1.10.0, 31,388 bytes) inside [google/agents-cli](https://github.com/google/agents-cli) — 6,086 stars, last pushed 2026-10-12 — and scraped the skills.sh detail page on 2026-10-13: **492.4K installs, weekly [10,654, 12,998, 42,957, 57,879, 73,298, 132,542, 53,192, 16,184]**. Read that counter carefully. The sibling `google-agents-cli-publish` and `google-agents-cli-workflow` skills sit within 300 installs of it, which is the same pack-level counter signature we keep seeing on skills.sh — traction for the suite, not for this command set alone. What the skill actually buys you is the institutional knowledge: which target scales how, which flag means something different per target, and which 403 you will hit first.

## Agent Runtime, Cloud Run, or GKE: Decide Before You Type

The skill leads with a decision matrix rather than a step list, and the axis that matters is session state. Agent Runtime keeps sessions in the Gemini platform, and ADK wires `VertexAiSessionService` automatically. Cloud Run and GKE give you in-memory (dev only), Cloud SQL, or a managed sessions backend you configure yourself. Networking splits the same way: Agent Runtime supports VPC-SC and PSC-I through network attachments, Cloud Run gives you direct VPC egress and IAP, GKE gives you whatever Kubernetes gives you.

Sizing is where the skill earns its keep, because the defaults are coupled and most people break them one flag at a time. Defaults are `--cpu 1`, `--memory 4Gi`, `--concurrency 8`, `--min-instances 0`, `--max-instances 10`. Memory — not CPU — is the first limit: every concurrent request holds its full context window, history, RAG chunks, and response buffer while it waits on the model, so peak is roughly base + concurrency × per-request memory. Raising `--concurrency` without raising `--memory` is the number one OOM cause, and the skill says so in plain language. Its recommended scaling line for 4x throughput moves all four knobs together:

```bash
agents-cli deploy --cpu 4 --concurrency 16 --memory 16Gi --max-instances 20
```

GKE rejects every one of those sizing flags — you size through Terraform manifests and a HorizontalPodAutoscaler instead. Also worth remembering: the CLI scales to zero by default, but the generated `service.tf` pins `min_instances = 1` so production deploys skip cold starts.

## Two Gates: Eval Scores, Then Human Approval

The deploy workflow is short and unusual. If the project has no deployment target yet, enhance it first with `agents-cli scaffold enhance . --deployment-target <target>`. Then the skill demands you paste the eval scores and test results to the human and ask "Ready to deploy to dev?" — and wait for explicit approval before running anything. The SKILL.md states the rule in caps: never run `agents-cli deploy` without explicit human approval. That is a real gate, not a formality; the sibling eval skill exists so there is something concrete to paste.

Agent Runtime deploys take 5-10 minutes and will outlive your command timeout. The skill's recovery path is `--no-wait` up front or `agents-cli deploy --status` polling every 60 seconds after a cancelled run — the deployment keeps going server-side whether or not your terminal is watching. In non-interactive runs (which is every agent run), pass `--no-confirm-project` explicitly whenever you let the project resolve automatically, or the command stalls on a prompt it will never receive.

## Secrets, Service Accounts, and the 403 That Eats Your Afternoon

Deploy-time secrets look symmetric and are not. `--secrets` / `--update-secrets` takes `ENV=SECRET` or `ENV=SECRET:VERSION` pairs, and on Cloud Run the pairs are **added** to the service's existing secrets while on Agent Runtime they **replace** the agent's existing set. Give the wrong one of those and you silently drop credentials your agent still needs. Grant `secretmanager.secretAccessor` to `app_sa` for Cloud Run and GKE, but to the platform-managed `service-PROJECT_NUMBER@gcp-sa-aiplatform-re.iam.gserviceaccount.com` for Agent Runtime.

Scaffolded projects run two identities: `app_sa` per environment for the deployed agent, and `cicd_runner_sa` for the pipeline, which needs permissions in both staging and prod projects. The skill maps the common failures to their missing binding rather than leaving you with a bare 403:

| Error | Missing grant |
|-------|---------------|
| Permission denied on Cloud Run | `cicd_runner_sa` deployment role in the target project |
| Cannot act as service account | `iam.serviceAccountUser` on `app_sa` |
| Secret access denied | `secretmanager.secretAccessor` on `app_sa` |
| Cloud SQL connection failed | `roles/cloudsql.client` on the runtime SA |
| Artifact Registry read denied | Cloud Run service agent read access in the CI/CD project |

That last row is the one people miss, because the failure shows up in the pipeline, not in the agent. One more habit the skill enforces: after granting an IAM role, wait a couple of minutes instead of re-granting the same role on the retry — propagation is not instant, and stacking duplicate grants makes the audit trail useless.

## Rollback Is Asymmetric

Recovery depends entirely on the target. CI/CD projects roll back through git: fix, commit, push to `main`, and the pipeline rebuilds through staging to production. Cloud Run adds an escape hatch — list revisions and shift traffic in one command:

```bash
gcloud run services update-traffic SERVICE_NAME --to-revisions=REVISION_NAME=100 --region=REGION
```

Agent Runtime has no revision-based rollback at all. Fix the code and redeploy. GKE rolls back with `kubectl rollout undo deployment/DEPLOYMENT_NAME -n NAMESPACE`. If your team assumes "we can always flip traffic back," Agent Runtime will correct that assumption during an incident, and the skill says it flatly instead of burying it.

## Which Target, In One Line Each

Agent Runtime wins when you want managed sessions, autoscaling, and VPC-SC/PSC-I without touching Kubernetes — and it needs no `gcloud` CLI, since there is none for it. Cloud Run wins when you need IAP, direct VPC egress, request timeouts up to 3,600 seconds, or a custom frontend deployed beside the backend. GKE wins when you already run Kubernetes and want HPA/VPA behavior plus Workload Identity. Something useful either way: `--dry-run` prints the exact `gcloud` command Cloud Run would execute, so you can copy it and add flags the CLI does not expose yet — and `--image` skips the source build on Cloud Run and GKE, though Agent Runtime will not accept it.

Custom infrastructure always goes in Terraform, never `gcloud`. The skill calls that CRITICAL and only tolerates console experimentation for throwaway tests.

## What To Do With This

Install it if you deploy ADK, LangChain, or any other framework `agents-cli` supports — the deploy surface is framework-agnostic. Read the `references/` files for the target you picked (`cloud-run.md`, `agent-runtime.md`, `gke.md`, `cicd-pipeline.md`) rather than treating the main SKILL.md as complete, and pair it with the [google-agents-cli-adk-code](/skills/coding/google-agents-cli-adk-code/) skill for agent code patterns and the eval skill for the scores you must paste before the approval gate.

```bash
uv tool install google-agents-cli
agents-cli deploy --status
```

One caveat while the install counter is a pack counter: judge the skill on the flag table and the 403 map, not on the 492K number sitting next to it.
