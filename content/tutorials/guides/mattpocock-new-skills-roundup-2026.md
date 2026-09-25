---
title: "New Matt Pocock Skills: Guardrails, Loops, and Beats"
date: 2026-09-25
draft: false
toc: true
tags:
  - Matt Pocock
  - Agent Skills
  - Developer Workflow
category: "guides"
description: "Seven new mattpocock/skills entries — guardrails, pre-commit, loops and beats — 270K–398K installs on matching launch curves."
---

Matt Pocock's skill family grew a second wave, and it never touched the engineering or productivity folders this site has been covering. I pulled the leaderboard on 2026-09-25: seven new [mattpocock/skills](https://github.com/mattpocock/skills) entries sit between ranks 139 and 237 — git-guardrails-claude-code (398.4K installs), setup-pre-commit (389.9K), writing-beats (383.6K), migrate-to-shoehorn (379.4K), loop-me (338.4K), claude-handoff (314.9K), setup-ts-deep-modules (270.0K). In the repo they live in `misc/` and `in-progress/`, deliberately apart from the main family. I read all seven SKILL.md files and compared what each one actually forces an agent to do. All seven ship with `disable-model-invocation: true` — nothing fires without a human asking, same as the rest of the family.

## The Enforcement Installers (misc/)

Three of the new skills are installers. They wire enforcement into a repo once, so the agent can't silently violate it afterwards.

**git-guardrails-claude-code** blocks dangerous commands before Claude executes them. It drops a PreToolUse hook — a bash script matched to the Bash tool — that intercepts `git push` in every variant including `--force`, `git reset --hard`, `git clean -f` / `-fd`, `git branch -D`, and `git checkout .` / `git restore .`. A blocked agent sees a message saying it lacks authority for the command. Scope is the user's call: this project only (`.claude/settings.json`) or all projects (`~/.claude/settings.json`), and an existing settings file gets the hook merged in, never overwritten. Verification is concrete: pipe the JSON payload for `git push origin main` into the script and expect exit code 2 with a BLOCKED message on stderr.

**setup-pre-commit** builds the commit-time gate: Husky plus lint-staged, with Prettier on staged files and typecheck + test in the pre-commit hook. The order matters — lint-staged first because it's staged-only and fast, then full typecheck and tests. It detects the package manager from the lockfile, drops the typecheck/test lines when those scripts don't exist, and the final step commits the whole setup through its own new hooks as a smoke test. Two details stick: Husky v9+ needs no shebang in hook files, and `prettier --ignore-unknown` skips images and other files Prettier can't parse.

**migrate-to-shoehorn** retires `as` assertions in test files. The npm package is `@total-typescript/shoehorn`, and the mapping is small: `as Type` → `fromPartial()`, `as unknown as Type` → `fromAny()`, with `fromExact()` for forcing a full object. Test files only — the skill says never use shoehorn in production code. It hunts candidates with `grep -r " as [A-Z]" --include="*.test.ts" --include="*.spec.ts"`, replaces, adds imports, and runs a type check to verify.

## setup-ts-deep-modules: Rules That Prove They Bite

