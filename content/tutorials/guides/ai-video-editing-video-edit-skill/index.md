---
title: "AI Video Editing With RunComfy: Testing the Video Edit Skill"
date: 2026-06-22
draft: false
toc: true
tags:
  - AI Video
  - Video Editing
  - RunComfy
  - Video Edit
  - Agentspace
description: "I spent a weekend editing product videos with the Video Edit AI skill on RunComfy. The good, the bad, and where Wan 2.7 beat Kling."
category: guides
related_skills:
  - video-edit
---

## Why I Went Down This Rabbit Hole

The project was simple on paper: take a dozen product demo clips — each five to eight seconds of someone holding a package, talking to camera, or showing it from different angles — and give them a consistent look. A unified background, matching color grade, clean audio. A video editor quoted two days and twelve hundred dollars. I figured AI could do it in an afternoon.

I had tried AI video tools before. Runway ML, Pika, a few others. They were good at generating video from scratch — surreal landscapes, dancing skeletons, morphing transitions. But editing existing footage was a different game.

Background swaps drifted after a few frames. Face consistency fell apart past three seconds. The tools I tried wanted me to start from nothing, not reshape what I already had.

That is when I found the [Video Edit skill page](/skills/image/video-edit/) on skills.sh. It claimed to route video editing requests to three different models depending on what you needed — Wan 2.7 for restyle and background swap, Kling for motion transfer, Lucy for lightweight outfit and scene changes. One skill, three models, one CLI command. I installed it on a Thursday night.

## Setup: How Long It Actually Took

Installation was straightforward but not instant. The skill itself took one command:

```bash
npx skills add agentspace-so/runcomfy-skills --skill video-edit -g
```

But the skill is a router, not the engine. The actual work happens through RunComfy's CLI and API, which required two more steps.

```bash
npm i -g @runcomfy/cli
runcomfy login
```

The login step opens a browser window to authenticate. That worked fine on my desktop but would be a blocker in a headless environment — you would need `RUNCOMFY_TOKEN` set as an environment variable instead.

Total time from first command to running a test: about 12 minutes. Six of those were reading the model routing table in the skill's SKILL.md to understand which model to pick for what job.

## What I Built With It

My test was a single product clip: a six-second shot of someone holding a skincare bottle, talking to camera, with a generic beige wall behind them. I wanted three things — swap the background to a clean white studio, keep the face and lip movement intact, and preserve the original audio.

I started with Lucy Edit Restyle because it sounded like the lightweight option. First attempt was a miss — the background change was incomplete, with a visible edge around the subject's shoulders where the original beige bled through. I tried again with a sharper prompt: "Change background to clean white studio; preserve face and motion." Better, but a faint color halo remained.

Switched to Wan 2.7 Edit-Video, which the skill doc marks as the default for restyle work.

```bash
runcomfy run wan-ai/wan-2-7/edit-video \
  --input '{
    "prompt": "Preserve the speakers face, pose, and lip movement; change the background to a clean white studio with soft lighting.",
    "video": "https://.../product-clip.mp4",
    "audio_setting": "origin"
  }' \
  --output-dir ./output
```

This took about 90 seconds. The result was clean. Background was solid white, the speaker's face stayed consistent, lip movement matched the audio, and the audio track carried through without degradation.

I ran the remaining clips through the same command, adjusting prompts for each (different source lighting, different framing). Eight came out well on the first pass. Three needed a second attempt with adjusted prompts — usually more preservation keywords upfront. One clip, where the speaker turned their head sideways, never quite worked.

Wan 2.7 kept introducing a flicker on the cheek during the turn.

That was the failure. I could not fix the head-turn flicker with prompt tweaks alone. The skill does not expose per-frame controls or masking. I ended up cutting that clip from the final set and replacing it with a different angle.

## What Surprised Me

The model routing worked better than expected. I did not have to read three different API docs. I did not have to learn the quirks of Wan versus Kling versus Lucy before starting. The skill's intent-to-model table was clear, and the prompt format stayed consistent across routes — describe the edit, state preservation goals, run.

Audio preservation was the biggest win. Most AI video tools I have used regenerate or drop the audio track when editing. Wan 2.7 Edit-Video with `audio_setting: "origin"` kept the original audio untouched. For talking-head clips, that is the difference between useful and unusable.

Speed also surprised me — 90 seconds for a six-second 1080p clip. That is not real-time, but it beats shipping clips to a human editor and waiting for a revision cycle.

## Things That Annoyed Me

Three things.

First, the source video constraints. Each clip must be two to ten seconds and under 100MB. That covers a lot of use cases, but three of my clips were nine to ten seconds, and I had to trim them before the API would accept them.

The skill does no pre-processing. When your video exceeds the limit, the API returns a generic 400 error, and you have to infer the constraint yourself.

Second, prompt sensitivity. Wan 2.7 preserves identity well when you lead with preservation keywords, but the order matters more than I expected. "Preserve the speakers face and pose; change the background to white" worked. "Change the background to white while preserving the face and pose" produced a flicker on the first frame. I reproduced this three times to confirm.  

Third, no multi-route blending. The skill picks one model per call. I wanted to use Wan 2.7 for background swap and then Kling for motion stabilization on the same clip — not possible through this skill. You would need to run two separate skills and stitch the output yourself, which defeats the purpose of a single CLI interface.

## When I Use It vs When I Don't

I use Video Edit when I have a batch of short talking-head or product clips that need a consistent visual treatment — background swap, color restyle, or packaging replacement. It saves me from opening Premiere or DaVinci Resolve for what should be a one-command job.

I do not use it when I need precise masking, multi-layer edits, or any work on clips longer than ten seconds. The skill is built for speed and consistency within a narrow set of edit types. If your video needs frame-level control or runs past a few seconds, a traditional editor or a dedicated video model API with full parameter access is still the right call.

The sweet spot is exactly what I needed last week: five to ten second clips, one edit direction per clip, the same treatment across a batch. For that, Video Edit saved me a weekend and whatever a human editor would have charged for the second pass.
