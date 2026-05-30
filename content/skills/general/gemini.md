---
title: "Gemini"
date: 2026-05-30
draft: false
tags:
  - AI Writing
  - General
  - Conversational
  - Multimodal
description: "Google's most capable AI model with multimodal understanding across text, image, audio, and video"
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

Gemini is Google's most capable AI model, built to understand and reason across text, images, audio, video, and code.

## Key Features

- Multimodal understanding (text, image, audio, video)
- 1M+ token context window
- Native tool use and function calling
- Integration with Google ecosystem

## Usage

Access Gemini at [gemini.google.com](https://gemini.google.com) or through Google AI Studio.

## API

```bash
curl -X POST https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro:generateContent \
  -H "Content-Type: application/json" \
  -d '{
    "contents": [{"parts":[{"text": "Explain quantum computing"}]}]
  }'
```
