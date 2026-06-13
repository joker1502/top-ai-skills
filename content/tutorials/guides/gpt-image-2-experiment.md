---
title: "I Generated Marketing Assets With GPT Image 2 Inside Claude Code"
date: 2026-06-13
draft: false
tags:
  - Image Generation
  - RunComfy
  - Marketing
  - Claude Code
description: "GPT Image 2 inside Claude Code for product shots, multilingual labels, ad creatives. What worked, what broke, when I went back to the web UI."
toc: true
category: "guides"
related_skills:
  - gpt-image-2
---

## Why I Went Down This Rabbit Hole

Last Tuesday I was switching between four tabs: Claude Code, Canva, ChatGPT, and a product photo reference board. I was mocking up a landing page for a client — a premium water bottle brand — and every image revision meant exporting from ChatGPT, dragging into the right folder, then asking Claude to reference it. The context-switch tax felt absurd. Here I was using an AI coding assistant, and image generation still lived outside the chat window.

I remembered gpt-image-2 from the skills.sh leaderboard. The skill documentation said it pipes OpenAI's GPT Image 2 model through a RunComfy CLI into your coding assistant. Generate and edit images, no tabbing out. I installed it within a minute.

## Setup: How Long It Actually Took

Three commands, about five minutes total:

```bash
npm i -g @runcomfy/cli
runcomfy login
npx skills add agentspace-so/runcomfy-agent-skills --skill gpt-image-2 -g
```

The `runcomfy login` step opens a browser device-code flow — straightforward, no API key hunting. The skill became available inside Claude Code immediately after the last command.

The first generation failed. Not a crash — the image came out looking like a mid-2010s stock photo. Overexposed, generic, wrong aspect ratio. I had written "product photo of a water bottle" as the prompt. The model returned something that could have been any bottle on any shelf. No embedded text where I wanted it, no brand feel.

The fix was rewriting the prompt with specific product-photography cues: lighting direction, surface texture, font specification, and the exact text to render. GPT Image 2 is sensitive to how you phrase things. Vague in, vague out.

## What I Built With It

The project was a full product asset set for a fictional premium water brand called AQUA+. I needed four things: a hero product shot for the landing page, a multilingual label mockup (English and Japanese), an ad creative with headline embedded in the image, and a social media variant in 9:16.

The hero shot worked on the third try. I settled on a prompt that specified "matte ceramic bottle on warm linen, soft window light, the word AQUA+ in clean sans-serif on the label, shallow depth of field." The model rendered the bottle with readable text on the first label attempt — something I've had to Photoshop into DALL-E outputs before.

The multilingual label was the project's failure point. I asked for the same label with both English "AQUA+" and Japanese "アクアプラス" on it. The first attempt rendered gibberish for the Japanese characters — close-looking kanji that meant nothing. I rewrote the prompt to specify "Japanese katakana, accurate characters only" and split the text specification between the two scripts. The second attempt had correct katakana but placed them overlapping the brand mark. Third try: I described the layout spatially: "English on the left side, Japanese on the right side, equal size, sans-serif, clear contrast against the background." That produced a usable output.

This was the pivot moment. I realized GPT Image 2 can handle multilingual typography, but you have to be spatially explicit about where each script lives. It won't figure out a natural layout on its own when two scripts share the canvas.

The ad creative with embedded headline worked better than expected. I prompted for a "lifestyle shot, bottle in foreground, soft-focus background of someone hiking, headline at top reading HYDRATE BETTER in bold sans-serif." The model rendered the headline with correct typography and integrated it into the composition. No post-processing needed.

The 9:16 social variant was a simple size constraint change on the same prompt. That's where GPT Image 2's size limitation bit me — it only supports 1024x1024, 1024x1536, and 1536x1024. I wanted a phone-screen 9:16 but the nearest option was 1024x1536 (2:3 portrait), which left letterboxing room. I had to crop in post.

## What Surprised Me

The edit endpoint. I took the hero product shot and asked the model to "change the background to white studio, keep the bottle and label identical." It preserved the bottle's reflections, the label text, and even the subtle rim highlights — things I expected to regenerate differently each time. The composition held stable across five edit iterations where I only changed the background color. That's rare among image models.

The second surprise was prompt iteration speed. Because the skill lives inside Claude Code, I could discuss an output, adjust the prompt, and regenerate in the same conversation thread. The gap between "this doesn't look right" and the next image was about 20 seconds. Compared to ChatGPT where you wait through the interface reload, it felt fast.

## Things That Annoyed Me

The three-size limit is frustrating for anything that isn't a square or standard portrait. No 16:9 landscape, no ultrawide banner format. For hero images that meant working with 1536x1024 and cropping myself. For the social variant I had to letterbox. If GPT Image 2 is your primary generator, you will fight aspect ratios regularly.

The RunComfy CLI dependency also annoyed me. It's another thing to keep updated and another login flow. On a fresh machine I had to reinstall the CLI, re-login, and re-add the skill. Compared to skills that work entirely inside the agent (like [Grill Me](/skills/general/grill-me/) or to-prd which need zero infrastructure), gpt-image-2 has a heavier footprint. The CLI itself is stable — it's just another moving part.

## When I Use It vs When I Don't

I reach for GPT Image 2 inside Claude Code when I'm building a page or a mockup and need images that integrate with the code in the same session. The iteration speed inside the chat is the killer feature — describe, generate, evaluate, regenerate, all in one window. Great for: product hero shots, ad creatives with embedded text, UI mockup backgrounds, and any workflow where the image is one component of a larger coded output.

I don't use it for: exploratory moodboarding (I want a grid of diverse options fast, and Midjourney's style variety beats GPT Image 2's precision), high-volume social asset production (the size constraints add too much per-output friction), or any image that needs 16:9 or ultrawide framing. For those I tab out.

The honest summary: GPT Image 2 through RunComfy is a precision tool, not a creativity tool. When you know exactly what you want and need it rendered with text accuracy, it saves the context-switch overhead. When you're still figuring out what you want, the three-size prison and the external CLI requirement make it slower than just using the web UI.
