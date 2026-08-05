---
title: "HTML Anything"
date: 2026-08-05
draft: false
tags:
  - HTML
  - AI Writing
  - Content Creation
description: "An agentic HTML editor that turns any Markdown, CSV, or raw notes into ship-ready single-file HTML — 75 templates, 9 surface modes, zero API key."
version: "1.0.0"
author: "nexu-io"
repo_url: "https://github.com/nexu-io/html-anything"
install_cmd: "git clone https://github.com/nexu-io/html-anything && pnpm install"
compatibility:
  - Claude Code
  - Cursor Agent
  - Codex
  - Gemini CLI
  - GitHub Copilot CLI
  - OpenCode
  - Qwen Coder
  - Aider
category: "writing"
rating: 4.5
github_stars: 8094
github_forks: 793
installs: 0
last_updated: "2026-08-05"
ai_friendliness:
  score: 4.5
  documentation: 4.5
  setup: 4.0
  config: 4.0
---

## What It Is

HTML Anything is an agentic HTML editor from the team behind Open Design (40k+ stars, 200+ contributors). The [repo's own description](https://github.com/nexu-io/html-anything) calls it "the agentic HTML editor — your local AI agent writes the HTML," and the README leads with the philosophy in one line: "Markdown is the draft. HTML is what humans read. Your local agent writes it."

Instead of hand-editing documents, you paste any input — Markdown, CSV, Excel, JSON, SQL, or raw notes — into a local editor, pick a template, and press ⌘+Enter. Your local AI coding agent turns it into ship-ready single-file HTML in seconds. The project is built on top of nexu-io/open-design, and everything runs local-first: it reuses the CLI session you already have logged in, so there's **no API key required** — your existing Claude, Cursor, Codex, Gemini, or Copilot subscription does the work at zero marginal cost.

Under the hood, the editor auto-detects nine coding-agent CLIs on your `PATH` (Claude Code, Cursor Agent, Codex, Gemini CLI, GitHub Copilot CLI, OpenCode, Qwen Coder, Aider, and IBM Bob), and drives them through 75 composable skill templates across nine deliverable surfaces: magazine articles, keynote decks, résumés, posters, Xiaohongshu cards, tweet cards, web prototypes, data reports, and Hyperframes videos.

## What Makes It Different

The first thing that stands out is the **"ship-ready" bar**. The README is explicit: "when generation finishes, the artifact is what your audience actually sees. No 'I'll touch it up later' pass." Most AI writing tools output Markdown that needs styling, re-flowing, and screenshotting before it's presentable. HTML Anything skips that — the output is a single self-contained HTML file with inline CSS, ready to publish as-is. This matches how Claude Code's team now ships internal docs: HTML instead of Markdown, because "HTML is the final form for humans. Markdown is just an intermediate state during writing."

Second, the **template system is unusually deep**. The 75 skill templates cover everything from a SaaS landing page prototype to Swiss International keynote decks to Xiaohongshu social cards with platform-specific styling. There are 20 deck skills (Swiss International, Guizang Editorial, XHS Pastel, Hermes Cyber, Replit, Magazine Web), 10 Hyperframes video frames (liquid hero, NYT data chart, glitch title, macOS notification), office documents (PM specs, eng runbooks, finance reports, OKRs, weekly updates, meeting notes), and 3D device mockups. You're not limited to "article" or "post" — the same pipeline produces a résumé, a data report, or a video frame.

Third, **export is one-click and platform-aware**. The `juice` step inlines CSS for WeChat paste with zero re-formatting; `modern-screenshot` renders the iframe to a 2× PNG you can drop straight into a tweet composer; Zhihu equations render automatically; and you can download standalone `.html` or high-DPI `.png` files. Streaming render means you watch the AI generation type out in real time, and previews run in a sandboxed iframe so cookies and localStorage stay quarantined from the host.

## Who It's For

HTML Anything fits three types of users. First, **content creators and writers** who publish across multiple platforms — WeChat, X, Zhihu, newsletters — and are tired of re-flowing the same article into each format. One Markdown draft becomes a designed magazine page, a tweet card, and a WeChat post without touching CSS.

Second, **designers and developers building prototypes**. The `prototype` templates generate web/SaaS landing pages, dashboards, and data reports from raw data (CSV/JSON/SQL parsed locally in the browser), and the sandboxed preview runs Tailwind CDN, Google Fonts, and inline scripts safely. It's a fast way to turn a spec into a clickable artifact.

Third, **teams producing office documents** — PM specs, engineering runbooks, finance reports, HR onboarding, invoices, OKRs, weekly updates, meeting notes, and kanban boards — all available as skill templates with consistent formatting.

Skip it if you're happy with Markdown-to-publish pipelines or need a cloud-hosted SaaS editor: this tool is local-first by design (the agent always runs on your laptop, even if you deploy the web layer to Vercel), so there's no hosted editor and no team collaboration layer. It's Apache-2.0 licensed and free to use with the subscriptions you already pay for.

## Bottom Line

HTML Anything is the most complete agentic HTML editor in the writing-skill ecosystem: 75 templates across 9 output surfaces, zero API key, nine auto-detected coding agents, and one-click platform-aware export — all local-first on top of a 40k-star open-source base. If your agent already writes your drafts, this is the fastest path from raw notes to designed, publishable HTML. For other AI writing tools, see our [copywriting skill intro](/skills/general/copywriting/) and the [AI writing assistants guide](/tutorials/guides/how-ai-writing-assistants-changed-content-creation/).
