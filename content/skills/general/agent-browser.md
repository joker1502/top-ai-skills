---
title: "Agent Browser"
date: 2026-06-07
draft: false
tags:
  - Browser Automation
  - CLI
  - AI Agent
description: "Rust-powered browser automation CLI for AI agents. Control Chrome, Safari, and cloud browsers via terminal commands."
version: "0.27.1"
author: "Vercel Labs"
repo_url: "https://github.com/vercel-labs/agent-browser"
install_cmd: "npx skills add vercel-labs/agent-browser"
compatibility:
  - Claude Code
  - Cursor
  - Codex
category: "general"
rating: 4.0
github_stars: 35638
github_forks: 2245
installs: 338000
last_updated: "2026-06-05"
ai_friendliness:
  score: 4.0
  documentation: 4.0
  setup: 4.0
  config: 4.0
---

## What It Is

Agent Browser is a Rust-native CLI that lets AI agents control real browsers through terminal commands. It talks to Chrome (and Safari, Brave, Edge) via the Chrome DevTools Protocol, so your AI assistant can open pages, click elements, fill forms, take screenshots, and extract content without you writing a single selector.

## What's Actually Different

Most browser automation for AI is Python-based (Playwright, Browser Use). Agent Browser is written in Rust and designed specifically for the CLI workflow. It returns page snapshots as structured accessibility trees with element references (`@e1`, `@e2`), which makes it much easier for an AI to reason about "what to click next" than raw DOM or screenshots alone.

It also supports multiple browser engines (Chrome, Safari, iOS simulator) and cloud browser providers (Browserbase, Steel, etc.), which the Python tools generally don't.

## Who It's For

Use it when your AI agent needs to interact with web pages as part of a task — scraping JavaScript-heavy sites, filling multi-step forms, or testing web apps. If you just need to read static HTML, a simple fetch tool is faster and cheaper.

## Bottom Line

Agent Browser gives your AI agent a real pair of eyes and hands for the web — fast, multi-engine, and built for the terminal.
