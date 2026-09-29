---
title: "lark-sheets vs lark-base: Grid Cells or Typed Records?"
date: 2026-09-29
toc: true
draft: false
tags:
  - Lark
  - Feishu
  - Spreadsheets
category: "comparison"
description: "Feishu ships two data skills that look alike: lark-sheets (grid cells, formulas) and lark-base (typed records, views, forms). This maps when to use each."
---

Two skills in [larksuite/cli](https://github.com/larksuite/cli) handle almost every table-shaped task in Feishu, and choosing wrong costs you hours fighting the wrong data model. I read both SKILL.md files end to end on 2026-09-29 — lark-sheets v3.5.2 (27,880 bytes) and lark-base v1.2.23 (23,914 bytes) — plus their reference trees, and scraped skills.sh the same day: **lark-sheets 736,073 installs (open.feishu.cn) / 455,941 (larksuite/cli)**, **lark-base 737,255 / 459,583**. Nearly identical numbers, and the family packs them as one counter. The skills themselves route away from each other in their own frontmatter: lark-sheets says "多维表格 Base/bitable 请改用 lark-base", lark-base says spreadsheet content goes to lark-sheets. The line they draw is the whole story.

## The Data Model Split

lark-sheets treats everything as a grid of cells addressed by range — `A1:F30`, `--range A1:B2` — where a cell holds a value, a formula, a style, or a comment. Numbers, dates, and text live side by side in the same sheet, and the skill's formula rules read like an Excel migration guide: derived values must be written as cell formulas referencing other cells, never as static values computed in Python ("交付的是改输入不重算的死表"). Formula writes go through `+formula-verify --exit-on-error` until every segment reports success, and native AI formulas (`=AI(prompt, range)`) are the documented first choice for per-row NLP like translation, sentiment, and labeling.

lark-base is a record store wearing a spreadsheet front-end. Each row is a Record with a stable `record_id`; each column is a typed Field (text, number, datetime, select, user, link, lookup, formula) and each cell a CellValue that must match its field's type. Writes batch through `+record-batch-create` / `+record-batch-update` with JSON payloads, single batch capped at 200 records, serial per table to avoid the `1254291` concurrency conflict. `created_at`, `updated_at`, formula, and lookup fields are read-only — writing them silently drops into `ignored_fields`.

| Dimension | lark-sheets | lark-base |
|:----------|:------------|:----------|
| Core unit | Cell in a range (A1:F30) | Record with typed fields |
| Identity | Column/row position | Stable `record_id` |
| Formulas | Excel-style cell formulas; `+formula-verify` gate | Formula/lookup fields, read-only |
| NLP on data | Native AI formulas per row | Field-extension plugin (LLM writes back) |
| Visual layer | Charts, pivot tables, conditional formatting, sparklines, float images | Views, dashboards (charts, metric cards), BaseApp pages |
| Input forms | None | `+form-*` — forms create records |
| History | `+history-list` / `+history-revert` (async) | `+record-history-list` per record |
| Import/export | `+workbook-import` / `+workbook-export` (Excel/CSV) | Routes to lark-drive |

## What Each One Is Good At

lark-sheets wins where the shape of the work is *calculations and layout*. Financial modeling is the skill's own listed territory — DCF, three-statement models, budgets, sensitivity tables — because formulas recompute when inputs change and styles carry across new rows and columns. Its editing rules encode spreadsheet hygiene: minimal changes (never touch sheets the user didn't name), physical row/column insertion with `--inherit-style`, style read-back checks, and the stern rule that sorting and deletion use atomic `+range-sort` / `+dim-delete` instead of read-then-overwrite. High-risk writes (`+batch-update`, `+cells-batch-clear`, `+history-revert`, every object delete) sit behind a dry-run → `--yes` exit-10 gate.

lark-base wins where the data has *structure and relationships*. Link fields connect records across tables, select/status fields enforce an option set, views filter and group without touching data, forms collect input from people who never see the table, dashboards summarize multiple tables, and workflow blocks automate on record changes. The skill's resource model is a Block tree — table, dashboard, docx, workflow, folder — with advanced permissions and roles layered on top, and BaseApp pages compose read-only or interactive views of the same data. If your answer to "what is this table for" includes the words "relate to", "collect from", or "automate on", that is lark-base.

## The Boundary Rule in Practice

Throw a problem at both skills and the routing resolves in one sentence each. Hand lark-sheets a Base link and its frontmatter bounces you to lark-base; point lark-base at Excel, CSV, or `.base` files and it bounces to lark-drive for import/export; mention "create a table" and you must decide which model you mean before the CLI will help. The practical discriminator: **is the unit of work a cell or a record?** Editing one number, restyling a header, migrating an Excel workbook → lark-sheets. Tracking orders with statuses, linking customers, collecting submissions, building a dashboard → lark-base.

Identity preferences differ too and are worth knowing before automation: lark-base documents "优先使用 `--as user`" and switches to bot identity only when the user explicitly asks, while lark-sheets treats user/bot per-operation. Both demand reading `lark-shared/SKILL.md` first — authentication and the high-risk approval protocol live there, not in either data skill.

## Which One to Install

Install both — they share the lark-cli binary, so adding the second is one command. Start from the data shape: grid + formulas + Excel migration → `npx skills add https://github.com/larksuite/cli --skill lark-sheets`; structured records, links, forms, and automation → `npx skills add https://github.com/larksuite/cli --skill lark-base`. The mistake to avoid is picking by install count — the two numbers are inseparable family counters, 736K vs 737K tells you nothing. Pick by whether a row is something you compute or something you track. Read [lark-base intro](/skills/automation/lark-base/) or the lark-base FAQ for the record side, then the sheets workflow reference for formula discipline — the two reference trees are the actual documentation, and both skills point you there before any command runs.