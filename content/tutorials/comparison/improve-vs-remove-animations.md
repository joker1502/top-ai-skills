---
title: "Improve vs Remove Animations: Two Gates, One Contradiction"
date: 2026-11-09
toc: true
draft: false
tags:
  - Animation
  - Agent Skills
  - Design Engineering
category: "comparison"
description: "improve-animations plans motion fixes read-only, remove-animations deletes motion outright. On a 400ms modal the two skills give opposite verdicts, measurably."
---

Same author, same philosophy, opposite verbs. `improve-animations` loads three files and writes plans it will never execute; `remove-animations` loads one file and edits your source, but only to subtract. Put them side by side and they agree on most of the rulebook and disagree on one number that matters, which is exactly what makes the pair worth running in the right order.

## One Writes Plans, the Other Deletes Code

`improve-animations` describes itself twice as read-only: hard rule 1 is "Never modify source code," hard rule 2 adds no installs, no builds with side effects, no commits. Its only output is files under `plans/` — one per finding, `NNN-short-slug.md`, stamped with the current commit. `remove-animations` goes the other way. Every edit it makes "deletes an animation, reduces it, or removes code it left orphaned," and hard rule 1 forbids adding motion, changing a curve, or retuning a spring.

The load cost follows the same split:

| | `improve-animations` | `remove-animations` |
| --- | --- | --- |
| Files loaded | `SKILL.md` + `AUDIT.md` + `PLAN-TEMPLATE.md` | `SKILL.md` only |
| Bytes | 18,940 | 11,345 |
| cl100k tokens | 4,468 | 2,575 |
| Hard rules | 5 | 5 |
| Modifies your code | No, plans only | Yes, subtractively |

The file that plans is nearly twice as expensive as the file that edits. That is not a design flaw — `AUDIT.md` carries the target values (three named cubic-beziers, a five-row duration table) that keep plans from approximating, and the subtraction skill needs none of them. Grepping the family confirms it: `remove-animations/SKILL.md` contains zero `cubic-bezier` strings and twelve `ms` values; `improve-animations/AUDIT.md` contains four curves and eight durations. A skill that never retunes easing has nothing to cite.

## The Gate vs the Audit

`remove-animations` runs every existing animation through a decision tree with eight terminal branches — four DELETE, two REDUCE, two KEEP. Keyboard-triggered and seen-100-times-a-day both terminate at DELETE before purpose is even discussed. "Can you name its purpose" is where the judgment starts, and a nameable purpose only gets you to REDUCE if the surface is hit tens of times a day or the motion is over budget.

`improve-animations` does not have a gate. It has eight audit categories run in parallel, then a vetting pass where you re-read the cited code yourself and reject anything by-design, mis-attributed or duplicated. Severity comes out as HIGH / MEDIUM / LOW, coverage is set by effort level (`quick` allows one subagent and about five HIGH findings, `deep` allows eight subagents), and the output is one table sorted by impact divided by effort.

Both skills rank keyboard animations first. Both name Raycast as the reference implementation — `AUDIT.md` says "Raycast has none — correct," the remove gate says "Raycast has no open/close animation; that is the optimal experience." Same sentence, two files, one philosophy.

## Where the Two Disagree

Most of the rulebook is shared. The 300ms ceiling, `ease-in` on UI always being a finding, `scale(0)` being a defect, `transition: all` being a defect, `transform-origin` belonging at the trigger rather than the center — all of it appears in both. The disagreements are narrower and more interesting:

| Case | `improve-animations` verdict | `remove-animations` verdict |
| --- | --- | --- |
| 400ms drawer open | Compliant: duration table says modals and drawers run 200–500ms | Out of budget: gate fires "over 300ms" → REDUCE to 200–250ms, same curve |
| Stagger at 70ms per item | In band: "30–80ms stagger" belongs | Passes the 80ms threshold untouched; if it ever exceeds 80ms the target is 30ms, not 70 |
| Hover scale on a card | Adjust the curve; no hover duration cap in the table | Reduce to color/opacity only, ≤150ms, `ease` |
| Command palette animation | HIGH severity, plan a fix | DELETE, keyboard-triggered branch |
| A teleporting content swap | Category 8 missed opportunity, plan an addition | Never considered; adding motion is forbidden |
| Kept animation with bad easing | Fix it, it is a finding | Hand it to `improve-animations` in the Kept section |

