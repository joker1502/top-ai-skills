---
title: "Khazix Skills: 6 Practical Agent Skills for Claude Code"
date: 2026-08-08
draft: false
tags:
  - Agent Skills
  - AI Writing
  - AI Tools
description: "Khazix Skills bundles six battle-tested agent skills from a 19k-star repo — goal definition, disk cleanup, AI news, and personal-style writing for Claude Code."
version: ""
author: "KKKKhazix"
repo_url: "https://github.com/KKKKhazix/khazix-skills"
install_cmd: "帮我安装这个 skill：https://github.com/KKKKhazix/khazix-skills/tree/main/<skill-name>"
compatibility:
  - Claude Code
  - Codex
  - Cursor
category: "writing"
rating: 4.5
github_stars: 19380
github_forks: 2123
installs: 0
last_updated: "2026-08-08"
ai_friendliness:
  score: 4.5
  documentation: 4.5
  setup: 4.0
  config: 4.0
---

## What It Is

Khazix Skills is a 19.4k-star collection of six AI agent skills open-sourced by 数字生命卡兹克 (Khazix), founder of Xushi Media, for daily personal use. The [official README](https://github.com/KKKKhazix/khazix-skills) describes it plainly: "AI Skills I use every day, all open-sourced here — nothing fancy, just a few genuinely practical things." Every skill is a structured instruction set an agent can load directly, following the [Agent Skills open standard](https://agentskills.io) that Claude Code, Codex, Qoder, Kimi Code, iFlow, CodeBuddy, Cursor, and 40+ agents can install.

The six skills cover very different jobs: **leader** turns a vague idea into a formal goal document an agent can run autonomously for hours; **storage-analyzer** scans a whole Mac or Windows disk and produces a color-coded cleanup report in the browser; **aihot** pulls the daily AI HOT digest from aihot.virxact.com with one sentence and no API key; **neat-freak** realigns project docs, CLAUDE.md, and agent memory after every task; **hv-analysis** researches a product, company, or concept into a 10,000–30,000-word PDF report; and **khazix-writer** makes the agent write long-form WeChat articles in the author's own voice and rhythm.

## What Makes It Different

The first thing that stands out is that **every skill was run in production before being open-sourced**. The README's stated filter is explicit: only things "that ran in my own projects for a while and genuinely saved me effort" make the cut. That's a different quality bar than most skill repos, where skills are written speculatively and never exercised. Each one also ships with a real-world use case — the storage-analyzer's README even documents how it identified a 97 GB UUID container as Bilibili offline video cache and recommended cleaning it inside the app rather than deleting it by hand.

Second, the **leader skill treats "what not to do" as the core of goal-setting**. The README's argument is that the most important part of a goal is its harness: JFK's moon speech mattered because of "and safely return them to Earth," not because of "land on the Moon." The skill encodes a "seven questions" framework (purpose, completion state, evidence, anti-cheating, boundaries, trade-offs, unknowns) plus a zeroth question — verify the map yourself before sailing. It even recommends pairing models: a strong planner (Claude Fable 5) to write the goal and a strong executor (GPT-5.6 Sol) to run it.

Third, **safety is designed in rather than promised**. The storage-analyzer is strictly read-only by default: every deletion requires a browser button click plus a second confirmation dialog, runs on 127.0.0.1 with a random port and token, and uses a three-tier whitelist (green = cache you can delete, yellow = user data you move to trash, red = system files you can only open). neat-freak likewise never deletes anything without a candidate list you confirm, and treats machine-generated memory as read-only by default.

## Who It's For

Khazix Skills fits three types of users. First, **Claude Code and Codex users who want goal-driven long-running tasks**. If you've ever wanted to paste a vague idea and let an agent work for hours, the leader skill's goal documents are designed for exactly that — the README suggests triggers like "help me write a goal for the agent" or "let the agent run this project on its own," and the output is pure Markdown that works even without a goal mode.

Second, **writers who want a specific voice rather than generic prose**. khazix-writer is opinionated by design: it refuses clichés like "empower, leverage, closed loop," rejects "firstly... secondly" and "in today's rapidly developing AI era," and enforces the author's own rhythm through a four-layer self-check (structure, pacing, content, wording). It's the opposite of a generic "improve this text" prompt.

Third, **solo operators doing research and housekeeping**. hv-analysis produces structured PDF research reports for competitive analysis or concept deep-dives, aihot keeps you current on AI news without configuring an API key, and storage-analyzer replaces CleanMyMac-style utilities with an agent-driven, explainable cleanup flow.

Skip it if you want a single cohesive skill rather than a grab-bag — these are six independent tools with different purposes, and you should install only the ones you need. It's MIT licensed.

## Bottom Line

Khazix Skills is the rare skill repo where everything is proven in daily use: goal documents that let agents run for hours, an agent-driven disk cleaner with real safety rails, no-API-key AI news, project doc hygiene, deep-research PDFs, and a writing voice that actively rejects AI-slop phrasing. If you use Claude Code or Codex daily, install the two or three that match your workflow — pair the goal-focused `leader` skill with the [Baoyu Skills](/skills/writing/baoyu-skills/) pipeline for long-running content tasks, or use `khazix-writer` alongside the [HTML Anything skill](/skills/writing/html-anything/) to go from idea to published page. For a first-person take on AI writing workflows, see our [guide on how AI writing assistants changed content creation](/tutorials/guides/how-ai-writing-assistants-changed-content-creation/).
