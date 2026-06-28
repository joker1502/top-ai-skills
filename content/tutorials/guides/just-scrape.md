---
title: "AI-Powered Web Scraping: A Guide to Just Scrape CLI"
date: 2026-06-11
draft: false
tags:
  - Web Scraping
  - AI
  - CLI
  - Automation
  - Data Extraction
description: "Learn how to scrape websites, extract structured data, search the web, and monitor page changes using the Just Scrape AI-powered CLI tool."
toc: true
category: "guides"
related_skills:
  - just-scrape
---

## What This Gets You

This tutorial walks through installing and using Just Scrape — an AI-powered CLI that scrapes web pages, extracts structured JSON, searches the web, crawls site sections, and monitors pages for changes. By the end you will have a working setup that turns any URL into usable content with a single command and understand when to use each of its eight subcommands. The whole process takes about 10 minutes.

## What You Need Before Starting

- **Node.js 22 or later** — Just Scrape runs on Node. Check with `node --version`.
- **A ScrapeGraph AI API key** — sign up at [scrapegraphai.com](https://scrapegraphai.com/dashboard) (free credits included)
- **A terminal** — macOS, Linux, or WSL on Windows

## Step-by-Step

### 1. Install Just Scrape

The package is published on npm:

```bash
npm install -g just-scrape@latest
```

Expected output:

```
added 1 package in 3s
```

Alternatively, use `pnpm add -g just-scrape@latest`, `yarn global add just-scrape@latest`, or `bun add -g just-scrape@latest`.

**Gotcha**: If you get a permissions error with npm global installs on macOS/Linux, either use `sudo` or set up a local npm prefix. The quickest fix is `sudo npm install -g just-scrape@latest`.

### 2. Set Your API Key

Get your key from the [ScrapeGraph dashboard](https://scrapegraphai.com/dashboard), then set it as an environment variable:

```bash
export SGAI_API_KEY=your-api-key-here
```

To make this permanent, add that line to your `~/.bashrc` or `~/.zshrc`.

Just Scrape checks for the key in this order:

1. `SGAI_API_KEY` environment variable
2. `.env` file in the current directory
3. `~/.scrapegraphai/config.json`
4. An interactive prompt (last resort)

### 3. Verify the Setup

Run the validate command to confirm everything works:

```bash
just-scrape validate
```

Expected output:

```
✓ API key is valid
✓ API is reachable
```

Then check your credit balance:

```bash
just-scrape credits
```

Expected output shows your remaining credits — each operation consumes a small number.

### 4. Scrape Your First Page

The most common task — get a page as clean markdown:

```bash
just-scrape scrape "https://example.com"
```

This returns the page content in markdown format. Try other output formats:

```bash
just-scrape scrape "https://example.com" -f html,links,summary --json
```

The `--json` flag makes the output machine-readable, useful when piping into other tools or AI agents.

**Format options**: `markdown`, `html`, `screenshot`, `branding`, `links`, `images`, `summary`, `json`.

### 5. Extract Structured Data

This is where the AI part shines. Instead of writing selectors, you describe what you want:

```bash
just-scrape extract "https://news.ycombinator.com" -p "Extract the top 10 story titles and their points"
```

For stricter output, pass a JSON schema:

```bash
just-scrape extract "https://news.ycombinator.com" \
  -p "Extract story titles and points" \
  --schema '{"type":"array","items":{"type":"object","properties":{"title":{"type":"string"},"points":{"type":"number"}}}}'
```

### 6. Search the Web

No target URL yet? Search first, extract from results:

```bash
just-scrape search "latest AI coding tools 2026" --num-results 5
```

The search command supports time ranges and country filters:

```bash
just-scrape search "EU AI regulation" --time-range past_week --country de
```

You can also extract structured data directly from search results, avoiding an extra scrape call:

```bash
just-scrape search "best no-code web scrapers" -p "Extract tool names and pricing"
```

This pattern — search then extract in one pass — saves credits compared to searching, then scraping each result individually.

### 7. Crawl a Site Section

For larger sites like documentation hubs or blog archives:

```bash
just-scrape crawl "https://docs.example.com" --max-pages 30 --max-depth 2 -f markdown
```

Always set `--max-pages` to avoid runaway crawls. You can also filter which pages get crawled using include and exclude patterns:

```bash
just-scrape crawl "https://docs.example.com" \
  --include-patterns '["^https://docs\\.example\\.com/guides/.*"]' \
  --exclude-patterns '[\".*\\.pdf$\"]' \
  --max-pages 50
```

Crawl respects same-origin by default. Add `--allow-external` if you need to follow links to other domains.

### 8. Monitor a Page for Changes

Track a page over time:

```bash
just-scrape monitor create \
  --url "https://example.com/pricing" \
  --interval 1h \
  -f markdown
```

This polls the page hourly and can send webhook notifications on changes.

## Verification

After following the steps above, run this smoke test:

```bash
just-scrape scrape "https://httpbin.org/html" -f markdown --json
```

Expected output is a JSON object with the page content in markdown. You should see the HTML page converted to readable text.

```bash
just-scrape credits
```

This should show your remaining credits have decreased by at least one from the initial balance, confirming operations are billed correctly.

## One Thing That Tripped Me Up

The `--json` flag only affects output formatting — it does not change the scraping behavior. My first instinct was to use `--json` with `extract` to get structured data, but `extract` already returns JSON by default when you pass a prompt. The `--json` flag is mainly useful with `scrape` when you want the result as a structured object rather than raw text. If you pipe commands into `jq` or an AI agent, always check which format the command outputs by default before adding `--json`.

## Next Step

Try the `just-scrape monitor` workflow for a page you check regularly — documentation changelogs, competitor pricing pages, or job boards. Set up a webhook URL and you will get notified when the content changes.
