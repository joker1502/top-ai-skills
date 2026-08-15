---
title: "Grill with Docs: Plan Interviews That Write ADRs as You Go"
date: 2026-08-15
draft: false
tags:
  - Plan Review
  - AI Agent
  - Documentation
description: "A 735K-install Matt Pocock skill that stress-tests your plan with design-tree interviews and writes ADRs plus a glossary as you go. #4 on skills.sh all-time."
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
github_stars: 218205
github_forks: 18794
installs: 735200
last_updated: "2026-08-15"
ai_friendliness:
  score: 4.5
  documentation: 5.0
  setup: 4.0
  config: 4.0
---

Grill with Docs is a plan-review skill that interrogates you about a design decision and writes the documentation while it does. Matt Pocock built it, and it sits at #4 on the skills.sh all-time leaderboard with 735,200 installs. I pulled the actual skill files out of the [mattpocock/skills](https://github.com/mattpocock/skills) repo (218K stars) and walked the workflow piece by piece, because the README undersells what this thing does.

## What It Actually Does

The entire skill file is one sentence of orchestration: *"Run a /grilling session, using the /domain-modeling skill."* Everything interesting lives in those two components.

One quirk jumped out immediately: the skill sets `disable-model-invocation: true`. The model cannot trigger it on its own, no matter how much your prompt sounds like a plan review. You have to invoke `/grill-with-docs` explicitly. That constraint tells you the author learned the hard way what happens when an interview skill fires mid-conversation. The skill also ships an OpenAI agent definition (`openai.yaml`) with the same rule — `allow_implicit_invocation: false` — so the behavior carries across agent runtimes, not just Claude Code.

## How the Interview Actually Works

The grilling half maps every decision into a **design tree** and questions it in rounds. Each round, the model computes the *frontier* — every decision whose prerequisites are already settled — and asks the whole frontier at once, numbering each question and giving you its recommended answer. You answer, the tree reshapes, and the next frontier opens up.

Two rules make this different from a normal "challenge my plan" chat. Finding facts is the model's job, never yours: when a frontier question needs something from the filesystem or a tool, it dispatches a sub-agent instead of asking you. The session also ends only when the frontier is empty — every branch visited, nothing left silently assumed. It refuses to act on the plan until you confirm shared understanding.

The domain-modeling half captures what the interview resolves. Settled terms go straight into `CONTEXT.md` — a glossary, explicitly "a glossary and nothing else," with implementation details banned. Decisions worth recording become ADRs in `docs/adr/`, but only when all three conditions hold: the choice is hard to reverse, a future reader would find it surprising without context, and it came from a real trade-off with genuine alternatives. Miss any one, and the skill skips the ADR. Repos with multiple contexts get a `CONTEXT-MAP.md` that points to each context's glossary and ADR folder.

## Grill with Docs vs. Grill Me

Both skills come from the same repo, and they overlap enough that you should pick deliberately.

| | Grill Me | Grill with Docs | Plain "review my plan" |
|---|---|---|---|
| What gets questioned | The plan itself | The plan + your domain language | Whatever the model feels like |
| Artifacts left behind | None | ADRs + CONTEXT.md glossary | None |
| Best moment | Before you start coding | When decisions outlive the session | Quick sanity check |
| Installs on skills.sh | 864.3K | 735.2K | — |

Grill Me interrogates your thinking and stops there. Grill with Docs does the same interrogation, then pins the answers into files your future self (or your teammates) will actually read. If your project has no `CONTEXT.md` and no `docs/adr/` folder yet, the skill creates them lazily — the first resolved term, the first qualifying decision.

## Bottom Line

If you just want a sharper plan, Grill Me is enough. If the decisions you're making will still matter in six months — architecture, data model, integration boundaries — Grill with Docs pays for itself by writing the docs that would otherwise rot on your "document this later" list. Install it with `npx skills@latest add mattpocock/skills` (pick it in the installer), or `claude plugins install mattpocock-skills` for the managed plugin version. For a plan-only interrogation that skips the documentation, see our [Grill Me intro](/skills/general/grill-me/).
