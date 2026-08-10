---
title: "How to Scrape Websites for AI with Firecrawl: Step-by-Step"
date: 2026-08-10
toc: true
draft: false
tags:
  - Firecrawl
  - Web Scraping
  - AI Agents
category: "guides"
description: "Learn how to scrape websites for AI with Firecrawl — get an API key, install the SDK, and run your first scrape, search, and crawl in under ten minutes."
---

You need data from the web — a competitor's pricing page, a documentation site, a directory of 500 listings — and your agent needs it as clean text it can actually reason over. The moment you try to build this yourself, you discover why everyone hates scraping: the HTML is a swamp of menus and ads, half the content renders only in JavaScript, and the site blocks your requests the third time you hit it. Firecrawl exists to remove that entire layer. The official README calls it "the API to search, scrape, and interact with the web at scale" — this guide walks through setting it up from scratch and running your first real extraction in about ten minutes.

## Why Scraping the Web for AI Is Still Hard

The failure isn't a lack of scraping tools — it's that generic tools solve the wrong problem. Most scraping starts with BeautifulSoup or Playwright, and that's where the time goes: you write selectors, the site changes its markup, your selectors break, you add retries, you get blocked, you rotate proxies, and suddenly the scraper is a part-time job.

JavaScript rendering makes it worse. Modern sites hydrate content client-side, so a plain HTTP request returns an empty shell — you need a headless browser, which means managing Chromium, waiting for network idle, and handling popups. Then there's the format problem: even when you get the HTML, LLMs want markdown or structured JSON, not markup. Every pipeline ends up with a bespoke HTML-to-text converter that produces output slightly too messy to trust.

This is the gap Firecrawl is built to close. Its docs claim 96% of the web is covered including JS-heavy pages, with P95 latency of 3.4 seconds — the company handles the rotating proxies, orchestration, rate limits, and JS-blocked content server-side, and returns LLM-ready output (markdown, structured JSON, or screenshots). You don't maintain a browser farm; you call an API.

## Step-by-Step: Scrape the Web with Firecrawl

The setup has seven steps and takes about ten minutes. You'll need a Firecrawl account, an API key, and Python or Node.js installed.

### Step 1: Create an Account and Get Your API Key

