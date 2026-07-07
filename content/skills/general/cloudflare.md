---
title: "Cloudflare Skill for AI Agents: Manage Workers, Pages, and DNS"
date: 2026-07-07
draft: false
tags:
  - Cloudflare
  - Workers
  - CDN
  - DNS
  - Serverless
  - DevOps
keywords:
  - Cloudflare AI skill
  - Cloudflare Workers agent
  - deploy Workers with AI
  - Cloudflare Pages AI
  - cloudflare/skills
  - AI agent Cloudflare management
  - serverless deployment agent
description: "The official Cloudflare skill lets AI agents manage Workers, Pages, DNS, R2, D1, and more — deploy serverless code, configure zones, and monitor performance from natural language."
version: "1.0.0"
author: "cloudflare"
repo_url: "https://github.com/cloudflare/skills"
install_cmd: "npx skills add cloudflare/skills"
compatibility:
  - Claude Code
  - Cursor
  - Codex
  - Windsurf
  - Cline
category: "general"
rating: 4.5
github_stars: 2069
github_forks: 183
installs: 31480
last_updated: "2026-07-07"
ai_friendliness:
  score: 4.0
  documentation: 4.5
  setup: 4.0
  config: 3.5
---

## What It Is

The Cloudflare skill is an official skill from cloudflare/skills that gives AI agents direct access to the Cloudflare ecosystem. Instead of digging through the Cloudflare dashboard or memorizing API endpoints, you tell your agent what you need — "deploy a Worker to handle form submissions," "add a DNS record for the new staging subdomain," "purge the cache for /blog/*" — and it handles the API calls using the [Cloudflare API](https://developers.cloudflare.com/api/).

It's published by Cloudflare themselves, which means the skill stays current with Cloudflare's API changes. As of July 2026, it covers Workers, Pages, DNS, R2 object storage, D1 databases, KV, Queues, Cache, and SSL/TLS settings. The skill wraps the Wrangler CLI and Cloudflare API into a single agent-aware interface.

## What It Does Well

**Deploy Workers from your chat.** This is the headline feature. You describe a worker — "create a Worker that redirects /old-path to /new-path with a 301" — and the skill generates the code, writes the `wrangler.toml`, and deploys it. No terminal switching, no manual `wrangler deploy` commands. If something fails, the agent reads the error and fixes it in the next iteration.

**Manage DNS records without the dashboard.** Adding, updating, or removing DNS records is a common task that usually means logging into the Cloudflare dashboard, finding the right zone, and clicking through forms. The skill handles it inline. "Add an A record for api.example.com pointing to 192.0.2.1 with proxying enabled" — the agent calls the API, confirms the change, and returns the new record details.

**Configure Pages projects.** Deploy a frontend to Cloudflare Pages by pointing the agent at your build output. The skill sets up the project, configures the build command and output directory, and triggers the first deployment. It also handles environment variables, custom domains, and branch previews.

**R2 and D1 operations.** Create buckets, set permissions, upload and list objects in R2. Run queries against D1 databases. The skill translates natural-language requests into the appropriate API calls, so you don't need to remember the exact endpoint for every operation.

## Where It Falls Short

**No visual feedback for complex configs.** If you're setting up a multi-rule cache configuration or a complex Workers route with multiple origins, the skill shows you the resulting JSON or API response. It works, but you don't get the visual tree view that the Cloudflare dashboard offers for understanding the full configuration at a glance.

**Rate limits apply.** The skill uses the Cloudflare API under your account, so you're subject to the same rate limits as any API client. Heavy batch operations — updating hundreds of DNS records, deploying dozens of Workers — will hit those limits and require you to pace the requests.

**Requires an API token.** The skill needs a Cloudflare API token with the right permissions. Setting one up means going to the Cloudflare dashboard, creating a token, and passing it to your agent. It's a one-time setup, but it's not zero-config.

## Who Should Install It

Anyone who manages Cloudflare services regularly and wants to stay in their editor instead of context-switching to the dashboard. It's especially useful for:

- **Developers deploying Workers** as part of their regular workflow — the skill cuts the deploy cycle from "write code, switch to terminal, wrangler deploy, check dashboard" to "tell agent, done."
- **DevOps engineers managing DNS and cache** across multiple zones — batch operations that would take minutes of clicking take seconds of typing.
- **Teams using Cloudflare Pages** for frontend deployments — connect the skill to your CI pipeline and let agents manage the deployment config.

Skip it if you touch Cloudflare once a quarter and prefer the dashboard UI for those rare visits. The API token setup isn't worth it for occasional use.

## Bottom Line

The official Cloudflare skill turns your AI agent into a Cloudflare operator. Deploy Workers, manage DNS, configure Pages, and handle R2 or D1 — all from natural language. It's the fastest way to manage Cloudflare without leaving your editor.
