---
title: "How to Use the Copywriting Skill to Generate Marketing Content"
date: 2026-06-26
draft: false
toc: true
tags:
  - Copywriting
  - Marketing
  - AI Writing
description: "A step-by-step guide to installing and using the Copywriting skills.sh agent. Generate email sequences, landing pages, and social posts from a single product brief."
category: "guides"
---

## What This Gets You

This guide walks through installing the Copywriting skill and using it to turn one product description into four types of marketing copy: an email sequence, a landing page draft, social media captions, and ad headlines. You feed the skill a brief once and get formatted output for each channel.

**Time estimate**: 20 minutes from install to first draft.

## What You Need Before Starting

- An AI coding agent that supports skills.sh (Claude Code, Cursor, OpenCode, or Codex)
- Node.js 18+ and `npx` available on your system
- A product or service description ready — 3-5 sentences about what you're selling, who it's for, and what makes it different

## Step-by-Step

### 1. Install the skill

Run the install command in your terminal:

```bash
npx skills add coreyhaines31/copywriting
```

Expected output:

```
> Added coreyhaines31/copywriting to your skills
```

This downloads the skill's instruction set into your agent's skill directory. The skill is now available in your next agent session.

### 2. Open your agent and load the skill

Start a new session in Claude Code, Cursor, or OpenCode. The agent picks up installed skills automatically — no manual import needed.

To confirm the skill is loaded, ask your agent:

```
What skills do I have available?
```

You should see `copywriting` listed among your installed skills. If it doesn't appear, restart your agent session.

### 3. Prepare your product brief

Write a short description of what you're marketing. Keep it to 3-5 sentences. Include:

- What the product or service does
- Who it's for
- What makes it different from alternatives
- One specific use case or result

Example brief:

```
SaaS product: TaskFlare, a project management tool for remote teams.
It replaces Slack threads and Trello boards with task-based timelines
that auto-adjust when deadlines shift. Differentiator: smart
rescheduling — move one deadline, the rest adjust automatically.
For small-to-mid-size remote teams tired of context-switching
between chat and project tools.
```

### 4. Generate an email sequence

Tell your agent to generate emails using the Copywriting skill. The exact phrasing matters less than including your brief:

```
Using the copywriting skill, write a 3-email launch sequence for:
[your brief]
```

The skill returns output structured as email drafts with subject lines, preview text, and body copy. Each email has an open-loop hook in the subject line and a clear call-to-action at the end.

### 5. Generate a landing page draft

Same brief, different format:

```
Using the copywriting skill, write a landing page for:
[your brief]
```

Expected output includes a hero headline, subheadline, feature sections, social proof placeholder, and a CTA section. The structure follows conversion copy principles — problem-agitation-solution flow above the fold, risk reversal near the CTA.

### 6. Generate social captions and ad headlines

For social media and ads, specify the platforms:

```
Using the copywriting skill, write 3 LinkedIn caption options,
3 Twitter threads, and 5 ad headlines for: [your brief]
```

The skill adapts tone per platform. LinkedIn captions get a professional cadence, Twitter threads open with a hook and deliver value in short bursts, ad headlines stay under 10 words with benefit-first framing.

## Verification

To confirm the skill is working correctly, run this minimal test:

```bash
npx skills run coreyhaines31/copywriting --dry-run
```

Expected output confirms the skill is found and its instructions are loadable. If you get a `skill not found` error, re-run the install step and restart your agent.

Then test with a real invocation in your agent:

```
Using the copywriting skill, write one ad headline for a
task management tool for remote teams.
```

You should get a headline back immediately. If the agent responds with generic advice instead of skill-specific output, the skill may not be loading — restart your agent session.

## One Thing That Tripped Me Up

The skill generates its best output when you give it a focused brief. I initially tried to describe my product in one sentence, and the results were generic — the kind of copy you'd get from asking ChatGPT directly. The improvement came when I added a differentiator and a specific use case. The skill's built-in copywriting templates need material to work with. A vague brief produces vague copy, which defeats the purpose of installing a dedicated skill.

## Next Step

Once you have drafts, run them through the skill again with a refine instruction: "Shorten the headline options to 5 words or less" or "Rewrite the email sequence for a technical audience." The skill remembers the original brief, so you only need to ask for format adjustments.

To see more examples, read the [Copywriting skill page](/skills/general/copywriting/) for the full capability breakdown.
