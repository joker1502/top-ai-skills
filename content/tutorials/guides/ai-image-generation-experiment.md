---
title: "I Generated 100 AI Images From My Coding Assistant"
date: 2026-06-20
draft: false
toc: true
tags:
  - AI Image
  - Image Generation
  - FLUX
  - Gemini
  - Narrative
description: "I tried generating AI images directly inside Claude Code using the ai-image-generation skill. 50 models, one terminal, and a few surprises along the way."
related_skills:
  - ai-image-generation
  - gpt-image-2
  - kling-3-0
---

## Why I Went Down This Rabbit Hole

Thursday afternoon, 3 PM. I was building a landing page for a side project and needed a hero image. Not a placeholder — something that actually looked like the product. My usual workflow is: write a prompt in ChatGPT, download the image, drag it into the project folder. Then tweak the prompt, repeat. Every iteration costs a context switch.

I remembered the [ai-image-generation](/skills/image/ai-image-generation/) skill sitting in my installed list from when I first set up inference.sh. I had never actually used it. The idea of generating images without leaving the terminal seemed convenient in theory, but I was skeptical about output quality compared to Midjourney or the ChatGPT web interface.

One `belt app run` later, I was 100 images deep into an afternoon I did not plan to spend this way.

## Setup: How Long It Actually Took

Installing the skill took 12 seconds. Actually using it took longer because I had to figure out the belt CLI.

The install command is straightforward — `npx skills add inference-sh/skills` adds the whole inference.sh ecosystem, which includes not just image generation but video, LLM calls, and web search. If you only want image generation, there are granular installs for individual models (`npx skills add inference-sh/skills@flux-image`, etc.), but I went with the full set.

The real setup step is `belt login`. Inference.sh uses its own CLI layer called belt, which handles authentication and API routing. Without a belt account, nothing works. Signup requires an email and a credit card — image generation on inference.sh is not free. Models are priced per call, ranging from $0.0001 (FLUX Klein 4B) to around $0.05 (GPT-Image-2 high quality). I spent about $4 across 100 generations.

What tripped me up: the skill injects itself as a bash tool into Claude Code, but not every model works the same way. Some require specific JSON schemas in the `--input` flag, and the error messages when you get it wrong are generic (`Error: Bad Request` with no details on which field broke).

## What I Built With It

I was trying to generate a hero image for a SaaS landing page — a dashboard mockup with data visualizations in a specific color palette. First five generations were useless. FLUX Dev LoRA on default settings produced decent abstract art but couldn't render readable text or realistic UI elements.

I pivoted to [GPT-Image-2](/skills/image/gpt-image-2/), which handles text rendering better. The first pass gave me a blurry dashboard with nonsensical numbers. I added an `aspect_ratio: "16:9"` param and bumped quality to high. Better framing, still fake-looking charts.

The breakthrough came with **Reve**. This model is specifically designed for natural language editing with text rendering. I ran:

```
belt app run falai/reve --input '{
  "prompt": "A modern SaaS analytics dashboard with charts and data tables, blue and white theme, professional lighting, text that reads Monthly Revenue and User Growth"
}'
```

The output was usable. Not perfect — Reve still hallucinated chart data — but the layout, colors, and general composition worked as a background image behind the fold. I ended up using it as a blurred hero background, which neatly hid the hallucinated numbers while keeping the visual impact.

Later I tried Seedream 4.5 for a product shot of the same app displayed on a laptop. Seedream's 2K-4K output is genuinely impressive. The laptop screen showed a reasonable facsimile of a dashboard, and the lighting on the keyboard and desk looked photographic. That one went straight into the marketing page.

## What Surprised Me

**FLUX Klein 4B is stupidly cheap.** At $0.0001 per image, I generated 50 variations for five cents. The quality is noticeably lower than FLUX Dev or GPT-Image-2 — softer details, occasional anatomy errors — but for iteration and ideation, the cost is effectively zero. I started generating 10 variations of each prompt and cherry-picking, which I would never do with paid-per-call models.

**Model selection matters more than prompt engineering.** A prompt that produces garbage on FLUX Dev might look great on Seedream, and vice versa. The skill gives you access to 50+ models, and the biggest quality gain comes from knowing which model to use for which job, not from perfecting your prompt.

**The skill works differently in different coding assistants.** In Claude Code, the skill calls bash commands directly. In Cursor, it works the same way. But the experience varies because each assistant handles tool output differently — Claude Code displays the image URL returned by belt, which you then open in a browser. There's no inline image preview in the terminal.

## Things That Annoyed Me

**No inline preview.** The skill returns a URL to the generated image on inference.sh's CDN. You have to click the link or paste it into a browser. This breaks flow state. I ended up keeping a browser tab open at inference.sh's app dashboard just to see results, which defeats some of the convenience of keeping everything in the terminal.

**Error handling is barebones.** Wrong JSON key in the input? `Error: Bad Request`. Missing required field? Same error. The skill provides no validation before sending the request, and the belt CLI's error messages don't tell you which parameter caused the problem. I spent 20 minutes debugging a prompt that had a trailing comma in the JSON.

**Not every model listed actually works.** The SKILL.md lists over 15 models, but a few returned `404 App Not Found` errors when I tried them. The inference.sh app store has the definitive list, but the skill documentation doesn't auto-sync.

## When I Use It vs When I Don't

I use the ai-image-generation skill now when I need quick visual assets during coding — hero images, placeholder graphics, concept art for game projects, social media cards. The iteration speed of generate, see, tweak, regenerate in the same conversation is genuinely faster than any multi-tab workflow I have used.

I don't use it when I need production-quality images with specific text, complex compositions, or brand-consistent output. Midjourney or DALL-E through their native interfaces still win for polish and control. The skill is a prototyping tool with occasional production-ready output from specific models like Seedream 4.5 and GPT-Image-2.

The real win is the 50-model buffet. When one model fails, the next might deliver exactly what I need — all from the same install.
