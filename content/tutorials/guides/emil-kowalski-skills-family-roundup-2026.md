---
title: "Emil Kowalski's 18 Skills: 60,611 Tokens and One Shared Rulebook"
date: 2026-11-10
toc: true
draft: false
tags:
  - Animation
  - Agent Skills
  - Design Engineering
category: "guides"
description: "All 18 skills in emilkowalski/skills weigh 60,611 tokens, from 1,177 to 9,313 each. Four files hold the easing curves, the newest arrivals hold none."
---

Eighteen skills sit in [emilkowalski/skills](https://github.com/emilkowalski/skills), and the leaderboard shows three of them. The other fifteen live on detail pages, which is where the interesting numbers are: a token ladder from 1,177 to 9,313, a shared rulebook that gets restated in some files and skipped in others, and four skills that appeared from zero in the last two weeks.

I read every SKILL.md, tokenized the set with `o200k_base`, and cross-checked each file for the same six rules. The repo was pushed on 2026-11-09. Install counts and weekly curves come from the skills.sh pages on 2026-11-10.

## The Token Ladder

Total cost of the family is 60,611 tokens. Individual files are not remotely equal, and the ranking has nothing to do with installs.

| Skill | Installs | Last wk | Tokens |
| --- | --- | --- | --- |
| `write-swift` | 152.1K | 14,522 | 9,313 |
| `emil-design-eng` | 434.4K | 20,798 | 6,156 |
| `apple-design` | 287.8K | 18,972 | 5,152 |
| `animate-expo` | 171.6K | 14,997 | 4,325 |
| `mobile-native` | 122.6K | 15,947 | 4,136 |
| `choreograph` | 13.8K | 9,575 | 3,576 |
| `break-ui` | 101.7K | 16,006 | 3,442 |
| `animation-performance` | 74.0K | 16,473 | 3,280 |
| `animation-vocabulary` | 275.9K | 16,143 | 2,963 |
| `animate` | 212.4K | 17,636 | 2,942 |
| `remove-animations` | 28.7K | 15,246 | 2,563 |
| `find-animation-opportunities` | 246.0K | 16,265 | 2,290 |
| `gestures` | 5.7K | 1,358 | 1,994 |
| `review-animations` | 296.8K | 18,032 | 2,000 |
| `improve-animations` | 262.7K | 17,188 | 1,850 |
| `prototype` | 208.9K | 15,280 | 1,699 |
| `ask-sonner` | 173.9K | 14,770 | 1,753 |
| `pick-ui-library` | 220.4K | 15,520 | 1,177 |

The most expensive file is `write-swift` at 9,313 tokens, and it is not a motion skill at all — it is a Swift 6 guide (value types, `@concurrent`, `Sendable`, ARC, Swift Testing, macros). The most installed file, `emil-design-eng` at 434.4K, costs about two thirds of that. The cheapest file, `pick-ui-library` at 1,177 tokens, is a curated library list with four headings.

## The Rulebook Is Shared, the Coverage Is Not

Every file in this family is written by the same person and points at the same craft standard. What surprised me is how unevenly the standard is actually present. Counting files that carry each rule:

| Rule | Files carrying it |
| --- | --- |
| `prefers-reduced-motion` handling | 11 of 18 |
| "Never `ease-in`" | 10 of 18 |
| "Never start from `scale(0)`" | 9 of 18 |
| `stagger` guidance | 8 of 18 |
| Explicit `transform-origin` rule | 7 of 18 |
| Frequency table (100+ times/day → never animate) | 7 of 18 |
| `spring` parameters | 13 of 18 |
| All three named cubic-beziers | 4 of 18 |
| The word "Raycast" as the no-animation benchmark | 4 of 18 |

Only `animate`, `animate-expo`, `emil-design-eng` and `find-animation-opportunities` carry the full curve set — `0.23, 1, 0.32, 1`, `0.77, 0, 0.175, 1`, and the Ionic drawer curve `0.32, 0.72, 0, 1`. `gestures` cites just the third, because that is the one a finger-following sheet needs.

Which gives a concrete recommendation: if you want the numbers, install `animate`. It is 2,942 tokens and holds all three curves plus the duration table, against 6,156 tokens for `emil-design-eng`. The bigger file buys you judgment across surfaces, the smaller one buys you the constants. Anyone telling you to install the flagship because it has the most installs is optimizing for popularity, not for context.

And the overlap is prose-level low. Sentence-level comparison across the 18 files shows 0% to 13% of sentences appearing verbatim in another file — the maximum is `animate` at 13%, and `gestures` shares none. This family is not one skill pasted eighteen times. It is one philosophy with eighteen different entry points, and the constants live in four of them.

## Four Skills That Did Not Exist Two Weeks Ago

The release signature is easy to spot in the weekly buckets. Fifteen veterans follow one shape — a climb to a peak two weeks back, then a shared slide to the 15,000–20,000 band. `emil-design-eng` went 17,740 → 23,021 → 21,061 → 20,798. `apple-design` went 14,691 → 21,421 → 19,778 → 18,972. Same wave, same direction.

Four skills break the pattern because their earlier buckets are zero:

| Skill | Weekly curve (oldest → newest) |
| --- | --- |
| `animation-performance` | 0, 0, 0, 1,148, 16,579, 18,512, 16,767, 16,473 |
| `break-ui` | 0, 0, 5,165, 19,562, 21,800, 18,352, 16,461, 16,006 |
| `remove-animations` | 0, 0, 0, 0, 0, 0, 9,405, 15,246 |
| `choreograph` | 0, 0, 0, 0, 0, 0, 0, 9,575 |
| `gestures` | 0, 0, 0, 0, 0, 0, 0, 1,358 |

`remove-animations` reached 15,246 installs in its second week while sitting at 28.7K lifetime — roughly a tenth of `improve-animations`' 262.7K — which means the weekly number is already 89% of a skill that has been out for months. `choreograph` and `gestures` both landed in the current bucket and have one bucket of history each.

`gestures` is also the family's only structural outlier. Seventeen files open with an identical framing sentence — "When this skill is first invoked without a specific question, respond only with:" followed by a house-style greeting — and `gestures` has no Initial Response section at all. Its description is 825 characters of trigger keywords ending in quoted user complaints ("doesn't follow my finger", "jumps when I let go"). The new arrivals clearly lean harder on trigger text: `choreograph` is 959 characters, `animation-performance` 800, against 155 for `emil-design-eng` and 159 for `review-animations`.

## The Inconsistency Worth Knowing Before You Install

Three files set `disable-model-invocation: true`, so the model cannot fire them on its own: `review-animations`, `prototype`, `pick-ui-library`. Two of the three say so in the description — `pick-ui-library` and `prototype` both end with "Only runs when explicitly invoked; it does not trigger on its own."

`review-animations` does not. Its description is 159 characters and says nothing about explicit-only invocation, which is why it reads like an auto-triggering reviewer in the leaderboard copy while behaving like a manual one in practice. If you installed it expecting it to audit every animation you write, that is the gap.

If you have already read the [improve vs remove comparison](/tutorials/comparison/improve-vs-remove-animations/) or the [layout-cost test on `animate`](/tutorials/guides/animate-skill-layout-cost-narrative/), you have the two ends of this family. What is left is the middle: pick by cost, not by installs. Start with `animate` for the constants, add `emil-design-eng` when you want surface-level judgment, and reach for `choreograph` or `gestures` only when the task is literally coordinated motion or finger tracking. Eighteen skills at 60,611 tokens is not a library you load — it is a menu you order from.
