---
title: "I Tested Supabase's Postgres Skill on 500k Rows"
date: 2026-11-03
toc: true
draft: false
tags:
  - PostgreSQL
  - Database
  - Performance
category: "guides"
description: "Five rules from Supabase's Postgres skill on a live 500k-row database: 41ms to 0.19ms on a missing index, 127x on cascades, and one rule I could not reproduce."
---

Supabase's `supabase-postgres-best-practices` skill is a 3.2 KB SKILL.md pointing at 34 reference files, 31 of them rules, each carrying a predicted speedup. Missing index: 100-1000x. Foreign key index: 10-100x. Partial index: 5-20x smaller. RLS function wrapping: 5-10x, "100x+ on large tables."

Those numbers decide whether an agent rewrites your schema or leaves it alone, so I wanted to know which ones survive contact with a real database. I spun up a throwaway Postgres, loaded 500,000 orders across 25,000 users and 5,000 customers, and ran five rules from the skill as written. Four held. One never got off the ground, and the reason is worth more than the speedup.

## The Setup: One Table, Half a Million Rows

A temp database through `npx create-db@latest --json --ttl 30m` gave me a real Postgres with no local server to babysit. The schema mirrors the skill's own examples: `customers(id primary key)`, `orders(customer_id references customers on delete cascade, user_id uuid, total, status, created_at, deleted_at)`. Half a million rows, 80% soft-deleted, 2% pending, and no indexes beyond the primary keys.

The table weighed 58 MB once loaded. Then I ran the queries the skill tells you to fix.

## Rule 1: Index the Filter Column — 94x to 214x

`select count(*) from orders where customer_id = 123` against an unindexed column. Two runs: 41.557 ms and 40.840 ms. The plan is a parallel seq scan, 6,025 shared buffers hit, 166,633 rows removed by filter per worker to return 100 matches.

Then `create index orders_customer_id_idx on orders (customer_id)` and the same query: 0.439 ms cold, 0.194 ms warm. It flips to a Bitmap Index Scan, 103 buffers, exact heap blocks.

That works out to 94x on the cold run and 214x on the warm one. The skill advertises 100-1000x, which is the right order of magnitude and slightly optimistic at this size — and note that all 58 MB was already sitting in shared buffers, the friendliest possible case. On a cold cache or a bigger table the gap widens, not narrows. Verdict: holds.

## Rule 2: Index the Foreign Key — 127x on Cascade Delete

This one surprised me in the other direction. The skill scores it 10-100x. I deleted 200 customers with 100 orders each, 20,000 rows total, and timed the whole statement.

Without an index on `orders.customer_id`: **6,142 ms**. The `ON DELETE CASCADE` trigger has to scan the child table once per deleted parent row.

With `create index orders_customer_id_idx on orders (customer_id)`: **48.3 ms**.

127x, past the top of the advertised range. A single-customer delete shows the same shape at smaller scale — the trigger cost dropped from 31.3 ms to 0.6 ms. Deletes look cheap in development because child tables are tiny, and the penalty lands in production with no warning. Verdict: holds, and it bites hardest there.

## Rule 3: Partial Index — 4.95x Smaller, and the Planner Uses It

The skill claims partial indexes run 5-20x smaller. On `user_id` with `where deleted_at is null`:

| Index | Definition | Size |
|---|---|---|
| Full | `(user_id)` | 4,040 kB |
| Partial | `(user_id) where deleted_at is null` | 816 kB |

4.95x, just under the floor of the advertised range, on a table where 80% of rows were soft-deleted. The mechanism comes down to arithmetic — a partial index only carries the 20% of rows that match — so your mileage depends entirely on how much dead weight the predicate filters out. At 80% dead the ratio is 5x; at 50% dead it would be about 2x.

The part that matters more: the planner actually picked it. `where user_id = … and deleted_at is null` produced a Bitmap Index Scan on `orders_active_user_idx` at 1.03 ms. A partial index only gets used when the query repeats the `WHERE` clause verbatim or implies it. Write `deleted_at is not distinct from null` or filter on a different flag and it silently falls back to the full index. Verdict: holds, with a matching caveat the file already prints.

## Rule 4: Wrap `auth.uid()` in a Subquery — Could Not Reproduce

The RLS rule is the loudest in the skill: `using (auth.uid() = user_id)` calls the function per row, so wrap it as `using ((select auth.uid()) = user_id)` and get "100x+ faster on large tables."

My first run showed no difference at all — 86.7 ms naive versus 87.2 ms wrapped — and the plans were identical. Both had a `Filter: (status = 'completed')` clause and neither mentioned `auth.uid()`. Something was wrong with the test, not with the rule.

The session user was `prisma_migration`, and `select usesuper from pg_user where usename = current_user` returned `t`. Superusers bypass row-level security unconditionally, even with `ALTER TABLE orders FORCE ROW LEVEL SECURITY`. The policies were created, enabled, and completely ignored. When I tried to fix it the proper way by creating a non-superuser role, Postgres refused: "restricted superuser cannot create roles." On a managed instance you often cannot provision the role you would need to test this rule at all.

So I tested the expression instead of the policy, where the mechanism actually lives:

```
where auth.uid() = user_id            -> Index Cond: (user_id = (COALESCE(NULLIF(current_setting(...)))))::uuid)   0.155 ms
where (select auth.uid()) = user_id   -> InitPlan 1 + Bitmap Index Scan on (InitPlan 1).col1                        0.118-0.449 ms
```

`auth.uid()` is declared `language sql stable`, so the planner inlined the function body straight into the index condition. With an index on `user_id`, both forms became index scans over 22 blocks and the per-row evaluation cost never materialized. The wrapper did appear as an InitPlan, exactly as the rule says. It bought nothing measurable, because nothing scanned 500,000 rows.

That is the honest shape of this rule: the per-row cost only exists when the RLS predicate cannot use an index. Put `auth.uid()` on a column with no index, and the plan degrades to a seq scan calling the function per row — which is the scenario the file is warning about. Verdict: not reproducible as written, and worth testing on your own instance rather than trusting the 100x.

## Rule 5: Keyset Pagination — 316x on a Deep Page

Last one, cheapest to verify. Page 24,951 of 20 rows:

- `order by id limit 20 offset 499000` — 87.502 ms, index scan touching 499,020 rows.
- `where id > 499000 order by id limit 20` — 0.277 ms, index scan touching 20 rows.

316x. The skill calls this O(1) versus O(offset), and it wins more mechanically than any other rule in the file, with one catch it also mentions: the cursor has to carry every sort column, so multi-column sorts need a composite comparison like `(created_at, id) > ('2024-01-15 10:00:00', 12345)`. Get that wrong and you skip or duplicate rows at page boundaries.

## What I'd Do Differently Reading This Skill

The rules are accurate enough to act on, which is more than most "best practices" collections manage. The predicted multipliers are directional, not literal: one rule underperformed its floor, one beat its ceiling, and one was untestable in a managed environment where the connection is a superuser.

What the skill cannot tell you is that your first RLS test may be lying to you. If policies get created with no error and no effect, check `usesuper` before you rewrite anything — I burned two runs and a role-creation error before I thought to look.

The full rule set lives on [our page for the skill](/skills/general/supabase-postgres-best-practices/), with the category prefixes (`query-`, `conn-`, `security-`, `schema-`, `lock-`, `data-`, `monitor-`, `advanced-`) matching the reference filenames, so an agent can pull one file per problem instead of all 34. If you want the same discipline applied to a script rather than a database, the [minimal-run-and-audit walkthrough](/tutorials/guides/minimal-run-and-audit-procedural/) is the same idea with a runner and a log.
