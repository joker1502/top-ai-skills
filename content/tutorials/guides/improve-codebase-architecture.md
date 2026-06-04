---
title: "Finding Architecture Problems with Improve Codebase Architecture"
date: 2026-06-03
toc: true
draft: true
tags:
  - Architecture
  - Code Quality
  - Refactoring
description: "Matt Pocock's architecture review skill — AI finds deep improvement opportunities based on your domain language and ADRs"
category: "guides"
rating: 5
related_skills:
---

## What It Discovers

Ask AI to "optimize my code" and it does local improvements — extracting functions, adding types, renaming. Useful, but surface-level. Improve Codebase Architecture does something different: it makes AI understand your domain model first, then finds architectural issues from that perspective. Cross-module coupling that local optimization can never see.

## Part of Matt Pocock's Suite

One of 18 skills. Install the full set:

```bash
npx skills@latest add mattpocock/skills
```

Run `/setup-matt-pocock-skills` first to configure your issue tracker, labels, and doc paths. AI needs to know whether you use GitHub Issues or Linear and where docs live.

## How to Use

Make sure you have a CONTEXT.md with project terminology. If not, create one — tell AI what "user," "order," "payment" mean in your context.

Then run `/improve-codebase-architecture`. AI scans the codebase, combines domain language and ADRs, and provides improvement suggestions. Each includes: what the problem is, why it's a problem, and how to fix it.

## vs. Just Asking AI

Ask "what's wrong with my architecture" directly and you get generic advice. This skill combines project docs (CONTEXT.md) and ADRs, so suggestions are tied to your specific business domain — not one-size-fits-all platitudes.

## Things to Watch Out For

Best for established codebases. New project architecture issues are usually obvious and don't need AI analysis. The skill suggests but doesn't auto-implement changes — you decide what to adopt. Pair with `/grill-me` to interrogate your refactoring plan before executing.

## What's Next

Pair with `/to-issues` to break architecture improvements into trackable GitHub Issues.
