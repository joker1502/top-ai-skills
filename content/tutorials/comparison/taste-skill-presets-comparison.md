---
title: "minimalist vs brutalist vs premium: 3 Taste-Skill Presets"
date: 2026-10-16
toc: true
draft: false
tags:
  - Frontend
  - Design Systems
  - AI Coding
category: "comparison"
description: "One repo ships three presets that cancel each other out: Inter banned twice and required once, corners 12px, 0px or 2rem. Byte-level read of all three files."
---

One repository publishes three aesthetics that ban each other's rules, and all three are installed hundreds of thousands of times under separate names. leonxlnx/taste-skill (97,912 stars, last push 2026-10-14) carries 14 SKILL.md files, 13 of which show up as install names on the skills.sh board I scraped on 2026-10-16: **minimalist-ui** at 415,142, **industrial-brutalist-ui** at 387,807, **high-end-visual-design** at 448,490 — last-week figures 20,368 / 19,247 / 21,875, inside a 3,500 spread while their totals sit 60,000 apart. I read all three files end to end: 8,212, 8,456 and 10,561 bytes. The interesting part is not the palettes. It is that the three disagree on rules the others treat as hard failures.

## Same Skeleton, Three Mutually Exclusive Rule Sets

Every file in this family follows one shape: a meta section, an absolute-ban list, typography, color, components, motion, and a delivery protocol. The skeleton holds — and then the content splits three ways. Radius is the clearest case:

| | minimalist-ui | industrial-brutalist-ui | high-end-visual-design |
|:---|:---|:---|:---|
| Corners | 8px to 12px max, `rounded-full` banned for large containers | absolute rejection of `border-radius`, all corners exactly 90° | `rounded-[2rem]` squircles, full pills for CTAs |
| Shadow | practically non-existent or under 0.05 opacity | strictly prohibited | soft, heavily diffused ambient shadows required |
| Gradients | banned, then permitted at 0.03 opacity as "light spots" | banned outright | required in the Ethereal Glass archetype |
| Emoji | banned everywhere, including alt text | not mentioned, ASCII art instead | not mentioned |
| Motion spec | 600ms fade-up, `translateY(12px)`, reduced-motion mandatory | none at all | 800ms+ with `blur-md`, staggered, spring easing |

A tag pill is legal in minimalist-ui and illegal in industrial-brutalist-ui, where geometry is non-negotiable: "All corners must be exactly 90 degrees to enforce mechanical rigidity." The white-on-charcoal aesthetic is not the differentiator you would assume, either. Brutalist runs `#F4F4F0` paper against `#E61919` aviation red with exactly one accent color allowed, and no translucent glass in sight — the same file calls modern translucency prohibited.

## Inter Is Banned Twice and Recommended Once

Here is the finding that made the three-way read worth it. minimalist-ui opens its ban list with "DO NOT use the 'Inter', 'Roboto', or 'Open Sans' typefaces." high-end-visual-design agrees: "Banned Fonts: Inter, Roboto, Arial, Open Sans, Helvetica." And industrial-brutalist-ui lists Inter in its optimal macro-typography set — "Neue Haas Grotesk (Black), Inter (Extra Bold/Black), Archivo Black, Roboto Flex (Heavy)" — where Roboto Flex takes the same treatment one line later.

Same repo, same maintainer, opposite verdicts. Nothing here is sloppy, either: each file is written for a different client. Type among designers varies by context, and the family is deliberately shipping a menu rather than a doctrine. But if you install two of these into one agent and let both fire, you get a font bug report that no rule resolves. Pick one preset per project and stop at the frontmatter.

## One File Rolls Dice, One Commits, One Removes the Choice

The variance rules are where the design philosophies actually diverge, and they are incompatible by construction:

- **high-end-visual-design** mandates variety — "NEVER generate the exact same layout or aesthetic twice in a row" — then asks the agent to silently pick one of three texture archetypes (Ethereal Glass, Editorial Luxury, Soft Structuralism) crossed with one of three layout archetypes (Asymmetrical Bento, Z-Axis Cascade, Editorial Split) before writing code.
- **industrial-brutalist-ui** does the reverse: "Pick ONE per project and commit to it. Do not alternate or mix both modes within the same interface," and never mix light and dark substrates. Two modes exist, Swiss Industrial Print and Tactical Telemetry, and choosing wrong means rebuilding.
- **minimalist-ui** takes the choice away. One palette (`#F7F6F3`, `#FFFFFF`, off-black `#111111` or `#2F3437` body text), pastels reserved for tags, bento grids with a `1px solid #EAEAEA` border, body line-height 1.6.

So: randomized premium polish, one rigid mode you must commit to, or a fixed editorial palette with the decisions pre-made.

## Motion and Accessibility Are the Real Splits

Only minimalist-ui treats reduced motion as mandatory: scroll-entry, staggered reveals and the ambient blob are gated behind `@media (prefers-reduced-motion: no-preference)`, with a `reduce` block that puts content at rest instantly. That rule arrived late — the file was last touched 2026-06-21 in a commit titled "Enforce prefers-reduced-motion in gpt-taste and minimalist-ui", so the other presets never inherited it.

industrial-brutalist-ui has no motion section whatsoever. Its degradation effects — CRT scanlines via `repeating-linear-gradient`, 1-bit dithering, a global noise filter on the DOM root — are static texture work, not animation, so there is nothing to gate. high-end-visual-design substitutes performance guardrails for accessibility: no `backdrop-blur` on scrolling containers, animate `transform` and `opacity` only, `min-h-[100dvh]` instead of `h-screen` to stop iOS Safari viewport jumps, and mobile collapse rules for every asymmetric layout. That is a rendering-performance list with an accessibility side effect, not an accessibility policy.

Both older files (brutalist and soft) have sat untouched since the March 2026 restructure that moved everything under `skills/`, while the flagship keeps moving — which is exactly what the [design-taste-frontend v1 vs v2 comparison](/tutorials/comparison/design-taste-frontend-v1-vs-v2/) showed at 21KB against 87KB.

## Which One You Actually Want

Match the preset to the artifact instead of stacking them:

- **Data-heavy dashboard, portfolio, or an editorial site that should feel like a declassified blueprint** → industrial-brutalist-ui, and commit to one substrate before you write a line of CSS.
- **Documentation, workspace tooling, anything Linear-adjacent** → minimalist-ui, mostly because the negative constraints (no emoji, no Inter, no `shadow-lg`, no pill containers) are the ones AI-generated frontends break first.
- **Marketing page or client work that has to read as expensive** → high-end-visual-design, whose Double-Bezel nesting and button-in-button icon pattern are the two rules that visibly separate it from a template.

If your goal is auditing what an agent produced rather than styling the next build, the [anti-ui-slop vs web-design-guidelines comparison](/tutorials/comparison/anti-ui-slop-vs-web-design-guidelines/) covers that layer. These three are generation rules, not auditors.
