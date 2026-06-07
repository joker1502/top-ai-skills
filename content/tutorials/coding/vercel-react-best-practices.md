---
title: "Vercel React Best Practices: 64 Rules for Faster Next.js Apps"
date: 2026-06-04
toc: true
draft: false
tags:
  - React
  - Next.js
  - Performance
description: "Vercel's official React/Next.js performance skill — 64 rules across 8 categories that your AI assistant follows automatically when writing code"
category: "coding"
rating: 5
related_skills:
---

## What This Skill Actually Does

Vercel packages their React and Next.js performance knowledge into 64 rules. Once installed, your AI assistant follows them automatically when writing code. The rules cover rendering strategy, state management, component design, data fetching, performance optimization, type safety, accessibility, and testing — 8 categories total.

The skill lives inside the larger `vercel-plugin` package, which bundles 25 skills covering the entire Vercel ecosystem. You can install just the React best practices skill, or the full plugin.

## Why It Matters

Write "follow React best practices" in a prompt, and you get inconsistent results depending on the model, the day, and the mood of the temperature setting. These 64 rules are hardcoded by Vercel's team. They don't drift. And they're Next.js-specific — Server Components, App Router, `use cache`, and other framework-unique concepts that generic React best practices never touch.

## Setting It Up

```bash
npx skills add vercel-labs/vercel-plugin@react-best-practices
```

That's it. The skill activates when your AI assistant detects a React or Next.js project. No configuration needed.

If you want the full Vercel ecosystem plugin (25 skills including AI SDK, Turbopack, shadcn/ui, Vercel CLI, and more):

```bash
npx plugins add vercel/vercel-plugin
```

The full plugin also injects a relationship knowledge graph at session startup, so your AI understands which Vercel products work together and when to use which one.

## What the 64 Rules Cover

The skill breaks down into 8 categories:

**Rendering**: Server Components vs Client Components, when to use `"use client"`, streaming patterns, and avoiding unnecessary client-side rendering.

**Caching**: Next.js caching strategies, revalidation, `use cache`, cache tags, and when to opt out of the default cache.

**State Management**: Server state vs client state, avoiding global state bloat, and using URL state where possible.

**Component Design**: Composition patterns, prop drilling alternatives, and keeping components focused.

**Data Fetching**: Server-side fetching patterns, parallel data loading, and avoiding waterfall requests.

**Performance**: Bundle size management, dynamic imports, image optimization, and Core Web Vitals.

**Type Safety**: TypeScript strict mode, discriminated unions for props, and avoiding `any`.

**Accessibility**: Semantic HTML, keyboard navigation, and ARIA attributes.

Each category has roughly 8 rules. They're specific enough to be actionable — not vague advice like "use semantic HTML" but concrete patterns like "fetch data in the layout, not in individual page components."

## Things to Know

The skill is maintained by Vercel and synced from upstream. Rules update as Next.js evolves, so you get current best practices without manually checking changelogs.

If you're not using Next.js, some rules won't apply — particularly the rendering and caching categories which rely on App Router and Server Components. The React patterns (component design, type safety, accessibility) are framework-agnostic and useful regardless.

## What's Next

If you're deploying on Vercel, pair this with the full `vercel-plugin` for end-to-end coverage — from writing the code to deploying it. The plugin's 3 specialized agents (deployment expert, performance optimizer, AI architect) can review your work holistically.
