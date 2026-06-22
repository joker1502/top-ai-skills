---
title: "FAQ: Installing AI Agent Skills in Claude Code and Cursor"
date: 2026-06-17
draft: false
tags:
  - AI Skills
  - Installation
  - Claude Code
  - Cursor
  - skills.sh
  - Tutorial
toc: true
description: "Answers to the most common questions about installing AI agent skills — from skills.sh CLI to Claude Code and Cursor setup, prerequisites, and troubleshooting."
---

## What This FAQ Covers

AI agent skills extend what your coding assistant can do — image generation, web scraping, database queries, browser automation, and dozens of other tasks. But the installation process varies by tool, and the documentation is scattered across GitHub repos, skills.sh, and individual README files. This FAQ collects the practical questions that come up when you actually sit down to install one.

---

## Q&A

### What exactly is an AI agent skill?

An AI agent skill is a packaged set of instructions and tool definitions that teaches an AI coding assistant (Claude Code, Cursor, Codex, OpenCode) how to perform a specific task. Think of it as a plugin — you install it, and suddenly your assistant can generate images, scrape websites, or interact with a database without you writing the integration code. Skills live in a registry (skills.sh) and are installed through a CLI command or copied into a project folder.

---

### How do I install a skill from skills.sh?

The standard install command is `npx skills add <owner>/<repo>`. For example:

```bash
npx skills add inference-sh/skills
```

This downloads the skill from GitHub, registers it in your global skills directory (`~/.config/skills/` by default), and makes it available to any compatible coding assistant. Some repos contain multiple skills — you install them all at once, then your assistant auto-discovers which ones apply to your current task.

For mono-repo skills (like agentspace-so/runcomfy-skills which bundles gpt-image-2, video-edit, image-edit, and others), you can install a single skill:

```bash
npx skills add agentspace-so/runcomfy-skills --skill gpt-image-2 -g
```

The `-g` flag registers it globally. Without it, the skill is installed locally in the current directory only.

---

### What's the difference between `npx skills add` and `skills.sh`?

skills.sh is the website (and registry) where you browse available skills by category, install count, and GitHub stars. The `npx skills add` command is the CLI tool that talks to the same registry and downloads the skill to your machine. The website is for discovery. The CLI is for installation. You don't need to visit the website to install — knowing the GitHub repo path is enough.

---

### Do I need Node.js installed to install skills?

Yes. The `skills.sh` CLI (`npx skills`) requires Node.js 18 or newer. If you don't have Node.js installed:

```bash
# macOS (Homebrew)
brew install node

# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Windows (winget)
winget install OpenJS.NodeJS.LTS
```

Verify with `node --version`. If you cannot install Node.js, some coding assistants (like Claude Code in its desktop app) offer built-in skill management that doesn't require a separate CLI — check your assistant's documentation.

---

### How do I install a skill in Claude Code?

Claude Code (the CLI version) auto-discovers globally installed skills. After running `npx skills add <owner>/<repo>`, the skill is immediately available — just ask Claude Code to perform the task and it will find and use the relevant skill automatically.

For Claude Code desktop app (if your version supports skills), you may need to point it to your skills directory or install through the app's internal skill browser. The exact path varies by Claude Code version — check `~/.claude/skills/` or the app's settings panel.

---

### How do I install a skill in Cursor?

Cursor discovers skills installed in the current project. Run the install command from your project root:

```bash
cd ~/my-project
npx skills add inference-sh/skills
```

Cursor scans the local `.cursor/rules/` directory and project-level skill registrations. Some skills also support direct installation as Cursor rules — copy the skill's `.mdc` file into `.cursor/rules/` and Cursor picks it up on the next conversation turn.

---

### Can I install a skill without internet access?

No. The `npx skills add` command downloads from GitHub and the skills.sh registry. If you're on an air-gapped machine or behind a corporate proxy, you have two options:

1. Clone the GitHub repo manually, then run `npx skills add` from the local copy (some CLIs support `--local` paths).
2. Ask your team's AI admin to mirror the skill repo to an internal Git server and point the skills CLI at your mirror.

Neither is well-supported today — the skills ecosystem assumes internet access.

---

### How do I update a skill I already installed?

