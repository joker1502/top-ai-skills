---
title: "Wizard Skill FAQ: The Bash Script That Walks Humans Through Setup"
date: 2026-09-21
toc: true
draft: false
tags:
  - Bash
  - AI Agents
  - Automation
category: "guides"
description: "Straight answers on Matt Pocock's wizard skill: what generated bash wizards do, how stages and secrets work, when to commit one, what 392K installs mean."
faq:
  - question: "What does the wizard skill actually do?"
    answer: "It generates an interactive bash script — a 'wizard' — that walks a human, step by step, through a manual procedure only they can perform: provisioning infrastructure, setting up credentials or CI secrets, navigating an unfamiliar third-party dashboard, or running a one-off migration or cutover. The agent authors the stages; the human drives the browser and pastes values back. It sits in mattpocock/skills at skills/engineering/wizard/ with 392.6K all-time installs (rank 133 on skills.sh on 2026-09-21)."
  - question: "When should I use it — and when not?"
    answer: "Use it when a procedure is tedious to do by hand and tedious to re-explain to an agent every time, and the steps genuinely require a human: browser dashboards, secret entry, irreversible confirmations. Don't invoke it for steps the agent can perform itself. The skill's trigger list: provisioning infrastructure, setting up credentials or CI secrets, walking an unfamiliar third-party dashboard, running a one-off migration or cutover."
  - question: "What does a generated wizard look like when run?"
    answer: "A banner lists the total stages, then each stage clears the screen and shows one focused task: the URL to open, exactly what to click and copy, and where the captured value lands. open_url opens the page in the human's browser, ask and ask_secret collect values, confirm gates anything irreversible, and a finishing summary lists .env values written, GitHub secrets set, and anything skipped. Interrupt with Ctrl-C and re-run later — it remembers values already saved."
  - question: "What is the 'library above the STAGES marker'?"
    answer: "template.sh splits at a marker. Everything above it is a wizard library that is identical in every generated wizard — banner, stage, say, step, note, warn, open_url, pause, confirm, ask, ask_secret, write_env, set_secret, set_var, finish, plus _clear and _existing helpers. Everything below is the author's stages. The skill is explicit: never hand-edit the library; the agent's whole job is scoping the procedure and authoring the stages below the marker."
  - question: "How does the authoring process work?"
    answer: "Three steps. Scope: read the repo first — .env, .env.example, README, docker-compose, and every workflow file, because each secrets.* or vars.* reference is a value the wizard must produce — then list the ordered stages and confirm with the user, who may add, drop, or reorder. Map: for each stage write the precise journey (URL to open, what to do, where the value appears, which variable it fills). Author: copy template.sh, replace the example stage with one stage per step, set TOTAL_STAGES to match, and verify."
  - question: "How does the agent verify a wizard it can't run?"
    answer: "It must not run it end-to-end — wizards open browsers and block on human input. Instead: bash -n for syntax, shellcheck when available, chmod +x, then a static trace — every value from the scoping step lands where step 1 said it would (including the right ENV_FILE), and every set_secret name exactly matches a secrets.* reference in CI. The skill's bar: a stranger should be able to follow the stages without asking the agent anything."
  - question: "How are secrets handled?"
    answer: "ask_secret reads input hidden from the terminal. write_env upserts KEY=VALUE into the .env file idempotently — it replaces any existing line and keeps the current value as a default on re-runs. set_secret writes only the values CI actually needs, pushing them via gh, and records a SKIPPED warning with the exact manual command if gh is missing or unauthenticated, so the human gets a to-do list in the finishing summary."
  - question: "What are the common traps?"
    answer: "Inventing UI steps that may not exist — if you don't know the current dashboard, say so and check the docs instead. Asking the user cold instead of reading the repo first. Bundling several actions into one stage, since each stage clears the screen. Skipping confirm() before irreversible actions. And committing an ephemeral one-off wizard that was meant to be thrown away after the job."
  - question: "Is a wizard ephemeral or committed?"
    answer: "Ephemeral by default: built for one run, saved to a scratch or scripts/ path, deleted when the job is done. Commit it only when the user wants a repeatable setup path that should live in the repo — then link it from the README so the next person runs the script instead of asking an agent. The template's closing line makes the same point: 'only the stages below this marker are yours.'"
  - question: "Is the 392.6K install number real?"
    answer: "Yes. skills.sh on 2026-09-21 showed wizard at #133 with 392,600 all-time installs and a weekly series of 19,850, 42,981, 41,317, 44,161, 41,947, 41,252, 37,335, 34,729 — a peak near 44K about seven weeks back, now settling in the mid-30K band. The repo pushed on 2026-09-18, and the skill's SKILL.md reads only 4 KB while template.sh carries 8.5 KB of the actual UX."
