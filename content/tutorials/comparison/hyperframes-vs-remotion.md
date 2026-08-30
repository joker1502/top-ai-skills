---
title: "HyperFrames vs Remotion: HTML Video vs React Video in 2026"
date: 2026-08-30
toc: true
draft: false
tags:
  - Video Generation
  - Agent Skills
  - AI Tools
category: "comparison"
description: "HyperFrames renders HTML video via a 10-workflow skill router; Remotion renders React. Audits cover seek-driven motion, graded migration, 457K installs."
---

Both frameworks render video from web pages: open a real browser, draw each frame, encode the result. The difference is what you write, and it runs deeper than the marketing admits. I read three SKILL.md files from [heygen-com/hyperframes](https://github.com/heygen-com/hyperframes) (43,150 stars, Apache-2.0), the official hyperframes-vs-remotion guide, and the remotion-to-hyperframes migration skill. Then I pulled install curves for both ecosystems off skills.sh on 2026-08-30. The leaderboard numbers surprised me more than the code did.

## What You Write: One HTML File vs One React Component

Remotion asks for a React component that is a pure function of the frame number. `useCurrentFrame()` and `interpolate()` do the timing math in frames; a `<Composition>` entry registers the render. Deterministic by construction — same frame, same output, every time.

HyperFrames asks for an HTML file where the DOM declares timing with `data-*` attributes and a paused GSAP timeline declares motion, registered on `window.__timelines` under the composition's id. The official guide shows the same three-second title card both ways, and its three render rules are worth memorizing: every visible slot carries `class="clip"` with an `id`, `data-start`, `data-duration`, and `data-track-index`; the timeline is created paused; it registers under the same id as the root element. Miss the registration and you get a still frame with no motion. The renderer doesn't watch a clock — it pauses your animation and seeks it to an exact moment before capturing, which is why GSAP runs, Web Animations, and Lottie all render deterministically instead of racing.

## The Skill Layer Is the Real Difference

Remotion the framework ships one agent skill from its org, remotion-best-practices — 501,865 installs, with weekly reports drifting between roughly 10K and 13K. HeyGen ships a whole toolbox. The leaderboard lists three installable entries from the same repo, and here's the finding: hyperframes (442,881 installs), hyperframes-cli (457,873), and hyperframes-registry (400,642) all trace nearly identical eight-week curves, spiking near 49K in one week and settling into the low 30s. The three entries are one install wave wearing three labels, so don't rank them by counts — the split is about jobs.

**hyperframes** is the mandatory entry point: a state table that matches your project state (a `BRIEF.md` exists, a `hyperframes.json` exists, or fresh creation) to an action, then routes fresh work across ten workflows — slideshow, embedded-captions, talking-head-recut, music-to-video, motion-graphics, pr-to-video, product-launch-video, faceless-explainer, general-video, and remotion porting. The intent interview ends by writing `BRIEF.md`, which the skill calls "the only routing artifact the workflow reads."

**hyperframes-cli** owns the dev loop: `init`, `lint`, `check`, `snapshot`, `preview`, `render`, `publish`. `check` runs lint first, then one browser session with one seek pass audits runtime errors, layout, and WCAG contrast. The catalog search is local-only with two tiers — a vocabulary ranker by default, and a meaning ranker after a consented 33 MB ONNX model download (`bge-small-en-v1.5`) — and both are English-only, so query in English even when the video is Japanese or Chinese. Renders cover draft/high local, Docker, batches, HeyGen cloud, AWS Lambda, and Google Cloud Run.

**hyperframes-registry** manages blocks and components — standalone sub-compositions installed via `hyperframes add <name>` and wired with `data-composition-src`, versus snippet files pasted straight into your HTML. Registry items are tagged snapshots; the manifest carries a 24-hour TTL and heals itself.

Remotion counters with a mature ecosystem of templates and answered questions, which the official guide concedes plainly, alongside the honest note that Remotion Lambda is the more battle-tested render farm. The license asymmetry matters too: HyperFrames ships Apache-2.0, whole teams included; Remotion stays free only for individuals and companies of three or fewer.

## The Migration Skill Grades Its Own Work

The `remotion-to-hyperframes` skill is the sharpest argument HeyGen has. It claims roughly 80% of a typical composition translates mechanically and encodes the lossy remainder instead of hand-waving: `lint_source.py` flags `useState`, `useReducer`, `useEffect` with non-empty deps, async `calculateMetadata`, and third-party React UI libraries as blockers it refuses to translate, pointing at the runtime-interop pattern from PR #214 instead. `@remotion/lambda` config gets dropped as a warning, not a blocker.

It also ships a graded test corpus — T1 through T4 fixtures with validated SSIM baselines of 0.974, 0.985, and 0.953 against thresholds of 0.95, 0.95, and 0.90. One pitfall buried in the eval docs cost me a double-take: both renders need matching pixel formats, `png` plus `bt709` color space, or the diff measures encoder differences — a ~0.05 SSIM hit that looks like a bad translation when the translation was fine. The skill renders both versions, compares frame by frame, and writes `TRANSLATION_NOTES.md` for anything it dropped. Migration is strictly one-way; exporting back to Remotion is not a workflow.

## Which One to Reach For

| | HyperFrames | Remotion |
|:--|:-----------|:---------|
| What you write | HTML + CSS + paused GSAP timeline | React + TypeScript, pure function of frame |
| Motion timing | Renderer seeks a paused timeline | Code reads the frame number |
| Existing web material | HTML/CSS animations drop in close to as-is | Rewritten as React components |
| Agent story | Router skill + 10 workflows + 3 leaderboard entries | One established best-practices skill |
| Render paths | Local, Docker, HeyGen cloud, Lambda, Cloud Run | Local, Lambda (mature) |
| License | Apache-2.0 | Free ≤3 people, paid above |

Real talk — the frameworks converge where it counts, and your existing codebase decides the winner. A team already writing React gets typed compositions and its design system for free from Remotion, and its docs are dramatically deeper. Anyone with HTML, GSAP, or Lottie work sitting around, or with an agent doing the authoring, gets closer to done with HyperFrames — the skills exist precisely because an agent needs written rules, and the [remotion-best-practices intro](/skills/coding/remotion-best-practices/) covers what the older framework's own skill demands. My honest setup: keep authoring in whatever your team writes today, and treat hyperframes-registry as the low-risk experiment — install the [router skill](https://github.com/heygen-com/hyperframes) first and port one title card before you bet a campaign on either framework. The migration skill will tell you, in SSIM, whether the port actually held.