---
title: "Setup Matt Pocock's Skills: Prepare Your Repo for AI Agents"
date: 2026-08-16
draft: false
tags:
  - Repo Setup
  - AI Agent
  - Engineering
description: "A 631K-install skill that sets up your repo for Matt Pocock's engineering skills: issue tracker, triage labels, and domain docs in one pass. #9 on skills.sh."
version: "1.0"
author: "Matt Pocock"
repo_url: "https://github.com/mattpocock/skills"
install_cmd: "npx skills@latest add mattpocock/skills"
compatibility:
  - Claude Code
  - Codex
  - Cursor
category: "general"
rating: 4.5
github_stars: 219056
github_forks: 18871
installs: 631300
last_updated: "2026-08-16"
ai_friendliness:
  score: 4.5
  documentation: 4.5
  setup: 4.0
  config: 4.0
---

Setup Matt Pocock's Skills is the one-time configuration pass that every other engineering skill in the [mattpocock/skills](https://github.com/mattpocock/skills) repo (219K stars) quietly depends on. It ranks #9 on the skills.sh all-time leaderboard with 631,300 installs, and its job is boring on purpose: decide where your issues live, what triage labels mean, and where domain docs go — once, up front, so the skills that run later don't have to guess. I pulled the actual skill folder out of the repo and read every file, because the README undersells what this thing decides for you.

## What It Actually Does

Run it once, and it writes the config files that `to-tickets`, `triage`, and `to-spec` read before they touch your repo. The output lands in `docs/agents/`: an issue-tracker file, a domain-docs file, a triage-labels file (only when the `triage` skill is installed), plus an `## Agent skills` block appended to your `CLAUDE.md` or `AGENTS.md`.

The skill is prompt-driven, not scripted. It explores your repo first, presents what it found, takes your answers one section at a time, shows you a draft, and only then writes anything.

## The Three Decisions It Makes You Make

**Section A — where your issues live.** You get four options: GitHub (driven by the `gh` CLI), GitLab (`glab`), local markdown files under `.scratch/<feature>/`, or any other tracker you describe in one paragraph of freeform prose. The skill defaults to GitHub when `git remote -v` points there, and GitLab for GitLab remotes. The choice gets recorded in `docs/agents/issue-tracker.md` with the exact CLI conventions for creating, reading, and labeling issues. A "PRs as a request surface" flag ships in the GitHub and GitLab templates, defaulted off — the skill won't even raise it unless you flip it yourself.

**Triage labels only get configured when the `triage` skill is installed.** Exploration checks your available skills first and skips Section B entirely otherwise. The defaults are five labels: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. Say no to the defaults only when your tracker already uses different names, and the skill records the mapping instead of creating duplicates.

**Domain docs default to single-context: one `CONTEXT.md` plus `docs/adr/` at the root, written without asking.** Multi-context — a `CONTEXT-MAP.md` pointing at per-context files — comes up only when exploration finds monorepo signals: a `pnpm-workspace.yaml`, a `workspaces` field in `package.json`, or populated `packages/*` directories.

## The Quirks Worth Knowing

Three details jumped out while I read through the skill folder file by file.

First, the skill refuses to decide which file to edit. If `CLAUDE.md` exists it edits that; otherwise `AGENTS.md`; if neither exists it asks you — and it will never create the one that's missing. That anti-duplication rule is easy to miss because the skill's own description never mentions it.

The second quirk: it ships `disable-model-invocation: true`, the same flag as Grill with Docs. The model can't trigger this skill mid-conversation no matter how relevant the moment looks. You type `/setup-matt-pocock-skills` explicitly.

Then there's the quietest detail, buried in the `domain.md` seed template: downstream skills proceed silently when `CONTEXT.md` doesn't exist. No flagging, no nagging to create it — `/domain-modeling` creates those files lazily, only when a term or decision actually gets resolved. That default is why this skill family doesn't litter fresh repos with empty scaffolding.

## When You Can Skip It

Solo project, no remote, none of the engineering skills installed? Skip the setup. The only consumers are `to-tickets`, `triage`, `to-spec`, `grill-with-docs`, `domain-modeling`, and `improve-codebase-architecture` — none installed, nothing to configure. The skill agrees: it drops Section B on its own when `triage` isn't present.

## Bottom Line

If you use any of Matt Pocock's engineering skills, run this once before the first use. The alternative is those skills guessing where your issues live, or writing ADRs into a folder nobody reads. Re-running is only necessary when you switch issue trackers or want a clean restart — the config files are plain markdown you can edit by hand anytime. Install it with `npx skills@latest add mattpocock/skills` and pick it in the installer, or `claude plugins install mattpocock-skills` for the managed plugin. The skill it most often precedes, [Grill with Docs](/skills/general/grill-with-docs/), is the one that turns this domain-doc setup into actual ADRs — and if you want the interrogation without the documentation, [Grill Me](/skills/general/grill-me/) is the lighter sibling.
