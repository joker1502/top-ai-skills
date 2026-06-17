---
title: "Video Edit"
date: 2026-06-16
draft: false
tags:
  - AI Video
  - Video Editing
  - RunComfy
description: "Video Edit routes your editing intent to the right AI video model — Wan 2.7, Kling Motion Control, or Lucy Restyle — through one CLI command."
version: "1.0.0"
author: "agentspace-so"
repo_url: "https://github.com/agentspace-so/runcomfy-skills/tree/main/video-edit"
install_cmd: "npx skills add agentspace-so/runcomfy-skills --skill video-edit -g"
compatibility:
  - RunComfy CLI
  - skills.sh
category: "image"
rating: 4.0
github_stars: 4
github_forks: 2
installs: 180000
last_updated: "2026-04-29"
ai_friendliness:
  score: 4.0
  documentation: 4.5
  setup: 3.5
  config: 4.0
---
## What It Is

Video Edit is an intent-routing skill for the RunComfy ecosystem that maps a natural-language video editing request to one of three video models — Wan 2.7 Edit-Video, Kling 2.6 Pro Motion Control, or Lucy Edit Restyle. Instead of picking a model, researching its prompting quirks, and manually constructing a JSON body, you describe the edit you want and the skill handles model selection and parameter formatting.

The skill lives inside the `agentspace-so/runcomfy-skills` monorepo alongside its siblings ([gpt-image-2](/skills/image/gpt-image-2/), image-edit, wan-2-7). You install it with a single `npx skills add` command that registers a `video-edit` agent skill, then call it through the RunComfy CLI.

## What's Actually Different

Most video AI tools expect you to understand the model landscape before you start editing. Need a background swap? That's Wan 2.7. Want to transfer a dance motion to a different character? That's Kling Motion Control. Trying to change an outfit while keeping the face stable? Lucy Edit Restyle. Each model has its own schema, its own prompting rules, and its own limitations.

Video Edit collapses that decision tree into one pipeline. It reads your intent from the prompt — "swap this background to a modern office" routes to Wan 2.7, "make this dancer's motion match the reference clip" routes to Kling — and sends the correctly structured JSON to the right model. It also bundles documented prompting patterns so you get sharper results without trial-and-error across three different APIs.

## Who It's For

Get this if you're already on RunComfy and regularly edit video through AI models — you save time by not switching between model docs and re-learning schemas. Skip it if you're editing video once a month and are fine working directly with a single model's interface, or if you don't use RunComfy at all.

The skill is also useful if you're building a video pipeline inside an agent workflow and need a reliable way to dispatch different edit types from one entry point.

## Bottom Line

Video Edit removes the model-choice overhead from AI video editing — one skill, three routes, one CLI call.
