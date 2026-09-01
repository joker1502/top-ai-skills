---
title: "Prisma Skills Pack FAQ: Nine Agent Skills, One ORM"
date: 2026-09-01
toc: true
draft: false
tags:
  - Prisma
  - AI Coding
  - ORM
description: "Straight answers on Prisma's nine official agent skills: what each covers, why the v7 upgrade demands driver adapters, and what 253K installs signal."
category: "guides"
faq:
  - question: "What is the Prisma skills pack and what ships in it?"
    answer: "It's the official set of nine agent skills from prisma/skills covering the ORM and the platform: prisma-cli (command reference), prisma-client-api (query API), prisma-database-setup (per-provider config), prisma-upgrade-v7 (v6→v7 migration), prisma-mongodb-upgrade (MongoDB decision path), prisma-postgres and prisma-postgres-setup (Prisma Postgres platform), prisma-compute (app deployment), and prisma-driver-adapter-implementation (custom driver adapters). All follow the Agent Skills format and install with npx skills add."
  - question: "Why do all nine skills show nearly identical install counts?"
    answer: "Because they're one pack counted nine times. On the 2026-09-01 skills.sh scrape, the nine ranged from 235,757 (prisma-mongodb-upgrade) to 253,040 (prisma-database-setup) — a 17K spread across the whole set, with lockstep weekly curves: prisma-cli at [43,794, 41,486, 39,813, 20,907] and prisma-compute at [43,410, 41,201, 39,452, 20,586], four weeks of matching waves. The same pack-counter signature shows up in azure-skills (nine skills, 235–499K, identical wave shapes). Treat the totals as 'the pack is installed a lot', not as per-skill usage heat."
  - question: "Is prisma-cli the ORM skill or the Platform CLI skill?"
    answer: "The ORM one — and the SKILL.md carries an explicit boundary warning about the mix-up. The stable ORM command is `prisma` (this skill, version 7.9.1). The public-beta Platform package is `@prisma/cli` with binary `prisma-cli`, routed to the prisma-compute skill. The file spells it out: use prisma-compute for Compute apps and workspace auth, prisma-postgres for Platform projects and databases, and this skill for ORM commands like init, generate, migrate, db push/pull, dev, debug, and studio."
  - question: "What actually breaks when upgrading Prisma to v7?"
    answer: "Four headline changes per prisma-upgrade-v7 (v7.6.0): the generator moves to `prisma-client` with required output paths and generated entrypoints (client, browser, models, enums), driver adapters become mandatory for SQL providers, config moves to prisma.config.ts with explicit environment loading, and the module system goes ESM-first with a CommonJS fallback via moduleFormat = 'cjs'. It also lists removed features — middleware, metrics, and legacy CLI behavior — plus a special section for Accelerate users. The skill's crash case is import errors right after upgrade, which trace back to the new generated entrypoints."
  - question: "Does the v7 upgrade guide apply to MongoDB projects?"
    answer: "No, and the skill says so on the first page: 'Using MongoDB? This guide does not apply.' Prisma v7 has no MongoDB connector, so prisma-mongodb-upgrade exists as a separate decision and migration skill. It lays out the landscape — v6 is terminal for MongoDB, v7 has no path, Prisma Next is the successor — with a stay-on-v6 vs migrate-now decision table, schema/contract and client API mapping, and a cutover checklist with no-go signals. If an agent proposes an 'upgrade MongoDB to v7' plan, that plan is wrong out of the box."
  - question: "What runtime prerequisites do the skills assume?"
    answer: "prisma-database-setup pins Node.js 20.19.0+ and TypeScript 5.4.0+, with provider guides for PostgreSQL, MySQL, SQLite, SQL Server, MongoDB, and CockroachDB. The file has one Bun-specific rule worth stealing: run CLI commands with `bunx --bun prisma` so Prisma uses the Bun runtime instead of silently falling back to Node. The client-api skill (v7.9.1) organizes its reference by priority — model queries, transactions, and raw SQL are CRITICAL; client construction, query shape, filters, and relations are HIGH."
  - question: "Which skill should I install first?"
    answer: "prisma-cli, then prisma-database-setup — that pair covers the daily loop: init, generate, migrate, db operations, plus per-provider config and connection-string troubleshooting. Add prisma-client-api when your agent writes real queries, prisma-upgrade-v7 the week you plan a v6→v7 migration, and prisma-mongodb-upgrade if MongoDB is in the mix. Skip prisma-compute and the two prisma-postgres platform skills unless you're deploying Compute apps or using Prisma Postgres — they cover paid platform workflows, not the ORM."
  - question: "What does the postgres platform skill cover that database-setup doesn't?"
    answer: "prisma-postgres (v7.9.1) is about the hosted product: provisioning instant databases with a create-db CLI (flags include --ttl, --copy, --quiet, --open), linking local projects with `prisma postgres link`, managing resources through the Management API or its typed SDK, and connection choices between direct TCP and serverless drivers. prisma-database-setup stays in ORM-land — provider strings, env-var configuration, and client instantiation. The boundary is the same flavour as cli-vs-compute: platform vs ORM, and the pack keeps the two deliberately separate."
