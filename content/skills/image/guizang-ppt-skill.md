---
title: "Guizang PPT Skill"
date: 2026-08-07
draft: false
tags:
  - AI Presentations
  - AI Image
  - AI Tools
description: "Guizang PPT Skill generates single-file HTML decks with magazine or Swiss design, presenter mode, rehearsal tools, and social covers for AI agents."
version: ""
author: "op7418"
repo_url: "https://github.com/op7418/guizang-ppt-skill"
install_cmd: "npx skills add https://github.com/op7418/guizang-ppt-skill --skill guizang-ppt-skill"
compatibility:
  - Claude Code
  - Codex
category: "image"
rating: 4.5
github_stars: 23454
github_forks: 1684
installs: 0
last_updated: "2026-08-07"
ai_friendliness:
  score: 4.5
  documentation: 4.5
  setup: 4.0
  config: 4.0
---

## What It Is

Guizang PPT Skill is a 23.4k-star agent skill for Claude Code, Codex, and similar coding-agent environments. The [official README](https://github.com/op7418/guizang-ppt-skill) describes it plainly: "It generates **single-file HTML horizontal-swipe decks**, deck visuals, and social cover pages, with a complete rehearsal and presenter mode built in." No build step, no server — the output is one HTML file you can open in a browser, present, send, and screenshot.

The repo ships two visual systems. **Style A: editorial magazine × electronic ink** — the README's own description is "picture *Monocle* with code stitched in," best for narrative talks, opinions, salons, and personal voice, with serif headlines, fluid WebGL backgrounds, and warm ink tones. **Style B: Swiss International Typographic Style** — grid-first, one high-saturation anchor color (Klein blue, lemon yellow, lemon green, or safety orange), sharp rectangles, hairline rules, and extreme type contrast, built for facts, products, analysis, and frameworks.

The skill was "distilled by Guizang from offline talks like 'One-Person Company: Organizations Folded by AI' and 'A New Way of Working' — every pitfall hit during those decks is logged in `checklist.md`." That origin shows in the details: layouts for section covers, data callouts, image grids, pipelines, and comparisons, plus a presenter mode with a dual-window audience view, current/next 16:9 previews, speaker notes, timed rehearsal, auto-advance, laser pointer, annotation, and live failure recovery.

## What Makes It Different

The first thing that stands out is the **two design systems instead of one generic template**. Most deck skills render every slide with the same look; Guizang PPT Skill deliberately separates narrative decks (Style A) from factual ones (Style B), each with locked layouts — Style A offers 10 layouts, Style B offers 22 locked variants like Cover, Statement, KPI Tower, Loop Diagram, Duo Compare, Image Hero, and Closing Manifesto. You tell the agent the style, and it applies a coherent typographic system across the whole deck instead of improvising.

Second, it is **agent-native by construction**. Because decks are plain HTML/CSS text, an agent can read, edit, and verify them directly — and it can regenerate any slide from feedback. The README's reasoning is explicit: HTML has more expressive range than Markdown (fine typography, spatial positioning, animation, interaction, responsive covers) while staying fully inspectable. Deck visuals are handled the same way: on Codex you can generate photographic images, infographics, flowcharts, system diagrams, and UI mockups with GPT-Image and insert them at template-mandated ratios.

Third, it **covers the whole presentation lifecycle, not just the slides**. The same visual rules produce WeChat 21:9 covers, 1:1 share cards, Xiaohongshu 3:4 covers, and horizontal video covers from one deck's core ideas. The presenter mode adds speaker notes, per-slide planned timing, rehearsal with a countdown, auto-advance, a laser pointer, on-slide annotation, and a low-performance static mode (press `B` to disable WebGL/canvas animations on weak machines).

## Who It's For

Guizang PPT Skill fits three types of users. First, **founders and solo operators who present often** — the author's own use case is "one-person company" talks, product launches, and demo days. If you give offline talks, internal keynotes, or private sharing sessions and want decks with strong personal style, this is the fastest path from article to presentation: the README's sample request is literally "Create a Swiss-style deck from this article, around 7 slides, with 2-3 generated visuals."

Second, **content teams that repurpose one piece of content across platforms**. The cover generation pipeline means a single deck's thesis can become a WeChat banner, a 1:1 share card, a Xiaohongshu 3:4 image, and a horizontal video cover without re-prompting from scratch.

Third, **agents and developers building presentation tooling**. Because the output is one portable HTML file, decks fit naturally into automated pipelines — generate, screenshot, attach to a report, or ship to a client. It's also available outside Claude Code/Codex via 360 Security Lobster, Cola Skill, and Kimi work.

Skip it if you need dense data tables, high-information training courseware, or collaborative multi-editor editing — the README is honest that single-file static HTML is not the right fit for those. It's AGPL-3.0 licensed.

## Bottom Line

Guizang PPT Skill is the most polished HTML-deck skill in the agent ecosystem: two complete design systems, 22 locked Swiss layouts, multi-platform cover generation, and a full presenter/rehearsal suite — all delivered as a single portable HTML file with no build step. If you present with AI agents, it turns "turn this article into a deck" from a coin-flip into a reliable workflow. For related agent tooling, see the [single-slide-ppt skill](/skills/coding/single-slide-ppt/) for minimal decks, the [HTML Anything skill](/skills/writing/html-anything/) for HTML generation from natural language, or the same author's [humanizer-zh skill](/skills/general/humanizer-zh/) for AI-text rewriting.