---

{{< faq-schema >}}

## Why a Wizard FAQ Exists

Matt Pocock's `wizard` skill generates a bash script that walks a human through steps only they can perform — provisioning infrastructure, pasting API keys, clicking through a vendor dashboard. It sounds niche until you count the setup tasks you re-explain to an agent every week. The SKILL.md is short (4 KB), but the real substance lives in template.sh (8.5 KB), which ships the entire wizard library: every helper, the STAGES marker, the closing summary. I read both files plus the skills.sh leaderboard on 2026-09-21; every answer above traces to one of them.

## The Short Answers

- **It writes bash, not actions.** A wizard opens URLs and captures values; the human does the clicking.
- **Three authoring steps:** scope the procedure, map each stage's journey, author below the marker.
- **Never edit the library.** Everything above `STAGES` is identical across every wizard for a reason.
- **Static verification only.** Don't run a wizard end-to-end; trace it instead.
- **Ephemeral by default.** Commit only when the repo should own the setup path.

## What a Wizard Actually Is

A wizard is the awkward middle ground between "the agent does everything" and "the README says click here, then here, then here." The generated script opens each URL, says exactly what to click and copy, captures the values, writes them where they belong (`.env`, GitHub secrets), confirms at every stage, and shows how many stages remain. The skill's own framing: "It might configure third-party services, run a one-off migration, or move the project from one state to another."

The delightful UX is pre-solved — that's the point of the template. Progress stages, confirmation gates, cross-platform URL opening (including WSL), hidden secret entry, idempotent `.env` upserts, `gh secret` and `gh variable` writes, a closing summary. The agent's only job is scoping the procedure and authoring its stages. A wizard is a tiny product: the human's time is the constraint, and every helper exists to make the human's job smaller.

## The Library vs. The Stages

`template.sh` enforces a hard boundary. Above the marker: `banner`, `stage`, `say`, `step`, `note`, `warn`, `open_url`, `pause`, `confirm`, `ask`, `ask_secret`, `write_env`, `set_secret`, `set_var`, `finish`, plus `_clear` and `_existing`. Below it: `TOTAL_STAGES` and one `stage` block per manual step, in dependency order.

The consistency is load-bearing. A library that changes per wizard can't be trusted; a library that's identical everywhere gets audited once. The author contract is strict: copy `template.sh`, replace the example Stripe stage with real stages, set `TOTAL_STAGES`, and don't touch anything above the marker. The template even ships an example (Stripe test keys → `.env` + CI secret) so the shape is unambiguous.

## Secrets and CI: The Three Write Paths

Every captured value lands somewhere, and the skill names exactly where. `write_env` upserts to `.env` — it greps out any existing `KEY=` line and rewrites the file, so re-runs never duplicate keys and an empty Enter keeps the current value. `set_secret` and `set_var` push to GitHub Actions through `gh` — secrets for values CI must not print, variables for non-secret config — and if `gh` isn't authenticated, they append to a `SKIPPED` list that the finishing summary prints as explicit manual to-dos. `ask_secret` hides input with `read -rs`; nothing secret ever echoes.

That mapping is why the scoping step matters: every `secrets.*` reference in `.github/workflows/*` is a value the wizard must produce, and the static verification step checks each `set_secret` name against those references exactly.

## Verification Without Running It

Wizards block on human input and open browsers — so running one end-to-end is off the table. The skill substitutes static checks plus an audit: `bash -n` for syntax, `shellcheck` when present, `chmod +x`, then a trace that every value from the scoping pass actually lands where step 1 declared and every `set_secret` matches a CI reference. The test of a well-built wizard is that a stranger can run it without asking the agent anything — which is a higher bar than the agent running it once itself.

It slots into the same repo family as [handoff](/skills/general/handoff/) — where one skill passes work to a human, this one builds the human a scripted path through the setup. Install with `npx skills add https://github.com/mattpocock/skills --skill wizard`. Next time provisioning needs a browser and a paste, that's exactly what the wizard is for.