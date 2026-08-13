---
title: "Guizang Social Card Skill: Xiaohongshu & WeChat Covers"
date: 2026-08-13
draft: false
tags:
  - Social Cards
  - AI Image
  - AI Tools
description: "Guizang Social Card Skill turns articles into Xiaohongshu carousels, Live Photo motion cards, and WeChat 21:9+1:1 cover pairs with 28 layouts and 10 themes."
version: ""
author: "op7418"
repo_url: "https://github.com/op7418/guizang-social-card-skill"
install_cmd: "npx skills add https://github.com/op7418/guizang-social-card-skill --skill guizang-social-card-skill"
compatibility:
  - Claude Code
  - Codex
category: "image"
rating: 4.5
github_stars: 6303
github_forks: 511
installs: 0
last_updated: "2026-08-13"
ai_friendliness:
  score: 4.5
  documentation: 4.5
  setup: 4.0
  config: 4.0
---

Guizang Social Card Skill is a 6.3k-star agent skill that turns articles, screenshots, product notes, and user videos into **Xiaohongshu / Rednote carousels**, **Live Photo motion cards**, and **WeChat 21:9 + 1:1 cover pairs**. The [official README](https://github.com/op7418/guizang-social-card-skill) calls it the sister project of the author's [Guizang PPT Skill](/skills/image/guizang-ppt-skill/): shared visual language, separate maintenance. PPT handles horizontal swipe talks; this one handles static feed images.

## What It Is

The skill ships the same two design systems as its PPT sibling. **Editorial** draws on restrained magazine layouts — think *Monocle*, *Kinfolk*, *Cereal* — for storytelling, lifestyle, travel, and personal observation. **Swiss International** goes grid-first with a single anchor color, sharp hairlines, and extreme type contrast, built for product reviews, data, frameworks, and tool roundups. Both share one workflow, so a five-card set stays visually coherent from cover to last page.

Output is single-file HTML rendered to PNG with Playwright — `node render.mjs`, no bundler, no build chain, no server. Install it with `npx skills add https://github.com/op7418/guizang-social-card-skill --skill guizang-social-card-skill`, then ask for "a Swiss-style Xiaohongshu carousel from this article, 5 cards, IKB blue."

## What Makes It Different

Generic image tools give you pretty pictures and hope. This skill gives you a design grid.

The layout system alone is worth the install: 28 skeletons — 16 Editorial (`M01`–`M16`, including Image-Led Cover, Pipeline, Before/After) plus 12 Swiss (`S01`–`S12`, including KPI Tower, H-Bar Chart, Matrix + Hero) — and 10 theme presets. Editorial themes run from Ink Classic and Indigo Porcelain to a Midnight Ink dark mode; Swiss themes lock onto one of four anchor colors: IKB Klein Blue, Lemon, Lemon Green, Safety Orange.

Text-on-image gets treated as an engineering problem, not a styling afterthought. Full-bleed images pass through quiet-zone detection and subject mapping first, so copy dodges faces, products, and key actions; the skill adds localized tint only where needed, never a blanket full-canvas mask. A validator script then auto-checks four failure classes — overflow, type-cap violations, four-band density gaps, footer collisions — before you render.

Live Photo cards follow an information budget the README spells out. WeChat gets 3 seconds: one action point or one state change. Xiaohongshu gets 5 seconds: one compact process. Triple collages exist for three parallel results, not sequential stories. Real talk: I've seen people shove 30-second clips into these formats and wonder why the numbers tank. The most useful line in the repo is the rule to make the first frame work as a still card, then let 3–5 seconds of motion add evidence.

## Who It's For

Content teams repurposing one piece across platforms get the fastest win — the same article becomes a WeChat banner, a 1:1 share card, and a Xiaohongshu 3:4 set without re-prompting from scratch.

Indie creators on Chinese platforms are the core audience. The workflow handles platform quirks directly, including `.pvt` packaging so Live Photos actually publish from an iPhone — desktop and web paths generally can't.

Agent builders get a clean automation surface. Because output is single-file HTML, you can generate, validate, and screenshot cards in a pipeline without maintaining your own browser stack.

Skip it if you need true motion graphics or long-form video editing. Live Photo here means "user video inside a card layout," not a video editor. The project is AGPL-3.0 licensed.

## How It Compares

| | Guizang Social Card Skill | Guizang PPT Skill | Generic image tools |
|---|---|---|---|
| Output | Xiaohongshu carousels, WeChat cover pairs, Live Photo cards | Single-file HTML decks | Any image, no layout system |
| Layouts | 28 skeletons, 10 themes | 10 + 22 locked layouts | None |
| Validation | Built-in validator script | Checklist-driven | None |
| Platform rules | 3:4, 21:9, 1:1, 5s/3s motion | Presentation-focused | None |
| Stars (Aug 2026) | 6.3k | 23.4k | — |

Same author, same two visual systems, opposite deliverable: [Guizang PPT Skill](/skills/image/guizang-ppt-skill/) builds horizontal swipe decks, this one builds static feed cards. Both beat generic image tools because neither leaves layout to chance.

## Bottom Line

Guizang Social Card Skill closes the gap between finished copy and platform-ready cards — 28 layout skeletons, 10 themes, a validator, and an honest motion budget, all delivered as one HTML file. If your agents already produce articles, this turns them into Xiaohongshu carousels and WeChat cover pairs in a single prompt. Pair it with the [HTML Anything skill](/skills/writing/html-anything/) for broader HTML generation, or grab the sister PPT skill when the deliverable is a talk, not a feed post.
