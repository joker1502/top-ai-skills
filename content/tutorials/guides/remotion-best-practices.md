---
title: "Writing Videos with React: A Guide to the Remotion Agent Skill"
date: 2026-06-03
toc: true
draft: true
tags:
  - Remotion
  - React
  - Video
  - Animation
  - Tutorial
description: "Remotion's official Agent Skill teaches your AI assistant to write video code with React — from animation and subtitles to 3D and transitions"
category: "guides"
rating: 5
related_skills:
  - agent-browser
---

## What Remotion Is

Remotion is a framework for creating videos programmatically with React. Every frame of the video is a render result of a React component. You use `useCurrentFrame()` to get the current frame number, `interpolate()` for animation easing, and standard web technologies — JSX, CSS, Canvas, SVG, WebGL — to build visuals. The output is an MP4 file.

48.8k GitHub Stars. Fireship's "This video was made with code" and GitHub Unwrapped were both built with Remotion.

## Why This Skill Matters

The short version: it stops your AI from writing Remotion code that doesn't work.

Remotion has enough quirks that AI will reliably break things without guidance. CSS transitions don't render correctly in video output. Tailwind animation classes are useless. Assets must live in `public/` and be referenced via `staticFile()`. These aren't things you can fix with a one-line system prompt — they're domain-specific rules that the skill encodes permanently.

The skill covers 30+ sub-topics beyond the basics: subtitles, sound effects, scene transitions, 3D via Three.js, GIF sync, transparent video, audio visualization, AI voiceover generation via ElevenLabs TTS, Google font loading, and more.

## Setup

```bash
npx skills add remotion-dev/skills@remotion-best-practices
```

One command. If you need a new Remotion project first:

```bash
npx create-video@latest --yes --blank --no-tailwind my-video
```

Open the project in Claude Code or Cursor. The skill activates automatically when a Remotion project is detected.

## How It Performs

I asked AI to write a "title fades in, subtitle appears after a delay" animation. Without the skill, it used CSS `transition` for the fade — which silently produces no animation in Remotion's renderer.

With the skill installed, the same prompt produced code using `useCurrentFrame()` + `interpolate()` + `Easing.bezier()`, with `<Sequence from={...}>` for the subtitle delay. Worked on the first render.

The skill's value isn't making AI write better code — it's preventing AI from writing code that fundamentally cannot work in Remotion's rendering pipeline.

## Things to Watch Out For

Remotion uses a custom license, not a standard open-source one. Free for personal projects, but commercial use requires a company license. Check the terms before using it in a commercial product.

The skill follows Remotion's release cycle — rules sync upstream. If a major version introduces new APIs, the skill will update accordingly. But if you're running an older Remotion version, some rules may reference APIs you don't have yet.

## Skill vs Manual Development

If you already know Remotion well, this skill adds little — you already internalized these rules. Its audience is React developers who are new to Remotion's specific constraints, or teams that need to prototype fast without reading docs.

The depth ceiling is also worth noting: 30+ sub-topic files cover breadth well, but each topic has limited depth. For complex 3D scenes or multi-track audio mixing, the skill gets you started, but fine-tuning still requires the official docs.

## What's Next

After installing, try asking your AI to "make a 30-second product launch countdown video" and see if it uses `<Sequence>` for timeline management, `interpolate()` for number animations, and `<Audio>` for background music. Pair it with find-skills to discover more video-related skills in the ecosystem.
