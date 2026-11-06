---
title: "UI-UX Pro Max FAQ: I Counted All Nine Numbers in Its Skill File"
date: 2026-11-06
toc: true
draft: false
tags:
  - UI Design
  - Design Systems
  - Agent Skills
category: "guides"
description: "ui-ux-pro-max advertises 80 styles, 192 palettes, 74 fonts, 119 guidelines and 25 charts. I counted the CSV rows: all nine numbers hold, and the search agrees."
faq:
  - question: "What is ui-ux-pro-max, in one paragraph?"
    answer: "It's a design-intelligence skill from NextLevelBuilder, version 2.15.0, MIT licensed, installed with npx ui-ux-pro-max-cli init --ai <platform>. Instead of writing design advice in prose, it ships a folder of CSV data — styles, palettes, font pairings, UX guidelines, icons, motion presets, chart types, and per-framework stack rules — plus a Python search script that queries that data locally. The agent picks a query, the script returns matched rows, and the agent builds from the returned spec."
  - question: "Do the advertised counts actually match the data files?"
    answer: "Yes, all nine. I counted the rows in each CSV on 2026-11-06: colors.csv has 192 palettes, typography.csv has 74 font pairings, ux-guidelines.csv has 119 guidelines, icons.csv has 105 curated icons, motion.csv has 17 presets, charts.csv has 25 chart types, and data/stacks/ holds exactly 22 stack files. styles.csv has 89 rows, which resolves to the advertised '80 searchable' once the 9 deprecated rows are excluded. A shipped catalog-summary.json dated 2026-11-04 documents the same figures."
  - question: "What does '80 searchable styles (51 active)' mean?"
    answer: "The 89 rows in styles.csv carry a Status column: 51 active, 29 supplemental, 9 deprecated. Active plus supplemental equals 80, and both are reachable from a --domain style search. I proved it by querying 'heat map color-coded grid data intensity' and getting back the supplemental row 'Heat Map & Heatmap Style' with Status: supplemental and a Parent Style ID of data-dense-dashboard. Deprecated rows are the only ones that never come back in a result."
  - question: "Why did a deprecated style return zero results instead of a row?"
    answer: "Because the search script treats a deprecated label as a routing problem, not a missing row. Querying 'hero-centric design compelling headline product showcase' returns 0 results plus a written note: this legacy style label is now modeled in the landing domain as hero-centric-design, search that domain instead. A page-composition pattern stopped being a visual style and moved domains, and the tool says so rather than handing back an obsolete entry."
  - question: "Does the search need Python packages, an API key, or a network connection?"
    answer: "No to all three. scripts/search.py runs on the Python 3 standard library — no pip install, no key, no network call. The whole data folder is about 3.1 MB on disk. The one trap is the path: invoke it as python \"${CLAUDE_PLUGIN_ROOT}/.claude/skills/ui-ux-pro-max/scripts/search.py\" \"<query>\" --domain <domain>, because the script lives inside the skill directory, not your project. The skill file also lists python3 and py -3 as fallbacks if python is not on PATH."
  - question: "What does --design-system return that a single domain query doesn't?"
    answer: "A coherent bundle instead of one matched row. I ran the skill's own example, 'beauty spa wellness service' with -p 'Serenity Spa', and got back a page pattern (Hero + Testimonials + CTA with a five-section order and CTA placement), a style (Soft UI Evolution, with light/dark mode support and its accessibility requirements), a full palette as CSS variables (primary #EC4899, secondary #F9A8D4, accent #8B5CF6, background #FDF2F8, foreground #831843), typography, and anti-patterns to avoid. Add --persist --output-dir <project root> and it writes design-system/<slug>/MASTER.md as the project's source of truth."
  - question: "How current is the data, and can I check it myself?"
    answer: "Each stack row carries Applies To and Verified At fields — the html-tailwind rows I pulled were verified 2026-08-13 and marked Applies To: html-tailwind 4.3. The repo also ships scripts/validate_data.py; running it prints OK: validated 12 domain files, 22 stack files, and ui-reasoning.csv. catalog-summary.json pins SHA-256 hashes for the largest datasets (google-fonts.csv, icons.csv, phosphor assets, font licenses) so you can confirm nothing changed under you."
  - question: "What happens when a query matches nothing?"
    answer: "The tool refuses to invent an answer. Querying 'zzzqqq nonexistent widget frobnicator' returned 0 results and an explicit message that this is not a match with an empty value — the query did not hit the database — plus instructions to retry with different keywords and to tell the user when falling back to general defaults. It also printed a Closest known terms line pointing at the nearest indexed token. The SKILL.md repeats the same discipline: never present a 0-result search as if it returned data."
---

`ui-ux-pro-max` does not describe design. It ships a database and a search script, then makes the agent query it. The skill file is 16,646 bytes of instructions wrapped around 12 CSV domain files, 22 stack files, and a stdlib-only Python script.

That structure invites a fair question — are the numbers in the description real, or marketing? I cloned the repo on 2026-11-06, counted every row, ran the search script against real queries, and ran the repo's own validator. The counts hold. The interesting part is how the search behaves at the edges.

## The Nine Numbers, Counted by Hand

The skill's frontmatter advertises nine quantities. Here is each claim next to what `csv.DictReader` returned.

