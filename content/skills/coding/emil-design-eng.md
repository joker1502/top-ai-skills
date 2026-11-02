---
title: "Emil Design Engineering Skill: Motion Rules Agents Ignore"
date: 2026-11-02
toc: true
draft: false
tags:
  - Emil Kowalski
  - Design Engineering
  - Agent Skills
category: "coding"
description: "Emil Kowalski's emil-design-eng skill packs 676 lines of motion rules, a mandatory before/after review table and a hard ban on animating keyboard actions."
---

Emil Kowalski's `emil-design-eng` is the only design skill I have read that opens by refusing to talk. Invoke it with no question attached and it prints one fixed sentence, then stops. Everything useful sits behind that gate: 676 lines on motion, a required output format for code review, and no scripts at all. The folder holds a single SKILL.md at 27,509 bytes.

Kowalski built Sonner and Vaul, and worked on interfaces at Vercel and Linear. His repo [emilkowalski/skills](https://github.com/emilkowalski/skills) has 52,945 stars and was pushed today, 2026-11-02. On the skills.sh board it reads 410.6K installs at rank #108, weekly buckets `[13,348, 17,740, 18,074, 19,408, 21,612, 21,425, 23,021, 21,061]` — climbing for six weeks, then a small pullback at the end.

## Four Skills, One Wave, 154K Apart

The repo publishes 25 skills. Four of them cluster on the board:

| Skill | Installs | Weekly buckets (oldest to newest) |
|---|---|---|
| emil-design-eng | 410.6K | 13,348 → 23,021 → 21,061 |
| review-animations | 275.9K | 11,920 → 20,074 → 18,236 |
| apple-design | 265.5K | 13,069 → 21,421 → 19,778 |
| animation-vocabulary | 256.9K | 11,830 → 18,489 → 16,866 |

Read the install column and you would conclude the flagship is 60% more popular than `animation-vocabulary`. Read the weekly columns and the gap collapses: every one of the four climbed from about 12K to about 20K over the same eight buckets. That is a shared publish wave, the pattern mattpocock's pack shows and the one HyperFrames shows in mirror image. Install count here records when a file was added, not how often anyone loads it.

## Two Gates That Fire Before Any Advice

The first is a canned greeting. The file instructs the agent to respond only with "I'm ready to help you build interfaces that feel right, my knowledge comes from Emil Kowalski's design engineering philosophy" and to volunteer nothing else. That is unusual, and it is a deliberate trade: no unsolicited audit, no 40-line summary, no plan for work you did not ask for.

The second gate is stricter. `## Review Format (Required)` demands that every UI review come back as one markdown table with `Before | After | Why` columns, and it prints an example of the wrong shape so the model cannot wander into it:

```
Before: transition: all 300ms
After: transition: transform 200ms ease-out
```

That formatting rule exists because prose skills drift. Give an agent eight animation fixes and it will produce eight paragraphs, two of which quietly contradict each other. A table with a mandatory "why" column makes the check mechanical — you can scan the left column for `transition: all` without reading a word of justification.

One rule in that file gets repeated three times: popovers scale from their trigger, modals stay centered. It appears in the review table, again in the popover section, again in the closing checklist. Three repetitions means the author watched agents over-apply a rule until it broke something.

## The Frequency Table Carries Most of the Weight

Before the easing advice, before any CSS, the skill asks how often a user will see the animation:

| Frequency | Decision |
|---|---|
| 100+ times/day (command palette, keyboard shortcuts) | No animation. Ever. |
| Tens of times/day (hover, list navigation) | Remove or drastically reduce |
| Occasional (modals, drawers, toasts) | Standard animation |
| Rare or first-time (onboarding, celebrations) | Can add delight |

Then one line that kills a whole category of agent behavior: never animate keyboard-initiated actions. Kowalski points at Raycast, which has no open/close animation at all, and calls that optimal for something invoked hundreds of times a day. Agents default the other way — an 8px slide and a 200ms fade on every panel, because motion reads as polish in a diff.

Easing gets a decision tree and a ban. `ease-in` is out for UI, full stop: it starts slow, and the first 60ms is the part a user is actually watching. In its place the file ships three curves with real numbers — `cubic-bezier(0.23, 1, 0.32, 1)` for interactions, `cubic-bezier(0.77, 0, 0.175, 1)` for on-screen movement, and `cubic-bezier(0.32, 0.72, 0, 1)` credited to the Ionic Framework for drawers. Durations are tabulated, not described: button press 100–160ms, tooltips 125–200ms, dropdowns 150–250ms, modals and drawers 200–500ms. Anything past 300ms on UI gets flagged in the review checklist.

## No Engine, and That Is the Point

Two design skills I wrote about earlier take the opposite route. [Impeccable](/skills/coding/impeccable/) ships a Rust binary and 62 deterministic rules that run after an edit; the [taste-skill presets](/tutorials/comparison/taste-skill-presets-comparison/) hardcode dials and refuse to negotiate them. Both hand the checking to a machine.

`emil-design-eng` has no `scripts/` directory. Judgment stays prose, and the enforcement is a table you have to fill in yourself. That costs you automatic detection — nothing runs after your edit, nothing fails your build. It buys freedom in cases a rule engine handles badly: a 2px blur that masks a crossfade, a stagger interval that depends on how many cards exist, an exit that should be faster than its enter.

The mechanical parts inside the prose are still pinned to numbers. Stagger 30–80ms. Blur under 20px. Press scale 0.95–0.98. Enter from `scale(0.95)` with opacity, never `scale(0)`. Tooltip delay on the first hover, zero on every hover after it. Body measure and contrast ratios are left to the other skills.

## Details You Only Get From Shipping Components

Kowalski writes from inside libraries people install, and three passages read like that:

**Percentages in translate.** `translateY(100%)` moves an element by its own height. Sonner positions toasts this way, Vaul hides its drawer this way, and neither needs to know the pixel height. It is a one-line fix for the class of bugs where a hardcoded `translateY(320px)` clips a taller drawer.

**Velocity beats distance.** Dismissal should not require dragging past a threshold. Compute `Math.abs(dragDistance) / elapsedTime` and dismiss when velocity passes roughly 0.11, so a quick flick works even when the swipe was short.

**The Motion version line.** From `motion` 14.2 the shorthand props (`x`, `y`, `scale`, `rotate`) are hardware-accelerated on HTML elements; before that they ran on the main thread. Layout animations, `onUpdate`, `transformTemplate`, inertia and motion-value-driven transforms stay on the main thread in every version. The example behind that note: Vercel's dashboard tabs used Shared Layout Animations and dropped frames during page loads until they moved to CSS. Most design skills would say "animate transform, not layout" and stop. This one names the version boundary where the usual advice stops working.

There's also the honest admission that Sonner uses `ease` rather than `ease-out` and runs slightly slower than typical UI motion, on purpose, because the whole library should feel elegant rather than snappy. Cohesion over the duration table, stated as an exception by the person who wrote the table.

## What I Would Skip

The `write-swift` skill in this repo is 42,445 bytes, the largest file in a repo about interface design, and it covers value types and Swift 6 concurrency. Useful if you write native iOS. Unrelated to the reason most people will install this.

"Review your work the next day" is advice for a human with a sleep schedule, not for an agent in a 25-minute session. It is the one place where the file forgets who its reader is.

And the media-query rule — gate hover behind `@media (hover: hover) and (pointer: fine)` — is correct and worth having, but it belongs in a lint rule; several of the eleven checklist rows do.

## What to Take

If you read one section, read the frequency table. It is the only part of the file that changes decisions agents get wrong by default, and it costs four lines. Add the `<300ms` ceiling and the `Before | After | Why` review format, and you have covered the three failures that show up in nearly every generated interface: motion on a keyboard action, a 400ms dropdown, and a review that argues instead of listing.

Install with `npx skills@latest add emilkowalski/skills` and the full set of 25 lands in your skills directory; the flagship is the one you get when you ask for animation help. If you want the automated-detector version of this advice instead, run Impeccable alongside it — one catches the bans mechanically, the other explains the trade-offs you still have to decide.
