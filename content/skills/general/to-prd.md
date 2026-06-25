---
title: "To PRD"
date: 2026-06-13
draft: false
tags:
  - Product Management
  - PRD
  - Documentation
  - AI Agents
description: "A skill by Matt Pocock that turns unstructured AI conversation into structured PRDs and publishes them straight to your issue tracker."
version: "1.0.0"
author: "Matt Pocock"
repo_url: "https://github.com/mattpocock/skills"
install_cmd: "npx skills@latest add mattpocock/skills"
compatibility:
  - Claude Code
  - Codex
  - Cursor
category: "general"
rating: 4.5
github_stars: 145461
github_forks: 12583
installs: 176000
last_updated: "2026-06-24"
ai_friendliness:
  score: 4.5
  documentation: 5.0
  setup: 4.0
  config: 3.5
---

## What It Is

A PRD generation skill that works by synthesis, not interview. Instead of asking you a list of questions, it listens to whatever context you've already built up in your AI conversation — discussion about a feature, tradeoffs you've explored, constraints you've mentioned — and turns that into a structured product requirements document with sections for problem statement, process, deep modules, and test seams. It then publishes the result to your issue tracker with a triage label.

## What's Actually Different

Most AI document generators either interview you (fill-in-the-blank questionnaire) or produce a templated output that could describe any project. To PRD skips the interview. It expects you to have done the thinking already and just needs the formatting and publishing done. The real differentiator is how it reads your repo's existing ADRs and codebase terminology — the PRDs I've seen use the correct internal vocabulary (workspace vs organization vs team, for example) without being told.

The downside is also the feature: cold starts produce nothing useful. You can't open a blank chat and say "PRD this" — the skill needs conversational context to work from.

## Who It's For

Get it if you write PRDs regularly and the mechanical work of translating a decision conversation into document structure is a bottleneck. Worth installing alongside [Grill Me](/skills/general/grill-me/) — the two form a before-and-after workflow: challenge the plan, then document it. Skip it if your team uses a PRD format that differs significantly from Matt Pocock's engineering-oriented template, or if your documentation process doesn't involve GitHub issues.

## Bottom Line

A documentation accelerator that saves the typing but not the thinking — works best when you know what you want to build and need it written down fast.
