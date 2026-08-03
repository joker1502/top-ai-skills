---
title: "Top AI Skills Directories in 2026"
date: 2026-08-03
draft: false
toc: true
description: "A practical roundup of 9 AI skills directories in 2026 — skills.sh, ClawHub, Smithery, agentskills.io and more — with install commands and when to use each."
keywords:
  - AI skills directories
  - skills.sh
  - ClawHub
  - Smithery
  - agent skills
  - install AI skills
  - skills marketplace
  - gh skill install
tags:
  - AI Skills
  - Directories
  - Roundup
category: "guides"
---

You've decided your AI agent should use skills — but finding, vetting, and installing them means digging through scattered GitHub repos, docs pages, and marketplaces, and every agent seems to expect a different install command. The ecosystem has consolidated fast, though: in 2026 there are a handful of directories that cover 90% of what you'll ever need to find. Here's my roundup of the ones actually worth using, grouped by what they're best at.

## Official and Cross-Agent Registries

These are the directories with the broadest reach — they index skills from many authors and install them into many different agents.

### 1. skills.sh — The Agent Skills Directory

[skills.sh](https://skills.sh) is Vercel's official skills directory, and it describes itself simply: "Discover and install skills for AI agents." It's the closest thing the ecosystem has to a default registry — the homepage runs a leaderboard ranked by installs, and every skill maps to a GitHub repo with `npx skills add <owner>/<repo>` as the universal install command.

What makes it valuable is the install-count signal. When you search for a skill, the number of installs tells you which skills are actually used in production rather than just starred on GitHub. The directory works across Claude Code, Codex, Cursor, and other major agents — one command, no per-agent setup.

**Best for:** Your first stop. If you don't know where to look, search here first.
**Install:** `npx skills add <owner>/<repo>` (add `-all -y` to install everything in a repo)

### 2. Anthropic Agent Skills — The Official Reference

The [anthropics/skills](https://github.com/anthropics/skills) repository is where the skill format itself comes from — it's the public home of Agent Skills, with 165K+ stars and 30+ reference skills covering everything from PDF extraction to browser automation. The official docs at [code.claude.com/docs/en/skills](https://code.claude.com/docs/en/skills) define the `SKILL.md` spec that every other directory in this list builds on.

This matters more than it sounds: the format is the ecosystem's lingua franca. A skill written as a folder with a `SKILL.md` file (name, description, instructions) can be dropped into any agent that supports skills — no compilation, no packaging. When a directory says "works with Claude Code, Cursor, and Codex," it's because they all read this same format.

**Best for:** Learning the format, studying high-quality reference skills, and verifying what "official" skills look like.
**Install:** Clone the repo or use any registry — the skills are all mirrored.

### 3. agentskills.io — The `gh skill install` Registry

[agentskills.io](https://agentskills.io) is the registry behind GitHub CLI's `gh skill install` command (GitHub CLI v2.90+). It's the newest entry on this list and the most interesting distribution experiment: instead of a separate CLI or a web app, skills are installed through a command developers already have.

The pitch is cross-agent coverage from one command. `gh skill install heygen-com/skills heygen-avatar` writes the skill to the right directory for your agent automatically — Claude Code, Cursor, Codex, Gemini CLI, Copilot, Junie, Goose, OpenHands, Amp, Cline, OpenCode, and Warp are all supported. Official vendor skills like HeyGen's publish here first, which makes it a good place to watch for new releases.

**Best for:** Terminal-first developers who want one install path across every agent they use.
**Install:** `gh skill install <owner>/<repo> <skill-name>`

## Community Hubs and Framework Registries

These directories are smaller but deeper — they serve a specific ecosystem or a specific kind of skill.

### 4. ClawHub — Fast Registry with Vector Search

[ClawHub](https://clawhub.com) calls itself "a fast skill registry for agents, with vector search," and it's the home of the OpenClaw/Clawd ecosystem — the directory lists roughly 10,000 skills. The vector search is the differentiator: instead of keyword matching, you search by what you want the skill to *do*, and the registry finds skills by semantic similarity.

ClawHub is also the distribution channel for OpenClaw plugins — you install skills with `clawhub install <name>` and plugins with `openclaw plugins install clawhub:@org/plugin-name`. If you run OpenClaw as your agent platform, this is your primary registry.

**Best for:** OpenClaw and Clawd users, and anyone who wants semantic search over keyword search.
**Install:** `clawhub install <skill-name>`

### 5. Smithery — From MCP Registry to Skills Hub

[Smithery](https://smithery.ai) started as the largest registry of MCP servers and has grown into a skills hub — the homepage now advertises "100K+ tools and skills instantly." If your workflow runs on MCP (Model Context Protocol), Smithery is where you discover, configure, and install servers, and it now treats skills as first-class citizens alongside them.

Its install model is agent-aware: you pick your client (Claude Code, Cursor, Cline, and so on) and it gives you the exact command for that client, including configuration for authenticated servers. For anyone building agent workflows around MCP, Smithery is the practical default.

**Best for:** MCP-centric workflows and teams that want a big catalog with client-specific install commands.
**Install:** `npx -y @smithery/cli install <server> --client claude`

### 6. Mastra Skills — TypeScript-Native Skills

[Mastra's skills repo](https://github.com/mastra-ai/skills) is the official skill collection for the Mastra TypeScript agent framework, installed via `npx skills add mastra-ai/skills`. It's a good example of a framework-specific registry: the skills are written with TypeScript developers in mind and integrate directly with Mastra's agent runtime rather than requiring a separate agent CLI.

This category is worth knowing about even if you don't use Mastra — every serious agent framework (LangChain, CrewAI, Mastra, and friends) now ships an official skill collection, and they're usually the best-vetted skills for that framework.

**Best for:** TypeScript agent developers and anyone evaluating framework-native skills.
**Install:** `npx skills add mastra-ai/skills`

## Where Skills Live in Your Workflow

The last category is the directories that are really just folders and search — but they're where the ecosystem actually operates day to day.

### 7. Claude Code Skills Docs — The In-Editor Source

Claude Code's official docs maintain the canonical explanation of how skills work in practice: a `~/.claude/skills` directory where any subfolder containing a `SKILL.md` is auto-discovered. The docs cover authoring, packaging, and distributing skills, and they link the official reference skills plus community collections.

The reason this deserves a roundup slot: it's the *specification* for the entire ecosystem. When a skill behaves unexpectedly, the docs are where you confirm the format, the frontmatter fields, and the discovery rules. Treat it as the reference manual that every other directory assumes you've read.

**Best for:** Claude Code users who author skills and need the definitive format reference.
**URL:** [code.claude.com/docs/en/skills](https://code.claude.com/docs/en/skills)

### 8. GitHub Topic Search — The Raw Source

Finally, don't forget that every skill in every directory above ultimately lives in a GitHub repository. Searching `topic:agent-skills` or `topic:claude-skills` surfaces the raw source — including vendor-published skills that haven't been indexed by a directory yet (new ones like [heygen-com/skills](https://github.com/heygen-com/skills) typically publish on GitHub first).

GitHub is also where you *vet* skills: check the star count, the last commit date, whether the repo has an actual `SKILL.md`, and what tools the skill is allowed to run. Directories aggregate; GitHub is where you verify. For anything you're about to give agent-level access to, this step isn't optional.

**Best for:** Power users who want the newest skills and need to audit what they install.

## Comparison Table

| Directory | Best For | Install Command | Standout Feature |
|-----------|----------|-----------------|------------------|
| **skills.sh** | First stop, cross-agent discovery | `npx skills add owner/repo` | Install-count leaderboard |
| **Anthropic Agent Skills** | Format spec + reference skills | Clone or any registry | 165K★ official repo |
| **agentskills.io** | One command for any agent | `gh skill install owner/repo skill` | GitHub CLI integration |
| **ClawHub** | OpenClaw/Clawd ecosystem | `clawhub install name` | Vector search, ~10K skills |
| **Smithery** | MCP tools and skills | `npx -y @smithery/cli install ...` | 100K+ tools, client-aware |
| **Mastra Skills** | TypeScript framework devs | `npx skills add mastra-ai/skills` | Framework-native |
| **Claude Code Docs** | Authoring reference | Read the docs | The SKILL.md spec |
| **GitHub Search** | Vetting + newest skills | `topic:agent-skills` | Raw source, audit trail |

## Which Directories Should You Use?

The honest answer: you need two, not eight.

**If you're starting out:** Use **skills.sh** to find skills by install count — it's the safest signal of what actually works — and keep the **Claude Code docs** open as the format reference. That covers discovery and understanding with zero extra tooling.

**If you're an OpenClaw or MCP user:** Add **ClawHub** (if you run OpenClaw) or **Smithery** (if you live in MCP land) as your primary registry — both install into your agent with client-aware commands and have deeper catalogs for their ecosystems.

**If you're a developer shipping or installing skills daily:** Install **`gh skill install` / agentskills.io** and use **GitHub topic search** for vetting. The CLI gives you one command that works across every agent you touch, and GitHub is where you check that a skill is maintained and safe before granting it file and shell access.

The ecosystem settled on one file format — `SKILL.md` — and everything else is distribution. Pick the directory that matches how you work, and you'll never have to hand-install a skill again. For more on the skills ecosystem, browse our [full skills directory](/skills/), see how to [install AI agent skills](/tutorials/guides/faq-installing-ai-agent-skills/), or read about [publishing skills to directories](/skills/coding/github-skill-forge/) if you're a skill author.
