---
title: "Web Design Guidelines: Vercel's Live UI Review Skill"
date: 2026-08-24
draft: false
tags:
  - Web Design
  - UI Audit
  - Accessibility
description: "Vercel's web-design-guidelines skill audits UI code against a live 190-line rulebook, flagging issues in file:line form. #37 on skills.sh with 570K installs."
version: "1.0.0"
author: "Vercel"
repo_url: "https://github.com/vercel-labs/agent-skills"
install_cmd: "npx skills add vercel-labs/agent-skills"
compatibility:
  - Claude Code
  - Cursor
  - Codex
category: "coding"
rating: 4.5
github_stars: 30412
github_forks: 2718
installs: 570998
last_updated: "2026-08-24"
ai_friendliness:
  score: 4.5
  documentation: 4.6
  setup: 4.5
  config: 4.5
---

Vercel's web-design-guidelines skill doesn't write your UI. It audits it — and the rulebook isn't even stored in the skill. The SKILL.md file is a 39-line launcher; the actual review standard ships from a separate repository and gets fetched fresh on every run. At skills.sh #37 with 570,998 installs and 21,343 installs last week (checked 2026-08-24), it's the most-used UI audit skill on the leaderboard, published by [Vercel Labs](https://github.com/vercel-labs/agent-skills) (30.4K stars). I read the launcher and pulled the live rulebook it points at — 190 lines, 16 rule groups — to see what a real audit actually flags.

## It Fetches a Fresh Rulebook on Every Review

The skill fires on phrases like "review my UI", "check accessibility", "audit design", or "check my site against best practices", and it takes a file or glob as its argument. That's the whole trigger surface: this is a review tool, not a generator, so nothing auto-fires during a build session.

The launcher does four things: fetch the guidelines from `raw.githubusercontent.com/vercel-labs/web-interface-guidelines/main/command.md`, read the files you named, apply every rule in the fetched document, then report in `file:line` format. The skill text is explicit that the fetch happens *before each review* — "Fetch fresh guidelines before each review" — which makes the whole thing versionless by design. When Vercel's engineers tighten a rule in the source repo, every agent in the wild picks up the new standard on its next run. No reinstall, no changelog, no stale checklist pinned inside a skill file, which is the trap most bundled-checklist skills fall into.

Real talk: that live-fetch design is the reason the numbers look the way they do. The skill has been climbing the leaderboard steadily — weekly installs went from roughly 17K to 21.3K over the last two months — without a single version bump. The review standard moves, the launcher stays still.

## What the Live Rulebook Actually Demands

The fetched command.md groups its rules into 16 buckets: accessibility, focus states, forms, animation, typography, content handling, images, performance, navigation, touch, safe areas, dark mode, i18n, hydration safety, hover states, and copy. A few specifics show how opinionated it is:

- **Typography**: `…` not `...`, curly quotes over straight ones, non-breaking spaces (`10&nbsp;MB`, `⌘&nbsp;K`), loading states ending with `…` ("Loading…"), `font-variant-numeric: tabular-nums` for number columns, `text-wrap: balance` on headings.
- **Interaction**: `outline-none` only flies with a `focus-visible` replacement; `transition: all` gets flagged — list the properties — and `touch-action: manipulation` kills the double-tap zoom delay.
- **Forms**: inputs need `autocomplete` and a meaningful `name`, blocking paste is banned outright (`onPaste` + `preventDefault`), `spellCheck={false}` on emails, codes and usernames, errors inline next to fields with focus on the first one.
- **Performance**: virtualize lists over 50 items, no `getBoundingClientRect` reads in render, prefer `<video autoplay muted loop playsinline>` over animated GIFs.
- **i18n**: `Intl.DateTimeFormat` and `Intl.NumberFormat` instead of hardcoded formats, `translate="no"` wrapped around brand names and code tokens so auto-translation leaves them alone.
- **Copy**: active voice — "Install the CLI", not "The CLI will be installed" — Title Case in the Chicago style, numerals for counts, and specific button labels: "Save API Key", not "Continue".

The output side is just as strict. Findings group by file, use `file:line` so they're clickable in VS Code, and skip explanations unless the fix is non-obvious. The source doc says it plainly: "sacrifice grammar for brevity. High signal-to-noise." A clean file gets a single `✓ pass` line and nothing else.

## The Anti-Pattern List Is the Fastest Win

The last section of the rulebook is a 14-item anti-pattern list the review must flag: `user-scalable=no` or `maximum-scale=1`, paste-blocking, `transition: all`, `outline-none` without a focus replacement, inline `onClick` navigation without an `<a>`, `<div>` or `<span>` elements with click handlers, images without dimensions, large `.map()` calls without virtualization, inputs without labels, icon buttons without `aria-label`, hardcoded date and number formats, unjustified `autoFocus`, animated GIFs where compressed video fits, and gesture-only actions with no tap, click or keyboard alternative.

Real talk: if you've reviewed AI-generated UI in the last two years, you've seen most of this list in a single screenshot — `<div onClick>`, missing labels, and stripped focus rings are the default output of a rushed generation pass. What this skill does differently is treat them as a fixed, named list instead of vibes.

## How It Differs From the Other Design Skills

| Skill | Job | Output | Standard source |
|-------|-----|--------|-----------------|
| web-design-guidelines | Audit existing UI | `file:line` findings | Live Vercel rulebook |
| frontend-design | Generate UI code | React/Next components | Static skill file |
| design-taste-frontend | Judge aesthetics | Style direction | Taste rubric |

That split is worth internalizing. [frontend-design](/skills/coding/frontend-design/) is a generator — you hand it a screen description and it writes components. web-design-guidelines is the reviewer you run on whatever came back, and it doesn't care which tool produced the code. The two fit together: generate with one, audit with the other, and keep the audit in CI so the standard applies on every PR, not just the screens you remember to check.

## Bottom Line

Use web-design-guidelines as the review gate in your frontend loop: point it at a component folder, let it fetch its own standard, and act on the `file:line` punch list. It's freely installable with `npx skills add vercel-labs/agent-skills` and it works in Claude Code, Cursor, and Codex. Expect findings, not prose — and expect them to stay current, because the rulebook refreshes itself. Start with the anti-pattern list on your last AI-generated screen; the `✓ pass` line on an audited file means something a checklist in a skill file never can.