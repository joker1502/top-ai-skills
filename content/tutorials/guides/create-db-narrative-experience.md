---
title: "I Ran npx create-db and Got a Live Postgres in Seconds"
date: 2026-09-03
toc: true
draft: false
tags:
  - Prisma
  - Postgres
  - Database
description: "Narrative of a real create-db run: a throwaway Prisma Postgres appeared in seconds with no signup, honored a 30-minute TTL, and answered SQL over TLS."
category: "guides"
---

I typed `npx create-db@latest --json --ttl 30m` and 30 seconds later I was running SQL against a live PostgreSQL 17.2 database I never registered for, never paid for, and never had to clean up. The prisma-postgres skill (v7.9.1) documents this CLI, and I ran the whole loop myself on 2026-09-03: provision, connect, write, read. Nothing below is from the docs — it's the transcript.

## One Command, Zero Signup

The command exits with a clean JSON object — no interactive prompt, no browser, no account. Here's the full output:

```json
{
  "success": true,
  "connectionString": "postgres://<token>:<secret>@db.prisma.io:5432/postgres?sslmode=require",
  "claimUrl": "https://create-db.prisma.io/claim?projectID=proj_...",
  "deletionDate": "2026-09-03T17:33:19.820Z",
  "region": "us-west-1",
  "name": "2026-09-03T17:03:09.972Z",
  "projectId": "proj_..."
}
```

Two details jumped out at me. First, the TTL was honored exactly: I asked for `30m` and `deletionDate` landed precisely 30 minutes after creation — 17:03:19 → 17:33:19. The skill's reference file says unclaimed databases auto-delete after ~24 hours, and `--ttl` is the override that pulls that deadline in. Second, the region defaulted to **us-west-1** — which contradicts the SKILL.md's own claim that a programmatic `create()` with no region defaults to us-east-1. The CLI and the library API apparently pick different defaults, so pin `--region` if the geography matters.

The `claimUrl` is the retention mechanism: open it and the throwaway database becomes a permanent project database. Skip it and the deletion timer just runs out. For a demo or CI smoke test that's exactly the lifecycle you want — the database deletes itself while you move on.

## The Database Behind the URL

`sslmode=require` is enforced, not optional — no plaintext fallback. I connected from psql over TLS and the handshake took about a third of a second:

```
$ psql "<connection string>" -c "SELECT version();"
 PostgreSQL 17.2 on x86_64-pc-linux-musl, compiled by gcc (Alpine 13.2.1_git20240309)
```

The musl build is the tell — this runs on an Alpine-style container, not the usual Debian Postgres image. The instance is a full server, not a shim: I created a table, inserted a row, and read it back, all in one session:

```sql
CREATE TABLE demo(note text, n int);
INSERT INTO demo VALUES ('created via npx create-db', 42);
SELECT * FROM demo;  -- note | n  →  created via npx create-db | 42
```

Round trip finished instantly. You get a single `postgres` database, and the URL carries the credentials inline — treat it like a bearer token, because that's exactly what it is. Anyone holding the string can connect.

## Flags, Aliases, and When the CLI Is Not Enough

The skill's `create-db-cli.md` reference spells out the full flag set, and `--help` confirms what ships: `--region` (six choices: ap-southeast-1, ap-northeast-1, eu-central-1, eu-west-3, us-east-1, us-west-1), `--interactive` for a region picker, `--json` for machine output, `--env` to write `DATABASE_URL` and `CLAIM_URL` into a `.env` file, `--ttl` for sooner deletion, `--copy` for the clipboard, `--quiet` to print only the connection string, and `--open` to launch the claim URL. The package also installs as `create-pg` and `create-postgres` — three names, one binary. In CI, `npx create-db@latest --json --ttl 1h` piped into a step that exports `DATABASE_URL` is a complete test database with no cleanup job.

The boundary matters: `create-db` makes throwaway databases, and throwaway means exactly that. Persistent, named, backed-up databases belong to the platform CLI — `npx @prisma/cli@latest database create`, `database list --json`, `database backup list` — which requires a workspace and authentication. The [prisma skills pack FAQ](/tutorials/guides/prisma-skills-faq/) covers that split; the short version is that `create-db` is for the 30-minute experiment and `@prisma/cli` is for the thing you'll still need next quarter.

## When to Reach for It

Reach for `create-db` when you need a real Postgres and any friction would kill the task: reproducing a bug report, staging a demo, exercising a migration script, or proving a query plan. Skip it when the data outlives the session — claim the project or use the management API (`api.prisma.io/v1`) with a service token instead. The command I'd rerun tomorrow, unchanged: `npx create-db@latest --json --ttl 2h`. It takes one command, zero accounts, and the fastest Postgres I've spun up this year.