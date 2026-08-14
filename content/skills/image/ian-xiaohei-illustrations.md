---
title: "ian-xiaohei-illustrations: Hand-Drawn Xiaohei Article Images"
date: 2026-08-14
draft: false
tags:
  - AI Image
  - Codex Skill
  - Illustration
description: "ian-xiaohei-illustrations turns Chinese articles into 16:9 hand-drawn Xiaohei images, guided by a shot-list workflow and strict white-background style DNA."
version: "1.0"
author: "helloianneo"
repo_url: "https://github.com/helloianneo/ian-xiaohei-illustrations"
install_cmd: "git clone https://github.com/helloianneo/ian-xiaohei-illustrations.git && cp -R ian-xiaohei-illustrations/ian-xiaohei-illustrations ${CODEX_HOME:-$HOME/.codex}/skills/"
compatibility:
  - Codex
category: "image"
rating: 4.5
github_stars: 9440
github_forks: 1183
installs: 0
last_updated: "2026-08-14"
ai_friendliness:
  score: 4.5
  documentation: 4.5
  setup: 4.0
  config: 4.0
---

ian-xiaohei-illustrations is a 9.4k-star Codex skill that turns Chinese articles into **16:9 hand-drawn explainer images** starring "Xiaohei" — a solid-black character with white dot eyes, thin legs, and a blank expression. The [official README](https://github.com/helloianneo/ian-xiaohei-illustrations) frames it precisely: not commercial illustration, not PPT infographic, not cute mascot — one memorable drawing per cognitive anchor in your article, on pure white, with a few red-orange-blue Chinese annotations.

## What It Is

The skill exists to answer one question the author Ian kept hitting in his one-person-company workflow: how do you illustrate a method article without a designer and without generic stock art? His answer is a repeatable pipeline — read the article, extract the judgment/process/state/metaphor worth drawing, and render it as a hand-drawn 16:9 image where Xiaohei performs the core action.

It runs as a Codex skill, not a Claude Code one. Install is a plain folder copy: clone the repo and drop the inner `ian-xiaohei-illustrations/` directory into `${CODEX_HOME:-$HOME/.codex}/skills/`. Then invoke it with `Use $ian-xiaohei-illustrations` followed by your article, or a single concept like "turn 'trust isn't declared, it's laid brick by brick' into an image."

## What Makes It Different

Three rules inside the workflow separate it from generic "make me an illustration" prompts.

**The shot list comes first.** The skill refuses to generate blind. It analyzes your article for cognitive anchors — core judgments, two breakpoints, input-output loops, before/after states, handoff paths — then outputs a shot list of 4-8 images, each specifying placement, theme, structure type, what Xiaohei does, and suggested Chinese annotation words. Only after you approve the plan does it generate, one image per call. Long articles cap at 9 images; a short note gets 1-3. It will not turn your post into a picture book.

**Structure types are explicit.** Each image picks from a fixed vocabulary: workflow, system fragment, before/after, character state, conceptual metaphor, method layering, map route, or comic panel. The skill then reinvents a low-tech, slightly absurd but coherent physical metaphor for that structure — a fishing net for "one input, many uses," a bridge for handoff paths. It deliberately avoids copying composition from its own example images.

**Xiaohei must carry the action.** The QA checklist includes a brutal test: if you remove Xiaohei and the image still works, Xiaohei is decoration — regenerate. The character isn't a mascot standing in the corner; it's a small absurdist worker actually doing the thing the article describes.

## Who It's For

Chinese-language content teams producing method articles, workflow docs, Notion pages, or WeChat posts get the fastest win — the skill assumes Chinese text, and its annotation system is built for short Chinese labels (the README warns: shorter text renders more reliably in image models).

Indie creators and one-person businesses match the original use case: Ian built it for his own article pipeline, so the workflow favors speed and consistency over art-directing every frame.

Skip it if you need commercial illustration, editable vector sources, complex architecture diagrams, or anything not on a white background. The style DNA is strict — no paper texture, no beige, no gradients, no shadows, no text-heavy infographics.

## How It Compares

| | ian-xiaohei-illustrations | Generic image prompts | PPT infographic skills |
|---|---|---|---|
| Output | 16:9 hand-drawn explainer, one concept per image | Any image, no system | Slide decks, not inline images |
| Workflow | Shot list → approve → generate → QA checklist | Prompt → image | Layout templates |
| Style control | Fixed DNA + QA rules | None | Grid-based |
| Character | Xiaohei, required in core action | Optional | None |
| Language | Chinese annotations | Any | Any |
| Stars (Aug 2026) | 9.4k | — | — |

The closest sibling in the same ecosystem is [Guizang PPT Skill](/skills/image/guizang-ppt-skill/): where that one builds structured decks for talks, this one draws single conceptual images for article bodies. Both sit above raw image generators because neither leaves composition to chance.

## Bottom Line

ian-xiaohei-illustrations solves a real publishing gap: consistent, memorable, on-brand inline images for Chinese method content, produced by an agent instead of a designer. The shot-list-first workflow is the part worth copying even if you never install it — plan the cognitive anchors before generating, and every image earns its place. If your articles run on Chinese-language platforms like WeChat or Xiaohongshu, this is the fastest path from finished copy to finished visuals. For decks rather than article images, check the sister [Guizang PPT Skill](/skills/image/guizang-ppt-skill/), or browse the full [skills directory](/skills/) for more image-generation options.
