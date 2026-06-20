---
title: "Kling 3.0"
date: 2026-06-20
draft: false
tags:
  - AI Video
  - Video Generation
  - RunComfy
description: "Kling 3.0 exposes six video generation endpoints on RunComfy — Standard, Pro, and 4K in text-to-video and image-to-video modes, all from a single skill."
version: "1.0.0"
author: "agentspace-so"
repo_url: "https://github.com/agentspace-so/runcomfy-agent-skills"
install_cmd: "npx skills add https://github.com/agentspace-so/runcomfy-agent-skills --skill kling-3-0"
compatibility:
  - RunComfy CLI
  - skills.sh
category: "image"
rating: 4.0
github_stars: 22
github_forks: 9
installs: 240000
last_updated: "2026-05-15"
ai_friendliness:
  score: 4.0
  documentation: 4.5
  setup: 3.5
  config: 4.0
---
## What It Is

Kling 3.0 is a RunComfy skill that wraps Kuaishou's third-generation video model into six endpoints — Standard, Pro, and 4K tiers, each available as text-to-video or image-to-video. Instead of navigating Kling's API docs and constructing JSON bodies for each rendering tier, you describe what you want and the skill routes your request to the right endpoint with appropriate parameters.

The skill lives in the `agentspace-so/runcomfy-agent-skills` monorepo alongside siblings like kling-2-6 and lucy-edit. You install it with a single `npx skills add` command and call it through the RunComfy CLI.

## What's Actually Different

Most video generation tools give you one quality level or make you choose between resolution tiers manually. Kling 3.0 ships three distinct rendering tiers that share the same multi-shot architecture — Standard for fast iteration at 1080p, Pro for hero-quality 1080p with better motion fidelity, and 4K for native 3840x2160 output. Each tier is available in text-to-video and image-to-video modes, giving you six endpoints behind one skill interface. Compared to working with Kling's API directly, this skill handles the schema differences between tiers so you don't need to restructure your request when upgrading quality.

## Who It's For

Get this if you're on RunComfy and regularly generate video through Kling — you save time by not switching between tier docs and reformatting requests. Skip it if you're fine working directly with a single Kling tier through its native API, or if you don't use RunComfy at all.

The skill is especially useful if you're building multi-shot sequences where you need consistent character identity across clips, since the underlying model handles that at the tier level and the skill just passes your prompt through correctly.

## Bottom Line

Six Kling 3.0 endpoints, one skill, no tier-switching overhead.
