---
title: "minimal-run-and-audit: What Its Scripts Actually Record"
date: 2026-10-14
toc: true
draft: false
tags:
  - Deep Learning
  - Reproducibility
  - AI Agents
category: "guides"
description: "We ran RigorPilot's minimal-run-and-audit scripts on a real repo: the metric it calls best, the shell-mode gate, and a pipe that fakes success."
---

`minimal-run-and-audit` is RigorPilot's execution-evidence skill: you take one short command — a smoke test, a documented inference or eval run — execute it, and it normalizes what happened into `repro_outputs/` files a reviewer can audit. It is deliberately narrow. It does not pick your reproduction target, does not do repo intake, does not run training, and cannot be used as end-to-end orchestration by itself. I read the SKILL.md (2,761 bytes), `references/reporting-policy.md`, and both scripts, then cloned [lllllllama/RigorPilot-Skills](https://github.com/lllllllama/RigorPilot-Skills) (482 stars, last push 2026-09-23) and ran the runner eight times against a real repo. The scripts behave well. Three of them behave in ways the docs do not say out loud, and one of those can hand you a success that is not one.

The install counter needs a caveat first. On the 2026-10-14 skills.sh leaderboard, this skill sits at **456,657 installs with weekly [41,212, 41, 41, 30, 29, 40, 82, 3,504]** — a 41K week roughly seven weeks ago, six weeks of double digits, then 3,504 last week. The number is not this skill's own traction: `paper-context-resolver` reads 457,516, `repo-intake-and-plan` 456,726, and `env-and-assets-bootstrap` 456,558. RigorPilot also now publishes two separate counters, the ~457K group above and a ~317K group holding `ai-research-reproduction` (317,541), `analyze-project` (317,704), and `safe-debug` (317,223). If you are comparing these skills by install count, stop — you are comparing publish dates.

## Step 1: Confirm the Skill Applies Before You Run Anything

The SKILL.md is unusually strict about entry conditions, and following them saves the whole run. Apply it when a reproduction target and setup plan already exist, when the main skill needs execution evidence, or when the user already knows which command should be attempted and wants execution plus reporting only. Do not apply it during initial repo scanning, while the environment or assets are still undefined enough that execution would be meaningless, for literature lookup, or while the user is still deciding which run counts as the main one.

Two boundaries are worth reading twice. It "should not normalize risky code edits into acceptable practice," and it "must not hide changes that alter evaluation, preprocessing, checkpoints, metrics, or other scientific meaning." If you patch a repo file, the patch state goes into `SUMMARY.md` briefly and the full trail goes into `PATCHES.md`. Hidden or unlogged edits are the failure mode this skill exists to prevent.

## Step 2: Run the Command Through the Runner, Not by Hand

The command wrapper is `scripts/run_command.py`, and it takes a repo and a command:

```bash
python3 skills/minimal-run-and-audit/scripts/run_command.py \
  --repo /path/to/repo \
  --command "python3 scripts/smoke_test.py" \
  --timeout 60
```

Two flags decide what happens. `--shell-mode` defaults to `direct`, meaning argv execution with no shell. `--timeout` defaults to 60 seconds. In direct mode, a command containing shell syntax is refused before launch — I passed `git log --oneline | head -2` and got `status: "blocked"`, `main_blocker: "Executable not found for command: The documented command contains shell syntax. Re-run with --shell-mode native only after reviewing the command."`, and an execution log that begins `Command failed before launch`. That is the right default: it stops you from quietly running something you have not reviewed.

`native` shell mode executes it — and this is where my test turned up the one thing you have to watch. With `--shell-mode native`, the same piped command returned `status: "success"` and `main_blocker: "None."` while stderr contained `fatal: not a git repository (or any of the parent directories): .git`. The failing `git` command's exit code never reached the runner, because a pipeline reports the status of its last stage. Put a pipe in a native-mode command and a broken command can be recorded as a clean success. Two habits follow: prefer direct mode and keep the command single-process, and when you must use a pipeline, read stderr in the payload rather than trusting `status`.

Timeout and failure handling are honest, which is the point of the skill:

| Situation | `status` | `main_blocker` | `monitoring_scope` |
|-----------|----------|----------------|--------------------|
| Exit 0 | `success` | `None.` | `process_completion` |
| Exit 3 | `partial` | `Selected command exited with code 3.` | `process_completion` |
| Killed at a 2s timeout | `partial` | `Selected command did not finish within 2 seconds.` | `timeout:2s` |

The timeout case is worth internalizing: a command that hangs past `--timeout` is recorded as `partial` with `duration_seconds` 2.0167 in my run — partial, never success, never hidden. `blocked` is reserved for a command that never launched at all.

## Step 3: Read the Evidence Bundle, Not Just the Summary