Run the install command again — `npx skills add <owner>/<repo>` overwrites the existing skill with the latest version. There is no separate update command. If you installed a skill globally with `-g`:

```bash
npx skills add inference-sh/skills -g
```

This refreshes the skill to its latest published version. The skills.sh CLI does not auto-update — you need to manually re-run the install periodically.

---

### How do I uninstall a skill?

There is no standard uninstall command across all skill CLIs. For skills installed with `npx skills add -g`, remove the skill directory:

```bash
# Find where skills are installed
ls ~/.config/skills/
rm -rf ~/.config/skills/<owner>/
```

For project-local skills, remove the `node_modules/.skills/` or similar directory in your project, or check the skill's README for uninstall instructions. This is an area where the ecosystem is still maturing — most skills document their uninstall process in their respective SKILL.md files.

---

### Do skills work in any AI coding assistant?

Not all. Skill compatibility varies by assistant. A skill's front matter (in its `SKILL.md` file) lists compatible tools under the `compatibility` field. Common values include:

- Claude Code — most widely supported
- Cursor — good support, especially for `.mdc`-format skills
- Codex CLI — growing support
- OpenCode — supports the standard skills.sh format
- Web — skills that work through a browser interface rather than a terminal

Always check the `compatibility` list in the skill's page before installing. A skill built for Claude Code may not work in Cursor without adaptation.

---

### Why did my skill install fail?

Three common failure modes and how to fix them:

**1. "Command not found: npx"** — Node.js is not installed. Install Node.js 18+ and try again.

**2. "ENOENT: no such file or directory"** — The GitHub repo path is wrong. Verify the owner/repo slug at skills.sh or GitHub. Common mistake: typing the display name instead of the repo slug.

**3. Permissions error on global install** — On macOS/Linux, global npm commands sometimes need `sudo`. Safer fix: reconfigure npm prefix to a user-owned directory.

```bash
npm config set prefix ~/.npm
export PATH="$HOME/.npm/bin:$PATH"
```

Then run `npx skills add` without sudo.

---

### Can I install a skill locally in one project only?

Yes. Omit the `-g` flag:

```bash
cd ~/my-project
npx skills add inference-sh/skills
```

This installs the skill in the current directory rather than globally. The skill is only available when you're working in that project. This is useful for team-shared skills — commit the skill configuration to your project's repository so every team member gets it on clone.

---

### How do I know which skills are already installed?

Run:

```bash
npx skills list
```

This shows all globally and locally installed skills. If `npx skills` doesn't have a list command (some versions omit it), check the config directory:

```bash
ls ~/.config/skills/
```

Each subdirectory corresponds to a skill source repo.

---

### What should I do after installing a skill?

Test it with a simple prompt. After installing an image generation skill, try: "Generate an image of a cat sitting on a desk." After installing a web scraping skill, try: "Scrape the headlines from the front page of Hacker News." If the assistant doesn't pick up the skill, check:

1. Is the assistant compatible (per the skill's front matter)?
2. Did you restart the assistant session after installation?
3. Is the skill global or local to a different project directory?

Most skills surface their capabilities through natural language triggers — just describe what you want and the assistant routes to the correct skill.

---

## One Question I Wish People Asked

**"How do I choose between two skills that do the same thing?"**

Duplicate skills exist. For image generation alone, there's `ai-image-generation` (inference-sh/skills), `gpt-image-2` (agentspace-so/runcomfy-skills), and several others. They differ in backend model access, prerequisite setup, and output quality.

The answer is not in the skills.sh page — it's in the skill's `SKILL.md` file on GitHub, specifically the **comparison with siblings** section (if the author wrote one). Read the "When to pick this" guidance. Check prerequisites: does one need a paid API key while another works with a free tier? Does one require a separate CLI installation? These details determine which skill you'll actually use more than once. Testing both takes five minutes and beats reading spec sheets.

---

## Where to Go Next

- Browse all available skills at skills.sh (skills.sh)
- Read the skills.sh CLI documentation on GitHub
- Check the [find-skills](/skills/search/find-skills/) skill page for discovering new skills inside your assistant
- Visit [topaiskills.com/skills/](/skills/) for curated skill recommendations by category
