---
title: "Caveman: Cut AI Response Tokens by 75% Without Losing Accuracy"
date: 2026-06-03
toc: true
draft: true
tags:
  - Productivity
  - Token
  - AI Agent
  - Tutorial
description: "Caveman makes Claude Code and other AI assistants respond with 75% fewer tokens while maintaining full technical accuracy. Setup in 30 seconds."
category: "guides"
rating: 5
related_skills:
  - vercel-react-best-practices
---

## What Caveman Does

It makes AI coding assistants shut up — not by making them dumber, but by stripping filler.

Before Caveman, Claude Code explains a React re-render like this:

"The reason your React component is re-rendering is likely because you're creating a new object reference on each render cycle. This causes React to see the prop as changed, triggering a re-render..."

After Caveman:

"New object ref each render. Inline object prop = new ref = re-render. Wrap in `useMemo`."

Same fix. 69 tokens down to 19. 72% reduction.

## Setup

30 seconds.

```bash
# macOS / Linux / WSL
curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh | bash

# Windows PowerShell
irm https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.ps1 | iex
```

Requires Node.js 18+. The install script auto-detects which AI coding tools you have and installs only for those. Type `/caveman` in Claude Code or say "talk like caveman" to activate. Say "normal mode" to stop.

## Four Compression Levels

| Level | Effect | Best For |
|-------|--------|----------|
| lite | Removes filler only, keeps sentences | Daily use |
| full | Default caveman mode | Most scenarios |
| ultra | Telegram-style, extreme minimal | Quick bug triage |
| wenyan | Classical Chinese style, even shorter | Fun |

## Extra Features

`/caveman-commit` — Generates Conventional Commit messages with subject lines under 50 chars, emphasizing "why" over "what."

`/caveman-review` — Single-line PR review comments: `L42: 🔴 bug: user null. Add guard.`

`/caveman-stats` — Real-time token usage, lifetime savings, and dollar amounts. Add `--share` for a shareable stats line.

`/caveman-compress <file>` — Rewrites CLAUDE.md and project memory files. Average 46% input token reduction while preserving code, URLs, and paths verbatim.

## What Surprised Me

Compression is better than expected. Official benchmarks show 65% average reduction across 10 tasks, and my experience matches. The React re-render example went from 1,180 to 159 tokens — 87% reduction.

It only affects output tokens. Thinking/reasoning tokens are completely untouched. A 2026 paper found that constraining models to be concise actually improved accuracy by 26 points on some benchmarks. Less talk, more correct.

## Things to Watch Out For

Not all 30+ supported AI agents have identical feature sets. Main ones (Claude Code, Cursor, Codex, Windsurf, Cline, Copilot) are fully supported. The status bar badge `[CAVEMAN] ⛏ 12.4k` in Claude Code updates on each `/caveman-stats` run. Set `CAVEMAN_STATUSLINE_SAVINGS=0` to disable.

## What's Next

Try different compression levels to find your daily sweet spot. Pair with caveman-shrink (MCP middleware) for compressed tool descriptions and cavecrew sub-agents for reduced sub-task token usage.
