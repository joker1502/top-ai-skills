---
title: "I Let AI Write My PRD for a Week Here's What Happened"
date: 2026-06-12
draft: false
tags:
  - PRD
  - Product Management
  - AI Coding
  - Matt Pocock
description: "A week-long experiment using to-prd to turn vague product ideas into structured PRDs published straight to the issue tracker. The results surprised me."
category: "guides"
related_skills:
  - to-prd
  - grill-me
---

## Why I Went Down This Rabbit Hole

It was a Tuesday afternoon, and I was staring at my third blank PRD template of the month. Same cursor blinking in the same "Problem Statement" field. Same feeling that I should be writing code instead of documenting why the code matters.

I work on a small team. We ship fast, which means documentation is always the first thing to slip. PRDs end up as Notion scraps or Slack threads titled "that thing we discussed." When I found `to-prd` on skills.sh — described as a tool that synthesizes conversation context into a structured PRD and publishes it to your issue tracker — I installed it within 30 seconds. The promise was simple: stop writing requirements, start shipping. I'd already tried [Grill Me](/skills/general/grill-me/), another Matt Pocock skill, for plan review. to-prd felt like the natural companion.

## Setup: How Long It Actually Took

Installation was straightforward. One command:

```
npx skills add https://github.com/mattpocock/skills --skill to-prd
```

Then `/setup-matt-pocock-skills` inside Claude Code to configure my issue tracker connection. That took about 2 minutes — it asked for my GitHub repo and confirmed the triage label setup.

The first run failed. I hadn't realized the skill expects you to already have a conversation context built up. I tried running it cold — just opened Claude Code, typed "generate a PRD for a new feature" and... nothing useful came out. The skill returned a generic template with no specifics.

Second attempt: I spent 5 minutes describing the feature to Claude, discussing tradeoffs, then ran to-prd. This time it worked. The output was actually coherent — it used vocabulary from our codebase and referenced existing ADRs.

Total time from install to first usable PRD: about 20 minutes, including the false start.

## What I Built With It

I tested to-prd on a feature I'd been dreading to spec out: adding granular permission controls to our dashboard app. Every team member had raised this as needed, but nobody wanted to write the PRD because it touched so many systems — auth, database roles, UI routing, API middleware.

I spent 10 minutes in Claude Code talking through the problem. What the feature should do, who needs it, what constraints exist. Then I ran to-prd.

What came back had a problem. The skill identified three "deep modules" that could be built in isolation: a permission resolver, a route guard, and an audit log. But it missed the UI layer entirely — no mention of how admins would configure permissions, no wireframes, no user flow for assigning roles. The PRD was architecturally sound and completely blind to the user experience.

This is where the skill showed its bias. It's built by Matt Pocock, whose work leans heavily toward backend architecture and type systems. The generated PRD reflected that worldview — solid on module boundaries, weak on interaction design. I had to explicitly ask it to consider the admin interface before it produced anything usable on that front.

I went back, mentioned the UI gap explicitly, and ran to-prd again. The second version included the admin panel spec, complete with acceptance criteria for each permission toggle. That was the pivot moment — I realized the skill is excellent at structuring what you tell it, but it won't fill gaps you haven't surfaced. It forced me to think through the whole feature before it could write about it.

## What Surprised Me

The domain glossary integration. Our codebase uses specific terminology ("workspace," "organization," "team") that have subtle but important distinctions. to-prd picked up on these from the ADRs in the repo and used them correctly throughout the PRD.

No corrections needed.

The "test seams" section was also genuinely useful. The skill proposed a permission resolver module that could be unit-tested without loading any route handlers — exactly the kind of architectural insight you'd expect from a senior engineer, not a generated document.

## Things That Annoyed Me

Cold starts are useless. If you run to-prd without a preceding conversation, you get a templated output that could apply to any project. The skill's own docs say "Do NOT interview the user — just synthesize what you already know," which means the quality depends entirely on how much context you've built up before invoking it. This makes it bad for quick captures of half-baked ideas. You can't just shout "PRD this" and expect magic — you have to do the thinking first.

The PRD template itself is rigid. It produces a specific structure (Problem Statement, Process, Modules, Test Seams) that fits Matt Pocock's engineering workflow. My team uses a different format with sections for "Success Metrics" and "Rollback Plan." I couldn't easily customize the output without editing the published issue by hand. There's no config file or template override — what you see is what you get.

Also, publishing to the issue tracker with `ready-for-agent` label is great if your team uses AI agents to pick up work. If you don't, that label is noise.

## When I Use It vs When I Don't

I use to-prd when I have a feature that's been discussed enough to have a clear shape but hasn't been written down. It saves me the mechanical work of translating conversation into document structure. Perfect for mid-complexity features that touch multiple systems — exactly the kind of work where the PRD writing feels like a bottleneck between decision and implementation.

I don't use it for pure discovery work — early ideas that need to stay loose and iterative. The act of writing a PRD forces commitment, and committing too early kills good exploration. I also skip it for trivial changes where a one-line issue is sufficient, or for features so complex that the PRD needs heavy human judgment around tradeoffs.

The honest verdict: to-prd is a documentation accelerator, not a thinking replacement. If you know what you want to build and need it written down in a structured, publishable format, it saves maybe 30-40 minutes per PRD. If you're hoping it'll do the thinking for you, you'll get a well-structured empty document.
