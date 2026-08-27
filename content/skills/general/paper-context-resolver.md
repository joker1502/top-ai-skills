---
title: "paper-context-resolver: 450K Installs, Zero Summaries"
date: 2026-08-27
draft: false
tags:
  - Deep Learning
  - Reproducibility
  - AI Research
description: "RigorPilot's 49-line helper hit 450,765 installs by refusing most paper requests: one gap per answer, README conflicts recorded, never overridden."
version: "1.0"
author: "lllllllama"
repo_url: "https://github.com/lllllllama/RigorPilot-Skills"
install_cmd: "npx skills add lllllllama/rigorpilot-skills --all"
compatibility:
  - Claude Code
  - Codex
  - Cursor
category: "general"
rating: 4.0
github_stars: 476
github_forks: 16
installs: 450765
last_updated: "2026-08-27"
ai_friendliness:
  score: 4.0
  documentation: 4.5
  setup: 3.5
  config: 3.5
---

paper-context-resolver exists for the moment a reproduction run stalls on paper details the README never explains. Your agent hits the evaluation-split section and starts guessing. That split could be any of three things. This 49-line helper from the RigorPilot family passed 450,765 installs on skills.sh by refusing almost every other job you could give it. I read its SKILL.md, its reference file, and the live leaderboard on 2026-08-27. The refusals surprised me more than the numbers.

## One Gap, One Question, One Answer

The skill ships under the slug `paper-context-resolver` for compatibility, but its display name is *Rigor Paper Context*. The repo keeps branding separate from install aliases — the family migrated from `ai-paper-reproduction-skills` to RigorPilot-Skills, and the old slugs stayed valid.

Its own description block reads like a gate, not a hook: *"Use only when the README and repository files leave a narrow reproduction-critical gap."* Five question types get through the gate:

- **Dataset version or split** — which corpus, which fold, which sampling
- **Preprocessing or postprocessing details** — normalization that changed results
- **Evaluation protocol** — metrics, thresholds, how the numbers were produced
- **Checkpoint or model variant mapping** — which weights feed which experiment
- **Critical runtime assumptions** — batch shapes, seeds, hardware-dependent behavior

Input expectations are explicit: repo metadata, a concrete reproduction question, existing README evidence, and any known paper links. Output expectations match: a narrowed source list, the reproduction-relevant answer only, and a clear split between direct evidence and inference. The model does not get to pad the answer.

## The Refusal List Is the Real Product

The line that made me re-read the file twice sits in the description: *"Do not use for general paper summary, repo scanning, environment setup, command execution, title-only paper lookup, or replacing README guidance by default."* A skill that writes anti-marketing into its own pitch — that's rare on a leaderboard where every other entry promises more.

The when-not-to-apply list is just as blunt: the README already gives enough detail, the user wants a general explanation, the goal is overriding the README without documenting the conflict, or the only input is a paper title with no concrete gap yet.

Trigger discipline is baked into the reference file with worked examples. A good trigger: *"README is ambiguous about the evaluation split. Check the linked paper and record the conflict if needed."* A bad trigger: *"Summarize this paper."* or *"Find the paper for this repository title and explain it."* The reference also excludes full-paper summaries, novelty explanations, broad related-work discussion, and speculative "best settings" by default.

The source-order ladder deserves attention. The skill checks the paper link the README provides, then the official project page, then the arXiv or OpenReview record, and Google Scholar only to *locate* the primary source — never as a source itself.

The conflict rule is where the design earns its keep. When README and paper disagree, the skill must not silently replace the README. It records the conflict, states which source says what, and preserves the README-first policy in the final report. That turns a paper lookup into an audit trail.

## 450,765 Installs, and the Helper Outsells the Flagship

The leaderboard snapshot from 2026-08-27 puts paper-context-resolver at #66 with 450,765 all-time installs. Its weekly series runs 20,543 → 22,298 → 26,744 → 25,118 → 11,191 → 32,245 → 50,275 → 41,240 — roughly 230K installs, about half its lifetime count, landed in the last eight weeks.

The strangest number is the comparison. The two bundled helper skills — paper-context-resolver (450,765) and repo-intake-and-plan (450,010) — out-install the family's flagship entrypoint `ai-research-reproduction` (310,826). On this leaderboard, the helper tier beats the main event. That inverts the usual pattern where an orchestrator skill carries the install count.

The file itself is aging gracefully. Git history shows the skill folder was last touched on 2026-05-18, during the rename cleanup; the repo's last push was 2026-07-26, and it sits at 476 stars and 16 forks. The SKILL.md has not changed in three months while weekly installs kept climbing — install counts measure adds, not use, so treat the 50,275 peak week as traction, not proof. A single week of 41,240 says the wave has not crashed the way azure-rbac's did (its weekly count fell from 11,820 to 2,600 over eight weeks after its repo removal).

| | paper-context-resolver | "Summarize this paper" prompt | ai-research-reproduction |
|:--|:--|:--|:--|
| Scope | one reproduction gap | the whole paper | a full reproduction run |
| When it applies | README leaves a gap | any moment you ask | repo + README available |
| Conflict handling | records README vs paper conflicts | none | annotation verdicts per section |
| Output | narrowed sources + answer + conflict note | an essay | evidence bundle with ANNOTATED_README.md |

Three options, three different jobs. The helper is the only one that treats "the paper says X, the README says Y" as a finding to preserve rather than a contradiction to resolve.

## The Bet Behind the Refusal

The whole design rests on one claim: an agent that documents its paper-reading is more useful than an agent that writes essays about papers. The 450,765 installs suggest enough people agree. If you run deep-learning reproduction work, install it with the family — `npx skills add lllllllama/rigorpilot-skills --all` — and the next time a README punts to a paper, watch what the agent does with the ambiguity. If the conflict note lands in the report instead of the code, the skill did its job. New to agent skills? The [AI Agent Skills FAQ](/tutorials/guides/ai-agent-skills-faq/) covers the installation side, and the [AI debugging roundup](/tutorials/guides/ai-debugging-skills-roundup-2026/) is a useful map of how the research-adjacent skills fit together.