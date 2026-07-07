---
title: "LLM API Pricing 2026: Compare Costs Across Every Major Provider"
date: 2026-07-07
toc: true
draft: false
tags:
  - LLM API Pricing
  - OpenAI
  - Anthropic
  - Google Gemini
  - AI Costs
  - Roundup
description: "Compare 2026 LLM API pricing across OpenAI, Anthropic, Google, Mistral, Cohere, DeepSeek, and open-model providers. Table includes input/output tokens, reasoning model costs, and hidden fees."
keywords:
  - LLM API pricing 2026
  - OpenAI pricing 2026
  - Anthropic Claude pricing
  - Google Gemini API cost
  - Mistral AI pricing
  - cheapest LLM API
  - AI model costs comparison
  - GPT-4o pricing
  - Claude 4 Sonnet price
  - Gemini 2.5 Pro cost
related_skills:
  - anysearch
  - gpt-researcher
  - tavily-search
category: "guides"
rating: 4.5
---

Pricing LLM APIs in 2026 feels like comparing phone plans during a price war — everyone keeps dropping rates, adding new model tiers, and burying the real cost in fine print about caching, batch discounts, and reasoning tokens.

I spent a weekend pulling current pricing from every major provider to build a single table you can actually compare. No markdown math, no outdated numbers from blog posts six months ago — just the rates as of July 2026.

## The Short Version

**OpenAI still leads on breadth** — they have the widest model range with GPT-4o, GPT-4.1, o3, o4-mini, and the new GPT-5 series. **Anthropic wins on consistency** — Claude 4 Sonnet is the most reliable all-rounder and their pricing hasn't jumped around as much. **Google is the cheapest for high volume** if you can tolerate occasional quality dips on Flash models. **Open-source via Together and Fireworks** remains the budget king for self-hosted workloads but you pay in latency and setup complexity.

| Provider | Best Model (Input / 1M tokens) | Best Model (Output / 1M tokens) | Cheapest Model (Input) |
|----------|-------------------------------|--------------------------------|------------------------|
| OpenAI | GPT-4.1: $2.00 | GPT-4.1: $8.00 | GPT-4o Mini: $0.15 |
| Anthropic | Claude 4 Sonnet: $3.00 | Claude 4 Sonnet: $15.00 | Claude 3.5 Haiku: $0.80 |
| Google | Gemini 2.5 Pro: $1.25 | Gemini 2.5 Pro: $5.00 | Gemini 2.0 Flash: $0.10 |
| Mistral | Mistral Large 2: $2.00 | Mistral Large 2: $6.00 | Mistral Small: $0.20 |
| DeepSeek | DeepSeek-V3: $0.50 | DeepSeek-V3: $2.00 | DeepSeek-R1: $0.14 |
| Cohere | Command R+: $2.50 | Command R+: $10.00 | Command R: $0.50 |

## Full Pricing Table

All prices are in USD per million tokens. "Input" is the prompt you send. "Output" is the generated response. "Reasoning" refers to internal chain-of-thought tokens that some models count separately.

### OpenAI (as of July 2026)

| Model | Input (per 1M tokens) | Output (per 1M tokens) | Reasoning Tokens | Batch Discount (50%) |
|-------|----------------------|-----------------------|-----------------|---------------------|
| GPT-4.1 | $2.00 | $8.00 | N/A | ✅ |
| GPT-4o | $2.50 | $10.00 | N/A | ✅ |
| GPT-4o Mini | $0.15 | $0.60 | N/A | ✅ |
| o3 | $10.00 | $40.00 | Same as output | ❌ |
| o4-mini | $1.10 | $4.40 | Same as output | ❌ |
| GPT-5 | $5.00 | $20.00 | N/A | ✅ |

OpenAI reduced GPT-4.1 pricing twice since launch — it started at $3/$12 in late 2025. **Batch API cuts everything by 50%** but results take up to 24 hours. The o-series reasoning models charge for internal thinking tokens at the output rate, which means a "short" answer can cost 3-5x more if the model spent many reasoning steps.

**Cached input tokens get a 50% discount** on GPT-4.1 and GPT-4o if you use the same system prompt across requests. This matters more than most people realize — a long system prompt that hits cache saves you real money at scale.

### Anthropic (as of July 2026)

| Model | Input (per 1M tokens) | Output (per 1M tokens) | Cache Write | Cache Read |
|-------|----------------------|-----------------------|-------------|------------|
| Claude 4 Sonnet | $3.00 | $15.00 | +25% | -90% |
| Claude 3.5 Sonnet | $3.00 | $15.00 | +25% | -90% |
| Claude 3.5 Haiku | $0.80 | $4.00 | +25% | -90% |
| Claude 3 Opus | $15.00 | $75.00 | +25% | -90% |

Anthropic's pricing structure is simpler than OpenAI's — no separate reasoning model tier. But their **prompt caching is the best in the industry**: a 90% discount on cached reads means a 10K-token system prompt effectively costs $0.30/1M instead of $3.00. If you send similar prompts across requests, Claude gets dramatically cheaper than the headline rate suggests.

The catch: cache hits depend on prompt prefix reuse. Change the system prompt slightly and the cache misses, costing full price.

### Google Gemini (as of July 2026)

| Model | Input (per 1M tokens) | Output (per 1M tokens) | Context Cache (75% off) | Free Tier |
|-------|----------------------|-----------------------|------------------------|-----------|
| Gemini 2.5 Pro | $1.25 | $5.00 | ✅ | 50 req/day |
| Gemini 2.5 Flash | $0.15 | $0.60 | ✅ | 1,500 req/day |
| Gemini 2.0 Flash | $0.10 | $0.40 | ✅ | 1,500 req/day |

