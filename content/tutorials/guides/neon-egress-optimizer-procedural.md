---
title: "Neon Egress Optimizer Skill: 4 Steps, 139 Scored Runs"
date: 2026-11-02
toc: true
draft: false
tags:
  - Postgres
  - Neon
  - Cost Optimization
category: "guides"
description: "Neon ships 139 recorded eval runs next to its egress-optimizer skill. Here are the four steps, the diffs that fixed each problem, and what the scores hide."
---

`neon-postgres-egress-optimizer` is a four-step procedure for cutting the bytes your app pulls out of Postgres: diagnose with `pg_stat_statements`, analyze the code behind the worst queries, fix five named anti-patterns, verify. The unusual part is not the procedure. It is that Neon committed the eval harness next to it — 139 scored runs, 139 saved diffs, three numbered skill versions — so you can check whether the advice works before you install anything.

I pulled the repo on 2026-11-02 ([neondatabase/agent-skills](https://github.com/neondatabase/agent-skills), 110 stars, last push 2026-10-30, nine skills), read the 10,419-byte SKILL.md, recomputed every rate in `evals/neon-postgres-egress-optimizer/results.csv`, and diffed skill v001 against v003 and against what actually ships. Two of those three comparisons changed my read of the skill.

## Step 1: Diagnose — Find the Queries That Move the Bytes

The skill opens by checking that the extension exists, and it does not assume it does:

```sql
SELECT 1 FROM pg_stat_statements LIMIT 1;
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
```

Then a trap that catches almost everyone on serverless Postgres. Stats reset when a Neon compute scales to zero and wakes up, so a quiet project often shows empty tables that look like a broken extension. The fix is in the file: `SELECT pg_stat_statements_reset()`, drive representative traffic for at least an hour, then read. One hour, not five minutes — the whole diagnostic is worthless on a sample of twenty requests.

Four queries do the ranking, and they sort differently on purpose: by total rows returned, by rows per execution, by call count, and by execution time. The second one catches the failure most people miss — a query called four times a day that returns 1,000 wide rows each time beats a query called 50,000 times that returns ten narrow rows.

The arithmetic that makes this page worth reading: 1,000 rows carrying a 50KB JSONB column is roughly 50MB per call. The fixture Neon built for its eval uses exactly those widths — `description` at ~5KB, `raw_payload` at ~50KB — because that is where bills come from.

If you have no access to production stats, the skill says to skip to Step 2 rather than stall. Code-level patterns catch four of the five problems without a single metric.

## Step 2: Analyze — Five Questions, and Why This Section Changed Between Versions

Compare v001 to v003 and the substantive edit is one block. v001 said:

> For each high-egress query, find the corresponding application code and identify what the response actually uses versus what the query fetches.

v003 replaced that single sentence with five questions:

- Does it select only the columns the response needs?
- Does it return a bounded number of rows (LIMIT/pagination)?
- Is it called frequently enough to benefit from caching?
- Does it fetch raw data that gets aggregated in application code?
- Does it use a JOIN that duplicates parent data across child rows?

Nothing else moved. Same fixes, same steps, 288 bytes added across the whole file (7,707 → 7,995). And the five problems in the eval map one-to-one onto those five questions. Read as one sentence, "identify what the response uses" invites the agent to solve column overfetching and call it a day; read as five questions, each one gets an answer or gets skipped explicitly. If you only remember one thing from this skill, remember that its measured improvement came from converting prose into a checklist.

## Step 3: Fix — What the Good Diffs Actually Did

Five anti-patterns, each with a before/after the skill spells out. The interesting one is the last, because it is the one agents consistently "fix" wrong.

**Column overfetch.** Name the columns. `SELECT *` → `SELECT id, name, price, image_urls`.

**Missing pagination.** `ORDER BY id LIMIT 50 OFFSET 0`, and flag it no matter how small the table is today.

**High-frequency reads of static data.** Cache. The skill suggests reusing whatever cache the app already has and names Upstash Redis for serverless and edge runtimes that cannot hold a pool.

**Application-side aggregation.** If the handler pulls every review row and computes `AVG` with `.reduce()`, the egress is the whole table for a tiny JSON response. Push it into SQL with `GROUP BY`, `AVG(rating)`, `COUNT(*)`.

**Join duplication.** This is the one worth a side-by-side. Here is what a baseline run did to `GET /products/:id`, the route that joins a product to its reviews:

```ts
// baseline: narrowed the columns, kept the join
const rows = await db.select({ products: { id: products.id, name: products.name, ... }, reviews })
  .from(products)
  .leftJoin(reviews, eq(reviews.productId, products.id))
```

Every review row still repeats the product's wide columns. With 200 reviews and a 50KB payload that is roughly 10MB for one request, and narrowing the column list does not touch it. The v003 run on the same fixture deleted the join and ran two queries: product by id, then reviews by `product_id`. Same response shape, no duplication.

Neon's rubric makes the distinction explicit, which is rare and useful: narrowing columns on a join counts as a P1-style fix, not P5 detection. An agent that does it and declares victory has fixed nothing.

A pagination fix from a passing run, for reference — the interesting part is the clamp, not the limit:

```ts
const limit = Math.min(Number(c.req.query("limit") || 50), 100);
const offset = Number(c.req.query("offset") || 0);
```

## Step 4: Verify — Three Checks, One of Which Nobody Runs

Run the tests. Check the responses still have the shape clients expect — pagination especially, since a client that assumes an array will break on `{ data, nextCursor }`. Then reset `pg_stat_statements`, let traffic run, and re-rank. The last step is the entire point of the exercise and it is also the one that gets skipped, because the fixes look obviously correct.

There is a fourth check the skill's own runbook adds, and it matters more than it sounds: confirm the agent actually loaded the skill. Claude Code prints `Skill(neon-postgres-egress-optimizer) — Successfully loaded skill` when it does. If that line is missing, the run is a baseline, not a skill run, and the runbook tells you to abort and force it with `/neon-postgres-egress-optimizer <prompt>`.

## What the 139 Runs Actually Say

The table below is my recount from `results.csv`, not a copy of the README. 89 baseline runs, 4 on v001, 4 on v002, 42 on v003, all on `opus-4.6-high-effort`, all within 2026-03-11 to 2026-03-15, every run with its own saved diff.

| Problem | Baseline (n=89) | v003 (n=42) |
|---|---|---|
| P1 SELECT \* unused columns | 100% | 100% |
| P2 Missing pagination | 0% | 57% |
| P3 High-frequency query | 0% | 12% |
| P4 App-side aggregation | 98% | 100% |
| P5 Join duplication | 28% | 100% |

Those numbers match the README's summary exactly, which is a good sign for the repo and a slight anticlimax for me. Three things the table does not say, though:

**P1 is a null result.** The model catches unused columns 89 times out of 89 with no skill at all. If column overfetch is your only problem, this skill buys you nothing.

**P2 at 57% is a real effect with a wide error bar.** Wilson interval on 24/42 is roughly 42–71%, against 0–4% for the baseline's 0/89. So the improvement is solid, and a third of runs still miss it.

**The README drops v001 and v002 for sample size, and that hides the noise.** v002 scored 4/4 on P2 in four runs — 100% — while v003 scored 57% across 42. Same skill family, same fixture, same model. Four runs will tell you almost anything.

P3 is the one the authors predicted would fail. It needs `pg_stat_statements` data to spot, and the two eval prompts carry none, so 12% means five runs out of 42 picked it up from call-site intuition rather than from a measurement.

One counterintuitive detail from splitting the rows by prompt: the vague one wins. Prompt A — "My Neon bill spiked to $400 this month, most of it is data transfer. Help me figure out why." — produced P2 detection 13/21 (62%). Prompt B, the tidier "Optimize the database egress in this project," got 11/21 (52%). A user with a complaint gets a better audit than a user with an instruction.

Tests passed on all 139 runs. Read that as a warning, not a badge. The fixture's `tests/products.test.ts` asserts the list endpoint returns an array of length 5 and checks four keys per item; the fixture has five products, and a default `limit` of 50 never truncates. So a run that changes the list response into a paginated envelope, or adds a default page size, still passes. The suite does not pin the contract it is supposed to protect, which is why "tests passed" and "response shape unchanged" are separate checks in Step 4.

Also worth noting: the `notes` column is empty in all 139 rows, even though the runbook explicitly asks you to record the case where the skill failed to load.

## The Shipped File Is Not the One That Was Measured

v003 is 7,995 bytes. The SKILL.md in `skills/` today is 10,419 — 2,424 bytes larger. What got added after the eval window:

- a `metadata` block naming `neon` as the parent skill, plus a "read the parent first" instruction and the `neon skills -s neon -y` install line
- an Upstash Redis link in the caching fix
- an entire `neon.ts` section on infrastructure as code: `defineConfig` from `@neon/config/v1`, `ttl: "7d"` for ephemeral branches, `autoscalingLimitMinCu: 0.25`, `autoscalingLimitMaxCu: 1`, `suspendTimeout: "5m"`, applied with `neon config apply`

That last section is about compute cost on dev and preview branches, not egress, and the text is careful to say so — "complementary, not a substitute." Fine advice. It also means the shipping version has never been scored, and the numbers above describe a file you cannot download anymore.

## How to Run It

Install the pack with `neon skills -s neon -y`, then ask for egress help in the same breath as the symptom — the eval says a specific complaint beats a general instruction. Read your own `pg_stat_statements` before touching code, since the model cannot see it unless you paste it. Then check the diff against Neon's own rubric line: did it remove the join, or just narrow the columns?

If you like this style of evidence — a skill that ships its own scored runs — the [minimal-run-and-audit writeup](/tutorials/guides/minimal-run-and-audit-procedural/) covers a RigorPilot script that records execution proof the same way, and it has the same weakness: the numbers look cleaner than the underlying process.
