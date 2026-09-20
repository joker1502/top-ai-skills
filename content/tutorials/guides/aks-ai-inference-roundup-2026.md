---
title: "AKS AI Inference Roundup: The Model-Serving Stack"
date: 2026-09-20
toc: true
draft: false
tags:
  - Azure
  - Kubernetes
  - AI Inference
category: "guides"
description: "airunway-aks-setup (337K installs) walks a bare AKS cluster to a served LLM in six kubectl steps — zero MCP tools, KAITO default, GPU dtype traps"
keywords:
  - airunway-aks-setup
  - azure-kubernetes
  - azure-diagnostics
  - KAITO
  - agent skills
---

Serving an open-weight LLM on Azure Kubernetes Service used to mean stitching together Helm charts, node pools and a serving wrapper by hand. Microsoft's `airunway-aks-setup` skill (v1.1.1, MIT, 337.0K installs, rank 174 on skills.sh) compresses that into six sequential steps from bare cluster to a model that answers `curl` — and it breaks a pattern I've tracked across the whole azure-skills pack: it uses zero MCP tools. I read its SKILL.md, all six step references, the GPU profile and model sizing guides, and the troubleshooting and PowerShell files, and pulled the leaderboard on 2026-09-20: weekly installs [16,865, 16,190, 15,950, 14,851, 13,299, 13,492, 12,000, 12,695], lockstep with the pack counter again. This roundup lines up the three skills that span the AKS AI path: [azure-kubernetes](/skills/automation/azure-kubernetes/) for the cluster, airunway-aks-setup for the serving layer, [azure-diagnostics](/skills/automation/azure-diagnostics/) for the post-deploy pain.

## Six Steps From Bare Cluster to Served Model

The skill assumes the cluster exists — if it doesn't, it hands off to `azure-kubernetes` first, with a GPU node pool unless CPU-only inference is acceptable. From there the steps run in order, each loading its own reference file as it starts: verify the cluster, install the controller, assess GPUs, pick a provider, deploy a model, smoke-test. Rule 5 covers interruptions: `skip-to-step N` resumes from a specific phase and assumes everything before it is done, and any already-complete step reports status and moves on. Every step demands the cluster state reported to the user — healthy or missing, no silent skips.

Verification (step 1) checks `kubectl`, `make` and `curl` exist, confirms `kubectl config current-context`, inventories nodes, then hunts GPUs through `nvidia.com/gpu.product` node labels — labels only the NVIDIA device plugin or GPU operator set. Empty output triggers a `kubectl describe nodes` fallback, and if that shows nothing on hardware you know has GPUs, the device plugin is missing and the skill tells you to install it before proceeding. A CPU-only cluster is not a dead end; it just routes to KAITO + llama.cpp later. Controller install (step 2) is two `make` targets — `make controller-install` for the `modeldeployments.airunway.ai` CRDs, `make controller-deploy` for the manager — and both must run from the AI Runway repository root; `No rule to make target` is the skill's own tell that you `cd`'d to the wrong directory.

## GPU Profiles Decide Your Model Before You Pick One

Step 3 matches detected hardware against a compatibility table, and this is where most deployments silently fail. T4 and V100 cards lack bfloat16 support — running a model that defaults to bf16 produces errors or silent dtype casting, so serving args must force `--dtype float16` (T4 also loses flash attention; V100 needs the xformers backend). The attention-backend ladder is compute-capability gated: FlashAttention-2 and Triton attention need Ampere or newer (cc 8.0+), while xformers works back to Volta (cc 7.0+). Model sizing then follows a weights-only rule: a 70B model needs ~140 GB in fp16, plus 20-30% for KV cache and activations, so it lands at ~168 GB and fits 4× A100 80 GB only with tensor parallelism — the skill's own math example.

