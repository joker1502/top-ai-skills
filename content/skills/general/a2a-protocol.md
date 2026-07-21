---
title: "A2A Protocol"
date: 2026-06-28
draft: false
tags:
  - Agent Communication
  - AI Protocols
  - Agent-to-Agent
  - MCP Alternative
description: "Enable seamless AI agent collaboration with the A2A protocol. Open standard for cross-vendor agent communication now under the Linux Foundation."
version: "1.0"
author: "absolutelyskilled"
repo_url: "https://github.com/absolutelyskilled/absolutelyskilled"
install_cmd: "npx skills add https://github.com/absolutelyskilled/absolutelyskilled --skill a2a-protocol"
compatibility:
  - Claude Code
  - Cursor
  - Cline
  - Any agent supporting npx skills
category: "general"
rating: 3
github_stars: 199
github_forks: 32
installs: 151
last_updated: "2026-06-28"
ai_friendliness:
  score: 3
  documentation: 4
  setup: 2
  config: 3
---

## Overview

The A2A Protocol skill brings Google's Agent-to-Agent communication standard into your AI agent's toolkit. Unlike MCP (which connects models to tools and data), A2A handles something different — agent-to-agent collaboration. Your Claude Code or Cursor agent can discover other agents, exchange messages, and coordinate on long-running tasks without sharing their internal stack.

### What It Does

Got multiple agents working on the same project? A2A lets them talk to each other. Each agent publishes an "agent card" — a lightweight JSON document describing its capabilities, endpoints, and auth requirements. Other agents discover these cards and start sending requests via JSON-RPC, gRPC, or plain HTTP.

The protocol supports:

- **Agent discovery** — agents find each other via publicly hosted agent cards
- **Task management** — send a task, get streaming updates, or receive push notifications when it's done
- **Cross-vendor** — works between agents built on different frameworks (Claude Code agents talking to Gemini agents, for example)
- **Complementary to MCP** — A2A doesn't replace MCP; it sits on top of it. MCP handles tool access, A2A handles inter-agent coordination

### How to Use It

```bash
npx skills add https://github.com/absolutelyskilled/absolutelyskilled --skill a2a-protocol
```

Once installed, your agent knows the A2A protocol spec and can participate in multi-agent workflows. The skill includes the full A2A specification, agent card templates, and message formats for task subscription and cancellation.

### Who Needs This

Anyone running multi-agent systems. If you've got one agent writing code and another reviewing it, A2A lets them coordinate naturally. The protocol is especially useful for agent teams where each member has a specialized role — research, coding, testing, deployment.

### Bottom Line

A2A is still young (first seen on skills.sh in March 2026), but it solves a real problem. As multi-agent setups become the norm, knowing A2A gives your agent a solid foundation for cross-platform collaboration. Pair it with MCP for a complete agent communication stack.

Check the [skills.sh page](https://www.skills.sh/absolutelyskilled/absolutelyskilled/a2a-protocol) for the latest install stats and security audit results.
