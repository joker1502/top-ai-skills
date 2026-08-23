---
title: "Resolve Git Merge Conflicts With AI: The 5-Step Workflow"
date: 2026-08-23
toc: true
draft: false
tags:
  - Git Workflow
  - Merge Conflicts
  - AI Coding
description: "A step-by-step guide to Matt Pocock's resolving-merge-conflicts skill, the five-step workflow that bans --abort, keeps both intents, and finishes every rebase."
category: "guides"
---

Resolve every hunk, never run `--abort`, and preserve both sides' intent — that's the complete doctrine of Matt Pocock's resolving-merge-conflicts skill (347.8K installs, #131 on the skills.sh all-time leaderboard). I read the SKILL.md out of the [mattpocock/skills](https://github.com/mattpocock/skills) repo (233K stars) after watching a coding agent hit its first real conflict: it stared at `<<<<<<<` markers, picked the HEAD side, and silently deleted a feature branch's work. The skill's rules exist to stop exactly that. This guide walks the five steps in order, with the exact behaviors the skill demands at each one.

## The Reflex That Costs You Work: --abort Is Not Resolution

An agent that hits a conflict usually does one of two things: it guesses a side, or it runs `git merge --abort` to escape the mess. Both lose information. Aborting throws away the merge state, but it also throws away the **context** — the partially-resolved hunks, the decisions already made, and the reason you started the merge at all.

The skill's instruction is flat and unqualified: *always resolve, never `--abort`*. There's no exception clause for "this is taking too long" or "the branches diverged badly". The merge state is a working session; abandoning it resets the problem to zero, and the next attempt starts from the same ignorance. If a conflict feels unresolvable, the fix is more investigation, not a restart.

## Step-by-Step: The Five-Step Resolution Workflow

**Step 1 — See the current state.** Run `git status` and `git log --oneline` to map where you are, then open the conflicting files. Know how many hunks you're facing before you resolve the first one. The skill groups this as one job: history plus files, read together.

**Step 2 — Find the primary sources.** For each conflict, dig up the commit messages, the PRs, and the original issues/tickets behind the changed lines. The skill is explicit about why: understand *deeply why each change was made, and what the original intent was*. A diff shows you two versions; only the primary sources tell you which intentions produced them. This step is where agents cut corners — they resolve the text they see instead of the intent behind it.

**Step 3 — Resolve each hunk.** Preserve both intents where possible; where they're truly incompatible, pick the one matching the merge's stated goal and **note the trade-off** in the resolution. Two hard prohibitions sit on this step: don't invent new behaviour, and never abort. If neither side's intent matches the merge goal, that's a finding to surface to the user — not a license to write a third version nobody asked for.

**Step 4 — Discover and run the automated checks.** Find the project's checks — typically typecheck first, then tests, then format — and run them. Fix anything the merge broke. The order matters: typecheck catches structural damage, tests catch behavioural damage, format catches the noise. A merge that passes all three is a merge you can trust. If you want a second pair of eyes on the result, the family's [code-review](/skills/general/code-review/) skill runs its smell audit over the merged code afterwards.

**Step 5 — Finish the merge or rebase.** Stage everything and commit. If you're rebasing, continue the rebase until every commit is rebased — the process ends only when `git status` reports a clean branch, not when the current commit looks okay.

## When Intents Clash: The Rule That Keeps the Merge Honest

Here's the scenario the rules are built for. Branch A changes a config default to `true` with a commit message about enabling the beta flag; branch B rewrites the same line to read from an env var, justified in its PR description. Both intents are alive in those two lines:

```text
<<<<<<< HEAD
feature_beta = true
=======
feature_beta = env("FEATURE_BETA", "false")
>>>>>>> feature/env-config
```

Preserving both intents means the env-var indirection wins (branch B's structural intent) — but the beta *should* default to on (branch A's behavioural intent), so the resolution is `feature_beta = env("FEATURE_BETA", "true")`. Pick the merge's stated goal, keep both behaviours, and say so in the commit message. The skill's real talk is blunt: inventing a third behaviour — say, silently deleting the flag — is the one unforgivable sin, because nobody can review what you never wrote down.

Real talk from running this: step 2 is where the time actually goes. Resolving hunks takes minutes; finding the PRs and issues that explain *why* the lines changed takes longer, and it's the part agents skip first. Skip it and you get a green build with a silently-wrong default.

## How This Differs From the Manual Reflex

| Situation | Typical manual reflex | This skill's rule |
|-----------|----------------------|-------------------|
| Conflict feels stuck | `git merge --abort`, try again later | Resolve, never abort — state is context |
| Two lines changed the same spot | Pick HEAD (or pick "theirs") | Preserve both intents, note the trade-off |
| Merge broke the build | Fix the symptom, commit quickly | Run typecheck → tests → format, fix root causes |
| Don't know why a change exists | Read the diff lines | Read commit messages, PRs, and issues first |

The difference is one of evidence. Manual resolution reads the two versions in front of you; this workflow reads the record behind them. That's the same evidence habit the family's [diagnosing-bugs skill](/tutorials/guides/diagnosing-bugs-skill-faq/) applies to failures — no theorising until the sources are in hand.

## Bottom Line

Resolving a merge conflict with this skill is a five-step sequence: map the state, read the primary sources, resolve hunks without inventing behaviour, run the checks, finish the merge. The two rules that actually matter are the ones most agents violate first — never abort, and never invent. Install the family with `npx skills@latest add mattpocock/skills`, pick `resolving-merge-conflicts`, and next time an agent reports a conflict, ask it for the primary sources before it touches a hunk. The diff will take care of itself.