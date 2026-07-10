---
title: "Shopping Browser Automation"
date: 2026-07-10
draft: false
tags:
  - Browser Automation
  - Playwright
  - MCP
  - Shopping
  - Web Automation
description: "Browser automation skill for AI agents that uses Playwright and MCP to automate shopping tasks — product search, add to cart, checkout, and order tracking on any e-commerce site."
version: "1.0.0"
author: "MassLab-SII"
repo_url: "https://github.com/masslab-sii/open-agent-skills"
install_cmd: "git clone https://github.com/masslab-sii/open-agent-skills.git && cd open-agent-skills && uv pip install -e ."
compatibility:
  - Claude Code
  - Codex
  - OpenAI
category: "automation"
rating: 4.0
github_stars: 133
github_forks: 6
installs: 0
last_updated: "2026-07-10"
ai_friendliness:
  score: 4.0
  documentation: 3.5
  setup: 3.5
  config: 4.0
---

## What It Is

Shopping Browser Automation is an agent skill from the Open Agent Skills collection that teaches AI agents how to automate browser-based shopping workflows. It combines Playwright for browser control with the Model Context Protocol (MCP) to give agents the ability to search products, compare prices, add items to carts, and complete checkout flows without human supervision.

This isn't a standalone tool — it's a skill that lives inside the Open Agent Skills framework, which provides a lightweight Python runtime for executing domain-specific agent skills. The project was built by the Project Q team at SII (a French IT services company) as part of their research into making AI agents more efficient by replacing raw MCP tool calls with structured skill instructions.

## How It Works

The skill uses Playwright to drive a headless browser session. Your AI agent loads the skill instructions, which break down shopping tasks into steps: navigate to site, search for a product, extract results, click through to details, add to cart, fill shipping info, and complete payment.

What makes this approach different from plain MCP browser automation is the skill layer. Instead of the agent figuring out each Playwright API call from scratch, the skill provides a structured playbook. According to the team's benchmarks, skill-based implementations achieve up to **20x context reduction** compared to pure MCP approaches while improving task accuracy by roughly 18 percentage points.

## Key Features

- **Playwright-powered** — Uses Chromium, Firefox, or WebKit for cross-browser automation.
- **MCP integration** — The skill coordinates with MCP servers for external data lookups (pricing APIs, inventory checks).
- **Context-efficient** — Pre-built instructions reduce token consumption by 20-40% on average.
- **Multi-step workflows** — Handles the full shopping flow: product discovery → cart management → checkout.
- **Framework agnostic** — Works with Claude Code, Codex, and any LLM provider through the Open Agent Skills runtime.

## Who It's For

E-commerce developers building AI shopping assistants, QA engineers automating purchase flow testing, and researchers experimenting with agentic browser automation will find this useful. The skill is open-source (Apache 2.0) and the benchmarks are reproducible from the repo.

## Install

```bash
git clone https://github.com/masslab-sii/open-agent-skills.git
cd open-agent-skills
uv pip install -e .
```

Set your API keys in a `.mcp_env` file and run tasks through the pipeline CLI.

## Related

See the [AI Workflow Automation Skills Comparison](/tutorials/comparison/ai-workflow-automation-skills-comparison/) for a broader look at automation tools for AI agents.

