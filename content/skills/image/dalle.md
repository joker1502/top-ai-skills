---
title: "DALL·E"
date: 2026-05-30
draft: false
tags:
  - AI Image
  - Design
  - Creative
description: "OpenAI's image generation model known for creative and diverse visual output"
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

DALL·E is OpenAI's image generation model that creates stunning visuals from text descriptions.

## Key Features

- Text-to-image generation
- Inpainting and outpainting
- Style transfer and editing
- Integration with ChatGPT

## Usage

Generate images through [ChatGPT](https://chatgpt.com) or the OpenAI API:

```bash
curl -X POST https://api.openai.com/v1/images/generations \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "dall-e-3",
    "prompt": "A serene mountain lake at sunset",
    "n": 1,
    "size": "1024x1024"
  }'
```

## Parameters

```yaml
prompt: "A serene mountain lake at sunset"
model: "dall-e-3"
size: "1024x1024"
quality: "hd"
style: "natural"
```
