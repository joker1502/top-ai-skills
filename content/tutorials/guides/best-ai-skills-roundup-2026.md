---
title: "7 Best AI Skills Every Developer Should Install in 2026"
date: 2026-06-24
draft: false
toc: true
category: "guides"
tags:
  - AI Skills
  - Developer Tools
  - Productivity
  - Roundup
description: "A curated roundup of 7 must-install AI agent skills for developers, from plan review and issue triage to architecture analysis and browser automation."
related_skills:
  - grill-me
  - triage
  - improve-codebase-architecture
  - tdd
  - agent-browser
  - just-scrape
  - find-skills
---

## The Problem

There are thousands of AI agent skills on [skills.sh](https://skills.sh). Most developers I talk to install two or three and stop exploring. The ones they miss turn out to be the ones they actually need.

The problem isn't finding skills — it's knowing which ones solve real problems. Half the skills on the directory are one-shot prompts wrapped in a package. You install them, run them once, and never touch them again. The other half are genuinely useful tools that change how you work with AI agents day to day.

I've been running AI coding agents for over a year. In that time I've cycled through dozens of skills across categories: coding, automation, search, image generation, and general productivity. Most lasted a day. Some lasted a week. These seven made it into my permanent setup.

This is not a theoretical list. Every skill here survived real use on real projects.

### Selection Criteria

Every skill on this list had to meet three tests:

- **Solves a recurring problem**, not a hypothetical one. If I couldn't remember the last time I faced the problem it claims to solve, it didn't make the cut. No skills that sound impressive in a README but sit unused.
- **Works across multiple coding agents** (Claude Code, Cursor, Codex). Skills that only work with one platform are too limiting for a general recommendation. All seven install via `npx skills add` and work with most major agents.
- **Has real installs (100K+) and active maintenance.** Dead skills are worse than no skills. If a skill hasn't been updated in six months or has fewer than 100K installs on skills.sh, it's excluded regardless of how clever the concept is.

## Quick Comparison Table

| Skill | Category | Installs | Author | Best For | Setup Time |
|-------|----------|----------|--------|----------|------------|
| Grill Me | Plan Review | 253K | Matt Pocock | Catching plan flaws before coding starts | 1 min |
| Find Skills | Discovery | 2.1M | Vercel Labs | Finding new skills directly from terminal | 1 min |
| Triage | Issue Mgmt | 241K | Matt Pocock | Automating issue triage and agent briefs | 5 min |
| Improve Architecture | Code Quality | 205K | Matt Pocock | Finding deep architectural issues in codebases | 2 min |
| TDD | Testing | 297K | Matt Pocock | Test-driven development enforced by AI | 2 min |
| Agent Browser | Automation | 480K | Vercel Labs | Browser automation through natural language | 3 min |
| Just Scrape | Data | 115K | ScrapeGraphAI | Web scraping described in plain English | 1 min |

## Individual Entries

### Grill Me

**Verdict**: The skill I tell every developer to install first.

Grill Me makes your AI interrogate your plan before writing any code. Instead of the usual "great idea, let me implement it" response, the agent asks you questions: *What's the edge case here? Have you considered this alternative? What happens when x assumption breaks?* Each question builds on the last.

The effect is immediate. The first time I used it, I realized I'd been skipping the most valuable part of AI-assisted development — the exploration of what I *actually* want. Most of us open a chat with an AI agent and start describing the solution. Grill Me forces you to describe the problem first.

Read the full [Grill Me skill intro](/skills/general/grill-me/) for details on setup and compatibility.

**Who it's for**: Anyone who has ever started implementing a feature only to realize halfway through that the approach was wrong. If you sketch out plans in your head or in a quick chat message, this skill forces the rigor of a design review without needing a second person.

**Standout feature**: The grilling session is conversational — one question at a time. You don't get a wall of fifty questions dumped on you. Each answer shapes the next question, so the conversation stays focused on the parts of your plan that actually have risk.

**Caveat**: It works best for well-scoped changes. If you're in the discovery phase of a large feature and don't know what you want yet, the grilling questions can feel premature. Let it sit until you have at least a rough direction.

### Find Skills

**Verdict**: Install this before any other skill, because you'll use it to find the others.

Find Skills is the terminal-based skill browser. Instead of opening skills.sh in a browser, searching for a skill, copying the install command, and switching back to your terminal, you run `/find-skills` and search right inside your coding agent. It shows descriptions, install counts, and agent compatibility at a glance.

The [Find Skills skill page](/skills/search/find-skills/) explains its full feature set, but the killer use case is this: when you're in the middle of a task and realize you need a skill you don't have, you can discover and install it in under 30 seconds without leaving your editor.

**Who it's for**: Anyone who plans to install more than one skill. If you're the type who types `npm search` instead of browsing the npm website in a browser, this will feel natural.

**Standout feature**: It shows install counts directly in search results. When you see a skill with 2.1M installs next to one with 500, the decision practically makes itself.

**Caveat**: Search doesn't show install counts in every view mode, and long natural-language queries sometimes return empty results. Short, specific keywords like "triage" or "grill" work more reliably than full sentences.

### Triage

**Verdict**: The best skill for anyone maintaining an open-source project.

Triage turns your AI into a maintainer assistant. It reads each issue or pull request, categorizes it as bug or enhancement, and moves it through a state machine: needs-triage → needs-info (when more details are required) → ready-for-agent (when it's fully specified and an AI can implement it) → ready-for-human or wontfix.

The workflow is thorough. For bugs, the skill attempts to reproduce the issue from the reporter's steps before writing an agent brief. For enhancements, it scans the codebase to check if the requested feature already exists and reads `.out-of-scope` docs for prior rejections. It even handles external PRs as "issues with attached code."

The [Triage skill intro](/skills/coding/triage/) covers the full state machine.

**Who it's for**: Maintainers of projects with more than ~20 open issues. Below that threshold, the setup time of configuring issue labels and tracker integration takes longer than the time it saves.

**Standout feature**: The agent briefs it generates for `ready-for-agent` issues are structured enough that another AI agent can pick up the issue and implement it without human clarification. This makes it possible to run an async triage pipeline where one agent triages and another implements.

**Caveat**: Setup requires running `/setup-matt-pocock-skills` first to configure your issue tracker and label mapping. It's a one-time config, but it takes about five minutes and requires a GitHub token with issue write access.

### Improve Codebase Architecture

**Verdict**: More useful than it sounds.

This skill scans your codebase for architectural issues — module coupling, responsibility blur, abstraction mismatches — based on your project's domain language and ADRs (Architecture Decision Records). It doesn't suggest extracting a function or renaming a variable. It finds the structural problems that make code harder to change over time.

The [Improve Codebase Architecture page](/skills/coding/improve-codebase-architecture/) describes the full workflow. The key insight is that it first reads your project's domain model (from a `CONTEXT.md` file) and only then looks at the code. This matters because the same architectural pattern can be right in one codebase and wrong in another, depending on the domain.

**Who it's for**: Teams working on codebases that are 6+ months old. New projects change too fast for architectural analysis to be useful. Mature codebases with growing technical debt get the most value.

**Standout feature**: It produces a visual HTML report with clickable areas for each finding. You can drill into any issue and discuss it with the agent, asking for code examples or alternative approaches for each identified problem.

**Caveat**: It works best with a `CONTEXT.md` file that defines your project's domain language. Without shared vocabulary, the architecture recommendations are generic — still useful, but not as sharp.

### TDD

**Verdict**: The most polarizing skill on this list — you'll either love it or skip it entirely.

TDD enforces a strict red-green-refactor cycle in your AI agent. You write a failing test, the agent makes it pass using the simplest implementation, then you refactor together. The agent does not skip steps or jump ahead. It's pedantic by design — that's the point.

The [TDD skill page](/skills/general/tdd/) has installation details. The practice of TDD with AI is different from TDD with a human pair: the AI is faster at the green phase but needs more guidance during refactoring. This skill accounts for that asymmetry.

**Who it's for**: Developers who already practice TDD manually and want their AI to follow the same discipline. Also useful for teams with compliance requirements around test coverage, where you need proof that tests were written before code.

**Standout feature**: The skill maintains a session log of which tests were written and whether each passed before moving to the next. You can review the log mid-session to see the full TDD cycle history.

**Caveat**: It slows down your AI considerably. For prototyping or throwaway code, TDD mode is overkill. The session log also adds token overhead. Use it on production changes where test quality matters, not on experimental branches.

### Agent Browser

**Verdict**: The most practical automation skill in the directory.

Agent Browser lets your AI control a browser from the terminal. Fill forms, take screenshots, extract data, navigate multi-step workflows — all through natural language commands. It uses Playwright under the hood but exposes a conversational interface.

The [Agent Browser skill page](/skills/general/agent-browser/) covers setup and agent compatibility. I've used it for tasks ranging from checking CI dashboard status to logging into SaaS services and exporting reports. Anything you'd normally script with Puppeteer or Playwright can be done with a single chat command.

**Who it's for**: Developers who automate any kind of web workflow. Testing form submissions, monitoring dashboards, extracting job listings, filling repetitive forms — if you've ever written a scraping script for a one-off task, this replaces it with a conversation.

**Standout feature**: The skill handles complex multi-step workflows. You can say "go to Gmail, search for the latest invoice from AWS, download the PDF attachment, and save it to /downloads" and it executes the entire sequence.

**Caveat**: It requires running a local browser instance via Playwright. This means it doesn't work in headless CI environments without Xvfb or similar display server setup. For local development use it works out of the box.

### Just Scrape

**Verdict**: Simple, focused, and honest about what it does.

Just Scrape takes a URL and a natural-language description of what you want and returns structured data. No CSS selectors, no XPath expressions, no config files. Describe what you need — "the title, price, and availability of all products on this page" — and the skill figures out the logic.

Check the [Just Scrape skill intro](/skills/general/just-scrape/) for compatibility details. The skill handles pagination and JavaScript-rendered content without extra configuration, which is the main thing that sets it apart from naive scraping approaches.

**Who it's for**: Developers who need to extract data from websites occasionally but don't want to learn Scrapy or maintain a scraping pipeline. If the site structure changes, you just re-describe what you want and the skill adapts.

**Standout feature**: It handles JavaScript-rendered content and pagination automatically. Most sites work out of the box without you needing to specify selectors or page structure.

**Caveat**: Not designed for large-scale scraping. If you need to extract data from tens of thousands of pages daily, you need proper scraping infrastructure (proxies, queues, storage). For one-off or periodic extractions of up to a few hundred pages, it's ideal.

## How I Picked These

I started with the top 50 skills on skills.sh by install count, plus recommendations surfaced through Find Skills. Over two weeks, I installed each candidate, ran it in real development scenarios, and noted which ones I kept reaching for organically versus ones I had to remind myself to use.

Skills I tested but excluded:

- **Remotion Best Practices** (346K) — useful if you work with Remotion for programmatic video, but too niche for a general developer roundup.
- **Vercel React Best Practices** (447K) — solid for Vercel and Next.js projects, but limited to that ecosystem.
- **Caveman** (205K) — interesting concept about reducing AI token usage, but I found myself overriding its suggestions more often than following them.
- **Microsoft Foundry** (365K) — capable in Azure environments, but most of its value is tied to the Azure integration rather than the AI skill itself.
- **Brainstorming** (240K) — works for idea generation, but overlaps too much with what base models already do well.

The seven that made the cut have one thing in common: they do something the base model can't do on its own. A skill that just adds a prompt prefix or tweaks system instructions won't stay installed. These seven add actual capabilities — browser control, codebase analysis, issue triage, structured testing — that change what your AI agent can accomplish.

## Which One I'd Pick

If I could keep only one, it's Grill Me. It changes the most fundamental part of the AI interaction — how you plan before you build. Every other skill on this list makes you faster at specific tasks. Grill Me makes you less wrong before you start, which is harder to measure and more valuable over time.

If you already have a planning habit and want one more, Agent Browser has the highest surprise factor. It does things most developers don't know an AI agent can do from a terminal. Watching it log into a website, navigate three pages deep, and extract data in one shot still feels like a party trick after the tenth time.

If you're a maintainer or work on a team project with active issue tracking, swap Agent Browser for Triage. The time it saves on issue triage alone will free up more hours than any automation skill.
