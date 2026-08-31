---
title: "HyperFrames Domain Skills Roundup: Which of the 5 Do You Need"
date: 2026-08-31
toc: true
draft: false
tags:
  - Video Generation
  - Agent Skills
  - AI Tools
category: "guides"
description: "HyperFrames domain skills roundup: core, creative, keyframes, animation, audio read from their SKILL.md files. Curves reveal audio as a 3-week-old newcomer."
keywords:
  - hyperframes-core
  - hyperframes-creative
  - hyperframes-keyframes
  - hyperframes-animation
  - hyperframes-audio
---

HyperFrames ships five domain skills and the naming lies: hyperframes-creative contains no animation code, hyperframes-keyframes owns almost no scene strategy, and hyperframes-audio — the one with the steepest install curve — did not exist three weeks ago. I read all five SKILL.md files in [heygen-com/hyperframes](https://github.com/heygen-com/hyperframes) (43,150 stars, Apache-2.0) and pulled fresh install numbers off skills.sh on 2026-08-31. The boundaries between the skills turned out to be the real content, and the curves backed up the file sizes.

## The Five Skills and the Line Between Them

The pack splits by concern, not by name. **hyperframes-core** is the technical contract: the `data-*` timing attributes, `class="clip"`, sub-composition templates, the single paused `gsap.timeline` registered at `window.__timelines[compositionId]`, determinism bans, and a 14-row reference index. It is the only skill you must read before writing composition HTML. **hyperframes-creative** is the brand layer — design-spec handling (`frame.md` → `design.md` → `DESIGN.md` precedence), palettes, typography, narration pacing, beat planning, audio-reactive visuals — and its frontmatter says it outright: "intentionally non-animation."

The split matters because the two motion skills collide. **hyperframes-keyframes** covers visual camera work: punch-in/out, Ken Burns pans, reframes, whip handoffs, masks, SVG morphs, and 2D/3D keyframes, framed as a "pose contract" with a mechanism-choice table (FLIP for box changes, path travel for routes, stroke draw for traces). **hyperframes-animation** holds everything else about motion: atomic rules, multi-phase scene blueprints, transitions, 24 named text effects, and seven runtime adapters — GSAP default, plus Lottie, Three.js, Anime.js, CSS keyframes, WAAPI, and TypeGPU/WebGPU. Their shared boundary rule: keyframes only animates visible handoff on wrappers inside clips, and never touches clip timing or source ranges — that is core's `data-start`/`data-duration`/`data-media-start` domain.

## The File Sizes Predict the Newcomer

Size order inside the pack: hyperframes-audio 24,734 bytes, hyperframes-keyframes 15,901, hyperframes-core 13,066, hyperframes-animation 7,785, hyperframes-creative 6,354. The largest is the youngest. My skills.sh scrape shows audio at 89,089 lifetime installs with a weekly series of five straight zeros — [0, 0, 0, 0, 0, 17,702, 36,501, 32,178] — meaning it hit the registry roughly three weeks ago and jumped from nothing to mid-30K weekly installs. Every other domain skill traces the pack's lockstep shape instead: core, creative, keyframes, and animation all peaked near 43-44K weekly in the same week and drifted to the 25-33K band since, totals running 250K-348K. Audio is the exception that confirms the pattern — a genuinely new skill grows alone, an established pack member just counts along.

## Why Audio Is Worth a Deeper Look

The size is not padding. hyperframes-audio reads like a mixing console spec: a mix is "a set of relationships, not a stack of processors," and every tool exists to express one relationship. Effects live on the element as `data-fx-chain`; envelopes ride `data-automation`; a voiceover carve keeps its own `data-fx-carve` settings so you can re-derive the ducking instead of guessing filters. Twelve effect families ship (gain, EQ, compressor, limiter, gate, saturation, delay, reverb, chorus, phaser, bitcrush), and — the detail that sold me — preview and render run the *same* Web Audio graph builder, one offline, one live, so "what you hear while scrubbing is what gets written. You never tune twice." A `<hf-audio-group>` bus carries a chain, a fader, and an automation clock across many tracks at once. The whole file reads like a manual for a tool that does not exist anywhere else.

## Rounding Out the Family

Two companion skills hold the tooling around the domain five. hyperframes-cli (461,670 installs, the top of the pack) documents `lint`, `check`, `snapshot`, `preview`, `render`, and the keyframe-proof flags — `--shot`, `--ghost`, `--layout strip` — while hyperframes-registry (403,886) manages reusable blocks versus components with a 24-hour TTL. The main `hyperframes` entry point (446,618) is the mandatory router: it resumes project state, runs a BRIEF/STORYBOARD intent layer, and owns the 10-workflow routing table we dissected in the [hyperframes-vs-remotion comparison](/tutorials/comparison/hyperframes-vs-remotion/) last week. If you are installing by hand, the honest shortlist is: core for anyone writing compositions, animation next for motion, keyframes when camera work appears, creative for brand-heavy deliverables, and audio — right now, before the pack curve absorbs it — for anything with narration over music.

## Where to Start

Do not install all five at once; the boundary rules do the routing for you. Start with `npx skills add https://github.com/heygen-com/hyperframes --skill hyperframes-core`, let the composition contract sink in, then add animation and keyframes when a scene actually needs motion. Audio you can grab today and watch its install curve climb for another week or two — the file is the strongest writing in the pack, and the 12-family effect chain has no equivalent in Remotion's toolkit. The summary, in one line: read core, route by boundary, and trust the newcomer with the biggest file.