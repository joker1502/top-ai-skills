---
title: "How to Generate AI Videos from the Command Line: A Step-by-Step Guide"
date: 2026-07-19
toc: true
draft: false
tags:
  - AI Video
  - Video Generation
  - CLI
  - Terminal
  - Belt CLI
  - Text-to-Video
description: "Learn how to generate AI videos directly from your terminal using the belt CLI and inference.sh — supports 40+ models including Sora, Veo, and Kling."
category: "guides"
---

You want AI-generated video without bouncing between browser tabs and credit systems — but every tool has its own UI, signup flow, and output format.

## Why the CLI Beats Web UIs for Video Generation

Most AI video tools are designed as standalone web apps. You log in, type a prompt, wait for the render, and download the result. For a single video, that's fine. For batch work — generating B-roll for a tutorial, testing prompts across models, or integrating video output into an automation pipeline — browser-based workflows fall apart fast.

The problem is structural: web UIs are built for human use, not scripted workflows. You can't easily combine Sora's visual quality with Kling's speed in one session because they're on separate platforms with separate APIs, credit systems, and export flows.

The belt CLI fixes this by giving you a unified command-line interface to 40+ video generation models from a single terminal session.

## What You Need Before Starting

- **Claude Code** (or any skills-compatible agent) with the `ai-video-generation` skill installed — or you can use the `belt` CLI directly
- An [inference.sh](https://inference.sh) account and API key
- A clear idea of what you want to generate (or at least a prompt to experiment with)

To install the skill:

```bash
npx skills add https://github.com/101-skills/skills --skill ai-video-generation
```

Then authenticate with inference.sh:

```bash
belt login
```

## Step 1: Generate Your First Video

The simplest command generates a video straight from a text prompt:

```bash
belt app run google/veo-3-1-fast --input '{"prompt": "drone shot flying over a misty forest at dawn"}'
```

This runs Google's Veo 3.1 Fast model. The `--input` flag takes a JSON object with the prompt. The CLI submits the job, polls for completion, and downloads the result when done.

A few things to watch for:

- **Keep prompts concise.** The best results come from 10-15 word descriptions focused on camera movement, subject, lighting, and mood. "Cinematic drone shot, misty pine forest, golden sunrise, 4K" beats a paragraph.
- **The first generation is the slowest.** Model startup adds a minute or two. Subsequent runs are faster.
- **Output goes to the current directory** unless you specify a path with `--output-dir`.

## Step 2: Compare Models Without Leaving the Terminal

The real power of the CLI shows when you run the same prompt across multiple models in parallel:

```bash
# Open a second terminal or use background processes
belt app run kuaishou/kling-3-0 --input '{"prompt": "drone shot flying over a misty forest at dawn"}' &
belt app run openai/sora --input '{"prompt": "drone shot flying over a misty forest at dawn"}' &
```

Each model returns a video with different characteristics:

| Model | Strengths | Best For |
|-------|-----------|----------|
| Google Veo 3.1 Fast | Quick renders, natural motion | Prototyping, quick tests |
| Kling 3.0 | Best quality-to-speed ratio, affordable | Production shots, social media |
| Sora | Highest visual fidelity, cinematic | Premium content, client work |

You don't need to sign up for each service separately — inference.sh handles the API routing and billing through one account.

## Step 3: Chain Image-to-Video for Better Results

Text-to-video is impressive but unpredictable. Image-to-video gives you much more control. The workflow is: generate a keyframe image (with Midjourney, DALL-E, or any image tool), then animate it:

```bash
belt app run kuaishou/kling-3-0 --input '{
  "prompt": "the lighthouse keeper walks along the cliff edge",
  "image_url": "https://example.com/keyframe.png"
}'
```

This approach gives you:

- **Controlled composition.** You decide the framing, subject, and lighting in the still image first
- **Consistent characters.** The same reference image across multiple clips keeps the subject recognizable
- **Faster iteration.** Fix the composition once, then try different motion prompts against the same base

For multi-shot sequences, create 4-5 keyframes, animate each one with the same character prompt, and stitch them in any video editor. The consistency won't be perfect — character AI video is still an unsolved problem — but image-to-video gives you the most predictable output.

## Belt CLI vs Traditional Web UIs

| Aspect | Belt CLI (This Skill) | Web UIs (Sora, Kling, etc.) |
|--------|----------------------|------------------------------|
| Setup | One-time install + login | Signup per platform |
| Model access | 40+ models, one interface | One model per platform |
| Batch workflow | Native (bash loops, chaining) | Manual per video |
| Cost control | Single inference.sh billing | Separate credits per platform |
| Learning curve | Terminal familiarity required | Browser-based, lower barrier |
| Output format | Direct file download | Varies by platform |

The CLI wins on throughput and automation. Web UIs win on visual preview and ease of use for non-technical users.

## Common Mistakes and How to Avoid Them

**Not checking model availability.** Some models are region-locked or have queue limits. Run `belt app list` before starting to see what's available on your account tier.

**Forgetting the JSON wrapper.** The `--input` flag expects valid JSON. A missing quote or bracket will fail silently. Test your JSON with `echo '{"prompt": "test"}' | python3 -m json.tool` before passing it.

**Overwriting output files.** The CLI names files by model + timestamp, but if you run the same model with the same prompt fast enough, you can hit a race condition. Always use `--output-dir` for batch jobs.

**Expecting perfect results on the first try.** AI video is probabilistic — run each prompt 3-5 times and pick the best clip. The CLI makes this easy with a bash `for` loop.

## Start Generating Today

The ai-video-generation skill turns your terminal into a video production studio with access to 40+ models. One install, one login, and you're generating clips alongside your code.

Quick start cheatsheet:

```bash
# Install
npx skills add https://github.com/101-skills/skills --skill ai-video-generation
# Login
belt login
# Generate a video
belt app run google/veo-3-1-fast --input '{"prompt": "your prompt here"}'
# List available models
belt app list
```

For a comparison of all major AI video generators, check our [AI Video Generator Comparison Guide](/tutorials/comparison/ai-video-generator-comparison-2026/). If you're new to AI video entirely, start with the [AI Video Generation FAQ](/tutorials/guides/ai-video-generation-faq-2026/) for the basics first.
