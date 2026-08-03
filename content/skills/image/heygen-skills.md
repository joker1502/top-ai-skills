---
title: "HeyGen Skills"
date: 2026-08-03
draft: false
tags:
  - AI Video
  - Avatar
  - Video Generation
description: "HeyGen's official agent skills — heygen-avatar, heygen-video, heygen-translate turn a photo into a reusable avatar that delivers videos in 175+ languages."
version: "3.2.0"
author: "HeyGen"
repo_url: "https://github.com/heygen-com/skills"
install_cmd: "gh skill install heygen-com/skills heygen-video"
compatibility:
  - Claude Code
  - OpenClaw
  - Codex
  - Cursor
category: "image"
rating: 4.0
github_stars: 379
github_forks: 66
installs: 0
last_updated: "2026-08-03"
ai_friendliness:
  score: 4.5
  documentation: 4.5
  setup: 4.0
  config: 4.0
---

## What It Is

HeyGen Skills are the official AI agent skills from HeyGen, the avatar video platform. The [repo's own description](https://github.com/heygen-com/skills) calls them "HeyGen AI agent skills — avatar creation and video production via the v3 Video Agent pipeline," and the README sums up the pitch in one line: "AI agent skills for creating avatar videos. Your agent gets a face, a voice, and the ability to send video like a message."

The repo ships three skills that work standalone or chain together: **heygen-avatar** turns a photo into a persistent digital twin (face + voice) that's reusable across every video; **heygen-video** takes an idea, writes a script, and generates a prompt-engineered video with your avatar delivering the message; and **heygen-translate** takes an existing video and produces a translated, dubbed version with voice cloning and lip-sync across 175+ languages.

The three skills are designed to work as a pipeline. Per the official docs, "heygen-avatar creates the identity. heygen-video uses it. heygen-translate localizes finished videos." Skills communicate through human-readable `AVATAR-<NAME>.md` files — heygen-avatar writes them, heygen-video reads them — so the avatar persists between sessions and every future video reuses it automatically. The skills work with Claude Code, OpenClaw, Codex, Cursor, and other AI coding agents.

## What Makes It Different

The first thing that stands out is the **self-installing setup**. Instead of cloning repos and wiring config by hand, you paste a single prompt into your agent — "Read https://raw.githubusercontent.com/heygen-com/skills/master/INSTALL_FOR_AGENTS.md and follow it" — and the agent clones the repo to the right path, asks for your API key, picks the best transport, runs a verify test, and ends with a working video. The install spec lives in the repo, not in your clipboard, so the same prompt works forever.

Second, HeyGen made **auth a billing decision**. The skills support two modes with explicit priority: CLI mode using a `HEYGEN_API_KEY` (billed directly against HeyGen API usage) or a remote MCP server with OAuth (`https://mcp.heygen.com/mcp/v1/`) that consumes your existing HeyGen plan credits. The docs spell out the tradeoff: "CLI mode bills against your HeyGen API usage (separately metered). MCP mode consumes your existing HeyGen plan credits — no extra API billing." If both are configured, the CLI wins.

Third, the skills are **distributed through the new skill ecosystem**. You can install them with `gh skill install heygen-com/skills heygen-avatar` (the GitHub CLI command backed by agentskills.io, which writes to the right directory for your agent automatically), with `clawhub install heygen-skills`, or as an OpenClaw plugin that bundles MCP support. The v3 Video Agent pipeline also handles the details agents can't: Frame Check for aspect-ratio correction, 20 curated presenter styles (A24, editorial, clean tech, and more), and automatic avatar resolution.

## Who It's For

HeyGen Skills fit three types of users. First, **founders and solo operators** who want personal video without hiring an editor — intro videos, investor outreach, and weekly updates where your avatar delivers the message. The README's example workflow is exactly this: "make a 30-60 second video of me introducing myself, casual tone" — the skill picks up your avatar, writes the script, generates the video, and returns a share link.

Second, **teams that treat video as a message**. Product launch videos, team updates, and explainers are all covered by heygen-video; the skill even interviews you first ("ask me what shipped before writing the script") so the script reflects real work. For international teams, heygen-translate handles dubbing and lip-sync across 175+ languages — a localization pipeline that used to take days.

Third, **agents and automation builders** who want video output inside a workflow: a marketing agent that turns an article or PDF into a 60-second explainer, or an outreach system that sends personalized video pitches. The skills are designed to be invoked by agents, with JSON output from the HeyGen CLI and stable exit codes.

Skip it if you need cinematic footage or b-roll without a presenter — these skills are presenter-led videos, not film production. You also need cloud access (either MCP or the CLI), so there's no offline mode. Pricing is credit-based: HeyGen starts at $0/month for a free tier, with paid plans from around $24–29/month that add credits, higher resolution, and commercial rights.

## Bottom Line

HeyGen Skills are the most complete avatar-video package in the agent skill ecosystem: an identity skill, a production skill, and a localization skill that chain together through a simple file format — with a self-installing setup and a choice between API-key billing and plan-credit MCP auth. If you want your agent to produce presenter-led video on demand, this is the fastest path from photo to finished clip. For other AI video options, see our [Pika Labs skill intro](/skills/image/pika-labs/) and the [Kling 3.0 skill page](/skills/image/kling-3-0/).
