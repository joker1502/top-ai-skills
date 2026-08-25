---
title: "Anti UI Slop vs Web Design Guidelines: Stopping Generic UI"
date: 2026-08-25
toc: true
draft: false
tags:
  - UI Design
  - Agent Skills
  - Design Review
category: "comparison"
description: "Two skills fight AI-generated UI slop: Vercel audits code against 16 rule groups, UIZZE grounds builds in 800K real screens. Weekly installs: 21K vs 121K."
---

Two official agent skills target the same enemy — AI-generated UI that looks like every other AI-generated UI — and they disagree about the fix. Vercel's [web-design-guidelines](/skills/coding/web-design-guidelines/) audits finished code against a live 190-line rulebook and answers with `file:line` violations. UIZZE's anti-ui-slop grounds new builds in more than 800,000 real screens, loads one playbook at a time, and closes with a render-and-inspect gate. I read both SKILL.md files and pulled their install curves from skills.sh on 2026-08-25. The numbers sharpen the contrast better than the marketing does.

## What Each Skill Actually Does

**web-design-guidelines** is a 39-line launcher. It fetches the guidelines file fresh from `vercel-labs/web-interface-guidelines` before every review, reads the files you name, applies every rule in the fetched document, then reports in `file:line` format. The rulebook ships separately — 190 lines, 16 rule groups from accessibility down to copy — plus a 14-item anti-pattern list, and the source doc tells the agent to "sacrifice grammar for brevity. High signal-to-noise." I broke the full rulebook down in the [web-design-guidelines intro](/skills/coding/web-design-guidelines/), so the short version: it's a compliance sweep you point at existing code.

**anti-ui-slop** (v1.2.13, MIT, from UIZZE) works the other side of the pipeline. Its opening line is "Stop making UI slop." The skill reads the product brief, existing components, design tokens, and constraints first — those outrank the skill itself, and it warns against adding "novelty for its own sake." Then it loads exactly one playbook, chosen from six: new-work for new interfaces, operate for products and dashboards, polish, distill, audit, and a dedicated ios playbook. The optional paid UIZZE MCP adds precisely two tools, `find_ui_references` and `find_ui_materials`, and the skill tells the agent never to claim the MCP is connected without an actual host result. It ends with a finish gate: render once when the environment allows, fix observable breakage — clipping, overlap, distorted media, inaccessible controls, inert interactions — and keep the handoff concise.

## Same Goal, Opposite Postures

The sharpest difference is what each treats as the source of truth.

web-design-guidelines treats quality as a compliance problem. Rules get fetched, files get checked against all of them, and the output is complete: findings grouped by file, clickable in VS Code, silent only when a file passes with a single `✓ pass` line. Nothing gets ranked, nothing gets capped.

anti-ui-slop treats quality as a judgment problem. Its audit playbook says "review only what can be observed in the implementation or rendered result. Do not invent missing requirements or turn personal taste into a defect." An audit caps at three material findings, ordered by user impact, and the SKILL.md warns the agent to "apply judgment rather than treating its examples as a checklist."

One skill is exhaustive. The other is selective on purpose.

## The Install Curves Tell Different Stories

web-design-guidelines: 574,938 installs, rank #37, weekly band between 17,172 and 21,343 across its last eight reports — steady, drifting up slightly.

anti-ui-slop: 481,847 installs, rank #61, and its weekly reports read like a hockey stick: 0, 0, 4,081, 14,588, 86,056, 106,826, 119,426, 121,261. Eight weeks from zero to 121K weekly installs — the steepest growth curve I found among design skills on the board.

The star counts make the contrast stranger. `vercel-labs/agent-skills` carries 30,412 stars; `uizze/uizze` has 11. The exploding skill comes from an 11-star repository. Vercel's name rides the marketplace and its own clout; UIZZE ships through uizze.com plus plugin packs for Claude Code, Cursor, and Codex sitting in the same repo — the wave isn't coming from GitHub discovery.

So the winner depends on the axis: most total installs is Vercel. Momentum is UIZZE, unambiguously.

## Which One to Reach For

Real talk — these two slot into different moments of the same flow, and I'd run them in sequence.

Sweeping code you already wrote before a release? web-design-guidelines is the tool. It's exhaustive, it produces a diff-friendly list, and it will flag the missing `aria-label` on the icon button and the `transition: all` you forgot to split.

About to generate or redesign a screen? anti-ui-slop shapes the generation itself — it changes what the agent produces before a rulebook gets a chance to complain. Its three-finding audit also reads better in a review discussion than a 60-item `file:line` dump.

My honest setup: write UI with anti-ui-slop, then sweep the result with web-design-guidelines before shipping. The judgment skill sets the direction; the compliance skill catches the stragglers. Both run free — the UIZZE skill explicitly needs no account, token, or MCP connection for the free tier.

Try the pair against one real component this week. Design a settings screen with anti-ui-slop, audit the output with web-design-guidelines, and count which one catches more. Start with the [full web-design-guidelines teardown](/skills/coding/web-design-guidelines/) for the 16 rule groups spelled out, then grab anti-ui-slop from github.com/uizze/uizze or uizze.com.