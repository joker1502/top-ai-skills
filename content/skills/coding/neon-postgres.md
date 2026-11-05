---
title: "Neon-Postgres Skill: 18,131 Tokens and a Parent You Must Install"
date: 2026-11-05
toc: true
draft: false
tags:
  - Neon
  - Postgres
  - Agent Skills
category: "coding"
description: "Neon's neon-postgres skill loads 4,303 tokens of SKILL.md plus 13,828 in references, and it refuses to start until its parent neon skill is installed."
---

The first line of the `neon-postgres` skill is not an instruction about databases. It reads **FIRST**: use the parent `neon` skill. So a skill you installed to answer schema and SQL questions opens by telling you it cannot do that alone.

I pulled all seven skill folders from [neondatabase/agent-skills](https://github.com/neondatabase/agent-skills) on 2026-11-05, weighted every file with `cl100k_base`, and ran the docs URL the skill points at. The load cost is the part nobody publishes: 4,303 tokens for the SKILL.md body, plus 13,828 across six reference files, before an agent reads a single line about your database.

## What the Parent Dependency Actually Costs

The repo ships seven skills — `neon`, `neon-postgres`, `neon-auth`, `neon-functions`, `neon-object-storage`, `neon-realtime`, `neon-ai-gateway`. The router `neon` is the largest single file in the set at 37,199 bytes, 8,648 tokens. The leaf I read is less than half that. Install the leaf and you inherit a pointer to something twice its size.

That fallback path is a plain fetch of `https://neon.com/docs/ai/skills/neon/SKILL.md`. I downloaded it and compared. Byte for byte identical to `skills/neon/SKILL.md` on `main`, same 37,199 bytes, no drift between the docs host and the repo. Rare enough to be worth saying out loud, since a stale docs copy is the normal failure mode for skill mirrors.

The CLI route is also checkable without installing anything. `npm view neonctl version` returns 8.23.1 with bins `neon` and `neonctl`; the `neon` package resolves to the same 8.23.1 and exposes only the `neon` bin. So `neon skills -s neon -y`, the install line inside the leaf, comes from an alias package rather than a separate tool.

Here is the split, measured:

| File | Bytes | Tokens |
| --- | --- | --- |
| `neon-postgres/SKILL.md` | 19,382 | 4,303 |
| `references/branching.md` | 12,665 | 2,885 |
| `references/vector-search.md` | 12,498 | 2,749 |
| `references/lakebase-search-drizzle.md` | 10,159 | 2,505 |
| `references/hybrid-search.md` | 10,612 | 2,483 |
| `references/egress-optimization.md` | 9,498 | 2,149 |
| `references/full-text-search.md` | 4,324 | 1,057 |
| Router `neon/SKILL.md` | 37,199 | 8,648 |

Four of the six references are search — vector, hybrid, BM25 full-text, plus a Drizzle pairing guide — and they total 8,794 tokens, 64% of the reference budget. Branching and egress split the remaining 5,034. If your work is plain schema and migration, you still pay to see the search stack listed in the body, twice: once in the description block, once in the routing paragraphs.

## Pooled or Direct, Decided by Task Not by Environment

The skill answers the connection-string question with a lookup table instead of a rule of thumb, and it is the most reusable page in the file. Web apps and serverless functions take the pooled `-pooler` host. Everything that needs session state takes direct: schema migrations, `pg_dump` and `pg_restore`, logical replication, long-running analytics with temp tables, admin tasks that run `SET`, and `LISTEN`/`NOTIFY`.

The migration section repeats the trap because it bites twice. `neon connection-string` returns the *direct* string by default, so an agent that grabs a URL for the app and reuses it for a migration gets lucky — and an agent that grabs the pooled URL the app uses gets a migration that dies halfway with no obvious cause. The check the skill asks for is one grep: the hostname must not contain `-pooler`.

## The Diagnostics You Should Not Hand-Write

Neon ships seventeen read-only checks behind `neon inspect db <check>`, mirrored by the MCP tool `inspect_database` with a single `check` per call. The mapping table is symptom-first: storage hogs to `table-sizes` and `index-sizes`, unused or heavily-scanned indexes to `unused-indexes` and `seq-scans`, stuck work to `long-running-queries` and `locks`, load shape to `outliers` or `calls`, cache fit to `lfc-hit-rate` and `working-set`, vacuum debt to `vacuum-stats` and `bloat`.

Three of those names get confused in practice, and the author calls it out explicitly. `long-running-queries` means statements running **right now** for over five minutes. `outliers` ranks by cumulative execution time since stats reset, not mean latency. `calls` ranks by execution count over the same history. Pick the wrong one and you get a confident answer to a question nobody asked.

Extension gates are stated in the body rather than buried in a reference. `outliers` and `calls` need `pg_stat_statements`; `lfc-hit-rate` and `working-set` need the `neon` extension. If a check reports one missing, the instruction is to ask before running `CREATE EXTENSION`, because installing an extension modifies the database. Small detail, large difference from an agent that improvises a DDL statement to unblock itself.

Same posture on indexes. `unused-indexes` is a candidate list, not permission to drop. Confirm the observation window, the constraints, and the workload first. A sequential scan on a small table is correct behavior, not a finding.

## Where It Stops and Hands Off

The egress section runs four steps — diagnose the queries moving the most data, read the code behind them, fix the anti-patterns, verify behavior held and transfer dropped — and audits five patterns: unused columns, missing pagination, repeated static reads, application-side aggregation, JOIN duplication. The skill adds one line worth keeping: do not stop after fixing `SELECT *`. That single fix is what most audits report as done.

Generic Postgres tuning is out of scope by design. When the evidence points at rewriting a query, choosing an index, or reading a plan node, the body routes to the sibling [postgres-best-practices](https://github.com/neondatabase/postgres-skills) skill and tells you to carry the diagnostic evidence across. Search, realtime, auth, functions, storage and the AI gateway each route to their own child skill.

On the [skills.sh board](https://www.skills.sh/) on 2026-11-05 — 185 rows scraped from the homepage sparklines — `neon-postgres` is the only Neon skill listed, at rank 167 with 303.2K total installs and weekly buckets `[17,462, 17,035, 18,096, 20,257, 20,832, 21,499, 22,834, 18,319]`. The router, auth, realtime, functions, storage and AI gateway skills do not appear at all. Treat the 303K as a floor for the family, not a measure of it, and treat the parent-dependency chain as the reason the effective install is larger than the number suggests.

If your work is Postgres on Neon and you want the cost side, the [egress optimizer workflow](/tutorials/guides/neon-egress-optimizer-procedural/) walks the five patterns against a real query log. If you want the auth half of the same repo, [neon-auth](/skills/general/neon-auth/) covers login and sessions. Install the leaf only after the parent is in place — otherwise your agent spends its first turn fetching a skill instead of reading your schema.
