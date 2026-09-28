---
title: "lark-contact: Resolve Feishu Names and Bots From CLI"
date: 2026-09-28
draft: false
tags:
  - Lark
  - Feishu
  - Contact
category: "automation"
description: "Feishu's lark-contact resolves names, emails, and bots into open_ids (449.8K installs) — with two strictly separate user and bot command paths."
---

Feishu's `lark-contact` skill turns names into IDs, and it keeps the two identities that can ask for that ID apart with a wall. I read the whole v1.0.0 SKILL.md (3,760 bytes) inside [larksuite/cli](https://github.com/larksuite/cli), all three reference files, and scraped its skills.sh page on 2026-09-28: **449.8K installs at #113**, weekly band [8.0K, 7.3K, 6.8K, 7.5K, 7.6K, 6.7K, 6.7K, 6.5K] — the same pack counter signature as every other lark skill. The interesting part is not the numbers. It's how this skill draws the user-vs-bot line harder than any of its siblings.

## Two Identity Paths That Never Cross

The routing table at the top of the SKILL.md is the whole design: **user identity and bot identity are two completely independent paths**, and you must decide which one you're on before picking a command.

| What you want | user identity | bot identity |
|---|---|---|
| Name/email → open_id | `+search-user` | not supported |
| Search visible bots/agents by keyword | `+search-bot` | not supported |
| Known open_id → someone's profile | `+search-user --user-ids <id>` | `+get-user --user-id <id>` |
| Look at yourself | `+get-user` or `+search-user --user-ids me` | not supported |
| Colleague's status/signature | `user_profiles batch_query` | not supported |

Three of the five rows are user-only. A bot can fetch a profile by ID (`+get-user --user-id ou_xxx --as bot`) but cannot search for people — because Feishu's bot tokens simply don't carry contact-search scopes. The skill doesn't paper over that asymmetry with a compatibility layer; it writes the asymmetry into the routing table and tells the agent to pick a lane first.

## The Disambiguation Ritual Before Side Effects

Searching a common Chinese name returns multiple hits, and the skill's rule is blunt: **if the next step has side effects — sending a message, inviting to a meeting — list the candidates and let the user choose; never silently take the first row.** It even ranks the disambiguation signals you should trust, most reliable first: `chat_recency_hint` (you've talked recently) > enterprise email prefix > department keyword. `localized_name` matches are explicitly rated useless for telling two 张伟s apart.

The fanout mode (`--queries "Alice,Bob,张三"`, up to 20 queries) gives each returned user a `matched_query` tag and each input its own `{query, error?, has_more}` block — a failed query doesn't kill the others, only an all-failed batch exits non-zero. And there's no auto-pagination: `has_more=true` means refine the query, not page onward.

## Where Bot Search Saves the Day

`+search-bot` is the row that makes this skill different from a plain directory lookup: search for a bot visible to the current user by keyword and get its `ou_` open_id back. Its flags mirror search-user (`--queries`, `--has-chatted`, `--page-size` 1–30), plus `--chat-ids` to scope the search to specific groups. The output carries `is_agent` so you can tell a plain bot from an agent, and when several hits come back, you're told to combine `description` + `is_agent` and confirm with the user before messaging or pulling into a group.

The SKILL.md troubleshooting section gives a scenario I found genuinely useful: when a user says "meet with reviewDuck," the name doesn't say whether reviewDuck is a colleague or a bot. Names containing bot/agent/AI/assistant markers → search bots first; unsure → search both sides.

## The Boundary Discipline Pairs It With the Rest of the Pack

Same warnings you'll see across the family, applied to a directory: `41050 / Permission denied` is visibility-scoped to the current identity, and **cross-tenant users (`is_cross_tenant=true`) come back with empty business fields** — always default downstream, never assume. The skill also refuses scope creep loudly: messaging and scheduling go to the family's dedicated commands (the `lark-calendar` scheduling flow is covered in [its procedural tutorial](/tutorials/guides/lark-calendar-procedural/)), org-chart traversal to `lark-openapi-explorer`. You resolve the ID here, then leave.

It's the second contact-adjacent skill I've written about, and the contrast with [lark-attendance](/skills/automation/lark-attendance/) is the lesson: attendance welded its "who" parameter shut with an empty `user_ids` array, while contact deliberately opens three commands the other way — because resolving an identity is a prerequisite to acting, so both lanes have to exist. Install it with `npx skills add https://github.com/larksuite/cli --skill lark-contact`, read `lark-cli contact --help` once, and remember the one rule that matters: decide whether you're the user or the bot *before* you pick the command.