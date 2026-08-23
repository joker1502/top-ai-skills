---
title: "Implement Skill: A 7-Line Spec That Routes AI Coding Work"
date: 2026-08-23
draft: false
tags:
  - Implement
  - AI Coding
  - Engineering
description: "Matt Pocock's implement skill is a seven-line delegation spec: it routes coding through pre-agreed seams, tdd, and code-review — and refuses to auto-trigger."
version: "1.0"
author: "Matt Pocock"
repo_url: "https://github.com/mattpocock/skills"
install_cmd: "npx skills@latest add mattpocock/skills"
compatibility:
  - Claude Code
  - Codex
  - Cursor
category: "general"
rating: 4.6
github_stars: 233486
github_forks: 19921
installs: 412300
last_updated: "2026-08-23"
ai_friendliness:
  score: 4.6
  documentation: 4.7
  setup: 4.5
  config: 4.5
---

The most important skill in Matt Pocock's engineering family is the one that barely exists. Implement's SKILL.md holds seven lines of instruction, yet the skill sits at #92 on the skills.sh all-time leaderboard with 412.3K installs. I pulled the file from the [mattpocock/skills](https://github.com/mattpocock/skills) repo (233K stars) and read it next to its siblings tdd, to-spec, and code-review. What the seven lines do is route work, not write it. That routing is the actual feature.

## It's Built to Never Fire on Its Own

Implement's frontmatter opens with `disable-model-invocation: true`, and its OpenAI agent manifest repeats the decision: `allow_implicit_invocation: false`. Models cannot trigger this skill mid-session; a human must invoke it explicitly. Compare that to siblings in the same folder: tdd's description fires on "red-green-refactor" or "integration tests", prototype names its own scenarios, but implement and to-spec both demand a named handoff.

That split is deliberate. Implementation is where context collapses — an agent that auto-fires "implement" builds from whatever it half-remembered instead of the agreed spec. Blocking implicit invocation forces the handoff into the open: someone names the spec, the seams, and the branch before the coding starts.

## What the Seven Lines Actually Say

The whole instruction body reads as a five-item routing list:

1. Implement the work described in the spec or tickets.
2. Use /tdd where possible, at pre-agreed seams.
3. Run typechecking regularly, single test files regularly, and the full test suite once at the end.
4. Review the work with /code-review when done.
5. Commit your work to the current branch.

Real talk: the cadence in item three is the discipline. "Pre-agreed seams" plugs straight into tdd's hard rule — write down the seams under test and confirm them with the user before writing any test. No unconfirmed seam, no test. The rhythm of typecheck-often, single-file-often, full-suite-once keeps the loop tight while you build. And item four sits before item five on purpose: review gate, then commit. No branch hopping, no PR-shaped surprise at the end.

## Where It Sits in the Assembly Line

Implement is step three of five in the family pipeline. Prototype cheaply answers the risky questions, to-spec publishes the conversation as a spec tagged `ready-for-agent`, implement builds to that spec, code-review audits the result, and diagnosing-bugs handles whatever still breaks. Previous write-ups here covered the bookends: [code-review](/skills/general/code-review/) brings the 12-point Fowler smell baseline, and [codebase-design](/skills/general/codebase-design/) supplies the glossary that keeps the vocabulary stable.

In that chain, implement's job is purely connective. The seam list arrives pre-agreed from to-spec, the test loop comes from tdd, the review standard comes from code-review. The seven lines point the agent at the right hop and set the cadence between hops — which is why the skill looks thin next to a 200-line "coding best practices" checklist. A checklist describes good code. This skill describes a repeatable handoff, and repeatability is what makes the other four skills dependable.

## Bottom Line

Implement is the least glamorous skill in the family and the one that makes the other four repeatable. Install the family with `npx skills@latest add mattpocock/skills`, pick implement alongside tdd and code-review, then try the explicit handoff on your next ticket: agree seams, build in vertical slices, review before commit. The seven lines won't write your code — they guarantee the code that gets written is the code you actually specified.