---
title: "Supabase Postgres Best Practices"
date: 2026-06-01
draft: false
tags:
  - Database
  - PostgreSQL
description: "Supabase's official PostgreSQL optimization guidelines covering query performance, indexing strategies, schema design, and security policies"
version: "1.0.0"
author: "Supabase"
repo_url: "https://github.com/supabase/agent-skills"
install_cmd: "npx skills add supabase/agent-skills"
compatibility:
  - Claude Code
  - Cursor
  - Codex
category: "general"
rating: 4.0
github_stars: 2280
github_forks: 163
installs: 207600
last_updated: "2026-06-09"
ai_friendliness:
  score: 4.0
  documentation: 4.0
  setup: 4.0
  config: 4.0
---

## What It Is + Verdict

Supabase Postgres Best Practices is Supabase's official PostgreSQL skill. It encodes their engineering team's standards for query optimization, indexing, schema design, and Row Level Security into every database task Claude handles.

## The One Thing That Matters

The skill knows Supabase-specific patterns that generic Postgres knowledge gets wrong. It understands Supabase's platform constraints (connection pooling limits, edge function cold starts, realtime subscription pricing) and generates queries that account for them. It also handles Row Level Security policies correctly, which is the most common source of production issues in Supabase projects.

## What's Actually Different

Generic Postgres skills produce correct queries that may perform poorly on Supabase's platform. This skill understands Supabase-specific concerns: when to use the API vs direct SQL, how to structure migrations for Supabase's deployment model, indexing strategies that work with Supabase's connection pooler, and RLS policies that scale. It also knows Supabase extensions (pg_graphql, pg_net, pg_cron) and when to use them.

## Who It's For

Supabase users who want their database code to follow platform best practices. Most valuable for teams scaling beyond prototype stage where performance and security matter. Less useful for non-Supabase Postgres deployments or trivial apps with minimal database usage.

## Bottom Line

Supabase Postgres Best Practices ensures every query Claude writes is optimized for Supabase's platform, not just generic Postgres.
