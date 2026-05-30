---
title: "Perplexity AI"
date: 2026-05-30
draft: false
tags:
  - AI 搜索
  - 研究
  - 对话
description: "支持实时引用和深度研究的 AI 搜索引擎"
version: "Pro"
author: "Perplexity AI"
repo_url: "https://www.perplexity.ai"
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

Perplexity AI 是一款 AI 搜索引擎，能提供带有实时引用和来源的答案。

## 核心特性

- 实时网络搜索
- 引用来源
- Pro 搜索（GPT-4 & Claude）
- 收藏夹与话题

## 使用方法

访问 [perplexity.ai](https://perplexity.ai) 或使用 API：

```bash
curl -X POST https://api.perplexity.ai/chat/completions \
  -H "Authorization: Bearer $API_KEY" \
  -d '{"model": "sonar-pro", "messages": [{"role": "user", "content": "最新的 AI 研究"}]}'
```
