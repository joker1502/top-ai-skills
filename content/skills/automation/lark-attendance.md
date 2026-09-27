---
title: "lark-attendance: Read Your Feishu Check-Ins From the CLI (729K)"
date: 2026-09-27
draft: false
tags:
  - Lark
  - Feishu
  - Attendance
category: "automation"
description: "Feishu's lark-attendance skill is the thinnest file in the lark pack: one endpoint, permanently fixed params, self-only by construction. 728.7K installs."
---

The smallest file in the biggest skill pack does one thing and refuses to do anything else. Feishu's `lark-attendance` skill (v1.0.0, inside [larksuite/cli](https://github.com/larksuite/cli)) is a 1,620-byte SKILL.md with exactly one API method — `user_tasks.query`, which returns your own check-in records. I read the file end to end and scraped its skills.sh detail page on 2026-09-27: **728,700 installs** on the open.feishu.cn counter, first seen April 14, 2026, with a weekly band running in lockstep with the rest of the family (lark-im 730.1K, lark-calendar 730.0K, lark-sheets 729.7K, lark-attendance 728.7K) — the pack-level counter at work again.

## One Endpoint, Two Parameters the Skill Refuses to Ask About

`user_tasks.query` takes two parameters that shape every call, and the skill hard-codes both of them. `employee_type` is pinned to `"employee_no"` and `user_ids` to `[]` — an empty array. The instruction is explicit: auto-fill these in every API call, **never ask the user for them**. The design intent is visible in the choice of empty array: this skill can only read the authenticated user's own attendance records. There is no path in the skill to query a colleague's clock-in history, because the parameter that would enable it is permanently fixed to "nobody else."

That makes attendance the family's safest skill by construction. Compare it with [lark-approval](/skills/automation/lark-approval/), which carries a 6,969-byte SKILL.md plus 16 reference files to describe who may act on whom; attendance carries one read-only endpoint, one scope (`attendance:task:readonly`), and zero write operations. The pack's answer to a PII-heavy domain is not more rules — it's removing the verbs entirely.

## The Schema-First Rule Applies to a One-Method Skill Too

The skill still enforces the family's schema discipline. Before calling anything, the agent must run `lark-cli schema attendance.user_tasks.query` to inspect the `--data` / `--params` structure rather than guessing field formats — the same rule lark-calendar applies to its fourteen reference files, applied here to a single method. The CLI help lives at `lark-cli attendance --help`, and the whole skill assumes the shared auth setup: reading `../lark-shared/SKILL.md` first is marked CRITICAL, because attendance data rides the same token and permission machinery as every other lark skill.

## Why the Thinnest Skill Is Also the Most Telling

Look at the family's install spread and you see one counter, not seven: lark-im 730.1K, lark-calendar 730.0K, lark-minutes 728.9K, lark-attendance 728.7K — all first seen the same week, all drifting together. Pack counting means popularity metrics here measure the platform, not the individual feature. What actually differentiates attendance is its minimalism: one byte-heavy method, two fixed parameters, zero references, one query-only scope. That's the whole product — `npx skills add https://open.feishu.cn/ --skill lark-attendance` and your agent can answer "how many days did I work from home last month?" without ever being able to ask about anyone else's.

The next time an agent framework ships a 500-line skill for something as personal as attendance, remember this one: the right amount of surface area for reading your own check-ins is a single read-only method with the "who" parameter welded shut.