Sign up at [firecrawl.dev](https://firecrawl.dev) and grab your API key from the dashboard — it looks like `fc-YOUR_API_KEY`. The free tier gives you enough credits for dozens of scrapes, which is plenty to complete this guide. There's also a [playground](https://firecrawl.dev/playground) where you can test any URL before writing code.

### Step 2: Install the SDK

Firecrawl has official SDKs for Python and Node.js, plus a CLI. For Python:

```bash
pip install firecrawl-py
```

For Node.js:

```bash
npm install firecrawl
```

Or skip the SDK entirely and use the CLI (`npm install -g firecrawl-cli`), which supports the same operations from the terminal.

### Step 3: Scrape a Single Page to Markdown

The core operation converts any URL into clean markdown. In Python:

```python
from firecrawl import Firecrawl

app = Firecrawl(api_key="fc-YOUR_API_KEY")
result = app.scrape("https://firecrawl.dev")
print(result.markdown)
```

The same call in Node.js:

```javascript
import { Firecrawl } from 'firecrawl';
const app = new Firecrawl({ apiKey: "fc-YOUR_API_KEY" });
const result = await app.scrape("https://firecrawl.dev");
console.log(result.markdown);
```

The response contains the page's content as markdown — navigation, ads, and cookie banners stripped. If a page renders via JavaScript, Firecrawl runs a browser server-side, so you still get the fully-rendered content.

### Step 4: Search the Web and Get Full Page Content

Scraping works when you know the URL; search works when you don't. The search endpoint returns full page content for results, not just titles and links:

```python
results = app.search("firecrawl", limit=5)
# each result: { url, title, markdown }
```

This is the pattern for research agents: search to find candidate pages, then scrape the promising ones for full content — the same two-step flow our [web scraping FAQ](/tutorials/guides/faq-web-scraping-with-ai-agents/) describes.

### Step 5: Crawl an Entire Website

When you need every page of a site — a docs domain, a blog archive — use the crawl endpoint instead of scraping URLs one by one:

```bash
curl -X POST 'https://api.firecrawl.dev/v2/crawl' \
  -H 'Authorization: Bearer fc-YOUR_API_KEY' \
  -H 'Content-Type: application/json' \
  -d '{
    "url": "https://docs.firecrawl.dev",
    "limit": 100,
    "scrapeOptions": { "formats": ["markdown"] }
  }'
```

The response returns a job ID immediately; polling `GET /v2/crawl/{id}` gives you progress and the collected pages when it completes. Crawls run asynchronously, so you can kick off a large site and check back — or run it from an agent that waits on the job.

### Step 6: Extract Structured Data

For AI pipelines you usually want structured records, not raw markdown. The Agent endpoint (the evolution of the older `/extract` endpoint) takes a plain-language prompt and returns organized data — no schema gymnastics:

```bash
curl -X POST 'https://api.firecrawl.dev/v2/agent' \
  -H 'Authorization: Bearer fc-YOUR_API_KEY' \
  -H 'Content-Type: application/json' \
  -d '{
    "prompt": "Find the pricing plans for Notion"
  }'
```

The agent searches, navigates, and retrieves — you describe what you need instead of supplying URLs. For sites with complex navigation or auth-gated content, this is more reliable than hand-writing selectors.

### Step 7: Connect It to Your AI Agent

The final step makes all of this available to your coding agent. Firecrawl ships an MCP server, so any MCP-compatible client (Claude Code, Cursor, and others) gets scrape, search, and crawl tools with one config block:

```json
{
  "mcpServers": {
    "firecrawl-mcp": {
      "command": "npx",
      "args": ["-y", "firecrawl-mcp"],
      "env": { "FIRECRAWL_API_KEY": "fc-YOUR_API_KEY" }
    }
  }
}
```

Restart your agent and you can say "scrape this URL" or "crawl that docs site" in natural language. There's also a skill installer — `npx -y firecrawl-cli@latest init --all --browser` — that sets up the CLI and browser tooling for agent use. If MCP is new to you, our [step-by-step MCP server guide](/tutorials/guides/how-to-build-your-first-mcp-server/) covers the fundamentals.

## Firecrawl vs DIY Scraping vs Playwright

| Aspect | DIY (BeautifulSoup/requests) | Playwright + custom pipeline | Firecrawl |
|--------|------------------------------|------------------------------|-----------|
| **JS-rendered pages** | ❌ Empty shells | ✅ Full browser | ✅ Handled server-side |
| **Anti-bot/proxy handling** | ❌ You build it | ⚠️ Partial, you maintain it | ✅ Built in |
| **Output format** | Raw HTML | Whatever you write | Markdown / JSON / screenshots |
| **Time to first result** | Hours | A day | ~10 minutes |
| **Maintenance** | Selectors break constantly | Browser upgrades, flaky waits | None |
| **Cost** | Free (your time) | Free (your time) | Free tier, then credits |
| **Agent integration** | None | Custom | MCP server, one config |

The trade-off is straightforward: DIY costs hours of your time and ongoing maintenance but zero API fees; Firecrawl costs credits but removes the browser, proxy, and parsing layers entirely. For one-off scrapes, DIY is fine. For anything your agent will do repeatedly, the API wins. The community-built [Firecrawl Scraper CLI skill](/skills/search/firecrawl-scraper/) and the [Playwright web scraper skill](/skills/search/playwright-web-scraper/) are worth a look if you prefer a skill-based setup to the MCP route.

## Common Mistakes and How to Avoid Them

**Mistake: Scraping URLs one by one when you need a whole site.** Use the crawl endpoint — it handles discovery, deduplication, and rate limiting for you. Scraping 500 URLs in a loop is how you burn credits and get blocked.

**Mistake: Ignoring the structured output options.** Raw markdown is fine for reading, but if you're building a dataset, use the Agent endpoint with a clear prompt. Ask for "a table of plan names, prices, and features" and you get records you can load directly.

**Mistake: Hard-coding the API key in your scraper.** Use an environment variable, and in the MCP config keep `FIRECRAWL_API_KEY` out of shared config files — the key is your billing identity.

**Mistake: Forgetting rate and credit limits on big crawls.** The crawl endpoint's `limit` parameter exists for a reason — a 10,000-page site will consume a lot of credits. Set a sensible cap and increase it deliberately.

## Scrape Your First Site This Hour

The full loop — account, API key, SDK, first scrape, first search, first crawl — is achievable in under ten minutes, and the MCP step adds maybe five more. Start with a single page you know well: scrape it, confirm the markdown is clean, then try search on a topic in your domain, then point a crawl at a docs site with a small `limit`. Once those three operations feel mechanical, connect the MCP server and let your agent drive them.

Firecrawl is open source and self-hostable if you prefer to run your own instance, and it fits naturally into the agent stack covered elsewhere on this site: pair it with [Just Scrape](/tutorials/guides/just-scrape/) for lightweight extraction, our [web scraping FAQ](/tutorials/guides/faq-web-scraping-with-ai-agents/) for the common failure modes, and the [MCP server guide](/tutorials/guides/how-to-build-your-first-mcp-server/) if you want to build your own connectors on top.
