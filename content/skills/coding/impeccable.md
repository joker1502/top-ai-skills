---
title: "Impeccable: 24 Design Commands and 62 Rules Against AI Slop"
date: 2026-11-01
draft: false
tags:
  - Impeccable
  - Frontend Design
  - Agent Skills
category: "coding"
description: "Impeccable ships a Rust engine, 45 reference files and 24 commands that steer agents away from eyebrow labels and purple gradients. 377.8K installs."
---

Impeccable is the first design skill I have read that treats "this looks like AI made it" as a defect list you can measure instead of a mood. Paul Bakaus's repo carries a Rust engine, 45 reference files and 24 command names, and the most useful part is not the styling advice — it is the part that refuses to let your agent argue with a ban.

The counters for 2026-11-01: 99,073 stars, 377.8K installs at rank #232 on skills.sh, weekly installs `[10,046, 10,293, 10,026, 12,403, 14,587, 15,883, 16,661, 17,994]`. The last bucket is the highest, which is rare on a board where most entries peaked weeks ago.

## What the Folder Actually Contains

SKILL.md is 11,864 bytes and declares version 4.8.0. One table lists all 24 command names with a reference path each, then eight paragraphs of routing rules that decide which of those 24 you get.

Behind it sit 45 files under `reference/` — 41 top-level plus four in `degraded/` that handle models which cannot spawn subagents. Size tells you where the thinking went: `new-work.md` is 62,902 bytes, `critique.md` is 45,608, `live.md` is 37,230, `document.md` is 27,436. `craft.md` is 555 bytes because `craft` is now a deprecated alias with nothing behind it.

`scripts/` holds the odd part. There is an 11,320-byte POSIX shell launcher, a 563 KB `live-browser.js`, and a 1.1 MB `font-index.json`. `scripts/VERSION` reads **0.1.18** while the frontmatter reads **4.8.0**. Two version numbers, two different objects: the skill release and the engine binary that does the checking.

## The Launcher Header Explains More Than the Docs

Read the top of `scripts/impeccable` and you get a design history lesson in a comment block. It resolves the binary in this order: `$IMPECCABLE_BIN`, the sibling `bin/<os>-<arch>/impeccable`, `~/.impeccable/bin/impeccable`, the version-pinned cache, then `impeccable` on `PATH`. No Node anywhere, which matters if your agent runs in a container without a runtime.

Two traps are written into that file. First, the retired 3.x npm CLI also installed a binary named `impeccable`, and calling it fails every verb with "Unknown command" — so every candidate has to answer an `engine-probe` handshake that prints `impeccable-engine <version>` before it gets trusted. Second, the sibling binary is gitignored, so a skill upgrade that copies files over the directory leaves the old engine sitting there; the launcher compares it against `VERSION` instead of assuming freshness.

Checksums come from `engine-checksums.txt`, never from anything published next to the binary. A `<binary>.verified` stamp holding the manifest digest skips rehashing — necessary, because the hook runs this launcher on every single edit.

## Four Modes Decide How Loud the Page Gets

The mode names what success looks like for the visitor, not what the product is:

| Mode | Visitor's job | Typical surface |
|---|---|---|
| Persuade | decides and acts | landing pages, pricing, campaigns |
| Operate | completes a task | dashboards, editors, admin, settings |
| Read | understands something | docs, articles, changelogs |
| Experience | is inside the work | portfolios, galleries |

The rule that trips people up: pick the mode from the surface, not the company. A developer tool's landing page is still Persuade, a fashion house's documentation is still Read, and a docs index is Read rather than Persuade. On Operate and Read, ambition shows up as restraint — "patterns the visitor already knows earn their place."

## The Craft Floor Is Where It Gets Opinionated

`reference/craft-floor.md` is 4,516 bytes and gets loaded immediately before any UI edit, not at planning time. It separates defaults from bans, and the ban list has exactly one absolute entry: **no kicker or eyebrow above a heading**. The file's own words — "This one is a ban, not a default: no brief earns it back. The heading carries its own weight."