| Cluster capacity | Starter model | Notes |
|:-----------------|:-------------|:------|
| CPU-only | `google/gemma-3-1b-it-qat-q8_0-gguf` | GGUF Q8, KAITO + llama.cpp |
| 1× T4 (16 GB) | `microsoft/Phi-3-mini-4k-instruct` | ~8 GB fp16, MIT license |
| 1× A10G / L4 (24 GB) | `meta-llama/Llama-3.1-8B-Instruct` | gated — HF token required |
| 1× A100 40 GB | `microsoft/Phi-3-medium-128k-instruct` | ~28 GB fp16, non-gated |
| 4× A100 80 GB | `meta-llama/Llama-3.1-70B-Instruct` | tensor parallel, gated |

The model ladder in the table is deterministic per cluster size, and the gated-vs-open split is spelled out: Llama-family models need a HuggingFace token, while Phi-3 (MIT) and Gemma ride free. The skill also opens with a cost warning most setup guides skip — A100-80GB nodes run $3-5+/hr, so it confirms the user understands the bill before provisioning GPU resources.

## KAITO by Default, Dynamo and KubeRay as Escapes

Provider selection (step 4) reads current registrations through `kubectl get inferenceproviderconfigs`, then recommends: KAITO for standard inference and anything CPU-only, Dynamo for teams that must scale prefill and decode independently (high-throughput serving), KubeRay for shops already invested in Ray. The default is KAITO, unconditionally — simplest setup, handles most use cases. Installation runs `make deploy IMG=<image>` from `providers/<provider>` with the image read from the provider's Makefile (`grep 'IMG\s*?='`), and registration is confirmed by `status.ready: true` within two minutes or pod-log digging.

Deployment (step 5) writes a `ModelDeployment` CR (`apiVersion: airunway.ai/v1alpha1`), deriving a DNS-safe name from the model ID — `meta-llama/Llama-3.1-8B-Instruct` becomes `llama-3-1-8b-instruct`. Gated models get a token flow that avoids shell history: `read -s` into a `mktemp` file, `chmod 600`, a trap that deletes it on exit, then `kubectl create secret generic hf-token --from-file=token=...`, referenced from the CR via `huggingFaceTokenSecretRef`. A 401 at model load means the secret never made it into the CR. `Ready` within 10 minutes is normal; 70B models take 20-40+ minutes because weights download first — the skill explicitly says to check pod logs for download progress rather than declaring failure. The smoke test (step 6) reads the endpoint from `status.endpoint` and posts to `/v1/chat/completions`, with a port-forward path for cluster-internal URLs (vLLM listens on 8000, llama.cpp on 8080). Rollback runs in reverse: delete the ModelDeployment, delete the token secret, `make undeploy`, then `make controller-undeploy && make controller-uninstall`.

## Where the Three Skills Split

| Skill | Role | Tooling | MCP |
|:------|:-----|:--------|:----|
| [azure-kubernetes](/skills/automation/azure-kubernetes/) | Day-0 cluster, node pools, AKS Automatic | az CLI | Heavy |
| [azure-diagnostics](/skills/automation/azure-diagnostics/) | AppLens, Monitor, resource health | az CLI + KQL | Heavy |
| airunway-aks-setup | Controller, GPU, provider, ModelDeployment | kubectl + make + curl | **None** |

That zero-MCP column is the anomaly worth remembering: the pack's other skills route through `mcp_azure_mcp_*` servers, while this one talks straight to kubeconfig with `kubectl`, `make` and `curl` — its SKILL.md carries an explicit "This skill uses no MCP tools" section, the first such declaration I've hit across the pack. It also pairs cleanly with the pack's earlier findings: [azure-kubernetes](/skills/automation/azure-kubernetes/)' SKILL.md references `azure-kubernetes-app-deploy` and `automatic-readiness` children that exist in neither the repo nor the leaderboard — routing residue — so the serving arm of the family is effectively this skill alone. Install it with `npx skills add https://github.com/microsoft/azure-skills --skill airunway-aks-setup`; if you want the full pack-health picture including removed skills, the [azure-skills pack health roundup](/tutorials/guides/azure-skills-pack-health-roundup-2026/) has the curve evidence.