Google is **aggressively undercutting everyone** on raw token pricing. Gemini 2.0 Flash at $0.10 input is the cheapest per-token cost of any frontier-quality model. The free tier is generous enough that individual developers rarely pay at all.

Quality is the trade-off. Flash models are fast and cheap but produce noticeably less reliable output on complex reasoning tasks. Gemini 2.5 Pro narrows the gap with GPT-4.1 and Claude 4 Sonnet but isn't quite there for tasks requiring precise multi-step logic.

### Mistral AI (as of July 2026)

| Model | Input (per 1M tokens) | Output (per 1M tokens) |
|-------|----------------------|-----------------------|
| Mistral Large 2 | $2.00 | $6.00 |
| Mistral Medium | $1.00 | $3.00 |
| Mistral Small | $0.20 | $0.60 |

Mistral remains the quiet contender. Their Large 2 model competes with GPT-4.1 on code and multilingual tasks while costing about the same. But their **leasing option for on-prem deployment** is unique — if you're handling sensitive data, you can run Mistral models in your own VPC for a flat monthly fee plus compute.

### DeepSeek (as of July 2026)

| Model | Input (per 1M tokens) | Output (per 1M tokens) |
|-------|----------------------|-----------------------|
| DeepSeek-V3 | $0.50 | $2.00 |
| DeepSeek-R1 | $0.14 | $0.55 |

DeepSeek is **the budget king for open-weight models**. Their API pricing is roughly 5-10x cheaper than OpenAI or Anthropic, and the quality gap has narrowed significantly with V3. R1 is their reasoning model — at $0.14 input it's a steal for tasks that benefit from chain-of-thought.

The trade-off: DeepSeek's API can have higher latency during peak hours, and their documentation isn't as polished as the US providers. If you need reliability SLAs, stick with the bigger names.

### Cohere (as of July 2026)

| Model | Input (per 1M tokens) | Output (per 1M tokens) |
|-------|----------------------|-----------------------|
| Command R+ | $2.50 | $10.00 |
| Command R | $0.50 | $2.00 |
| Embed v3 | $0.10 | — |

Cohere has carved out a niche in enterprise search and RAG workflows. Their embedding model at $0.10/1M is competitive, and Command R+ includes built-in citation generation which saves post-processing work. But for general-purpose chat and coding, the other providers offer better value.

### Open-Source via Third-Party Providers

If you want Llama 4, Qwen 2.5, or other open-weight models, you're looking at provider-specific pricing:

| Provider | Llama 4 (per 1M) | Qwen 2.5 (per 1M) | Mixtral (per 1M) |
|----------|------------------|-------------------|-------------------|
| Together AI | $0.40 / $1.20 | $0.25 / $0.75 | $0.60 / $1.80 |
| Fireworks AI | $0.30 / $1.00 | $0.20 / $0.60 | $0.50 / $1.50 |
| Groq | $0.10 / $0.40 | $0.05 / $0.20 | $0.15 / $0.60 |

Groq stands out for **inference speed** — their LPU hardware delivers 200+ tokens/second on Llama 4, which is 3-5x faster than GPU-based providers. The trade-off is a smaller model selection and occasional queuing during peak US hours.

## Hidden Costs Nobody Talks About

**Token inflation.** Not all tokens are equal. Models that use subword tokenization (like GPT-4o and Claude 4) typically consume 1.3-1.5 tokens per English word. But Gemini 2.5 Pro tokenizes at roughly 1.1 tokens per word on average — same task, fewer tokens, lower cost. When comparing prices, multiply by the tokenization efficiency of each model.

**Reasoning tokens on o-series.** OpenAI's o3 and o4-mini count internal reasoning tokens at the output rate. A request that returns 500 visible tokens might have consumed 3,000 internal reasoning tokens, making the effective cost 6x higher than the output price suggests. There's no way to cap reasoning token usage — the model decides how much thinking is needed.

**Context window costs.** A 200K-token input on Claude 4 Sonnet costs $0.60 just for the prompt. On GPT-4.1 with the same context, it's $0.40. If you're processing long documents or conversation histories, the context cost dwarfs the generation cost. Maxim [Cached input gets 50-90% off] every provider offers prompt caching — use it, or your context costs will dominate your bill.

**Rate limit tiers.** OpenAI's Tier 1 (free) gives you 200 RPM. Tier 5 (after spending $1,000+) gives you 10,000 RPM. If you're scaling from prototype to production, your effective throughput is gated by your spending history, not just the per-token price.

## How to Pick

**For prototyping and small projects:** Use Gemini 2.0 Flash or GPT-4o Mini. Both have free tiers, fast responses, and handle casual usage without costing anything.

**For production chat applications:** Claude 4 Sonnet with prompt caching gives the best quality-to-effective-cost ratio. The 90% cache discount on repeated system prompts makes a huge difference at scale.

**For heavy batch processing:** OpenAI's batch API at 50% off is hard to beat. Submit a batch of 10,000 summarization tasks overnight and pay half price. Results come back within 24 hours.

**For on-premise or sensitive data:** Mistral's leasing option or self-hosting Llama 4 through Together AI gives you data control. You trade simplicity for privacy.

**For pure cost minimization:** DeepSeek-V3 or Llama 4 via Groq. The quality isn't frontier-level but for straightforward tasks like classification, extraction, and simple generation, it's more than good enough at a fraction of the price.

## Bottom Line

LLM API pricing in 2026 is more competitive than ever, but the gap between headline rates and actual cost depends on your usage pattern. Prompt caching, batch processing, and model selection (especially reasoning vs. standard models) matter more than picking the cheapest per-token rate. Test with your real workload, not a benchmark.
