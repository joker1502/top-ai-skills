---
title: "Review-Animations Skill: Ten Motion Rules That Block a Merge"
date: 2026-11-04
toc: true
draft: false
tags:
  - Emil Kowalski
  - Motion Design
  - Agent Skills
category: "coding"
description: "The review-animations skill packs 10 blocking motion rules and a 187-line standards file, plus a stagger example that contradicts its own prose."
---

The `review-animations` skill reviews motion code and approves nothing by default. Two files carry the whole thing: SKILL.md at 8,491 bytes and STANDARDS.md at 9,964 bytes. No scripts, no API key, no build step — a review checklist you hand to an agent that already knows how to read code.

I pulled both files from [emilkowalski/skills](https://github.com/emilkowalski/skills) on 2026-11-04 and read them end to end. The repo holds 17 skills today. Three of them sit on the skills.sh board in the same band: emil-design-eng at 21,061 weekly installs, apple-design at 19,778, and review-animations at 18,236 with buckets `[11,920, 13,772, 14,870, 16,376, 18,107, 18,273, 20,074, 18,236]`.

## Ten Rules, Ordered So Deleting Comes First

The skill states a bias in its opening section: motion that merely runs is a regression, not a pass. Then it lays out ten non-negotiable standards, and the order matters more than the list.

Rule one asks why a thing animates at all — spatial consistency, state signal, feedback, explanation. "It looks cool" on a frequently-seen element is a block. Rule two gates on frequency: keyboard shortcuts and 100+/day actions get no animation, tens per day get reduced motion, rare first-time interactions earn delight. Rules three through seven cover easing (`ease-in` on UI blocks), the sub-300ms budget, transform origin, interruptibility and GPU-only properties. Rules eight to ten handle `prefers-reduced-motion`, asymmetric enter/exit timing, and personality cohesion.

The remedial hierarchy is where the posture shows. Its first move is *delete the animation*. Shorten it comes second. Fixing the easing curve sits third — below removal, which tells you how the author ranks polish against restraint. Nine tiers total, ending with accessibility and cohesion tuning.

One section lists escalation triggers you flag on sight: `transition: all`, `scale(0)` entrances, `ease-in` on any interaction, `transform-origin: center` on a trigger-anchored popover, keyframes on toasts, layout-property animation, a CSS variable on a parent driving a child transform, and everything-at-once entrances where a 30–80ms stagger belongs.

## Where the Standard Values Actually Land

Vague review advice is useless, so STANDARDS.md ships the numbers. Three named curves:

- `--ease-out: cubic-bezier(0.23, 1, 0.32, 1)` for UI
- `--ease-in-out: cubic-bezier(0.77, 0, 0.175, 1)` for on-screen movement
- `--ease-drawer: cubic-bezier(0.32, 0.72, 0, 1)`, the Ionic drawer curve

Duration budgets break down per surface: button press feedback 100–160ms, tooltips and small popovers 125–200ms, dropdowns and selects 150–250ms, modals and drawers 200–500ms. Springs come as two configs — `{ type: "spring", duration: 0.5, bounce: 0.2 }` for most cases, `{ mass: 1, stiffness: 100, damping: 10 }` when you need the physical form.

Here is the part nobody documents, and the reason reading beats skimming. The file says stagger group entrances at 30–80ms between items, "longer delays feel slow." The code sample four lines below sets `animation-delay: 50ms` on the second item and `100ms` on the third. The third value sits outside the stated band, in the skill's own example. Small thing. Also exactly the kind of gap a reviewer will hit while citing the rule to an author who reads code samples more carefully than prose.

Repeat that check on any standards file before trusting it: read the prose band, then read the sample, then measure.

## What the Output Looks Like, and Where It Refuses

The skill dictates a two-part output. Part one is a markdown table with three columns — Before, After, Why — one row per finding. It explicitly forbids a "Before:/After:" bullet list, which is what most agents produce unprompted.

Part two groups commentary by impact tier, highest first: feel-breaking regressions, missed simplifications, performance, interruptibility and timing, origin and cohesion, accessibility. Then one decision. **Block** fires on any feel-breaking regression, animation on a keyboard or high-frequency action, `scale(0)` or `ease-in` on UI, or a non-GPU animation with an easy GPU fix. **Approve** requires no feel-breaking regressions, no motion that should be deleted, in-bounds durations, handled interruptibility and respected reduced-motion.

Scope is narrow on purpose. Ask it to review general code and it declines, pointing at a general review skill. The frontmatter carries `disable-model-invocation: true`, so an agent cannot fire this skill on its own — you invoke it. On first invocation with no question, it prints one fixed sentence and waits.

Practice: this pairs badly with a generic "review my code" habit. Feed it a diff that touches CSS transitions or a Motion config, keep the diff small, and expect a table you have to act on rather than a summary you can skim.

If you want the build-side counterpart — the rules that generate motion rather than judge it — start with the [emil-design-eng skill](/skills/coding/emil-design-eng/), which shares the same curve and duration tables but wraps them in production guidance. And if your animation work happens inside a video pipeline instead of a browser, the [HyperFrames CLI guide](/tutorials/guides/hyperframes-cli-faq/) covers a different set of budgets entirely.

Grab the two files, drop them into `.claude/skills/review-animations/`, and run one real diff through it before you trust the verdicts.
