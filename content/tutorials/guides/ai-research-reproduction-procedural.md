---
title: "Reproduce an AI Paper Repo: The 9-Step Rigor Sequence"
date: 2026-08-28
toc: true
draft: false
tags:
  - Deep Learning
  - Reproducibility
  - AI Agents
description: "RigorPilot's ai-research-reproduction (310.8K installs) runs DL repos as 9 README-first steps: smallest target, audited patches, repro_outputs/ evidence."
category: "guides"
---

"Run this repo" is the most dangerous sentence in deep learning. Pick the whole training script as your target and the run dies somewhere in epoch two, and you can't tell whether the code is broken or your setup is. RigorPilot's `ai-research-reproduction` skill (310,832 installs, #162 on the skills.sh all-time board) exists to change that bet: it forces a README-first, smallest-honest-target pipeline that ends in a standardized `repro_outputs/` evidence bundle. I read its SKILL.md, its patch policy, and its agent config on 2026-08-28. This guide walks the nine steps in order, with the exact rules that keep each one honest.

## Steps 1–2: Read the README First, Then Extract a Plan

Step 1 is not a command. It's reading the README and the signals around the repo, because the README is treated as the **primary reproduction intent**. Repository files exist to clarify it, never to silently replace it — the skill says that explicitly. When the README and the paper disagree, you record the conflict and hand the narrow gap to the family's paper-context-resolver helper, not to your own guess.

Step 2 hands the repo to `repo-intake-and-plan`, which extracts the documented commands and candidate targets into a plan. This is where most reproduction attempts go wrong: they skip planning and run the first bash line they see. The skill's counter-move is a **trusted target ladder**, chosen smallest-first:

1. **Documented inference** — the cheapest honest demonstration.
2. **Documented evaluation** — metrics against a checkpoint.
3. **Documented training startup or partial verification** — a few steps, not an epoch.
4. **Full training** — only after explicit user confirmation.

## Steps 3–7: Pick the Smallest Honest Target, Then Run With Evidence

Step 3 selects and *justifies* the minimum trustworthy target. If the README documents inference, you do not reach for training. The justification is a real artefact, not a formality — it's what makes the difference between "I ran something" and "I ran the thing the repo claims."

Steps 4 and 5 are scoped helpers: `env-and-assets-bootstrap` only for target-specific environment, checkpoint, dataset, and cache assumptions; `analyze-project` only for read-only questions about structure, insertion points, or suspicious implementation patterns. Neither is a general-purpose setup tool. Step 6 runs `minimal-run-and-audit` for the documented inference, evaluation, smoke, or sanity execution; step 7 switches to `run-train` if your selected target is training startup, short-run verification, or a full kickoff.

The **patch boundary** sits across all of these. Default stance: no repository edits. When reproduction is blocked, the allowed-first classes are environment variables, filesystem path fixes, dependency pin adjustments, `requirements.txt` corrections, and command-line arguments that preserve documented intent. With caution: small compatibility fixes for modern Python or library versions, explicit path joins, OS portability fixes. Default-disallowed: architecture changes, dataset label changes, loss or metric definition changes, training-loop rewrites, inference-output rewrites, and any silent change that makes the command "pass" but alters experiment meaning. If repository files must change anyway, create a branch named `repro/YYYY-MM-DD-short-task` before the first edit, commit verified patches as sparse groups with messages like `repro: <scope> for documented <command>`, and record the README-fidelity impact in `PATCHES.md`.

## Steps 8–9: Human Gates, Then the Evidence Bundle

Step 8 is the skill's real innovation: a mandatory pause for human review *before* fuller training claims, and before any change that could alter dataset, split, checkpoint, preprocessing, metric, loss, model semantics, or result interpretation. The agent is instructed to stop and surface the decision rather than charge through it. That gate is what separates this from a script that just grinds until something runs.

Step 9 writes the standardized bundle under `repro_outputs/`:

```text
SUMMARY.md               # shortest high-value summary
COMMANDS.md              # copyable commands
LOG.md                   # process evidence, assumptions, failures, decisions
SCIENTIFIC_CHANGELOG.md  # scientific meaning and change effects
COMPARABILITY_REPORT.md  # comparison anchors and protocol deviations
status.json              # durable machine-readable state
ANNOTATED_README.md      # README verbatim, per-section colored annotations
PATCHES.md               # only if patches were applied
```

Two rules govern every file: verified facts are separated from inferred guesses, and the agent writes its final note in the user's language when practical. The `ANNOTATED_README.md` is the at-a-glance view — the README replayed verbatim, each section annotated in color with what the agent did there, linked back to the evidence files. A failed run isn't buried either: failed and later-resolved runs are auto-recorded as lessons via `shared/scripts/lessons_store.py`, disableable with `RIGORPILOT_LESSONS=0`.

| | "Make it run" reflex | Rigor reproduction |
|:--|:--|:--|
| First move | run the training script | read the README, extract commands |
| Target | whatever looks impressive | smallest documented inference/eval/training-start |
| Fix for a crash | patch the code, keep going | env vars / path / dep pins first; code edits audited |
| Evidence | terminal scroll | `repro_outputs/` with 8 artefacts |
| Training claims | "it started training" | human review gate before fuller claims |

The numbers explain the family's shape. The flagship `ai-research-reproduction` sits at 310,832 all-time installs while its two helpers — `paper-context-resolver` (450,773) and `repo-intake-and-plan` (450,016) — outsell it, the rare leaderboard where the helper tier beats the main event (skills.sh, 2026-08-28). Weekly installs for the flagship ran 20,528 → 22,267 → 26,717 → 25,099 → 11,179 → 32,246 → 50,263 → 41,228 over the last eight weeks. The helpers win on installs because they answer narrow questions; the entrypoint only earns its keep on full runs.

## Bottom Line

A trustworthy reproduction is nine steps: read the README, extract a plan, justify the smallest honest target, bootstrap only what the target needs, audit read-only, run minimal, train only when confirmed, pause at the human gate, and write the evidence bundle. The two rules that carry the whole design are the ones agents violate first — never let a repo file silently replace README intent, and never let a patch change scientific meaning. Install the family with `npx skills add lllllllama/rigorpilot-skills --all`, pick `ai-research-reproduction`, and point it at a repo you've been meaning to run. The helper it delegates to on paper gaps, [paper-context-resolver](/skills/general/paper-context-resolver/), is worth reading on its own, and the [AI Agent Skills FAQ](/tutorials/guides/ai-agent-skills-faq/) covers setup if you're new to skills. If the run still fails at the end, the LOG.md is the deliverable — that's the point.