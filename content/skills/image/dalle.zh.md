---
title: "DALL·E"
date: 2026-05-30
draft: false
tags:
  - AI 图像
  - 设计
  - 创意
description: "OpenAI 的图像生成模型，以创意和多样化的视觉输出著称"
version: "3"
author: "OpenAI"
repo_url: "https://github.com/openai/dalle"
install_cmd: ""
compatibility:
  - Web
  - ChatGPT
  - API
category: "image"
rating: 4.5
github_stars: 0
github_forks: 0
installs: 5000000
last_updated: "2026-05-26"
ai_friendliness:
  score: 4.2
  documentation: 4.5
  setup: 4.0
  config: 4.0
---

DALL·E 是 OpenAI 的图像生成模型，能从文本描述创建惊艳的视觉效果。

## 核心特性

- 文本生成图像
- 图像修补和扩展
- 风格迁移和编辑
- 与 ChatGPT 集成

## 使用方法

通过 [ChatGPT](https://chatgpt.com) 或 OpenAI API 生成图像：

```bash
curl -X POST https://api.openai.com/v1/images/generations \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "dall-e-3",
    "prompt": "夕阳下的宁静山湖",
    "n": 1,
    "size": "1024x1024"
  }'
```

## 参数

```yaml
prompt: "夕阳下的宁静山湖"
model: "dall-e-3"
size: "1024x1024"
quality: "hd"
style: "natural"
```
