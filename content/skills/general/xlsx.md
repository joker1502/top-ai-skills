---
title: "Xlsx"
date: 2026-06-01
draft: false
tags:
  - Documentation
  - Excel
description: "Creates and edits Excel spreadsheets with formulas, formatting, multiple sheets, and data analysis capabilities in Claude Code"
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
github_stars: 153864
github_forks: 18145
installs: 100900
last_updated: "2026-06-09"
ai_friendliness:
  score: 4.0
  documentation: 4.0
  setup: 4.0
  config: 4.0
---

## What It Is + Verdict

XLSX is Anthropic's spreadsheet skill that creates and edits Excel files from Claude Code. It handles formulas, cell formatting, multiple worksheets, and data layout — producing files that open correctly in Excel, Google Sheets, and LibreOffice Calc.

## The One Thing That Matters

The skill handles formulas correctly, not just static values. You can describe a calculation — "add a column that is tax plus shipping" — and it generates the correct Excel formula in the right cell. This means the output spreadsheet is alive: recipients can change inputs and see results update automatically.

## What's Actually Different

Where CSV export dumps data and loses all formatting, XLSX preserves column widths, number formats, cell colors, merged cells, and named ranges. It handles multiple sheets in a single workbook, which is essential for organized data reporting. Compared to writing Python scripts that use openpyxl or xlsxwriter, describing what you want in natural language is significantly faster for one-off reports.

## Who It's For

Anyone who delivers data as spreadsheets — financial reports, inventory lists, budget trackers, survey results. Also useful for transforming data from one spreadsheet format to another. Less relevant if CSV output meets your needs.

## Bottom Line

XLSX produces real Excel files with working formulas and professional formatting, from a natural language description.
