---
title: "PDF"
date: 2026-06-01
draft: false
tags:
  - Documentation
  - PDF
description: "在 Claude Code 中创建、读取和编辑 PDF 文档，支持文本提取、文档生成和格式保留的修改操作"
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
github_stars: 153813
github_forks: 18141
installs: 126100
last_updated: "2026-06-09"
ai_friendliness:
  score: 4.0
  documentation: 4.0
  setup: 4.0
  config: 4.0
---

## 它能做什么

Pdf 让 AI 代理能创建、读取和编辑 PDF 文档——生成报告、提取文本、添加表格和图片、合并拆分文件。Anthropic 官方技能套件（anthropics/skills，144k Stars）的一部分，是目前代理生态中处理 PDF 最直接的选项。

## 它与众不同在哪

PDF 格式是出了名的难处理——大多数 AI 工具只能"提取文本"或"用图片转"，遇到有复杂布局的文档就露馅。Pdf 技能能理解 PDF 的结构（段落、表格、页眉页脚），生成的文档也不是"拍照放进 PDF"，而是真正的可搜索、可选择的 PDF 文件。跟 Docx/Xlsx 等办公技能配合，可以实现"从数据到 PDF 报告"的完整流水线。

## 谁不适合用它

如果只是需要预览 PDF 内容，用浏览器打开就够了。如果你需要 OCR 扫描件、复杂表单填写、或者数字签名等高级功能，Pdf 技能目前不支持这些。它能处理的是"创建和读取"这一层——排好版的报告、数据输出的 PDF 文件。

## 总结

Pdf 让代理能直接生成专业 PDF 文件，而不是给你一段"你自己去转 PDF"的 Markdown——从数据到交付件的最后一步终于不需要人来接手了。
