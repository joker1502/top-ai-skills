---
title: "Diagnosing Bugs Skill FAQ: The Feedback Loop Comes First"
date: 2026-08-22
toc: true
draft: false
tags:
  - Diagnosing Bugs
  - AI Debugging
  - Engineering
description: "Straight answers on diagnosing-bugs: why the red-capable loop precedes hypotheses, how flaky bugs become debuggable, and when regression tests should wait."
category: "guides"
faq:
  - question: "What does the diagnosing-bugs skill actually do?"
    answer: "It runs a six-phase discipline for hard bugs and performance regressions: redact secrets, build a feedback loop, reproduce and minimise, rank hypotheses, instrument, then fix with a regression test and clean up. The skill triggers whenever you say 'diagnose' or 'debug this', or report something broken, throwing, failing, or slow. Phases can be skipped only with explicit justification — the whole point is stopping the agent from guessing."
  - question: "Why does it demand a feedback loop before any hypothesis?"
    answer: "Because that phase is the skill — everything else is mechanical. A tight pass/fail signal that goes red on the actual bug makes the cause findable through bisection, hypothesis-testing, and instrumentation. Without that signal, no amount of staring at code saves you. The SKILL.md is blunt: if you catch yourself reading code to build a theory before a red-capable command exists, stop — jumping straight to a hypothesis is the exact failure this skill prevents."
  - question: "What counts as a tight, red-capable loop?"
    answer: "One command you have already run at least once — a test invocation, script path, or curl — that drives the real bug code path and asserts the user's exact symptom, so it can go red on this bug and green once fixed. It must be deterministic (same verdict every run), fast (seconds, not minutes), and agent-runnable without a human. A 30-second flaky loop is barely better than no loop; a 2-second deterministic one is a debugging superpower."
  - question: "How do you handle flaky, non-deterministic bugs?"
    answer: "You don't chase a clean repro — you raise the reproduction rate. Loop the trigger a hundred times, parallelise, add stress, narrow timing windows, inject sleeps. The skill's rule of thumb: a 50%-flake bug is debuggable, a 1% bug is not. Keep raising the rate until the bug is debuggable, then proceed."
  - question: "What happens when a loop genuinely can't be built?"
    answer: "The agent stops and says so explicitly, listing what it tried, then asks for one of three things: access to the environment that reproduces it, a redacted captured artifact (HAR file, log dump, core dump, timestamped screen recording), or permission to add temporary production instrumentation. The rule is absolute: without a loop, no hypothesising."
  - question: "Why show the ranked hypotheses to the user?"
    answer: "The skill generates 3–5 falsifiable hypotheses before testing any of them, because single-hypothesis generation anchors on the first plausible idea. Each must state a prediction — if X is the cause, changing Y makes the bug disappear or worse. Showing the ranked list before testing costs little and saves hours, since users often re-rank instantly with domain knowledge like 'we just deployed a change to number three'."
  - question: "How does the skill keep instrumentation honest?"
    answer: "Change one variable at a time, and prefer a debugger or REPL inspection over logs — one breakpoint beats ten log statements. Targeted logs go only at the boundaries that distinguish hypotheses, never 'log everything and grep'. Every debug log gets a unique prefix like [DEBUG-a4f2], so cleanup at the end is a single grep. For performance regressions, logs are usually wrong: establish a baseline measurement first, then bisect."
  - question: "When should the regression test actually be written?"
    answer: "Before the fix, but only if a correct seam exists — one where the test exercises the real bug pattern as it occurs at the call site. If the only available seam is too shallow, a regression test there gives false confidence. Crucially, if no correct seam exists, that itself is the finding: the codebase architecture is preventing the bug from being locked down, and that gets flagged."
  - question: "What does the completion checklist look like?"
    answer: "Six things: the original repro no longer reproduces (re-run the Phase 1 loop), the regression test passes, all [DEBUG-...] instrumentation is removed by grepping its prefix, throwaway prototypes are deleted or moved to a marked location, and the hypothesis that turned out correct is stated in the commit or PR message so the next debugger learns from it."
  - question: "Why the redaction step at the very start?"
    answer: "The skill has the agent show commands, outputs, and captured artifacts, so secrets get redacted first — written as <REDACTED> — and loops are built against environment variables so credentials stay in the environment, not the transcript. Captured artifacts carry auth headers, so only the lines carrying the signal get quoted. If redacted output isn't enough to diagnose, the agent says so and asks for more."
