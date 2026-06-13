---
title: "Just Scrape"
date: 2026-06-11
draft: false
tags:
  - TypeScript
  - Web Scraping
  - AI
  - CLI
  - Automation
description: "Just Scrape is an AI-powered CLI for web scraping, structured data extraction, web search, and page monitoring via the ScrapeGraph AI API."
version: "1.0.0"
author: "scrapegraphai"
repo_url: "https://github.com/scrapegraphai/just-scrape"
install_cmd: "npm install -g just-scrape@latest"
compatibility:
  - Codex
  - Cursor
  - Claude Code
  - OpenCode
category: "general"
rating: 4.0
github_stars: 27
github_forks: 4
installs: 151226
last_updated: "2026-06-08"
ai_friendliness:
  score: 4.0
  documentation: 4.0
  setup: 3.5
  config: 3.5
---

## What It Is

Just Scrape is a terminal-based web scraping CLI that turns any URL into markdown, structured JSON, screenshots, or summaries using the ScrapeGraph AI API. One command replaces the usual dance of opening browser DevTools, writing custom parsers, and debugging selector breakages when a site changes its layout. It ships as both a standalone npm package and an installable agent skill for Claude Code, Cursor, Codex, and OpenCode.

## What's Actually Different

Most web scraping tools make you write extraction logic — XPath expressions, CSS selectors, or regex patterns that break the moment the target site updates its HTML. Just Scrape skips that entirely. You give it a URL and a plain-English prompt ("extract product names and prices"), and the AI figures out the structure. It also handles the full range of web tasks — search, scrape, extract, crawl, and scheduled monitoring — from a single CLI, so you don't need separate tools for each job. Compared to playing fetch with BeautifulSoup or puppeteer scripts, the maintenance cost is near zero.

## Who It's For

Reach for Just Scrape if you regularly need content from websites but don't want to write and maintain extraction code — researchers collecting data, developers prototyping with web content, or anyone building AI pipelines that consume live web pages. Skip it if you only need a one-off scrape and can copy-paste, or if your scraping needs are better served by a dedicated browser automation framework like Playwright that gives you finer control over JavaScript execution.

## Bottom Line

Just Scrape makes web content extraction feel like asking a question rather than writing a program.
