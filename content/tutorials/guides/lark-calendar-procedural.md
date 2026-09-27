---
title: "Schedule Meetings With lark-calendar: A Step-by-Step Workflow (730K)"
date: 2026-09-27
toc: true
draft: false
tags:
  - Lark
  - Feishu
  - Calendar
category: "guides"
description: "Procedural walkthrough of Feishu's lark-calendar skill: classify new vs edit, lock the event_id, branch on time clarity, book rooms as attendees."
---

"Help me set up a meeting" is a trap for agents: it sounds like one command, but the calendar skill's own workflow file warns that agents routinely skip to room-booking before deciding whether the request is a new event or an edit. Feishu's `lark-calendar` skill (v4, inside [larksuite/cli](https://github.com/larksuite/cli), 17.4K stars) runs **730.0K installs** on the open.feishu.cn counter (scraped 2026-09-27, first seen April 14, 2026). I read its full SKILL.md and all 14 reference files; this is the exact procedure the skill enforces, in order, with the rules that bite.

## Step 1 — Decide What the Request Actually Is

The workflow file opens with a hard gate: **judge new vs edit before touching any command**. The signals are linguistic, and the skill is strict about them. "约个会" / "安排会议" / "create a meeting" with no anchor pointing at an existing event → new. Any request that pairs an **existing-event anchor** (a title, a time, "this meeting") with a **modification verb** ("add Xiao Ming", "move to tomorrow", "change the room") → edit. The forbidden move is treating "move this meeting" as a create.

New events get smart defaults, not questions: title inferred from context (fallback "会议"), attendees default to just the user, duration defaults to 30 minutes, and a missing time gets a reasonable window ("today" or "the next two days") — the skill explicitly forbids asking "what time do you want?" when the user gave none. Edit requests must first **locate the target `event_id`** via `+agenda`, `+search-event`, or an instance view; if multiple candidates match, show them and wait for confirmation. The rule is absolute: **no `+update` without a resolved `event_id`.**

## Step 2 — Branch on Time Clarity

Once the task type is fixed, the workflow checks whether the time is explicit. Clear time (a concrete "tomorrow 3pm") goes straight to landing. Fuzzy or missing time goes to `+suggestion` — the one command that turns "sometime next week" into concrete candidate blocks:

```bash
lark-cli calendar +suggestion \
  --start "2026-03-19T14:00:00+08:00" \
  --end "2026-03-19T18:00:00+08:00" \
  --attendee-ids ou_xxx,oc_yyy \
  --duration-minutes 60
```

`+suggestion` combines working hours, existing busy blocks, and attendee calendars (users `ou_` or groups `oc_`); pass `--exclude` to carve out blocked windows, or `--event-rrule` for recurring suggestions. Two rules here: the edit-with-new-time case must **base the search on the user's new range, not the old event's time**, and when rescheduling an existing event, grab its **original duration first** — if the user gives a new start time, compute the new end by keeping the duration identical. Changing a meeting's length silently is listed as a violation.

## Step 3 — Rooms Are Attendees, Not Reservations

The skill's core model: **a room is a resource-type attendee (`omm_` prefixed), booked by adding it to an event's participant list — never standalone.** Two consequences follow. First, `+room-find` demands concrete time blocks, not a range search: pass one or more `--slot "start~end"` pairs, and batch numbered rooms with `--room-name "16,17,18,19,20"`. Location filters (`--city`, `--building`, `--floor`) are **strict extraction, not inference** — the skill forbids guessing a city from a building name, and normalizes floors (`2楼`/`二楼`/`2F` → `F2`). Second, when the user said "find a room" without a time, you must run `+suggestion` first to produce candidate blocks, then hand those blocks to `+room-find` in one batch — never invent a time to search.

```bash
lark-cli calendar +room-find \
  --slot "2026-03-27T14:00:00+08:00~2026-03-27T15:00:00+08:00" \
  --room-name "16,17,18,19,20"
```

## Step 4 — Land With Confirmation

A BLOCKING REQUIREMENT sits between options and execution: whenever time or room choices are on the table, **present the candidates and wait for confirmation before creating or updating anything**. Only then does the flow land:

```bash
# new event
lark-cli calendar +create \
  --summary "产品评审" --start "2026-03-12T14:00+08:00" \
  --end "2026-03-12T15:00+08:00" --attendee-ids ou_aaa,ou_bbb,omm_new_room

# edit (resolved event_id required)
lark-cli calendar +update \
  --event-id "<event_id>" --start "<new_start>" --end "<new_end>" \
  --add-attendee-ids omm_new_room
```

Editing rules bite at the last step: the skill keeps whatever `event_id` it located earlier — re-guessing the target at the end is forbidden. Adding a room to an existing event is **incremental by default**: `--add-attendee-ids` appends, old rooms stay. Only an explicit "replace the room" triggers `--remove-attendee-ids` (old) + `--add-attendee-ids` (new) together. Recurring events need `--apply-to` on every `+update`/`+delete`, created via `--rrule` (RFC 5545, e.g. `FREQ=DAILY;INTERVAL=1`).

## The Timezone Trap Everyone Hits

The one rule to memorize: **ISO 8601 timestamps must carry an explicit offset — `2026-03-12T14:00+08:00`, never `2026-03-12T14:00`.** A bare timestamp is parsed in the process's timezone, and agents' containers default to UTC, which silently shifts every Feishu (UTC+8) time by eight hours. The skill mandates converting dates with an external tool rather than trusting the container clock. `calendar_id` can be passed as the literal `primary` for the caller's main calendar; every write supports `--dry-run` first.

Worth noting for anyone comparing calendar skills: scheduling, room lookup, RSVP, and busy-time all live in this one skill — while archived **meeting records** route to [lark-meeting](/tutorials/guides/lark-meeting-skill-faq/) and to-dos to `lark-task`, per its explicit boundary list. Install it with `npx skills add https://open.feishu.cn/ --skill lark-calendar`. Then the next "set up a meeting" won't produce a duplicate event, a guessed room, or a meeting that starts eight hours early.