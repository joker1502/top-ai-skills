---
title: "GPT Researcher"
date: 2026-07-01
draft: false
tags:
  - Research
  - AI Search
  - Deep Research
  - Autonomous Agent
  - Python
keywords:
  - GPT Researcher
  - deep research agent
  - autonomous research
  - AI research tool
  - Claude Code skill
  - open source research
  - multi-agent research
description: "GPT Researcher is an open-source deep research agent that produces detailed, factual reports with citations from web and local documents. Install it as a Claude Code skill for autonomous research."
version: "3.5.1"
author: "assafelovic"
repo_url: "https://github.com/assafelovic/gpt-researcher"
install_cmd: "npx skills add assafelovic/gpt-researcher"
compatibility:
  - Claude Code
  - Cursor
  - Codex
  - OpenCode
category: "search"
rating: 4.5
github_stars: 28001
github_forks: 3779
installs: 120000
last_updated: "2026-06-28"
ai_friendliness:
  score: 4.5
  documentation: 5.0
  setup: 4.0
  config: 4.5
---

## Overview

GPT Researcher is the first open-source deep research agent designed for both web and local research. Instead of switching between browser tabs, PDF readers, and note-taking apps, you describe what you need to investigate, and the agent autonomously plans a research strategy, gathers information from 20+ sources, cross-references findings, and delivers a structured report with citations.

Built on the Plan-and-Solve and RAG research paradigms, GPT Researcher solves the core problems of manual research — weeks of effort, limited perspectives, and unintentional bias — by parallelizing the research process across planner and execution agents. A planner agent decomposes your query into sub-questions, execution agents crawl and summarize each angle, and a publisher agent assembles everything into a coherent report.

It went viral on launch (top trending on GitHub for 3 days straight) and is now used by researchers, analysts, students, and enterprises worldwide.

## Key Features

- **Autonomous deep research** — generate 2,000+ word reports with citations from 20+ web sources
- **Local document research** — analyze PDFs, Word docs, and local files alongside web sources
- **Smart image scraping** — relevant images are automatically filtered and embedded in reports
- **Multi-format export** — save reports as PDF, Word, Markdown, or HTML
- **Planner + execution agent architecture** — parallelized information gathering for speed
- **MCP server support** — integrate with any MCP-compatible agent
- **JavaScript-enabled crawling** — handles modern SPAs and dynamic content
- **Browser-based frontend** — lightweight HTML/CSS/JS and production Next.js dashboard

## What Makes It Different

Most research tools either require manual prompting at every step or use a single LLM call that hallucinates. GPT Researcher takes a different approach: it treats research as a multi-agent workflow. The planner breaks your question into concrete sub-tasks, each execution agent independently gathers and summarizes information, and the publisher validates facts before assembling the final report. This means you get depth (multiple angles explored) and reliability (each claim is source-tracked).

Compared to using Google Scholar or general ChatGPT for research, GPT Researcher excels at breadth — it will simultaneously pull from news articles, academic papers, documentation, and blog posts, then synthesize them into a single coherent narrative. It's particularly strong at getting you up to speed on unfamiliar topics fast.

## Who It's For

Get GPT Researcher if you regularly need to produce well-sourced research reports — whether for market analysis, academic literature reviews, competitive intelligence, or due diligence. It saves the most time on open-ended research questions where you'd normally spend hours clicking through search results.

Skip it if you only need quick fact-checks or simple Q&A — a direct LLM chat is faster for one-off questions.

## Installing as a Claude Code Skill

```bash
npx skills add assafelovic/gpt-researcher
```

Once installed, Claude Code gains deep research capabilities. You can also run it standalone via pip or Docker.

## Bottom Line

GPT Researcher turns weeks of browser-tab hell into a single agent conversation. Tell it what to investigate, come back to a cited report.

