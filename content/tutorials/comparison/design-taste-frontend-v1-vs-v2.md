---
title: "design-taste-frontend v1 vs v2: What the 4x Rewrite Changed"
date: 2026-09-24
toc: true
draft: false
tags:
  - Frontend
  - Design Systems
  - AI Coding
category: "comparison"
description: "One repo publishes two skills: the 21KB v1 with fixed dials and 87KB v2 that reads the brief first. This maps what the taste-skill rewrite actually changed."
---

One repository publishes two skills under two install names, and the numbers on skills.sh make it look like two products. [design-taste-frontend](https://github.com/leonxlnx/taste-skill) (514.8K installs, rank 84) and design-taste-frontend-v1 (259.1K, rank 239) are the same leonxlnx/taste-skill repo, 89,816 stars. I scraped the leaderboard on 2026-09-24 and read both SKILL.md files end to end — 87,253 bytes and 1,206 lines for v2, 21,195 bytes and 226 lines for v1, a 4.1x gap. The v1 file says it best: "The original v1 taste-skill, preserved for projects depending on its exact behavior. The current default is design-taste-frontend (v2 experimental), which is a substantial rewrite."

## Fixed Dials vs Reading the Room

v1 opens with three global knobs — DESIGN_VARIANCE 8, MOTION_INTENSITY 6, VISUAL_DENSITY 4, on 1-to-10 scales — and one instruction: "Do not ask the user to edit this file." Every rule downstream fires against those fixed values. v2 keeps the three dials but inverts the trigger: "Every rule below is contextual. None of it fires automatically."

v2's Section 0 makes the agent read six signals before touching code — page kind, vibe words, reference URLs, audience, existing brand assets, quiet constraints like accessibility or public-sector rules — and output a one-line Design Read before generating: *"Reading this as: B2B SaaS landing for technical buyers, with a Linear-style minimalist language, leaning toward Tailwind utilities + Geist + restrained motion."* If the brief genuinely diverges, it asks exactly one question and never a dump. The dials then get inferred from the read via a mapping table, not assumed: a "minimalist/editorial" brief lands at variance 5-6, motion 3-4, density 2-3; "premium consumer / Apple-y" at 7-8 / 5-7 / 3-4; "trust-first / public-sector" at 3-4 / 2-3 / 4-5. The baseline 8/6/4 survives only as a default when nothing else fits.

## v2 Gained Design Systems and Hard Layout Rules

The single biggest absence in v1 is design systems. v2's Section 2 hands the agent a routing map — Fluent UI for Microsoft, Carbon for IBM-style B2B, Polaris for Shopify surfaces, Atlaskit for Atlassian, Primer for GitHub-flavored devtools, GOV.UK Frontend and USWDS for public-sector work, Material Web, Radix Themes, shadcn/ui — with a stated rule to install the official package and never re-create its CSS by hand, plus "one system per project" and source-backed appendices with real install commands. v1 had none of this; it hand-rolled everything.

v2 also added a layer of hard layout discipline with mechanical, verifiable limits:

| Rule | Limit |
|:-----|:------|
| Hero | Fits viewport; subtext max 20 words; max 4 text elements |
| Navigation | One line at desktop, height ≤ 80px |
| Eyebrow labels | Max 1 per 3 sections, counted mechanically |
| Zigzag alternation | Max 2 image+text split sections in a row |
| Bento grid | Exactly as many cells as content items; bit 2-3 cells need real visual variation |
| Marquee | Max one per page |
| Em-dashes | Zero on the page, non-negotiable |

The eyebrow rule is typical of the new tone: it identifies the pattern by its CSS signature (`text-[11px] uppercase tracking-[0.18em]`), calls it "the #1 violated rule in production tests," and turns the check into a count of `uppercase tracking` instances across components.

## The Motion Contradiction

The sharpest finding is a straight contradiction between the two files. v1's Section 9 mandates perpetual motion: "Every card must have an 'Active State' that loops infinitely (Pulse, Typewriter, Float, or Carousel)" — magnetic buttons, staggered reveals, spring physics on everything. v2 lists "infinite-loop micro-animations everywhere" as one of the LLM defaults it exists to avoid, and its motion rule reads: "Not every card needs an infinite loop. If a section is informational, leave it still." The v1 aesthetic became the v2 anti-pattern in one rewrite.

Same flip on two other bans. v1: "Emojis are BANNED." v2: discourages emojis but explicitly overrides for playful, chat-style, social-native vibes. v1: "NO Inter Font: Banned." v2: discourages Inter as a default but permits it when the user asks for neutral or Linear-style, or the brief is public-sector. v1 even bans pure black (`#000000`); v2 keeps that but adds a fresh, more specific target: the premium-consumer beige+brass+espresso palette ("warm paper + brass/clay/oxblood + espresso dark text") is banned as a default reach, with rotation rules so the agent does not ship the same warm-craft family twice in a row.

## Redesign Protocol and the 60+ Box Pre-Flight

v1 is a builder's skill. v2 is a builder's and a surgeon's. Section 11 adds a redesign protocol with an audit-before-touching step — extract brand tokens, map information architecture, take an SEO baseline and treat "SEO migration is the #1 redesign risk" as the top preservation rule, never change URL slugs, nav labels, form field names, or analytics events without approval. Then a modernization lever order that stops when the brief is satisfied: typography refresh first, spacing second, color third, motion fourth, hero recomposition fifth, full block replacement only last.

The closing checklists measure the discipline gap. v1 ends with 7 pre-flight boxes. v2's Section 14 runs 60+ boxes, several of them mechanical — count the eyebrows, count the em-dashes, verify the CTA labels wrap at desktop — plus accessibility gates that did not exist in v1: button and form contrast at WCAG AA, reduced-motion handling, `prefers-reduced-transparency` fallbacks for glass effects. One scope note cuts the other way: v1 hardened dashboards, v2 declares "Not dashboards, not data tables, not multi-step product UI" and routes those briefs out (Fluent, Carbon, TanStack), while paradoxically also handing the dashboard briefs back to real systems in Section 2.

## Which One to Install

Both install with the same command shape from the leaderboard: `npx skills add https://github.com/leonxlnx/taste-skill --skill design-taste-frontend`, or with `--skill design-taste-frontend-v1` for the legacy path. Install v2 for any new project — the brief-inference flow, design-system routing, and redesign protocol are strictly additive value. Keep v1 only when an existing config depends on its exact behavior, which is precisely what its own frontmatter is preserved for.

The install numbers deserve one caveat. Weekly curves for both run in parallel shape — v2 at [22,212, 26,808, 24,487, 26,734, 30,689, 26,844, 24,606, 24,885] and v1 at [11,833, 14,674, 13,025, 15,703, 18,834, 16,408, 14,994, 14,976] — peaking the same week and settling together, the same pack-wave signature we documented on [anti-ui-slop vs web-design-guidelines](/tutorials/comparison/anti-ui-slop-vs-web-design-guidelines/). Still 15K people a week install the version the author calls a legacy archive. If you are on the fence, the deciding test takes five minutes: point each skill at the same landing-page brief and compare the first question it asks. v1 dives straight into code with the dials pre-set; v2 asks you to read the room first.

*Covered alongside: [web-design-guidelines — Vercel's audit skill](/skills/coding/web-design-guidelines/).*