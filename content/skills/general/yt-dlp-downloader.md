---
title: "Yt Dlp Downloader — AI Agent Video Download Skill"
date: 2026-07-18
draft: false
tags:
  - yt-dlp
  - Video Downloader
  - YouTube Downloader
  - AI Agent Skill
  - Cursor
description: "Download videos from YouTube, Bilibili, Twitter, and 1000+ sites through your AI agent using yt-dlp. Extract audio, grab subtitles, pick quality — all by asking in plain English."
version: "1.0"
author: "MapleShaw"
repo_url: "https://github.com/MapleShaw/yt-dlp-downloader-skill"
install_cmd: "git clone https://github.com/MapleShaw/yt-dlp-downloader-skill.git ~/.cursor/skills/yt-dlp-downloader"
compatibility:
  - Cursor
  - Claude Code
category: "general"
rating: 4
github_stars: 192
github_forks: 28
installs: 654
last_updated: "2026-07-18"
ai_friendliness:
  score: 7
  documentation: 7
  setup: 8
  config: 8
---

## Overview

Yt Dlp Downloader is an [AI agent skill](https://topaiskills.com) that wraps the legendary [yt-dlp](https://github.com/yt-dlp/yt-dlp) video downloader into something your AI can use on its own. Instead of remembering command-line flags and formats, you just tell your agent what you want — and it handles the rest.

Think of it as a translator between you and yt-dlp. You say "grab this video in 1080p with subtitles," your agent turns that into the right command, and the file lands in your Downloads folder. No flags to memorize, no syntax errors.

This skill works with Cursor and other AI coding agents that support custom skills.

## Key Features

- **1000+ site support** — YouTube, Bilibili, Twitter/X, TikTok, Vimeo, Twitch, and practically every video site yt-dlp knows about
- **Audio extraction** — Pull MP3 from any video with one request
- **Subtitle downloads** — Grab captions alongside or instead of video
- **Quality selection** — Pick 720p, 1080p, or best available
- **Auto error handling** — Deals with YouTube 403 errors using browser cookies automatically
- **Resume support** — Picks up interrupted downloads where they left off

## How It Works

The skill is dead simple. You install it, make sure yt-dlp and ffmpeg are on your system, and start asking:

| What you say | What happens |
|---|---|
| "Download this YouTube video" | Agent runs yt-dlp with sensible defaults |
| "Extract the audio from this" | Agent runs yt-dlp with `-x --audio-format mp3` |
| "Get the 1080p version with English subs" | Agent picks the right format and subtitle flags |
| "This download failed with a 403" | Agent retries with `--cookies-from-browser chrome` |

## Installation

```bash
# Step 1: Install yt-dlp and ffmpeg
pip install yt-dlp
brew install ffmpeg  # or: sudo apt install ffmpeg

# Step 2: Clone the skill
git clone https://github.com/MapleShaw/yt-dlp-downloader-skill.git ~/.cursor/skills/yt-dlp-downloader
```

That's it. Restart your agent and you're ready to go.

## Who Is This For?

Anyone who downloads videos regularly and uses an AI coding agent. If you're a content creator grabbing reference clips, a researcher collecting interview footage, or just someone who hates typing `-f bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best` — this skill saves you that pain every single time.

## Why yt-dlp?

yt-dlp is the gold standard for video downloading — it's actively maintained, supports more sites than anything else, and handles DRM workarounds better than its predecessor youtube-dl ever did. This skill just makes it accessible through natural language.

## Related Skills

- [Video Edit](/skills/image/video-edit/) — Edit and process videos with AI
- [Kling 3.0](/skills/image/kling-3-0/) — Generate AI videos from text prompts
