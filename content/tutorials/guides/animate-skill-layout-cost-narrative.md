---
title: "I Built the Same Dropdown Twice With the animate Skill and Counted Layouts"
date: 2026-11-08
toc: true
draft: false
tags:
  - Animation
  - Agent Skills
  - Web Performance
category: "guides"
description: "emilkowalski's animate skill gives exact curves. I built a dropdown its way and the opposite way, then counted layouts in Chromium: 0 against 16."
---

I asked the `animate` skill for a dropdown and got one I could not argue with — transform and opacity only, 200ms on a `cubic-bezier(0.23, 1, 0.32, 1)`, scale from 0.95, origin pinned at the trigger. Then I opened the same menu three ways in headless Chromium and read the layout counter.

The curve made no measurable difference. The property did, and the gap was 16 layouts against zero.

## The Gate Killed Two of Three Things I Wanted

The skill runs a seven-step sequence and refuses to skip ahead. Step one is a frequency table, and it is blunt:

| Frequency | Verdict |
|:---|:---|
| 100+ times/day — keyboard shortcuts, command palette | No animation. Ever. |
| Tens of times/day — hovers, list navigation | Near-imperceptible or nothing |
| Occasional — modals, drawers, toasts | Standard animation |
| Rare / first-time — onboarding, celebration | The delight budget lives here |

Keyboard-initiated is called a disqualifier, not a judgment call, with Raycast's animation-free open as the citation. Step two asks you to name the purpose from a five-word vocabulary — feedback, spatial consistency, state indication, preventing a jarring change, explanation — plus delight reserved for the rare tier. Can't name it, don't build it.

I came in wanting three things: an animated command palette, a hover lift on cards in a list, and a dropdown. The gate killed the palette outright and demoted the hover to "fast and subtle, or nothing." One survivor out of three, and the skill frames that as the correct outcome: "The gate below exists to produce zero lines of code sometimes. That's a success, not a dodge."

## Where the Real Instructions Live

The seven steps stack in a fixed order: gate, purpose, tool, properties, curve and duration, interruption and exit, reduced motion. Step three walks a ladder from cheapest to most expensive — CSS transition for hover and state toggles, `@starting-style` for mount entries, CSS animation for motion that must survive a busy main thread, WAAPI for programmatic control, Motion for springs and gestures. Step four is where the file turns hard.

`transform` and `opacity` only. `clip-path` is the sanctioned fourth, `height` is tolerated for accordions because no transform equivalent exists. Everything else — width, margin, padding, top, left — is listed as a defect. Then: never `scale(0)`, start at 0.9–0.97 with `opacity: 0`, and put `transform-origin` at the trigger with modals exempt because they aren't anchored to anything.

The numbers come from tables, and the skill forbids inventing your own. Three curves ship: `--ease-out: cubic-bezier(0.23, 1, 0.32, 1)`, `--ease-in-out: cubic-bezier(0.77, 0, 0.175, 1)`, and an Ionic drawer curve `cubic-bezier(0.32, 0.72, 0, 1)`. Durations run button 100–160ms, tooltip 125–200, dropdown 150–250, modal 200–500, with a hard ceiling under 300ms for UI. Built-in `ease-out` is called too weak, `ease-in` is banned outright on the grounds that it delays the exact moment the user is watching.

There is also a `RECIPES.md` — 7,957 bytes, fourteen sections — and the skill tells you to start from a recipe rather than a blank file. The dropdown entry reads:

```css
.popover {
  transform-origin: var(--transform-origin); /* Base UI supplies this */
  transition:
    opacity 200ms var(--ease-out),
    transform 200ms var(--ease-out);
}
.popover[data-starting-style],
.popover[data-ending-style] { opacity: 0; transform: scale(0.95); }
```

## Three Variants, One Property Changed

I wrote one HTML file with three panels and drove each with `classList.toggle` in headless Chromium. Panel A was the anti-pattern stack the "Never Ship" table blocks — `transition: all 250ms ease-in`, width from 0 to 240px, `scale(0)`, centered origin. Panel B was the recipe above. Panel C was the isolation test the skill doesn't ask for: Panel A's width animation with Panel B's curve, duration, and origin, so only the animated property differed.

I enabled CDP's `Performance` domain, reset the counters before each open-and-close, and read `LayoutCount` after the animation settled. Six passes per variant, and I took the median because the browser does unrelated work on a shared box.

| Variant | Layouts per open+close | Median | Main-thread task time |
|:---|:---|:---:|:---|
| A — width + `ease-in` + `transition: all` + `scale(0)` | 12, 15, 16, 16, 16, 16 | 16 | 13–45ms |
| B — `transform` + `opacity`, 200ms custom curve | 0, 0, 0, 0, 0, 0 | 0 | 3.1–4.4ms |
| C — width only, same curve and duration as B | 2, 7, 8, 11, 12, 12 | 11 | 7–13ms |

The computed styles confirm what was actually animating. Variant A resolved to `transition-property: all`, `0.25s ease-in`, `transform-origin: 131px 39.5px` — dead center on a 262px panel. Variant B resolved to `opacity, transform`, `0.2s`, `cubic-bezier(0.23, 1, 0.32, 1)`, origin at `0px 0px`. So A was not slow because of `ease-in`; C proves the point. C used the skill's exact curve and duration and still forced a layout on most frames, because the browser has to reflow the subtree every time a width changes.

Two of C's six runs reported 66ms and 696ms of task time against a 7–13ms baseline. That is the kind of noise that makes single-run benchmarks worthless, which is why the median column carries the argument, not the extreme.

## What the Numbers Change About Reading the Skill

The skill presents properties, curve, and duration as co-equal steps. The measurement does not support that weighting. Get the property wrong and you buy a full layout pass per frame; get the curve wrong and you get a transition that feels slightly off at the same cost. One of those shows up in DevTools, the other only in a stopwatch test with a user.

The duration ceiling earns its place differently. 200ms against 250ms is not measurable in layout counts — it is measurable in whether a menu feels attached to the click. That's feel, and the skill says so in its output section: state what you can't judge from code, then point at the check. Play it at 2–5× in the animation inspector, step frame by frame, look again the next day.

What I'd carry forward if I dropped the skill tomorrow: the frequency gate (it deleted two animations I would have built, and both were correct deletions), the property rule as a hard block rather than a preference, and reduced-motion plus `@media (hover: hover) and (pointer: fine)` shipping in the same commit as the animation. The hover gating matters more than it reads — on touch, an ungated `:hover` fires on tap and leaves the element stuck in its lifted state.

## The Skill in the Family and How to Install It

On skills.sh as of 2026-11-08, `animate` shows 206.5K installs with a weekly curve of 11,760 → 13,469 → 14,465 → 15,844 → 17,674 → 18,026 → 19,743 → 17,825. Its siblings sit higher in cumulative totals — `apple-design` 281.5K, `improve-animations` 257.0K, `find-animation-opportunities` 240.5K — while all four share the same wave shape in the weekly buckets. `animation-performance` is the newcomer at 68.5K with five empty buckets followed by 1,148, 16,579, 18,512, 16,767. `choreograph` is listed at 8.6K with eight zero buckets, so its rank says nothing about current use.

Install with `npx skills add https://github.com/emilkowalski/skills --skill animate`, and grab `RECIPES.md` alongside it — the recipe is a better starting point than the prose when you already know what you're building.

If you're choosing between the construction skill and its review counterpart, the [review-animations writeup](/skills/coding/review-animations/) covers the enforcement side, and the [three taste presets comparison](/tutorials/comparison/taste-skill-presets-comparison/) covers what happens when a design skill hands you fixed dials instead of a decision table.
