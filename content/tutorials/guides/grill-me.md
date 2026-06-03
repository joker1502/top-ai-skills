---
title: "Grill Me: Have AI Challenge Your Plan Before You Write a Single Line"
date: 2026-06-03
toc: true
draft: true
tags:
  - Plan Review
  - AI Agent
  - Productivity
  - Tutorial
description: "Grill Me is part of Matt Pocock's Skills suite — it makes your AI interrogate your plan before coding, catching flaws early"
category: "guides"
rating: 5
related_skills:
  - caveman
---

## What Problem It Solves

You tell AI "I'm going to refactor this module." AI says "Great, let me do it." Then halfway through, you discover the approach is flawed and need to rework everything.

Grill Me fixes this. Install it, say the same thing, and instead of diving in, AI starts questioning you:

"What's the scope of this refactor? Just this module or downstream dependencies? If the interface changes, what happens to existing callers?"

It keeps pushing until every branch has an answer.

## Which Suite It Belongs To

Grill Me is one of 18 skills in Matt Pocock's Skills suite — 116k Stars, covering engineering, productivity, and utilities. Install individually or grab the full set:

```bash
npx skills@latest add mattpocock/skills
```

Run `/grill-me` to start the interrogation.

## How It Feels

Different from normal AI chat. In regular mode, AI is an executor — tell it, it does it. In Grill Me mode, AI becomes a reviewer. You'll get asked about edge cases, failure modes, simpler alternatives, historical context, and blast radius.

If you can't answer, it keeps pushing. It won't let you go.

It's uncomfortable at first — you came for help, and now you're being interrogated. But after a few rounds, you'll notice that starting work with all the branches covered leads to far fewer mid-implementation pivots.

## vs. Plain Prompting

Write "challenge my plan first" in your system prompt, and AI might ask one or two questions then move on. Grill Me's interrogation is structured — it covers the full decision tree, not random surface questions.

## Things to Watch Out For

This skill is for complex tasks that benefit from upfront planning. For "write me a sort function," the grilling is a waste of time.

Matt Pocock's suite also includes `/grill-with-docs`, which ties into CONTEXT.md and ADRs. Better for documented projects. Start with Grill Me if you haven't built docs yet.

## What's Next

Before your next complex task, run `/grill-me` and count how many blind spots it catches.
