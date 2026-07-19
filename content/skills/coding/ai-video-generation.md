---
title: "AI Video Generation"
date: 2026-06-28
draft: false
tags:
  - AI Video
  - Video Generation
  - CLI
  - Text-to-Video
description: "Generate videos with 40+ AI models directly from your terminal using the belt CLI — supports Sora, Kling, Runway, and more through inference.sh"
version: "1.0.0"
author: "101-skills"
repo_url: "https://github.com/101-skills/skills"
install_cmd: "npx skills add https://github.com/101-skills/skills --skill ai-video-generation"
compatibility:
  - Claude Code
  - Cursor
  - Codex
  - GitHub Copilot
  - Windsurf
category: "coding"
rating: 4.0
github_stars: 629
github_forks: 94
installs: 238100
last_updated: "2026-07-19"
ai_friendliness:
  score: 4.0
  documentation: 4.5
  setup: 3.5
  config: 4.0
---

## What It Is + Verdict

AI Video Generation is a CLI-based skill that gives your AI agent access to 40+ video generation models through the [inference.sh](https://inference.sh) platform. Instead of switching between browser tabs for Sora, Kling, Runway, or Pika, you run one command and get a video back in your terminal.

## The One Thing That Matters

This skill eliminates the biggest bottleneck in AI video workflows: context switching. Most creators juggle 3-4 different web UIs, each with different prompts, credit systems, and export formats. The AI Video Generation skill unifies them under one CLI — your agent picks the right model, submits the job, and retrieves the result without leaving the terminal.

## What's Actually Different

Unlike most video generation tools that lock you into one ecosystem, this skill acts as a universal interface. It supports models from Google (Veo 3.1), Kuaishou (Kling 3.0), OpenAI (Sora), and dozens more through inference.sh's API. The `belt` CLI handles authentication, job submission, polling, and download automatically.

Key capabilities:

- **40+ models** across major providers — pick the best tool for each project
- **Single install** — no need to sign up for each platform separately
- **Agent-native** — your AI assistant can trigger generation autonomously during a coding session
- **Image-to-video** supported alongside text-to-video on compatible models
- **Async job polling** — the CLI waits for completion, so your agent can chain results

## Who It's For

Developers and creators who want AI video generation integrated into their CLI workflow rather than a separate app. Best for: prototyping video ideas rapidly, batch-generating B-roll for coding tutorials, and building agent workflows that need video output. Less useful if you prefer visual timeline editors or need fine-grained frame-by-frame control.

## Bottom Line

AI Video Generation turns your terminal into a video production studio. If you already work in the CLI and want to skip the web UI shuffle, this is the most direct path from prompt to video.
