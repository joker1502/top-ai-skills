---
title: "Gemini"
date: 2026-05-30
draft: false
tags:
  - AI 写作
  - 通用
  - 对话
  - 多模态
description: "Google 最强大的 AI 模型，支持文本、图像、音频和视频的多模态理解"
version: "2.5 Pro"
author: "Google DeepMind"
repo_url: "https://github.com/google-gemini"
install_cmd: ""
compatibility:
  - Web
  - iOS
  - Android
category: "general"
rating: 4.6
github_stars: 0
github_forks: 0
installs: 15000000
last_updated: "2026-05-28"
ai_friendliness:
  score: 4.4
  documentation: 4.8
  setup: 4.3
  config: 4.0
---

Gemini 是 Google 最强大的 AI 模型，能够理解并推理文本、图像、音频、视频和代码。

## 核心特性

- 多模态理解（文本、图像、音频、视频）
- 100 万 token 上下文窗口
- 原生工具调用和函数调用
- 与 Google 生态深度集成

## 使用方法

访问 [gemini.google.com](https://gemini.google.com) 或通过 Google AI Studio 使用。

## API

```bash
curl -X POST https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro:generateContent \
  -H "Content-Type: application/json" \
  -d '{
    "contents": [{"parts":[{"text": "解释量子计算"}]}]
  }'
```