Every run writes a runtime directory under `<repo>/repro_outputs/_runtime/<run-id>/` with `state.json`, `events.jsonl`, `stdout.log`, `stderr.log`, and `resources.jsonl`. The run ID is a UTC timestamp plus a short suffix — mine was `20261014T170321Z-9bc9eee7`. `--runtime-root` moves the directory if you do not want it inside the repo.

The resource block comes from the run itself, not from a monitor you started. My first run reported `samples: 1`, `max_root_process_rss_bytes: 7839744`, `max_root_process_cpu_seconds: 0.0`, `gpu_sampling_available: false`, and `duration_seconds: 0.141592`. `--monitor-gpu` is the opt-in that turns on NVIDIA device sampling; without it the GPU fields stay empty rather than reporting zeros you might mistake for measurements. The scope string — `root_process_and_optional_device_global` — tells you exactly what was sampled.

There is also a model identity block stamped onto every run. Unconfigured, it reads `status: "unconfigured"`, `adapter_id: "external-agent"`, `provider: "host"`, `model: "unspecified"`, with an empty capability list. If your reproduction claim depends on which model produced the numbers, that is the field your reviewer will look at first, and `--model-profile-json` plus `--require-model-capability` is how you make it real; demanding a capability the profile lacks fails the run at argument parsing, before anything executes.

## Step 4: Check What It Called Your Best Metric

The runner scans combined stdout and stderr for `name: value` pairs and reports `observed_metrics` plus a single `best_metric`. It does not choose the highest value. It filters out any name containing `loss`, `lr`, `time`, `mem`, `epoch`, `step`, `iter`, or `iteration`, then takes the **last** surviving match in log order. My test printed `epoch: 3 loss: 0.42 accuracy: 0.81 precision: 0.77` and the payload named `precision` 0.77 as best, with `accuracy` 0.81 sitting right there in the same dict.

Three consequences, all measured:

- Keep noisy metrics out of the log, or they disappear from `observed_metrics` too. A run printing only `loss: 0.9 time: 12.5` fell back to taking the last observed entry — `best_metric` became `time`, 12.5.
- Order matters more than magnitude. Print your headline metric last.
- The name pattern requires two or more characters. `F1: 0.88 P: 0.91 recall:0.8` captured `F1` and `recall` but silently dropped `P`. Single-letter or numeric-only names never appear.

Read `best_metric` as a convenience field, not as the audit's verdict. It lives alongside `observed_metrics` precisely so a human can disagree with it.

## Step 5: Emit the Normalized Outputs

`scripts/write_outputs.py` writes the bundle, and its CLI is small:

```
usage: write_outputs.py [-h] --context-json CONTEXT_JSON
                        [--mode {repro,train}] [--output-dir OUTPUT_DIR]
```

`--context-json` is required; `--mode` defaults to `repro` and `--output-dir` defaults to `repro_outputs`. The documentation's output expectations are the checklist for what you then verify: an execution result summary, the standardized `repro_outputs/` files, `SCIENTIFIC_CHANGELOG.md` for changed scientific meaning plus evidence status, `COMPARABILITY_REPORT.md` for README/paper/baseline comparability, and `PATCHES.md` whenever repo files changed — with verified, partial, and blocked states kept distinct.

Both scripts are wrappers, and this is the part that bites first-time installs. `write_outputs.py` loads a shared module from `parents[3]/shared/scripts/write_run_bundle.py` and falls back to `ai-research-reproduction/_bundled/shared/scripts/`; `run_command.py` needs `runtime_runner.py`, `model_adapter.py`, `command_utils.py`, and `resource_monitor.py` from the same shared tree. Install only the skill you want and you get a hard stop: `Shared writer missing: install all RigorPilot skills, including ai-research-reproduction.` The partner skill is not optional infrastructure — it carries the shared runtime.

## What the Report Should Sound Like

`references/reporting-policy.md` is 747 bytes and rules out most of what makes run logs unreadable. Reports stay short and factual; facts and inferences get separated; the documented command is named explicitly; the run is labeled full, partial, smoke-only, sanity-only, or blocked; the main blocker is stated without being buried. The priority order is clear result first, then copyable commands, a concise process trace, stable machine-readable state, and patch evidence when relevant. Explicitly avoided: long narrative journals, vague "it should work" language, and hiding unsupported assumptions.

That tone is the actual product. `run_command.py` will happily record a `partial` run with a blocker sentence and metrics you can argue about; it refuses to write a story. If you are using the rest of the family — [repo-intake-and-plan](/tutorials/guides/repo-intake-and-plan-narrative-experience/) for target selection, [ai-research-reproduction](/tutorials/guides/ai-research-reproduction-procedural/) for the full pipeline, or [paper-context-resolver](/skills/general/paper-context-resolver/) for reading the paper first — this is the skill that turns your one smoke command into evidence instead of an anecdote.

**Next step:** take the command you most want to claim works, run it through `run_command.py` with `--shell-mode direct` and a timeout you would not defend in a review, then read `main_blocker` and `status` before you read the metric. If it comes back `partial`, you already know more than the last person who ran it by hand.
