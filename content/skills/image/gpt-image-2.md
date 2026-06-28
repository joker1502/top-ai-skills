---
title: "GPT Image 2"
date: 2026-06-17
draft: false
tags:
  - AI Image
  - Image Generation
  - OpenAI
  - RunComfy
description: "GPT Image 2 brings OpenAI's strongest text-to-image model to your terminal through RunComfy — no ChatGPT tab, no API key management, one CLI command."
version: "1.0.0"
author: "agentspace-so"
repo_url: "https://github.com/agentspace-so/runcomfy-skills/tree/main/gpt-image-2"
install_cmd: "npx skills add agentspace-so/runcomfy-skills --skill gpt-image-2 -g"
compatibility:
  - RunComfy CLI
  - skills.sh
category: "image"
rating: 4.0
github_stars: 4
github_forks: 2
installs: 171000
last_updated: "2026-04-29"
ai_friendliness:
  score: 4.0
  documentation: 4.5
  setup: 3.5
  config: 4.0
---

## What It Is

A terminal skill that wraps OpenAI's GPT Image 2 (ChatGPT Images 2.0) through the RunComfy Model API — generate and edit images without leaving your CLI. One `npx skills add` command registers the skill, then you call `runcomfy run openai/gpt-image-2/text-to-image` with a JSON prompt and get back a file. No OpenAI API key, no ChatGPT subscription, no browser tab. It lives in the `agentspace-so/runcomfy-skills` repo alongside sibling skills like [Video Edit](/skills/image/video-edit/) and image-to-video.

## What's Actually Different

GPT Image 2's standout capability is **text rendering in images**. Most image models fumble embedded text — characters warp, letters appear as gibberish, multilingual typography collapses. This model reliably renders logos, signage, product labels, and UI mockups with legible text. Compared to FLUX or Midjourney, which treat text as a stylistic element, GPT Image 2 treats it as a specification — put "AQUA+" in quotes in your prompt and it shows up on the bottle. The RunComfy wrapper means you get this from the terminal rather than the ChatGPT web interface, which makes it practical for batch generation pipelines and agent workflows.

## Who It's For

Worth installing if you generate images that need readable text — e-commerce product shots, ad creatives with headlines, multilingual packaging mockups, or UI screenshots with labels. Skip it if you're after painterly aesthetics or hyperrealistic portraits, where Flux 2 and Nano Banana Pro outperform it. Also skip if you only generate images occasionally through ChatGPT's own interface — the terminal setup overhead isn't worth it for sporadic use.

## Bottom Line

GPT Image 2 is the best choice when the text in your image matters as much as the image itself, delivered through a skill you can call from any terminal.
