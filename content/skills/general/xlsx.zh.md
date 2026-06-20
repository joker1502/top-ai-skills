---
title: "XLSX"
date: 2026-06-01
draft: false
tags:
  - Documentation
  - Excel
description: "创建和编辑 Excel 电子表格，支持公式、多工作表、单元格格式和命名区域，输出可直接在 Excel 和 Google Sheets 中使用"
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
github_stars: 153070
github_forks: 18038
installs: 100900
last_updated: "2026-06-09"
ai_friendliness:
  score: 4.0
  documentation: 4.0
  setup: 4.0
  config: 4.0
---

## 它能做什么

Xlsx 让 AI 代理能够创建和编辑真正的 Excel 文件——包含公式、单元格格式、合并区域、图表和数据验证。Anthropic 官方出品（anthropics/skills，144k Stars），不是生成一个 CSV，而是生成一个有结构、带格式的 .xlsx 文件。

## 它与众不同在哪

大多数 AI 工具处理表格数据时输出 CSV 或 Markdown 表格，因为这两种格式最容易生成。Xlsx 不一样——它直接操作 Excel 的底层格式，生成的 .xlsx 文件用 Excel 或 Google Sheets 打开就是一份看得过去的报表。跟同行技能 Pptx（演示文稿）、Docx（Word 文档）是同一套，适合需要批量生成办公文档的场景。

## 谁不适合用它

如果只是导出数据做进一步处理，CSV 更轻量、更通用。如果你对 Excel 文件有极端精细的格式要求（特定字体、条件格式、复杂宏），Xlsx 目前还做不到那个程度——它能处理的是"有模有样的表格"而不是"像素级完美的报表"。

## 总结

Xlsx 把"生成 Excel 文件"从手动操作变成了代理的一句话指令——适合定期出报表、批量生成数据表格的重复性工作。
