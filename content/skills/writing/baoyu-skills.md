---
title: "Baoyu Skills"
date: 2026-08-06
draft: false
tags:
  - AI Content
  - Content Creation
  - AI Tools
description: "Baoyu's 20+ agent skills for content creation: Xiaohongshu cards, infographics, WeChat publishing, and multi-provider image generation in one npx install."
version: "2.5.2"
author: "JimLiu"
repo_url: "https://github.com/JimLiu/baoyu-skills"
install_cmd: "npx skills add jimliu/baoyu-skills"
compatibility:
  - Claude Code
  - Codex
  - Cursor
  - Gemini CLI
category: "writing"
rating: 4.5
github_stars: 24665
github_forks: 2749
installs: 0
last_updated: "2026-08-06"
ai_friendliness:
  score: 4.5
  documentation: 4.5
  setup: 4.0
  config: 4.0
---

## What It Is

Baoyu Skills is the most-installed content-creation skill collection in the agent ecosystem. The [repo's own description](https://github.com/JimLiu/baoyu-skills) calls it "Skills shared by Baoyu for improving daily work efficiency with AI Agents (Claude Code, Codex, etc.)," and at 24.6k stars with 2.7k forks it sits at the top of every content-creator skill ranking. The README leads with a deliberately opinionated tip: "This repository contains 20+ skills. Install only the ones you actually need — bulk-installing every skill adds unnecessary context overhead for your AI agent on every run."

The collection is organized into three groups. **Content Skills** are the publishing pipeline: `baoyu-xhs-images` turns an article into 1–10 Xiaohongshu image cards with a Style × Layout system, `baoyu-infographic` generates publication-ready infographics across 21 layouts and 17 visual styles, `baoyu-diagram` writes real SVG flowcharts and architecture diagrams, and `baoyu-post-to-wechat` / `baoyu-post-to-x` / `baoyu-post-to-weibo` push finished content straight to the major platforms. **AI Generation Skills** are the backends: `baoyu-image-gen` speaks to nine image providers — OpenAI GPT Image 2, Azure OpenAI, Google, OpenRouter, DashScope, MiniMax, Jimeng, Seedream, and Replicate — through one unified command. **Utility Skills** handle the grunt work: YouTube transcripts with chapters and speaker ID, URL-to-Markdown conversion, image compression, formatting, translation, and Markdown-to-WeChat-HTML.

Installation is one command: `npx skills add jimliu/baoyu-skills`. Codex users can copy individual skills into `<project>/.agents/skills/` for project-level installs, the repo also publishes each skill individually to ClawHub (`clawhub install baoyu-image-gen`), and agents with plugin marketplaces register it with `/plugin marketplace add JimLiu/baoyu-skills`. Credentials live in a `.env` file at `~/.baoyu-skills/` (user-level) or `<project>/.baoyu-skills/` (project-level), with CLI environment variables taking highest priority.

## What Makes It Different

The first thing that stands out is the **Style × Layout design system**. Most content skills generate one style and hope it looks good. `baoyu-xhs-images` separates visual aesthetics (cute, fresh, warm, bold, minimal, retro, pop, notion, chalkboard, study-notes, screen-print, sketch-notes) from information density (sparse, balanced, dense, list, comparison, flow) so you can mix and match — a dense knowledge-card layout with a macaron palette, or a list layout in sketch-notes style. `baoyu-infographic` takes the same approach at 21 layouts × 17 styles (fishbone, funnel, venn, iceberg, pyramid — plus claymation, cyberpunk-neon, pixel-art, and ikea-manual aesthetics). The combination means the same article can be re-rendered as a WeChat-friendly set, a knowledge card, or a slide deck without prompt engineering.

Second, the **multi-provider image backend** removes the vendor lock-in that plagues most image skills. `baoyu-image-gen` auto-detects a provider from your existing env vars, so the same `/baoyu-image-gen --prompt "A cat" --image cat.png` works whether you have an OpenAI key, a DashScope key, or a Replicate token. You can also pin a provider explicitly (`--provider azure --model gpt-image-2` for Azure deployments, `--provider dashscope --model qwen-image-2.0-pro` for Chinese text rendering). This is a genuinely practical design for people who switch models as pricing changes.

Third, the **publishing skills are built for real platforms, not generic output**. `baoyu-post-to-wechat` doesn't just produce Markdown — it includes the full Markdown-to-WeChat-HTML conversion flow and handles the API credential placement (user-level vs project-level `.env`) so articles land in the WeChat Official Account editor ready to publish. The repo's own recommended WeChat workflow is a three-skill chain: `baoyu-cover-image` → `baoyu-article-illustrator` → `baoyu-post-to-wechat`, and it explicitly notes you don't need `baoyu-markdown-to-html` separately because the post skill already includes it.

## Who It's For

Baoyu Skills fit three types of users. First, **content creators and social publishers** who produce across Xiaohongshu, WeChat, X, and Weibo. The Style × Layout system is clearly designed for the Chinese social content workflow — image cards, infographics, cover images, and comic-style illustrations — and the publishing skills close the loop from draft to posted. If you maintain a Xiaohongshu account or a WeChat Official Account, this is the most complete automation kit available as agent skills.

Second, **solo operators and indie hackers** running a content engine with AI agents. The tip in the README — install only the skills you need — is aimed exactly at this group: an agent with `baoyu-xhs-images` plus `baoyu-image-gen` plus `baoyu-translate` can repurpose one article across three platforms and two languages without bloating its context window with 20 unused skills.

Third, **teams that publish in Chinese-language markets** but work in English tooling. The image generation explicitly supports Chinese text rendering (via DashScope's `qwen-image-2.0-pro` and Z.AI GLM-Image), and the transcription, translation, and Markdown conversion utilities cover the zh↔en workflow that most Western skill collections ignore.

Skip it if you publish exclusively in English on Western platforms and already have a working design pipeline — the distribution and publishing depth here is heavily weighted toward the Chinese ecosystem (Xiaohongshu, WeChat, Weibo), and you'd be paying context overhead for skills you don't use. It's MIT-licensed, and individual ClawHub-published skills are MIT-0.

## Bottom Line

Baoyu Skills is the most complete content-creation skill collection in the agent ecosystem: 20+ skills spanning image cards, infographics, SVG diagrams, multi-provider image generation, and real platform publishing — all behind one `npx skills add` command, with a design system deep enough to make output actually look intentional. If your agent produces content for social platforms, this is the fastest path from draft to published. For a closer look at one of its content skills, see our [baoyu-article-illustrator skill page](/skills/image/baoyu-article-illustrator/), and for other AI writing tools compare it with the [HTML Anything skill intro](/skills/writing/html-anything/) or the [AI writing assistants guide](/tutorials/guides/how-ai-writing-assistants-changed-content-creation/).