---

{{< faq-schema >}}

## Why a Prisma Skills Pack FAQ Exists

Prisma shipped a full agent-skills pack without much fanfare, and most walkthroughs still treat it as one skill. It's nine. The pack covers the ORM CLI, the client API, per-database setup, the v6→v7 migration, MongoDB's unique dead-end, two hosted-postgres skills, app deployment, and custom driver adapters — with some genuinely sharp boundaries drawn between them. I wrote these answers after pulling the SKILL.md files out of prisma/skills and reading them line by line, alongside the 2026-09-01 skills.sh install snapshot. Every claim below traces to a file in that repo, not to a README summary.

## The Short Answers

- **One pack, nine skills.** Install them together; they share the same version train and the same workflow-first philosophy.
- **The numbers are a pack counter.** 235K–253K with lockstep weekly waves means "the pack got installed", not "client-api is more popular than cli".
- **The cli skill is the ORM.** The Platform's `@prisma/cli` belongs to prisma-compute — the boundary warning in the file is there because people keep confusing the two.
- **v7's breaking changes are named.** Driver adapters required, prisma-client generator, prisma.config.ts, ESM-first with a CommonJS escape hatch.
- **MongoDB has no v7 path.** v6 is terminal, Prisma Next is the successor; an agent that says "upgrade MongoDB to v7" is hallucinating.

## What the Leaderboard Numbers Actually Tell You

The 2026-09-01 scrape put the pack's nine skills between 235,757 and 253,040 installs — a tighter cluster than any other family on the board, with weekly curves moving in lockstep. Step back and the signature is unmistakable: this is the same pack-counter pattern we documented for [azure-skills](https://github.com/microsoft/azure-skills) in the [azure-messaging intro](/skills/automation/azure-messaging/) and [azure-diagnostics intro](/skills/automation/azure-diagnostics/) — install counts measure bundle adoption, not individual skill popularity. The prisma pack's curve shape differs from azure's in one way worth noting: azure rides a long plateau, while prisma's weekly wave drops from a ~43K peak to ~20K over four weeks, which fits a newer pack burning off initial installs. Trust the files for per-skill signal, the totals for pack-level reality.

## Common Mistakes to Avoid

**Mistake #1: Treating prisma-cli as the platform CLI.** The SKILL.md boundary section exists because this one bites constantly. ORM commands live in prisma-cli; `@prisma/cli` app deployment lives in prisma-compute; hosted-database work lives in prisma-postgres.

**Mistake #2: Running v7 upgrades on MongoDB projects.** The upgrade skill explicitly disclaims itself, and v7 has no connector. Route MongoDB through prisma-mongodb-upgrade and its stay-or-migrate decision table instead.

**Mistake #3: Assuming install totals rank individual skills.** A pack that moves as one unit on the leaderboard rewards you with no per-skill heat map. Judge prisma skills by their file contents, versions, and your actual workflow.

**Mistake #4: Forgetting the Bun flag.** On Bun runtimes, `bunx prisma` without `--bun` silently uses the Node runtime. The skill's `bunx --bun prisma` convention is a one-word fix for a whole class of subtle runtime mismatch bugs.

## Start With the CLI Pair

Grab prisma-cli and prisma-database-setup first — that pair covers six of your ten daily ORM interactions. `npx skills add https://github.com/prisma/skills` pulls the pack, then let your agent read the SKILL.md files before touching a schema. If you're sitting on a v6 codebase, add prisma-upgrade-v7 to the install and read its removed-features list before you run a single migration command — it names exactly which flags and middleware will vanish. And when a teammate asks whether "skills" are just prompts, point them at the [how to create your own AI agent skills](/tutorials/guides/how-to-create-your-own-ai-agent-skills/) guide so they can see how much structure a real skill pack carries.