Everything else is refusal-with-permission: same-size icon-plus-heading-plus-text cards as page structure, nested cards, the hero-metric template, `01 / 02 / 03` section numbers, gradient text, glass as decoration, a colored `border-left` above 1px, hard offset block shadows outside an actual neobrutalist world, monospace as a costume for "technical", emoji standing in for an icon system, geometric masks faking organic contours. Any of those can be earned by the brief's own words. Reaching for one when the axis is free means you were not deciding.

The measurable half is stated as ratios, not intentions: body and placeholder text ≥4.5:1, large text ≥3:1, body measure 65–75ch, display max 6rem, tracking floor −0.04em, more space above a heading than below it.

And then the paragraph I would frame: text selection, the caret, custom scrollbars, focus rings, underline offset, tabular numerals. Those ship with browser defaults that belong to no design system. Theming them "is the cheapest signal that a page was built rather than assembled, and the one models skip most reliably."

## 62 Rules That Never Call a Model

The README claims 62 deterministic rules, no LLM, no API key. The repo's test vectors show the granularity behind that number: 14 `check*` functions — `checkEmDashOveruse`, `checkGptThinBorderWideShadow`, `checkHeroEyebrow`, `checkKickerAboveHeading`, `checkOversizedH1`, `checkIconTile`, `checkItalicSerif`, `checkRadialSpotlight`, `checkNumberedSectionLabels`, `checkContentHiddenAtRest`, `checkMotion`, `checkBorders`, `checkColors`, `checkHtmlPatterns` — plus eight CSS/HTML scanners for glow, grid backgrounds, inset stripes, marquees, pseudo-element stripes, pulsing dots, radial halos and shape-assembled illustrations. Each has golden JSONL vectors; the marquee and pulsing-dot scanners alone carry 464 KB and 455 KB of cases.

This is the split worth understanding, because most design skills do it the other way. A prose-only skill like the [taste-skill presets](/tutorials/comparison/taste-skill-presets-comparison/) writes its rules in markdown and trusts the model to hold them. Impeccable puts the mechanical tells in a detector that runs after edits and hands the judgment calls to two scored commands — `critique` for UX heuristics, `audit` for accessibility, performance, theming and responsive behavior with P0-to-P3 severity.

The limit is real: a detector catches a pulsing dot and a kicker, not a weak information hierarchy. That is why the two evaluation commands exist next to it.

## Install It and Point It at One Component

```bash
npx impeccable install
# reload your coding tool, then in the agent:
/impeccable init
/impeccable critique the pricing cards
```

`init` runs a discovery interview and writes `PRODUCT.md`; `document` extracts colors, type, spacing and radii from your code into `DESIGN.md` in the Google Stitch format so other tools can read it too. `doctor` reports drift between those artifacts and the current engine version — a `CONTEXT_STALE` line in setup output is the cheap subset of the same report, and neither should be repaired silently during a design task. `pin audit` turns a command you run weekly into a standalone `/audit` shortcut.

One warning from the command metadata: live mode applies copy edits through your `package.json`'s optional `impeccable:manual-edit-validate` script with your permissions, so read it before using live mode in a repo you did not write.

Here is my honest read after going through the files. The eyebrow ban stings because half the landing pages on the internet open with one, and the README names the rest of the default stack without flinching: Inter for everything, purple-to-blue gradients, cards inside cards, gray text on colored backgrounds, a rounded-square icon tile above every heading. If your agent keeps producing that, this is a concrete way to stop it rather than a longer prompt.

Start with one component, not the whole page — narrow targets get better results, and a single section reviewed closely beats a page at a glance. If you want the site-level view instead, [web-design-guidelines](/skills/coding/web-design-guidelines/) audits against Vercel's interface rules, and the two cover different ground.
