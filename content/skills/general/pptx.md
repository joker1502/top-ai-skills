---
title: "Pptx"
date: 2026-06-01
draft: false
tags:
  - Documentation
  - Presentation
description: "Generates professional PowerPoint presentations with properly formatted slides, images, and layouts directly from Claude Code"
version: "1.0.0"
author: "Anthropic"
repo_url: "https://github.com/anthropics/skills"
install_cmd: "npx skills add anthropics/skills"
compatibility:
  - Claude Code
  - Cursor
  - Codex
category: "general"
rating: 4.0
github_stars: 150080
github_forks: 17714
installs: 132800
last_updated: "2026-06-09"
ai_friendliness:
  score: 4.0
  documentation: 4.0
  setup: 4.0
  config: 4.0
---

## What It Is + Verdict

PPTX is Anthropic's presentation skill that generates PowerPoint files from Claude Code. It produces slides with proper layouts, images, and formatting — opening correctly in PowerPoint, Google Slides, and Keynote.

## The One Thing That Matters

Good presentations are visual, and this skill generates slide content that includes images and diagrams, not just text placeholders. It understands slide layouts, master templates, and content placement. The output is usable as-is for internal presentations or as a strong first draft for client-facing decks.

## What's Actually Different

Most AI presentation tools are web apps with limited export options. This skill runs entirely in Claude Code — describing what you want produces a .pptx file on disk, no third-party service required. The output uses standard PowerPoint XML schemas, so formatting survives round-trips through different presentation software. It is part of Anthropic's office document family and follows the same conventions as docx and xlsx.

## Who It's For

Anyone who needs to create slide decks regularly — weekly status updates, investor pitches, training materials, conference talks. Less useful for one-off presentations where you would rather use PowerPoint's own tools.

## Bottom Line

PPTX generates real PowerPoint files with images and proper layouts, directly from a terminal prompt.
