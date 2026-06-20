---
title: "How to Install AI Agent Skills in Claude Code and Cursor"
date: 2026-06-18
draft: false
toc: true
tags:
  - Claude Code
  - Cursor
  - CLI
description: "Install AI agent skills in Claude Code, Cursor, and OpenCode using the skills.sh CLI. Step-by-step, from npm setup to running your first skill."
category: guides
---

## What This Gets You

Installing AI agent skills turns your coding assistant from a general-purpose LLM into a tool that knows how to debug your stack, generate video, audit SEO, or research content — without you describing what you need each time. This tutorial covers installing skills in Claude Code, Cursor, and OpenCode using the skills.sh CLI, and should take about 10 minutes if you already have Node.js installed.

## What You Need Before Starting

- **Node.js 18+** — The skills.sh CLI runs on npm. Run `node -v` to check. If you're below 18, update with `nvm install 18` or download from nodejs.org.
- **A supported coding assistant** — Claude Code (CLI), Cursor, or OpenCode. Each has a slightly different install path, covered below.
- **GitHub CLI (`gh`) or a GitHub token** — Only needed if you're installing private skills or ones hosted on GitHub Enterprise. Public skills install fine without it.

## Step-by-Step

### 1. Install the skills.sh CLI

The entire skill ecosystem runs through a single npm package:

```bash
npm install -g @skills-sdk/cli
```

Expected output (version may differ):

```
added 42 packages in 3s
```

Verify:

```bash
skills --version
# v0.5.0
```

If the command is not found after install, your npm global bin path may not be in `$PATH`. Run `npm bin -g` to find it, then add that directory to your shell profile.

### 2. Search for a skill

Browse available skills by name or tag:

```bash
skills search debug
```

Expected output — a table of matching skills with name, install count, and a one-line description:

```
┌─────────────────────────────────┬──────────┬──────────────────────────────────┐
│ Name                            │ Installs │ Description                      │
├─────────────────────────────────┼──────────┼──────────────────────────────────┤
│ systematic-debugging            │ 289K     │ Debug systematically             │
│ debug-battle                    │ 701      │ AI agent for debugging battles   │
│ nextjs-debugging                │ 810      │ Next.js debugging agent tool     │
└─────────────────────────────────┴──────────┴──────────────────────────────────┘
```

Use `skills search <term> --json` if you want machine-readable output for scripting.

### 3. Install a skill

Pick a skill from the search results and install it:

```bash
skills add systematic-debugging
```

Expected output:

```
✔ Installed systematic-debugging (289K installs)
```

The skill is now available in your local skill registry. It is **not yet active** in any assistant — that's the next step.

**Gotcha**: Some skills live in monorepos and need a full GitHub URL plus `--skill` flag:

```bash
npx skills add https://github.com/agentspace-so/runcomfy-agent-skills --skill kling-3-0
```

If you install without the `--skill` flag on a monorepo, you'll get a generic package with no useful commands. Check the skill's install_cmd in its page header on skills.sh — it always shows the exact command.

### 4. Activate the skill in your assistant

The activation step depends on which coding assistant you use:

**Claude Code (CLI):**

```bash
claude
# then inside Claude Code:
/skills add systematic-debugging
```

Or add it to your `~/.claude/skills.json`:

```json
{
  "skills": ["systematic-debugging"]
}
```

Skills added via the `/skills` command are available immediately in the current session. Skills added to `skills.json` are loaded on every new session.

**Cursor:**

Open Cursor Settings → Features → Skills, click "Add Skill", and type the skill name. Cursor installs it from the skills.sh registry automatically. No terminal needed.

If the skill doesn't appear in the dropdown, try restarting Cursor — the registry syncs on startup.

**OpenCode:**

Paste the install command in the agent's terminal. OpenCode picks up skills automatically from the npm global registry:

```bash
npx skills add systematic-debugging
```

Then reload the agent with `/reload` or start a new session.

### 5. Use the skill

Once activated, invoke the skill through your assistant's command interface. The exact syntax varies, but most skills follow this pattern:

"In Claude Code, use systematic debugging on the auth module"

or with explicit skill invocation:

```
/skill systematic-debugging auth flow
```

If nothing happens, check that the skill name was typed correctly — `/skills` (with an 's') lists available skills, while `/skill` invokes one. They're different commands.

## Verification

To confirm a skill is installed and active, ask your assistant to list available skills:

```
/skills
```

Expected output — a list of installed skills with their status:

```
Installed skills:
  systematic-debugging (active)
  vercel-react-best-practices (active)
  find-skills (inactive)
```

If the skill shows as "inactive", run `/skills add <name>` again or restart your assistant session.

For CLI verification outside the assistant:

```bash
skills list
```

This prints all locally installed skills with their install paths.

## One Thing That Tripped Me Up

The `skills add` command and the `/skills add` chat command are **not the same thing**. The first installs the skill into your local registry (like downloading a package). The second activates it inside your assistant (like importing a module). I spent 20 minutes running `skills add systematic-debugging` and wondering why Claude Code couldn't see it — I needed the second step inside the assistant. If a skill isn't showing up after installation, check which step you're missing.

## Next Step

Once you have a few skills installed, read [how to find the right skill for your workflow](/tutorials/guides/find-skills-discovery/) — the skills.sh registry has over 10,000 packages and knowing how to search effectively saves more time than the installation itself.
