---
title: "Azure AI Gateway: 6 Steps to Govern OpenAI Calls"
date: 2026-09-17
toc: true
draft: false
tags:
  - Azure
  - API Management
  - AI Gateway
category: "guides"
description: "Govern Azure OpenAI via API Management in six steps: managed-identity backends, the right inbound policy order, semantic caching, token limits, 401/429 fixes"
---

The moment your app starts calling Azure OpenAI directly, three things escape you: cost, rate limits, and what content is actually flowing through. Microsoft's azure-aigateway skill (v3.2.1) fixes that by configuring Azure API Management as an AI gateway — a control plane sitting between your callers and the model. I read the SKILL.md plus all four references (patterns, policies, troubleshooting, auth best practices) in [microsoft/azure-skills](https://github.com/microsoft/azure-skills), then scraped skills.sh on 2026-09-17: 585,092 installs, rank 57, lockstepping with azure-kusto two spots below. The procedure below is the skill's own Pattern 1, sequenced.

## Step 1–2: Wire the Backend with Managed Identity

Start with discovery. The skill dumps your AI resources into a table so the right account gets picked:

```bash
az cognitiveservices account list --query "[?kind=='OpenAI'].{name:name, rg:resourceGroup, endpoint:properties.endpoint}" -o table
```

Then give APIM an identity and the role it needs. This is the step most setups skip — you need **Cognitive Services User**, not Contributor, on the OpenAI resource:

```bash
az apim update --name <apim-name> --resource-group <rg> --set identity.type=SystemAssigned
PRINCIPAL_ID=$(az apim show --name <apim-name> --resource-group <rg> --query "identity.principalId" -o tsv)
az role assignment create --assignee "$PRINCIPAL_ID" --role "Cognitive Services User" --scope "$AOAI_ID"
```

Create the backend pointing at the OpenAI endpoint (`.../openai` suffix included), import the OpenAPI spec — the SKILL.md pins the stable 2024-02-01 inference JSON straight from azure-rest-api-specs — and set the inbound policy with `authentication-managed-identity resource="https://cognitiveservices.azure.com"`.

## Step 3–4: Stack the Six Policies in Order

The skill prescribes a fixed `<inbound>` order, and the sequence is the logic: authentication first, then semantic cache lookup, then token limiting, then content safety, then backend selection, then metrics. Run the cache lookup **before** the count check and your cached replies skip the token meter entirely.

Two policies need real setup behind them. Semantic caching (`azure-openai-semantic-cache-lookup` + `-store`) claims 60–80% cost savings on repeated prompts, but its prerequisites are listed explicitly: an embeddings backend, a deployed embedding model, and Azure Cache for Redis Enterprise with RediSearch. No Redis, no cache hits — and the troubleshooting file says a zero-percent hit rate usually means `score-threshold` too high (0.9 → 0.7). Token limits take `tokens-per-minute` and a `counter-key`; per-subscription keys give you per-tenant metering, and the SKILL.md shows the free-tier vs premium-tier pattern of keying on `"free-" + context.Subscription.Id`.

Content safety (`llm-content-safety`) filters across Hate, Sexual, SelfHarm, and Violence with per-category thresholds in the 0–6 range. Default 4; raise to 5–6 if legitimate business content gets blocked. The on-error block returns a clean `400 Content Filtered` instead of leaking the raw error.

## Step 5: Add Streaming — and Accept the Trade-off

Streaming is where the skill's policy table earns its keep. SSE needs one outbound `set-header`, and its condition is precise: flip Content-Type to `text/event-stream` only when the request body's `stream` flag is true. The trade-off sits in that same reference. Semantic caching and token metrics are **not compatible** with streaming responses. Serve streaming clients and you lose both — the cache savings and the token telemetry. Pick non-streaming for cost-controlled scenarios, or accept the gap.

## Step 6: Test, Then Troubleshoot by Symptom

Test with the gateway URL and a subscription key against the OpenAI-shaped path:

```bash
curl -X POST "${GATEWAY_URL}/openai/deployments/<deployment>/chat/completions?api-version=2024-02-01" \
  -H "Ocp-Apim-Subscription-Key: <key>" -H "Content-Type: application/json" \
  -d '{"messages": [{"role": "user", "content": "Hello"}], "max_tokens": 100}'
```

When it breaks, the troubleshooting reference splits by layer — and that split matters. A token-limit 429 means raise `tokens-per-minute`, add load-balanced backends, or enable caching. A **backend** 429 is different — Azure OpenAI's own TPM quota is exhausted, and more APIM policy won't fix it. Backend 401s come down to four causes: identity not enabled on APIM, missing Cognitive Services User role, the wrong auth resource (must be `https://cognitiveservices.azure.com`, not the endpoint URL), or RBAC propagation still settling. The skill tells you to wait 5–10 minutes after the role assignment. Timeouts on big-context prompts point at `<forward-request>` — the skill nudges it from the 30-second default to 120.

## When This Gateway Is Overkill

For a single internal model with one caller, adding APIM is a whole extra service to feed. The skill itself routes deployment through [azure-prepare](/skills/automation/azure-prepare/), and the auth reference hammers the production rule: `ManagedIdentityCredential` in production, `DefaultAzureCredential` only for local dev. If your problem is purely compute sizing or spend visibility rather than multi-tenant governance, [azure-cost](/skills/automation/azure-cost/) and [azure-compute](/skills/automation/azure-compute/) cover those lanes without the gateway layer.

Run the six steps once on a test APIM instance with a dev OpenAI deployment: identity, role, backend, the six-policy stack, a streaming curl, then break it on purpose — hit the token limit and watch the 429 flow. The skill's quick-decision table at the end of policies.md is the cheat sheet that survives.

*Related: [azure-prepare — plan-first Azure architecture](/skills/automation/azure-prepare/), [azure-cost — query before you optimize](/skills/automation/azure-cost/), [azure-kusto — the other lockstep sibling](/skills/automation/azure-kusto/).*