---
title: "Docx"
date: 2026-06-01
draft: false
tags:
  - Documentation
  - Word
description: "Creates, reads, and edits Word documents (.docx) with tables of contents, headings, images, tables, and tracked changes through Claude Code"
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
github_stars: 151404
github_forks: 17863
installs: 113900
last_updated: "2026-06-09"
ai_friendliness:
  score: 4.0
  documentation: 4.0
  setup: 4.0
  config: 4.0
---

## What It Is + Verdict

DOCX is Anthropic's Word document skill for creating, reading, and editing .docx files in Claude Code. It handles the full feature set — tables of contents, headings, tables, images, page numbers, and tracked changes — producing documents that open correctly in Microsoft Word and Google Docs.

## The One Thing That Matters

Word documents are XML packages under the hood, and malformed XML produces corrupted files. This skill knows the correct schema and produces valid output consistently. It handles real document features that naive approaches get wrong: proper heading styles for TOC generation, image embedding with correct relationships, and tracked changes that actually display in Word's review mode.

## What's Actually Different

Where PDF skill produces fixed-layout output, DOCX generates editable documents that recipients can modify. This makes it better for collaborative workflows — draft a memo, send for review, incorporate feedback. The skill supports tracked changes natively, so you can see what Claude added or modified. It pairs with the PDF skill when you need both editable source and final formatted output.

## Who It's For

Anyone who generates business documents — memos, reports, proposals, meeting notes — and needs them in an editable format. Less useful if your workflow ends with PDF or Markdown output.

## Bottom Line

DOCX produces genuine Word documents with real formatting, not Markdown dressed up as a .docx file.
