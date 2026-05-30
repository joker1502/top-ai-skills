---
title: "Perplexity AI"
date: 2026-05-30
draft: false
tags:
  - AI Search
  - Research
  - Conversational
description: "AI-powered search engine with real-time citations and deep research"
version: "Pro"
author: "Perplexity AI"
repo_url: "https://github.com/perplexity-ai"
install_cmd: ""
compatibility:
  - Web
  - iOS
  - Android
category: "search"
rating: 4.6
github_stars: 0
github_forks: 0
installs: 1200000
last_updated: "2026-05-26"
ai_friendliness:
  score: 4.3
  documentation: 4.5
  setup: 4.5
  config: 3.8
---

Perplexity AI is an AI-powered search engine that provides answers with real-time citations and sources.

## Key Features

- Real-time web search
- Cited sources
- Pro search with GPT-4 & Claude
- Collections and threads

## Usage

Search at [perplexity.ai](https://perplexity.ai) or use the API:

```bash
curl -X POST https://api.perplexity.ai/chat/completions \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "sonar-pro",
    "messages": [{"role": "user", "content": "Latest AI research"}]
  }'
```
