---
title: "Agent Device"
date: 2026-06-28
draft: false
tags:
  - Mobile
  - Device Automation
  - Testing
  - iOS
  - Android
  - E2E Testing
description: "agent-device is a CLI for AI agents to control iOS and Android devices. Inspect UI, tap buttons, scroll, and capture screenshots — all from natural language commands."
version: "0.19.3"
author: "callstackincubator"
repo_url: "https://github.com/callstackincubator/agent-device"
install_cmd: "npm install -g agent-device@latest"
compatibility:
  - Claude Code
  - Cursor
  - Codex
  - GitHub Copilot
  - Cline
  - Windsurf
category: "general"
rating: 4.6
github_stars: 3379
github_forks: 186
installs: 18000
last_updated: "2026-07-15"
ai_friendliness:
  score: 8.5
  documentation: 9
  setup: 8
  config: 8
---

## Overview

**agent-device** is an open-source CLI that gives AI agents hands-on access to real mobile devices — iOS simulators, Android emulators, physical phones, TVs, and even desktop apps. Think of it as [agent-browser](https://topaiskills.com/skills/general/agent-browser/) for mobile: instead of reasoning about code blindly, your agent can open an app, look at what's on screen, tap buttons, type text, scroll around, and grab screenshots or logs to verify what's actually happening.

Built by [Callstack](https://www.callstack.com/) (the React Native pros), it already has over 3,300 GitHub stars and integrates with Claude Code, Cursor, Codex, and other major coding agents. If you ship mobile apps and use AI agents to write or review code, this is the missing feedback loop.

## Quick Install

```bash
npm install -g agent-device@latest
agent-device doctor
```

Run `agent-device doctor` first to check your local setup — it'll tell you if Xcode, Android SDK, or ADB are missing. The CLI works on macOS (for iOS) and Linux (for Android), with Windows support for Android-only workflows via WSL.

## Key Features

- **Inspect real app UI** — get structured accessibility snapshots of any screen, with interactive element references like `@e3` so agents can target specific buttons or inputs.
- **Interact naturally** — open apps, tap, type, scroll, swipe, wait for elements, dismiss alerts. All through simple CLI commands your agent can call.
- **Capture evidence** — screenshots, screen recordings, device logs, network traffic, CPU/memory profiles, and crash context. Useful for debugging regressions and reviewing PRs.
- **Replay workflows** — record `.ad` scripts that can be replayed locally, in CI, or exported as Maestro YAML for stricter e2e pipelines.
- **Multi-platform** — iOS Simulator, Android Emulator, physical devices, tvOS, Android TV, macOS, and Linux desktop apps. Same interface, different targets.

## Compatibility & AI-Friendliness

**In short: very friendly.** The CLI outputs clean JSON and structured text that agents parse reliably. Commands are consistent (`agent-device snapshot`, `agent-device tap @e3`, `agent-device screenshot`), and the help output is designed to be read by both humans and LLMs.

The documentation is thorough — inline CLI help is the source of truth, with a full [website](https://oss.callstack.com/agent-device) for deeper setup guides. Most agents figure out the basics from the help output alone, no hand-holding needed.

## Real Talk

I installed agent-device to test it with Claude Code on a React Native PR. The `doctor` command caught that I was on Node 20 (needs 22+) and pointed me to the exact download. Once set up, I asked Claude to open the app, navigate to the settings screen, and take a screenshot. It worked on the first try — the agent used `agent-device snapshot -i` to find the gear icon, tapped it via its ref, waited for the new screen, then snapped a picture.

The tool is still pre-1.0 (0.19.3 at time of writing), so expect rough edges on exotic device configurations. But for the common case — iOS Simulator + Android Emulator — it's solid. If you're doing agent-driven mobile development, this is worth your time.

