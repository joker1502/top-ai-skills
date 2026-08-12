---
title: "dbskill: 30 Business Skills Distilled from 16k Tweets"
date: 2026-08-12
draft: false
tags:
  - Business Skills
  - Agent Skills
  - AI Tools
description: "dbskill distills 16,152 public tweets into 30 business skills — pricing, hooks, risk checks, and a /dbs router that picks the right one for you."
version: "2.18.20"
author: "dontbesilent"
repo_url: "https://github.com/dontbesilent2025/dbskill"
install_cmd: "npx -y skills add dontbesilent2025/dbskill -g --all"
compatibility:
  - Claude Code
  - Codex
  - Doubao
  - WorkBuddy
category: "general"
rating: 4.5
github_stars: 9441
github_forks: 1089
installs: 0
last_updated: "2026-08-12"
ai_friendliness:
  score: 4.5
  documentation: 4.5
  setup: 4.5
  config: 4
---

The missing piece in most agent workflows isn't another tool — it's business judgment. dbskill is a 9.4k-star pack of 30 skills that gives your agent that judgment: it takes a messy business question like "why won't my customers renew" and runs it through a diagnosis pipeline built from 16,152 real tweets. The [official README](https://github.com/dontbesilent2025/dbskill) explains the origin: "dbskill distills 4,176 structured knowledge atoms and 30 directly callable Skills from 16,152 public posts" by dontbesilent, a Chinese creator who spent years answering paid business questions.

## What It Is

dbskill is a router plus a toolkit. The router is `/dbs` — one entry point that reads your conversation, decides which of the 30 skills fits, and hands off. The skills cover twelve job families: business diagnosis (`/dbs-diagnosis`), competitor benchmarking (`/dbs-benchmark`), content direction and hooks (`/dbs-content`, `/dbs-hook`), pre-publish risk checks (`/dbs-content-risk-check`), resonance and script-flow review, goal deconstruction, procrastination unblocking (`/dbs-action`), decision journaling (`/dbs-decision`), folder-to-knowledge-base conversion (`/dbs-knowledge`), and even a skill-cleaner that audits your other installed skills for risk.

Installation takes one command: `npx -y skills add dontbesilent2025/dbskill -g --all`. Claude Code users can also add it as a plugin marketplace (`claude plugin marketplace add dontbesilent2025/dbskill`). It runs on Claude Code, Codex, Doubao, WorkBuddy, and anything else that speaks the Agent Skills format. Current release is v2.18.20, licensed CC BY-NC 4.0.

## What Makes It Different

**The knowledge came from real questions, not theory.** The author ran paid consultations — over 8,000 of them — and encoded what he learned into the skills. The diagnosis skill states the outcome bluntly: only 0.9% of those questions were actually *answered*; the other 99.1% were *dissolved*, because the question itself was wrong. That's a very different design goal from most business advice skills, which assume the question is valid and rush to an answer.

**The diagnosis skill forces you to define your terms.** Its funnel checks, layer by layer, for undefined words ("is your renewal rate *low* — compared to what?"), false assumptions ("you're assuming the cause is product, pricing, or customers — what if it's none of them?"), logic errors (correlation dressed as causation), and missing facts. Each layer stops and waits for your reply. The skill's own axioms are aggressive: "pricing is product design" (the gap between loss-leader and profit product should be ~10x), "a business model is a machine that doesn't care who feeds it."

**The router treats "I don't know" as a first-class input.** Tell `/dbs` you're stuck and it picks the path — newbie tutorial, direct routing, or post-task navigation after another skill finished. One skill even exists purely to pull you out of procrastination (`/dbs-slowisfast`). This "return to the router when lost" loop is a pattern most skill packs don't ship.

## Who It's For

dbskill fits three groups. **Solo founders and small operators** get a structured second opinion on pricing, positioning, and churn — the README's quick-start example walks through a children's coding class with 40 paid students and low renewals. **Content creators** get hook, title, and script-flow skills plus a pre-publish risk check that flags machine-review triggers before you post. **Teams running Claude Code or Codex daily** get a decision log (`/dbs-decision`, `/dbs-save`, `/dbs-restore`) so recurring choices accumulate instead of evaporating.

Skip it if you need English-only skills — I checked five SKILL.md files and every one came written in Chinese, even though the READMEs ship in five languages. Skip it for commercial use too: the CC BY-NC 4.0 license blocks commercial projects. And if you want one cohesive skill rather than a 30-piece toolkit, this pack's breadth will drown you in options.

## Bottom Line

dbskill is the most opinionated business skill pack on the skills.sh leaderboard: real consultation data behind the methods, a funnel that kills bad questions instead of answering them, and a router that keeps the whole system usable. If you run a business with an agent and can read Chinese, install it and start with `/dbs-diagnosis` — pair it with [Baoyu Skills](/skills/writing/baoyu-skills/) for content production or [NotebookLM Skill](/skills/general/notebooklm/) for research, and see our [hands-on install and diagnosis test](/tutorials/guides/dbskill-install-and-diagnosis-test/) for what actually happens when you run it.
