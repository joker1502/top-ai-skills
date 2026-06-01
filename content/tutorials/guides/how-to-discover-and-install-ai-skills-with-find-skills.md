---
title: "How to Discover and Install AI Skills with Find-Skills"
date: 2026-05-31
toc: true
draft: false
tags:
  - AI Coding
  - Skills
  - CLI
description: "Search the open agent skill registry with find-skills, discover new capabilities, and install them — all from your terminal. No browser needed."
category: "guides"
rating: 5
---

Search the open agent skill registry with find-skills, discover new capabilities, and install them — all from your terminal. No browser needed.

### What This Gets You

By the end of this guide, you'll have find-skills installed and working. You'll know how to search the skill registry, evaluate results, and install any skill — all without opening a browser. Total time: about 5 minutes.

### What You Need Before Starting

You need Node.js 18 or newer. Most agent development environments already have this — run `node --version` to check. You also need an agent that supports skills: OpenCode, Codex, Cline, or anything compatible with the `npx skills` toolchain.

The only prerequisite is the skills CLI itself. If you've never installed a skill before, you already have what you need — `npx` ships with Node.js.

### How to Install Find-Skills

Open your terminal and run:

```text
npx skills add vercel-labs/skills
```

The CLI downloads the skill and registers it with your agent. You'll see output like:

```text
âœ“ Added vercel-labs/skills
```

That's everything. The skill is now available. No config files, no API keys, no restart.

If you get a permissions error, your Node.js install may need an update. Run `nvm install --lts` to get the latest LTS version.

### How to Search for Skills

Once find-skills is installed, ask your agent to find something. Here are a few searches to try:

**"Find a skill for database work."**

The agent queries the open registry and returns ranked results:

```text
Top matches for "database":
1. supabase-postgres-best-practices â€” Supabase-specific Postgres patterns (4.2k installs)
2. firebase-basics â€” Firebase integration helpers (3.1k installs)
3. prisma-helper â€” Prisma ORM utilities (2.8k installs)
```

**"Find a skill for debugging."**

```text
Top matches for "debugging":
1. systematic-debugging â€” Hypothesis-driven debug methodology (8.7k installs)
2. error-analyzer â€” Parse and explain error messages (5.3k installs)
3. performance-debugger â€” CPU/memory profiling patterns (3.9k installs)
```

Each result includes install count and a description so you can judge relevance at a glance.

### How to Install a Skill You Found

Once you've found a skill you want, installation is a single command:

```text
npx skills add obra/superpowers
```

Replace `obra/superpowers` with the repo from your search results. The syntax is always `owner/repo`. The skill downloads and activates immediately — no restart, no config file changes needed.

Verify it worked by asking your agent to list available skills or by running:

```text
npx skills list
```

This shows all installed skills with their versions.

### One Thing That Tripped Me Up

I assumed find-skills would search GitHub directly. It doesn't — it searches the skills.sh registry, which is a curated subset. The first time I searched for a niche package that wasn't listed, I thought the skill had failed. It hadn't — the package just hadn't been published to the registry yet. Skills need to be submitted to skills.sh before find-skills can discover them.

If your search returns nothing useful, two things help: use broader terms, or check skills.sh directly to see what's available.

### Where to Go Next

Now that you can discover and install any skill, explore what's available. Systematic Debugging is a good next install — it replaces guesswork with a structured approach to fixing bugs. Or search for something specific to your stack and try what comes up.

Every search teaches the agent more about what you need. The more you use find-skills, the better it gets at ranking results for your workflow.
