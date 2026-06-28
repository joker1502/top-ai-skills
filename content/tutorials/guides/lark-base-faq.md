---
title: "Lark Base AI Skill: 12 Questions About Using It"
date: 2026-06-25
draft: false
toc: true
tags:
  - Lark Base
  - Feishu
  - Database
  - AI Automation
  - Agent Skills
description: "Answers to common questions about the Lark Base AI skill — install, authenticate, query records, create fields, batch operations, and permissions."
category: "guides"
---

The Lark Base skill is one of 26 agent skills in the [larksuite CLI](https://github.com/larksuite/cli). It gives your AI agent structured access to Lark Base — the spreadsheet-database hybrid in Lark's productivity suite — so it can query records, create tables, manage fields, and run data analysis through natural language. Below are the questions people actually ask once they start using it.

## What is Lark Base and how does the skill connect to it?

Lark Base (formerly called Bitable) is a spreadsheet-database hybrid inside the Lark/Feishu suite. Think of it as a relational database with a spreadsheet front-end — you get rows, columns, field types, formulas, lookups, and views, but the interface looks like a table anyone on your team can edit. Teams use it to track projects, manage customer data, inventory, content calendars, and anything else that needs structure.

The Lark Base skill is an agent skill inside the larksuite CLI monorepo. When your coding assistant has this skill active, it can call `lark-cli base +...` commands to interact with your bases. The skill handles everything from resolving a share link to a valid `base_token`, to creating fields with complex JSON configs, to running aggregated queries across tables. You do not need to write a single API call — the skill abstracts all of that.

## How do I install the Lark Base skill?

The Lark Base skill is part of the larksuite CLI. You install it in two steps:

```bash
# 1. Install the CLI (one time)
npx @larksuite/cli@latest install

# 2. Add the Base skill to your agent
npx skills add larksuite/cli -y -g --skill lark-base
```

The `--skill lark-base` flag tells the installer to register only the Base skill rather than all 26 skills — useful if you only need Base operations. If you want the full suite (Doc, Wiki, Sheets, Calendar, Tasks, etc.), omit the flag and install everything.

Inside your agent, activate it with `/skills add lark-base` (Claude Code) or the equivalent command for your coding assistant.

## Do I need the full larksuite CLI or just the Base skill?

You need the CLI plus the skill declaration. The `npx skills add` command registers the skill with your agent so it knows the `lark-cli base +...` commands exist. But those commands only work if the `lark-cli` binary is installed on your system — the skill is essentially a routing layer that tells your agent which CLI commands to run.

If you already have `lark-cli` installed (say, for Lark Doc or Lark Wiki), adding `--skill lark-base` is a one-line operation and takes about two seconds. The Base skill shares the same binary, same authentication, and same config as all other Lark skills.

## How do I authenticate before using the Base skill?

Authentication is shared across the entire larksuite CLI. You need to:

```bash
# 1. Configure app credentials (one-time, interactive)
lark-cli config init

# 2. Log in with recommended scopes
lark-cli auth login --recommend
```

The `--recommend` flag auto-selects commonly used OAuth scopes including Base read/write permissions. The login flow opens a browser window where you approve the app. After that, credentials are stored in your OS keychain — you do not need to log in again for subsequent sessions.

If your agent reports a permission error like `91403` or `permission_violations`, the error usually means the authenticated user lacks access to that specific Base. The skill's built-in fallback logic will first try user identity (`--as user`), and only fall back to bot identity if user-scoped access fails with a resource-level error.

## What commands does the Lark Base skill expose?

Roughly 50+ shortcuts organized by domain:

| Domain | Key commands |
|--------|-------------|
| Base management | `+base-get`, `+base-create`, `+base-copy`, `+base-block-list` |
| Tables | `+table-list`, `+table-get`, `+table-create`, `+table-update`, `+table-delete` |
| Fields | `+field-list`, `+field-get`, `+field-create`, `+field-update`, `+field-delete` |
| Records | `+record-get`, `+record-list`, `+record-search`, `+record-upsert`, `+record-batch-create`, `+record-batch-update`, `+record-delete` |
| Views | `+view-list`, `+view-get`, `+view-create`, `+view-update`, `+view-delete`, `+view-set-filter` |
| Forms | `+form-list`, `+form-detail`, `+form-submit`, `+form-questions-create/update` |
| Dashboards | `+dashboard-list`, `+dashboard-block-create`, `+dashboard-block-get-data` |
| Workflows | `+workflow-list`, `+workflow-get`, `+workflow-create`, `+workflow-update` |
| Roles & permissions | `+role-list`, `+role-create`, `+role-update`, `+role-delete`, `+advperm-*` |
| Data analysis | `+data-query` (aggregation DSL) |

Your agent picks the right command based on what you ask — you do not need to memorize them. The skill's routing table maps user goals to the appropriate shortcut.

## Can I query my Base with natural language?

Yes, but there is a distinction worth understanding. For simple lookups — "show me the rows where status is 'In Progress'" — your agent uses `+record-list` or `+record-search` with a filter parameter. The agent translates your request into the correct `--filter` JSON, but the filter is explicit, not magical: field names and values must match what actually exists in the table.

For analytical queries — "what is the average deal size by region this quarter" — the skill provides `+data-query`, which is a structured aggregation DSL. Your agent will first inspect the table schema with `+field-list` to verify field names and types, then construct a `+data-query` with the right grouping, aggregation, and filter clauses. It handles paginated results and can distinguish between "all rows" and "rows in the current page."

One thing that trips people up: your agent sees only what it queries. If it reads 100 records out of 10,000, it will not volunteer "by the way, there are 9,900 more." For global conclusions — totals, averages over the full dataset — the skill routes to `+data-query` which runs the aggregation server-side.

## Can it handle formulas and lookup fields?

Yes, and this is where the skill shows its depth. Lark Base supports formula fields (similar to spreadsheet formulas but with SQL-like functions), lookup fields (cross-table references), and auto-computed fields.

When your agent needs to create or update a formula or lookup field, the skill requires reading a dedicated reference document first — the SKILL.md specifies `formula-field-guide.md` and `lookup-field-guide.md` as pre-requisite reading before constructing the JSON. This is enforced by a hidden `--i-have-read-guide` flag that the agent must pass. It prevents agents from guessing field configurations and creating broken schemas.

Practical example: a lookup field that pulls the latest status from a related table requires specifying the source table, the link field, the target field to display, and any filter. The guide walks the agent through the exact JSON structure, including edge cases like multi-select lookups and aggregated lookups (count, sum, average of linked records).

## Batch operations: how many records can I update at once?

Batch writes are capped at 200 records per call. If you need to update 1,000 records, your agent will split them into 5 sequential batches. The skill serializes these writes to the same table — concurrent writes to the same Base trigger error `1254291`, so the agent waits briefly between batches.

There is also an important distinction between `+record-batch-update` and `+record-batch-create`. The update command applies the same patch to all record IDs in the list — it is "update these 200 records with the same status value." If you need different values per row, the agent must do individual upserts (slower but more flexible). The batch-create command accepts an array of records, each with different field values, up to 200 per batch.

## Can my agent create dashboards and workflows?

It can, but the complexity varies. Creating a simple dashboard with a chart block requires:

1. `+dashboard-create` to create the dashboard
2. `+dashboard-block-create` with a `data_config` JSON that specifies the chart type, data source table, metrics, and dimensions
3. Optionally `+dashboard-arrange` for auto-layout

The `data_config` JSON is not trivial — it specifies field bindings, aggregation functions, filter conditions, and visual properties. The skill links to `dashboard-block-data-config.md` as reference, and your agent will read that before constructing the config. Components must be created serially (one at a time), not in parallel.

Workflows (Base automations) are similar: `+workflow-create` accepts a `steps` JSON that defines triggers, conditions, and actions. The skill routes to `lark-base-workflow-guide.md` and `lark-base-workflow-schema.md` for the exact structure. Creating a workflow from scratch requires understanding the step schema; updating an existing workflow is simpler because your agent reads the current config, modifies only what you asked to change, and sends the delta.

## What happens when a query returns too many records?

The skill uses server-side pagination. Commands like `+record-list` and `+record-search` accept `--limit` and `--page-token` parameters. The default page size varies by command, but your agent can request up to 500 records per page.

When `has_more=true` comes back, the agent knows there is at least one more page. For open-ended questions like "how many records match this filter", the agent should use `+data-query` with a `count` aggregation rather than paging through all records. If the agent tries to page through everything — say, fetching 10 pages of 500 records each — it will run into context window limits and the conversation quality degrades.

The skill's data analysis SOP (`lark-base-data-analysis-sop.md`) explicitly instructs agents: "Do not pull raw records to local context and filter manually. Use server-side aggregation for global conclusions." This is built into the skill's routing rules.

## How does the skill handle permissions and access control?

The skill operates under the authenticated user's identity by default (`--as user`). This means your agent can only see and modify bases that you have access to in Lark. No special permissions are required beyond what you already have — if you can open a Base in the Lark web app, your agent can query it.

There is also a bot identity mode (`--as bot`) for scenarios where the agent needs to act as an application rather than a person. This is useful for automated workflows where you want the agent to create or update records without requiring your personal OAuth session. The skill uses bot identity as a fallback — user identity is tried first, and the agent only switches to bot if user-scoped access fails with a resource-level error.

Advanced permission management (`+advperm-*` and `+role-*` commands) lets the agent configure granular access within a Base — who can view, edit, or manage specific tables. These commands require the user to have Base owner or admin permissions. The role configuration JSON is complex, and the skill references `role-config.md` before constructing role create or update requests.

## One question I wish people asked

**"Does the skill distinguish between 'I need to see data' and 'I need to analyze data'?"**

It does, but most users do not realize how much thought went into this distinction. The Lark Base skill has two fundamentally different code paths for reading data:

- **Record queries** (`+record-list`, `+record-search`, `+record-get`) return raw rows with `record_id`, field values, and pagination metadata. These are for browsing, reading specific records, or extracting data to present to the user.

- **Aggregation queries** (`+data-query`) return computed results — counts, sums, averages, min/max, groupings — executed server-side. The response includes the aggregation result plus dimension fields for grouped queries, but critically, **no `record_id` is returned**. You can have the numbers without having access to individual rows.

This is not an accident. The separation means your agent can answer "how many overdue tasks per assignee" by reading 1 server-side aggregation result instead of paging through thousands of records. It also means users who have view-only access to a Base (no read on individual records) can still get aggregate statistics. Most people using the skill for the first time do not know this exists, and they end up with slow, context-clogging record queries when a single `+data-query` would have been instant.

If you do one thing after reading this FAQ, test `+data-query` on your largest Base. The difference in response time is noticeable.

## Where to go next

- Read the [Lark Base skill intro](/skills/automation/lark-base/) for a quick overview of what the skill does
- Check the [larksuite CLI documentation on GitHub](https://github.com/larksuite/cli) for full command reference
- If you use Lark Doc alongside Base, the [Lark Doc vs Lark Wiki comparison](/tutorials/comparison/lark-doc-vs-lark-wiki/) explains how the sibling skills differ
- For installation troubleshooting, the [AI agent skills FAQ](/tutorials/guides/faq-installing-ai-agent-skills/) covers common setup issues