The most ambitious of the seven wires [dependency-cruiser](https://github.com/sverweij/dependency-cruiser) into a repo and enforces the deep-module shape: a package's root files are its public entry points, and *anything* in a subfolder is private. Four `error`-level rules do the work — entry-point boundary (outside code may import only root files), intra-package freedom, tests through entry points only (a test may not deep-import even its own package's internals), and no dependency cycles. `$1` back-references in the depcruise config let a package reach its own internals while keeping outsiders out, and because public-vs-private is decided by depth alone, adding a new folder never requires a config change.

Two design choices stand out. First, **entry points, not barrels** — the config discourages funneling a whole subtree through one giant `index.ts`; a package exposes several small root files (`index.ts`, `client.ts`, `server.ts`). Second, the completion test is the good part: `lint:boundaries` must **pass** on the clean example, **fail** when you temporarily add a deep import, and **pass** again after reverting it. "A config that doesn't fail on a violation is worthless" is the stated criterion. It finishes by writing a README in the packages folder and adding a one-line context pointer to `CLAUDE.md` or `AGENTS.md`, so an agent discovers the boundary rule instead of tripping over it.

## The Process Skills (in-progress/)

Four skills sit in `in-progress/`, and they impose discipline rather than plumbing: on how the agent writes, hands off, and specifies.

**claude-handoff** replaces saving a summary with launching a fresh background agent seeded by it: `claude --bg --name "<descriptive name>" "<handoff summary>"`. It starts in the current working directory, returns immediately, and the user manages it with `claude agents`. The summary must carry a "suggested skills" section naming the skills the next agent should call, must not duplicate content already captured in specs or commits (reference those by path instead), and must redact keys and PII — the summary *becomes* the next agent's prompt.

**loop-me** grills you into workflow specs. It runs a stateful grilling session whose only output is `workflows/*.md` — one spec per recurring loop in your life: career, week, morning, any repeated activity. The vocabulary is small and optional: **trigger** (an event or a schedule — event usually cheaper), **checkpoint** (a human-in-the-loop point), **push right** (defer the checkpoint as far as it goes, so the human is asked once, late, with everything prepared), **brief** (a decision-ready summary, never the raw output). The definition of done is sharp: a spec is done when an implementer agent could build it without asking a single question. Nothing is done while a question remains.

**writing-beats** is exploit-phase writing — the raw material pile is fixed, and the agent commits to a path through it. The mechanism is grounding: every concept must be grounded before a beat leans on it, either as a prerequisite the audience brings or introduced by an earlier beat. The agent offers 2-3 candidate starting beats, the user picks one, and it writes **only that beat** to the file, stops, re-reads from disk, then offers the next 2-3 pivot points. Reachability decides the choose-your-own-adventure: a candidate beat is only offered if everything it requires is already grounded. Never write ahead, preserve user edits absolutely.

## What the Numbers Say

The leaderboard tells the same story as the repo layout. All seven weekly curves share one shape — roughly [20K, 22K, 19K, 29K, 32K, 31.8K, 29K, 27K] across the eight-week window, with the widest spread between any two skills in a given week under 700 installs. Yet the install totals diverge hard: 398.4K down to 270.0K. That is the signature of separate counters sharing one launch wave — registered and promoted together, each counting its own installs — not the pack-lockstep counters we've documented for azure-skills and prisma, where totals barely differ. The week-3 dip and the surge to ~32K in week 5 look like the index catching the wave mid-flight.

| Skill | Repo home | What it does | Reach for it when |
|:--|:--|:--|:--|
| git-guardrails-claude-code | misc/ | PreToolUse hook blocks push / reset --hard / clean / branch -D | You want a hard stop on destructive git |
| setup-pre-commit | misc/ | Husky + lint-staged + Prettier + typecheck + test | You want commit-time gates automated |
| migrate-to-shoehorn | misc/ | `as` → fromPartial / fromAny in tests | Test files fake huge objects with `as` |
| setup-ts-deep-modules | in-progress/ | dependency-cruiser deep-module boundaries | Packages import each other's internals |
| claude-handoff | in-progress/ | Fresh background agent seeded with a summary | A session must continue without you |
| loop-me | in-progress/ | Grills you into workflow specs | Recurring work deserves a spec |
| writing-beats | in-progress/ | Beat-by-beat article assembly with grounding | Raw notes need a shape, not an outline |

## Bottom Line

The family installs with `npx skills@latest add mattpocock/skills`, and the [ask-matt / wayfinder / to-tickets roundup](/tutorials/guides/ask-matt-wayfinder-to-tickets-roundup/) covers the rest of the flow. Start with git-guardrails-claude-code if you've watched an agent push straight to main on its own, or setup-pre-commit when the commit gate is missing. The process four reward a read before judgment — loop-me and writing-beats change how a session runs the most. Note that claude-handoff is not a replacement for the older [handoff](/skills/general/handoff/) skill: handoff writes a summary file for the next human-minded session, claude-handoff skips the file and launches the agent directly. And for the deep-module vocabulary, [codebase-design](/skills/general/codebase-design/) is the language layer setup-ts-deep-modules enforces; the [wizard FAQ](/tutorials/guides/wizard-skill-faq/) shows the family's other template-scripting style.