| Claim in SKILL.md | Rows I counted | Verdict |
|:---|:---|:---|
| 80 searchable styles | styles.csv: 89 total → 51 active + 29 supplemental + 9 deprecated | holds (80 = active + supplemental) |
| 192 product palettes | colors.csv: 192 | exact |
| 74 font pairings | typography.csv: 74 | exact |
| 119 UX guidelines | ux-guidelines.csv: 119 | exact |
| 105 curated icons | icons.csv: 105 | exact |
| 17 GSAP motion presets | motion.csv: 17 | exact |
| 25 chart types | charts.csv: 25 | exact |
| 22 technology stacks | data/stacks/*.csv: 22 files | exact |
| 51 active styles | Status column: 51 active | exact |

Eight of nine are straight row counts. The ninth needed unpacking, and the unpacking is the most useful thing in the repo.

### The 80-vs-51 discrepancy is a deliberate split

`styles.csv` has a Status column and three values: active (51), supplemental (29), deprecated (9). Add the first two and you land on 80. The shipped `catalog-summary.json`, verified 2026-11-04, states it in exactly these terms — total 89, searchable 80, active 51, supplemental 29, deprecated 9.

A supplemental row is a sub-style of an active parent. Searching `heat map color-coded grid data intensity` with `--domain style` returned "Heat Map & Heatmap Style" marked `Status: supplemental` and `Parent Style ID: data-dense-dashboard`. So the search index reaches it, and the parent pointer stays attached — useful when the agent needs to fall back to a broader style for spacing and layout rules.

### Datasets the description never mentions

The advertised list undersells the folder. Unadvertised files I counted: `google-fonts.csv` at 1,934 font families, `products.csv` at 192 product types, `ui-reasoning.csv` at 192 reasoning profiles, `landing.csv` at 34 landing patterns, `react-performance.csv` at 44 rules, `app-interface.csv` at 32 native-app rules, and 1,278 guideline rows spread across the 22 stack files — a figure that matches `stackGuidelines: 1278` in the catalog summary.

That last number is the one that changes how you use the skill. Per-framework advice is the largest single block of content in the repo, and it's invisible from the description.

## What the Search Actually Refuses to Do

Three queries told me more about the design than the counts did.

**Deprecated labels get rerouted, not returned.** Asking for "hero-centric design compelling headline product showcase" in the style domain produced 0 results and this line: the legacy style label is now modeled in the `landing` domain as `hero-centric-design`. The tool knows the row was retired and knows where its concept lives now. It also knows "migrate/upgrade/instead" phrasing means you may want the current generation rather than the legacy one, so the redirect logic stays quiet in those cases.

**Empty queries say they are empty.** A nonsense query returned 0 results, an explicit "this is not a match with an empty value — the query did not hit the database" statement, a retry instruction, and a `Closest known terms` hint. Nothing fabricated, nothing fuzzy-matched into a plausible-looking style.

**Stack answers arrive as diffable pairs.** A `--stack html-tailwind` query for "chip badge overflow nowrap" returned three rows; the top one carried Do (`flex flex-wrap gap-2` for collections, `whitespace-nowrap` with `min-w-0 truncate` for a single label), Don't (clip a fixed-height row), Good and Bad code snippets, Severity: High, a Tailwind docs URL, `Applies To: html-tailwind 4.3`, and `Verified At: 2026-08-13`. That's a spec an agent can implement without inventing a single value.

## Token Cost and Query Discipline Worth Knowing

The main SKILL.md is 16,646 bytes. Two reference files load on demand: `quick-reference.md` at 24,526 bytes holds the full rule text for all 119 guidelines, and `pro-rules.md` at 10,909 bytes holds the app-UI checklist. The data folder is roughly 3.1 MB and never enters the context — only the rows a query returns do.

That split is why the query contract matters. The skill asks for one dominant intent, 2–5 meaningful terms, and an explicit `--domain` when a term is ambiguous, because "font" auto-detects to either `typography` or `google-fonts` and the wrong one silently returns the wrong kind of answer. One retry with a narrower phrase, then state that no verified match was found. No cycling through keywords until something sticks.

Worth flagging: the skill was one of only two entries on today's 148-skill leaderboard whose last five weekly buckets never fell. 437.9K lifetime installs at rank #99, weekly installs climbing from 9,100 to 14,025 across six straight buckets — a 54% run while most of the board slides. Growth is not proof of quality, but a monotone curve on a data-heavy skill usually means people keep it installed after the first session.

## Who This Fits, and Who Should Skip It

Fits: agents building web or app interfaces where a wrong color pair or a 12px body font is a real defect; teams that want a recorded `MASTER.md` per project instead of re-deciding the palette each session; anyone who prefers a Do/Don't table with a docs URL over an essay about visual hierarchy.

Skip: backend and API work, marketing copy, and one-off landing pages where you already have a brand system — the value here is breadth, and breadth is noise when you have a house style. Also skip it if you cannot run Python locally; the search is the product.

Verify it yourself in four commands: count `styles.csv` rows, run `scripts/validate_data.py`, run one `--design-system` query on your own product category, then run one nonsense query and read what comes back. The last one is the real test of any data-backed skill — what it does when it has nothing to say.

For design-review rules that work on code you already wrote, the [interface quality skill breakdown](/skills/coding/impeccable/) covers the deterministic-rule approach. If you're wiring any of this into your own agent setup, the [skill authoring walkthrough](/tutorials/guides/how-to-create-your-own-ai-agent-skills/) covers the folder contract both skills follow.