The modal row is the contradiction. `AUDIT.md` prints the header "Duration budgets — **UI animations stay under 300ms**" and then, six lines later, lists modals and drawers at 200–500ms. The remove gate reads the header, not the table, and reduces anything past 300ms to 200–250ms. So a 400ms drawer animation passes the planning skill, fails the deletion skill, and fails the planning skill's own summary line. One of the three is wrong, and it is not the drawer.

The last two rows explain why running one does not substitute for the other. `improve-animations` has an additive category — places that do not animate but should — and `remove-animations` forbids adding anything. Run the subtraction last and you will delete motion the other skill just planned.

## Each Skill Contains a Counterweight Against Itself

The structural detail I did not expect: both skills build an antidote to their own bias into the required output format.

`remove-animations` demands "Part 2 — Kept (REQUIRED)": two to five animations you considered and deliberately kept, each with the purpose that saved it. Without that section a subtraction skill degenerates into deleting every transition in the repo, and the file says so — the section "is what separates this skill from deleting every transition in the codebase."

`improve-animations` pulls in the other direction. After the findings table it requires two to four missed opportunities, and it adds the line every audit skill should carry: "the motion here is already right" is a valid result. It also forbids re-litigating settled decisions when a design doc documents a deliberate motion tradeoff; `remove-animations` restates the same rule as hard rule 4.

Removal is also the harder engineering, which the deletion skill admits with a six-item hazard list: hidden start states that leave an element permanently invisible, `transitionend` listeners that keep waiting for motion that no longer exists, `AnimatePresence` exit animations that hold a component in the DOM, Motion's `layout` prop masking a layout shift, focus timed inside an animation callback, tests that wait on animation classes. Any one of those turns a cleanup into a regression, and none of them appear anywhere in the planning skill.

## Install Curves: The New Skill Is Catching Up Fast

The numbers from skills.sh on 2026-11-09 make an odd pair:

| | Total installs | Last eight weeks |
| --- | --- | --- |
| `improve-animations` | 259.5K | 13,445 → 14,337 → 15,455 → 17,151 → 17,432 → 19,222 → 17,252 → 17,188 |
| `find-animation-opportunities` | 243.2K | 13,163 → 13,998 → 15,153 → 16,897 → 16,874 → 18,619 → 16,822 → 16,265 |
| `remove-animations` | 26.2K | 0 → 0 → 0 → 0 → 0 → 0 → 9,405 → 15,246 |

`remove-animations` has been counted for two weeks. Its second week, 15,246, is 89% of what the established planning skill did in the same week despite a ten-fold smaller cumulative base. The subtraction framing sells, or the repo's README placement does — either way, agents default to adding motion is the premise both files were written against, and the newest one is aimed straight at that default.

## Run Them in This Order

Remove first. It is 2,575 tokens instead of 4,468, it needs no plan approval loop, and it shrinks the surface that the expensive audit has to cover. A drawer you deleted does not need a curve.

Then improve, on what survived. Its Phase 1 requires a frequency map before judging anything — the same input the remove gate wants — so the survival list is the right input, and its `execute <plan>` variant will hand a self-contained plan to a cheap model in an isolated worktree rather than spend the good model on mechanical edits.

Then [review-animations](/skills/coding/review-animations/) on the diff, which is the bar `improve-animations` already uses when it renders a verdict on an executed plan. For the philosophy underneath all three, the [emil-design-eng](/skills/coding/emil-design-eng/) intro covers the frequency table and the curve values these skills inherited.

One caveat worth pricing in. Both skills open with a hardcoded single-sentence reply and nothing else, so you can tell which one loaded from its first line — `improve-animations` says it is ready to audit, `remove-animations` says it is ready to remove. In a session where you asked for neither, that sentence is your signal that the wrong skill fired.

Full source, if you want to check any of the above against the files: [emilkowalski/skills](https://github.com/emilkowalski/skills), 18 skills in the repo as of this writing.
