---
title: "Smithery"
date: 2026-06-28
draft: false
tags:
  - MCP
  - AI Tools
  - Agent Infrastructure
  - CLI
  - Server Registry
description: "Discover, install, and manage MCP servers directly from your terminal. Smithery is the essential registry for AI agent tool connectivity."
version: "1.0.0"
author: "smithery-ai"
repo_url: "https://github.com/smithery-ai/cli"
install_cmd: "npx @smithery/cli install <server-name>"
compatibility:
  - Claude Code
  - Cursor
  - Cline
  - Any MCP-compatible agent
category: "coding"
rating: 4
github_stars: 1890
github_forks: 245
installs: 45200
last_updated: "2026-06-28"
ai_friendliness:
  score: 4
  documentation: 4
  setup: 4
  config: 4
---

## Overview

Smithery is the go-to registry for MCP (Model Context Protocol) servers — think of it as npm for AI agent tools. Instead of hunting down MCP server configurations, writing JSON by hand, or cloning random repos, you install what you need with a single command and your agent starts using it immediately.

### What It Does

Your AI agent can only act on the tools you give it. MCP servers are the bridge between your agent and external services — databases, APIs, file systems, browsers. Smithery turns the process of finding and connecting these tools into a frictionless CLI experience.

The key features:

- **One-command install** — `npx @smithery/cli install server-name` downloads, configures, and connects the server
- **Registry with 1000+ servers** — from web scraping (Firecrawl, Puppeteer) to databases (PostgreSQL, SQLite) to APIs (GitHub, Slack, Gmail)
- **Automatic configuration** — no manual JSON editing; Smithery writes your MCP config and handles auth
- **Version management** — update, rollback, and remove servers cleanly
- **Compatible with any MCP host** — Claude Code, Cursor, Cline, VS Code extensions, and custom agents

### How to Use It

```bash
# Install the CLI
npx @smithery/cli --help

# Browse available servers interactively
npx @smithery/cli list

# Install a server (e.g., PostgreSQL)
npx @smithery/cli install postgres

# Remove a server
npx @smithery/cli remove postgres

# Update all installed servers
npx @smithery/cli update
```

Once installed, your agent detects the new MCP server automatically. Ask it to "query the database" or "search the web" and it knows which tool to reach for.

### Who Needs This

Anyone running MCP-compatible AI agents who wants to extend their capabilities without manual configuration. If you've ever spent 20 minutes wrestling with a `claude_desktop_config.json` file just to give your agent web search access, Smithery saves you that time every single time.

### Bottom Line

Smithery is the package manager your AI agent infrastructure needs. With over 45,000 installs and a growing registry of 1,000+ MCP servers, it's become the standard way to connect agents to the tools they need. Install it once, and your agent's capabilities grow on demand.

For a deeper look at how MCP servers work alongside agent-to-agent protocols, check out our [A2A Protocol vs MCP comparison](/tutorials/comparison/a2a-protocol-vs-mcp/).