---

{{< faq-schema >}}

## Why a Diagnosing Bugs FAQ Exists

Matt Pocock's diagnosing-bugs skill is the least visible member of the [mattpocock/skills](https://github.com/mattpocock/skills) engineering family — it lives in the same folder as tdd, prototype, and code-review but rarely gets written about on its own. That's a gap, because it's the one skill in the family built for the moment everything else fails: a bug that survives your normal routine.

I wrote these answers after pulling the skill folder out of the repo and reading SKILL.md line by line. Every claim below traces to something in that file — the six phases, the loop-construction catalogue, the regression-seam rule — not to a README summary or marketing copy.

## The Short Answers

- **The loop is the skill.** Red-capable, deterministic, fast, agent-runnable — build that first, everything else follows.
- **No loop, no hypotheses.** The skill refuses to theorise without a red-capable command, and says so out loud.
- **Flaky is fixable by rate.** Raise a 1% flake to 50% and it becomes debuggable; the skill gives you the techniques.
- **Regression tests have a precondition.** Only at a correct seam; a shallow seam means false confidence, and no seam at all is itself a finding.
- **Every artifact is redacted.** Secrets become `<REDACTED>`, env vars hold credentials, and only signal lines get quoted.

## What the Leaderboard Numbers Tell You

The engineering family dominates the skills.sh all-time leaderboard — tdd sits at #6 with 741.7K installs, handoff at #10 (646.5K), triage at #11 (642.3K), prototype at #12 (630.8K), domain-modeling at #61 (469.1K), and codebase-design just behind at #62 (455.6K), all from the snapshot we pulled mid-August 2026. Diagnosing-bugs ranks below the top 64 but tracks the same weekly install curve as its siblings, which makes sense: it's the skill you install because you already hit a wall, not because you're setting up a workflow. Install counts on skills.sh measure adds, not anger, so this one's real value shows up in the sessions where the loop finally goes red.

## Common Mistakes to Avoid

**Mistake #1: Skipping the loop and reading code.** The skill treats this as its cardinal sin. A hypothesis formed by staring at source before a red-capable command exists is the exact failure mode the whole discipline exists to prevent.

**Mistake #2: Accepting a green test that isn't your bug.** A loop that passes but doesn't assert the user's exact symptom is not red-capable — it can't go red on this bug, so it proves nothing. Wrong bug, wrong fix.

**Mistake #3: Logging everything.** The skill names this explicitly as something to never do. Targeted logs at hypothesis-distinguishing boundaries, tagged with a unique prefix, are the sanctioned path — and one breakpoint beats ten logs.

**Mistake #4: Writing the regression test at the wrong seam.** A unit test that can't replicate the chain that triggered the bug gives false confidence. If the only available seam is too shallow, the honest output is a note that the architecture is blocking the lock-down.

## Start With One Red-Capable Command

Pick the next bug you can't fix by glance, run `npx skills@latest add mattpocock/skills`, and select `diagnosing-bugs` — it ships with the rest of the family, so tdd, [code-review](/skills/general/code-review/), and [prototype](/skills/general/prototype/) come along in the same install. Then obey one rule: before you let the agent theorise, demand a single command it has already run that goes red on your exact symptom. If you want the full comparison of how this skill's loop stacks up against tdd and code-review, the [AI Debugging Skills roundup](/tutorials/guides/ai-debugging-skills-roundup-2026/) breaks down all four methodologies side by side.