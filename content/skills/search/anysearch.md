---
title: "AnySearch"
date: 2026-07-04
draft: false
tags:
  - Research
  - AI Search
  - Web Search
  - Data Extraction
description: "Unified real-time search engine skill for AI agents — general web search, vertical domain search, parallel batch queries, and full-page content extraction from a single skill."
version: "2.1.0"
author: "anysearch-ai"
repo_url: "https://github.com/anysearch-ai/anysearch-skill"
install_cmd: "curl -L -o anysearch-skill.zip https://github.com/anysearch-ai/anysearch-skill/archive/refs/tags/v2.1.0.zip && unzip anysearch-skill.zip && mv anysearch-skill-2.1.0 ~/.agents/skills/anysearch"
compatibility:
  - Claude Code
  - Cursor
  - Codex
  - Windsurf
  - OpenCode
category: "search"
rating: 4.0
github_stars: 3939
github_forks: 279
installs: 0
last_updated: "2026-06-28"
ai_friendliness:
  score: 4.0
  documentation: 4.5
  setup: 3.5
  config: 3.5
---

## What It Is

AnySearch is a unified search engine skill for AI agents that replaces the need to manage multiple search APIs or scraping tools. Install it once, and your AI assistant gains the ability to run general web searches, query vertical domains (news, academic papers, documentation), execute parallel batch searches across dozens of queries simultaneously, and extract full-page content from any URL. It wraps multiple search backends behind a single interface so your agent doesn't need to know which engine powers each query.

## What's Actually Different

Most AI search tools force you to pick one backend — SerpAPI for Google results, Tavily for AI-optimized search, or a custom scraper for site-specific extraction. AnySearch abstracts this entirely. You hand it a query and a domain hint, and it routes to the appropriate backend automatically. The parallel batch mode is the standout feature: you can feed it twenty research questions at once, and it returns twenty results sets in roughly the same time a single sequential query would take. For deep research workflows — competitive analysis, literature reviews, market intelligence — this collapses hours of iterative searching into one agent call.

The skill also handles JavaScript-rendered pages through its content extraction pipeline, so you're not limited to static HTML like most search-only tools.

## Who It's For

Worth installing if your AI agent regularly needs to look things up on the web — whether that's checking documentation, researching competitors, gathering pricing data, or running literature reviews. If you find yourself copy-pasting search URLs into your AI assistant, this eliminates that step entirely. Skip it if you only need one search backend and already have a direct API integration set up.

## Bottom Line

AnySearch turns your AI agent into a capable research assistant that can search the web as naturally as it reads your files.
