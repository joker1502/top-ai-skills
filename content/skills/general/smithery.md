---
title: "Smithery CLI: Connect Agents to MCP Servers and Skills"
date: 2026-08-10
draft: false
tags:
  - Smithery
  - MCP Servers
  - Agent Skills
description: "Smithery CLI connects Claude Code and other agents to thousands of MCP servers and skills from the terminal — search, add, and call tools in one command."
version: "latest"
author: "Smithery AI"
repo_url: "https://github.com/smithery-ai/cli"
install_cmd: "npm install -g smithery@latest"
compatibility:
  - Claude Code
  - Cursor
  - Any MCP client
category: "general"
rating: 4.5
github_stars: 815
github_forks: 95
installs: 0
last_updated: "2026-08-10"
ai_friendliness:
  score: 4.5
  documentation: 5
  setup: 4
  config: 4
---

## What It Is

Smithery CLI is an 800+ star command-line tool that connects your AI agents to thousands of MCP servers and skills. The [official README](https://github.com/smithery-ai/cli) describes it in one line: "Smithery CLI connects your agents to thousands of skills and MCP servers directly from the command line. To get started, simply run `npx skills add smithery/cli`."

It solves the problem every agent user hits after the first week: you find a great MCP server on GitHub, but wiring it into your client means editing JSON config files, guessing at environment variables, restarting your agent, and repeating the whole dance for the next tool. Smithery collapses that into two commands — `smithery mcp search` to find a server, `smithery mcp add` to connect it. The registry at [smithery.ai](https://smithery.ai) hosts thousands of servers and skills, and the CLI talks to it directly from your terminal.

The mechanics are simple. Install the CLI once with `npm install -g smithery@latest` (Node.js 20+), then manage everything through commands: `smithery mcp list` shows your connections, `smithery tool find` searches the tools exposed by those servers, and `smithery tool call` invokes a tool with JSON arguments — no config file edits, no client restarts. The README's example workflow: search for a GitHub server, add it, find the "create issue" tool, and call it with a title and body.

## What Makes It Different

**The core difference is that Smithery is a registry with a client, not just a client.** Most MCP tooling makes you hunt for servers across GitHub repos and blog posts; Smithery's registry is searchable from the same command you use to install — `smithery mcp search "github"` returns available servers, and `smithery mcp add github --id github` connects one in a single step.

Second, it works **across the whole MCP lifecycle**. The README covers three layers: connecting to servers (`mcp` commands), interacting with their tools (`tool list/find/get/call`), and publishing your own servers (`smithery mcp publish <url> -n myorg/my-server`). If you built an MCP server, Smithery is also your distribution channel — publish a URL or a `.mcpb` bundle and it lands in the registry.

Third, it's **skill-aware, not just server-aware**. Beyond MCP servers, the CLI can browse and install agent skills from the [Smithery Skills Registry](https://smithery.ai/skills) — `smithery skill add anthropics/frontend-design --agent claude-code` installs a skill targeted at a specific agent. That's the same `npx skills` ecosystem the site's [find-skills discovery guide](/tutorials/guides/how-to-discover-and-install-ai-skills-with-find-skills/) covers, with the registry baked into the CLI.

## Who It's For

Smithery CLI fits three types of users. First, **Claude Code, Cursor, and Codex users who keep adding MCP servers** — if your client config is a graveyard of half-configured servers, `smithery mcp list` + `remove` gives you a clean way to audit and prune connections instead of editing JSON blind.

Second, **agents that need to call tools mid-conversation without setup friction**. The `tool call` command takes a connection and a tool name plus JSON args — `smithery tool call github create_issue '{"title":"Bug fix","body":"..."}'` — which makes it easy to script tool use or let an agent drive a server it discovered at runtime rather than one hard-coded at startup.

Third, **MCP server authors looking for distribution**. Publishing to Smithery is a one-liner (`smithery mcp publish https://my-mcp-server.com -n myorg/my-server`), and the registry is where agent users already search. For the server-building side, pair it with our [guide to building your first MCP server](/tutorials/guides/how-to-build-your-first-mcp-server/).

Skip it if you only use one or two MCP servers configured once — the registry's value compounds with the number of tools you juggle. Note that `smithery auth login` (OAuth) is required for publishing and some registry features, and free-tier users have limits on private namespaces.

## Bottom Line

Smithery CLI turns MCP server management from config-file surgery into three commands: search, add, call. It's an 800+ star tool because it covers the full lifecycle — finding servers, connecting them, calling their tools, and publishing your own — all from one CLI backed by a registry with thousands of entries. Install it in under a minute with `npm install -g smithery@latest`, and the next MCP server you discover takes ten seconds to wire up instead of ten minutes. For the protocol behind it all, see our [A2A vs MCP comparison](/tutorials/comparison/a2a-protocol-vs-mcp/) and the [A2A protocol skill intro](/skills/general/a2a-protocol/), or the [FAQ on installing agent skills](/tutorials/guides/faq-installing-ai-agent-skills/) for the broader installation picture.
