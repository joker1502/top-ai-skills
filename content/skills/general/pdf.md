---
title: "Pdf"
date: 2026-06-01
draft: false
tags:
  - Documentation
  - PDF
description: "Creates, reads, and manipulates PDF documents programmatically in Claude Code, supporting text extraction, generation, and editing"
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
installs: 126100
last_updated: "2026-06-09"
ai_friendliness:
  score: 4.0
  documentation: 4.0
  setup: 4.0
  config: 4.0
---

## What It Is + Verdict

PDF is Anthropic's document processing skill for working with PDF files in Claude Code. It handles reading text content, generating new PDFs, and modifying existing documents — covering the full PDF workflow without leaving your terminal.

## The One Thing That Matters

PDF generation from an AI agent is notoriously hard because PDF is a visual format built from low-level drawing primitives. This skill abstracts that complexity — you describe what the document should look like, and Claude produces correctly formatted PDF output. For reading, it extracts text content that Claude can analyze, summarize, or transform.

## What's Actually Different

Compared to converting PDFs to Markdown and back (which loses layout and formatting), this skill preserves document structure during generation. It handles tables, headings, page breaks, and basic styling. It is part of Anthropic's document processing family alongside docx, pptx, and xlsx — they share consistent patterns so results are predictable across formats.

## Who It's For

Anyone who needs to generate reports, invoices, certificates, or formatted documents from Claude. Also useful for batch-processing existing PDFs for text extraction or reformatting. Less relevant if you only read PDFs occasionally and do not need to generate them.

## Bottom Line

PDF gives Claude the ability to produce and consume formatted documents with reliable structure across generations.
