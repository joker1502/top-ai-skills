---
title: "Agent Browser Setup Guide: Vercel's CLI for AI-Powered Browser Automation"
date: 2026-06-03
toc: true
draft: true
tags:
  - Browser Automation
  - AI Agent
description: "Agent Browser is a Rust-based browser control CLI built by Vercel Labs. Once installed, your AI assistant can control browsers directly from the terminal."
category: "guides"
rating: 4
related_skills:
---

## What You Get After Installing

Once Agent Browser is set up, your AI assistant can open browsers, click buttons, fill forms, take screenshots, and extract page content through terminal commands. It's not a tool for writing automation scripts manually — it's built for AI agents. The AI sees a page snapshot and decides what to click next.

Unlike Browser Use (Python ecosystem), Agent Browser is implemented in Rust and communicates via the Chrome DevTools Protocol. No Node.js runtime needed for browser control. Fast startup, fits naturally into CLI workflows.

## Before You Start

Make sure you have:

- Node.js 18+ (for npm-installing the CLI itself; browser control doesn't need Node)
- Or Homebrew on macOS, or a Rust environment to install via Cargo
- Roughly 500MB disk space (first install downloads Chrome for Testing)

```bash
node -v   # confirm 18+
```

## Installation

The fastest way is npm global install:

```bash
npm install -g agent-browser
```

After installing, download the browser on first use:

```bash
agent-browser install
```

This automatically downloads Chrome for Testing. If you already have Chrome or Brave installed locally, Agent Browser can detect and reuse them.

On Linux, add a flag to install system dependencies:

```bash
agent-browser install --with-deps
```

macOS users can also use Homebrew:

```bash
brew install agent-browser
agent-browser install
```

## Verify the Installation

Try opening a page:

```bash
agent-browser open https://example.com
```

If the browser launched (or headless mode ran without errors), you're good. Next, grab a page snapshot:

```bash
agent-browser snapshot -i --json
```

It returns the page's accessibility tree, with each interactive element tagged with a reference marker (`@e1`, `@e2`, etc.). AI agents use these markers to locate elements.

Interact with elements using the markers:

```bash
agent-browser click @e2        # click the button tagged @e2
agent-browser fill @e3 "hello"  # type "hello" into the input tagged @e3
```

## Configuration

Create an `agent-browser.json` in your project root to customize behavior:

```json
{
  "$schema": "https://agent-browser.dev/schema.json",
  "headed": true,
  "proxy": "http://localhost:8080",
  "profile": "./browser-data"
}
```

Priority from lowest to highest: user config (`~/.agent-browser/config.json`) → project config (`agent-browser.json`) → env vars (`AGENT_BROWSER_` prefix) → CLI args.

## One Thing to Watch Out For

The default operation timeout is 25 seconds. If you set it above 30 seconds, the CLI may return EAGAIN errors. If an operation hangs, check your timeout setting before reinstalling the browser.

Windows users also need to close all Chrome windows before using the `--profile` flag to reuse Chrome login state — otherwise the profile gets locked.

## Agent Browser vs Browser Use

Both work in Claude Code or Cursor. Browser Use has a more mature ecosystem (96k Stars) and larger community. Agent Browser performs better (Rust-native), supports multiple browser engines (Chrome, Safari, iOS simulator, cloud browsers), and includes security features like domain allowlists and operation policies.

Choose Agent Browser if you need iOS Safari control or cloud browser integration. Choose Browser Use if you just need basic web automation with a lower setup barrier.

## What's Next

Try having your AI agent run a complete task flow — "open this website, log in, extract that data." Agent Browser supports batch commands and session persistence for chaining complex workflows. Pair it with find-skills to discover more available skills — browser automation is just the start.
