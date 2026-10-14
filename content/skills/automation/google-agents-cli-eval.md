---
title: "google-agents-cli-eval: Grade Your Agent, Not Your Vibes"
date: 2026-10-14
draft: false
tags:
  - Google Cloud
  - ADK
  - Evaluation
category: "automation"
description: "Google's agents-cli-eval skill: the 4-stage Quality Flywheel, judge metrics, and the region traps. We read all 24.9 KB — 495K installs."
---

`google-agents-cli-eval` is the sibling skill that turns "my agent feels better now" into a number you can paste. It covers the Gemini platform eval methodology end to end: dataset schema, judge-based metrics, failure clusters, and the prompt-optimization path. I read the whole SKILL.md — v1.10.0, 24,948 bytes, inside [google/agents-cli](https://github.com/google/agents-cli) (6,092 stars, last push 2026-10-12) — and scraped the skills.sh leaderboard on 2026-10-14: **494,982 installs, weekly [10,658, 13,005, 42,960, 57,863, 73,310, 132,549, 53,045, 16,002]**. Every one of the seven agents-cli skills sits inside a 1,108-install band (adk-code 495,962 down to observability 494,854), so read that counter as suite traction, not as this skill's own pull. What the skill actually buys you is the correction mechanism for the one thing agent developers get wrong most: rewriting prompts on instinct and calling it improvement.

## The Quality Flywheel Has Four Stages, and You Skip One

The loop is Prepare Data → Run → Analyze → Optimize, then back to Run. Each stage ships a default path you do yourself and an opt-in CLI command that delegates to the Eval Service in Gemini platform for more scale.

Two of those defaults matter more than they look. `agents-cli eval run` chains generation and grading in one shot and writes `results_<ts>.json` plus `.html` into `artifacts/grade_results/`. When you want to re-grade without re-running the agent — a real need, because the judge model is the expensive half — you fall back to `eval generate` then `eval grade`, and the canonical pairing is `--output custom_traces/` on the first and `--traces custom_traces/` on the second. The scaffolded project already has `tests/eval/datasets/`, `tests/eval/eval_config.yaml`, and a custom metric waiting, so the honest starting move is to run `eval run` before authoring anything new.

The stage most people delete is the honest one. The skill tells you to hold a slice of cases out of the iteration loop and grade them only when you believe you are finished — otherwise you cannot tell a fix that generalizes from a fix fitted to the cases you were staring at. Expect 5-10+ iterations per case before it passes, and keep a task list once you pass five so you stop re-attempting the same fix. That is a slower loop than rewriting the instruction and eyeballing one happy path. It is also the only version that produces evidence.

## Metrics: Pick by Question, Not by Habit

Only three built-ins accept multi-turn traces: `multi_turn_task_success`, `multi_turn_trajectory_quality`, and `multi_turn_tool_use_quality`. Every other built-in 400s on one. So for a conversational agent, "which metric" is mostly decided for you, and the choice collapses to what you want to measure:

| Question | Metric |
|----------|--------|
| Did the agent hit the user's goal? | `multi_turn_task_success` |
| Was the reasoning path efficient? | `multi_turn_trajectory_quality` |
| Were tool calls well chosen across turns? | `multi_turn_tool_use_quality` |
| Is the final answer good, with no golden reference? | `final_response_quality` |
| Did it invent facts? | `hallucination`, or `grounding` when the case carries `context` |
| Does it match a known-good answer? | `final_response_match` (needs `reference`) |
| Different pass criteria per case | `rubric_groups` + a managed rubric metric |
| Nothing built-in fits | custom `LLMMetric` or `CodeExecutionMetric` |

Run `agents-cli eval metric list` for the live list. The skill's harder warning is about sequence matching: hardcoding the exact order of tool calls breaks the moment the agent makes a useful extra call, so it pushes `multi_turn_tool_use_quality` and `multi_turn_trajectory_quality`, which build adaptive content- and intent-based rubrics and let the judge reason about intent instead of comparing strings.

Configuration is one YAML or JSON file with two separate parts, and conflating them is the common mistake. `metrics_to_run` is the selection list for this invocation; `custom_metrics` is a definition pool. Defining a metric in the pool does not run it. YAML is preferred for a concrete reason — prompts and Python snippets stop needing escape characters.

## The Region Rules That Fail Mid-Session

Evaluation services support only a subset of regions, and the defaults do not follow your project. `eval run`, `eval grade`, and `eval submit` all go to the `global` endpoint regardless of the manifest's `region`, and `eval analyze` is global-only. Override per run with `--region`, and if the region is unsupported you get a specific rejection: `400 FAILED_PRECONDITION: Unsupported region for Vertex Evaluation Service`.

The other half is the inverse. `eval generate` without `--url` and `eval dataset synthesize` run your agent locally, so they take **no** `--region` flag at all and honor the agent's own `.env` — notably `GOOGLE_CLOUD_LOCATION`, which picks the model endpoint when the agent runs on Gemini platform. One trap hides inside `synthesize`: scenario generation is a server-side eval call pinned to `GOOGLE_CLOUD_LOCATION`, so that variable has to stay in an eval-supported region even when the agent itself runs somewhere else. The skill's cleaner fix is to pin the location in code — `Gemini(model=…, client_kwargs={"location": …})` beats the environment variable and leaves the env var free for everything else.

If no supported region satisfies your residency rules, the escape hatch is local custom metrics: a `custom_metrics` entry with `custom_function` grades in-process, no GCP region needed, and your function can still call a judge model in a compliant region. You give up the managed built-ins; you keep LLM-as-judge.

Live agents add their own pair of preconditions. Passing `--mode adk_live` sends cases over the ADK `/run_live` WebSocket instead of `/run_sse`, the audio reply gets transcribed, and the transcript is what gets graded. Two things must already be true or the socket connects and then dies mid-session: the agent must use a Live model — the scaffold default is not one — and on Gemini platform the region must be pinned on the model rather than left to `GOOGLE_CLOUD_LOCATION`.

## Four Shortcuts the Skill Refuses to Let You Take

This table is why the skill is worth installing even if you already have an eval harness. Every entry is a rationalization the SKILL.md names out loud:

| Shortcut | Why it costs more than it saves |
|----------|--------------------------------|
| "Lower the bar so it passes" | You hid a real failure. Fix the agent, not the threshold. |
| "This case is flaky, skip it" | Flakiness is non-determinism in your agent. Fix it with `temperature=0`, rubric metrics, or tighter instructions. |
| "I'll fix the dataset, not the agent" | If you keep editing expected outputs, the agent has a behavior problem. |
| "Iterate until every case passes" | Nothing is left to detect overfitting to your own cases. |

There is a fifth, larger one: trusting the exit code. `eval run` exits 0 whatever the scores are, so the numbers you paste are the gate, not the return value. The skill's "Proving Your Work" section is blunt about this — paste the scores table after a run, show before/after for the case you fixed plus confirmation that nothing else regressed, and before deploying rerun the full suite and show every case.

One warning is financial. `eval optimize` runs ADK GEPA prompt optimization against a target metric, makes many LLM calls, and can run for a long time. Manual fixes first, then a **single** final `eval optimize` — never loop on it. Also, the optimized prompt lands in the command output; you capture and apply it yourself.

## Where This Skill Sits in the Suite

The seven agents-cli skills divide cleanly, and each one's description routes you to the right neighbor rather than letting you guess:

| Skill | Owns | Installs (2026-10-14) |
|-------|------|----------------------|
| `google-agents-cli-eval` | Datasets, metrics, judge scoring, optimization | 494,982 |
| [`google-agents-cli-deploy`](/skills/automation/google-agents-cli-deploy/) | Targets, scaling, IAM, rollout gates | 495,311 |
| `google-agents-cli-observability` | Cloud Trace, prompt-response logs, BigQuery analytics | 494,854 |
| [`google-agents-cli-adk-code`](/skills/coding/google-agents-cli-adk-code/) | ADK API patterns, agent code | 495,962 |
| `google-agents-cli-scaffold` | Project creation and enhancement | 494,893 |
| `google-agents-cli-workflow` | Spec-driven build → eval → deploy lifecycle | 494,996 |
| `google-agents-cli-publish` | Publishing the agent | 495,132 |

Follow the boundary and the skill works on any agents-cli project whatever framework your agent is written in; the ADK-only sections are labelled as such. Three ADK-only gotchas are worth carrying into the first run even so, because each one produces a confusing error rather than an obvious one: the `App` object's `name` must match the directory containing your agent or you get "Session not found"; session-state variables used in an instruction template need a `before_agent_callback` to initialize them or the first turn raises `KeyError`; and models with thinking enabled may skip tool calls entirely, which you fix through the tool-choice config (`mode="ANY"`) rather than by rewording the instruction.

**Next step:** run `agents-cli eval run` on the scaffolded dataset, open `artifacts/grade_results/results_<ts>.html`, and paste the scores to whoever has to approve the deploy. If the numbers are bad, pick the failing metric off the fix table above instead of rewriting prompts and hoping. Then install the eval dataset idea into your workflow once — the deploy gate in `google-agents-cli-deploy` expects those numbers anyway.
