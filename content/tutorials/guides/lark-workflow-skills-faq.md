---
title: "Lark Workflow Skills FAQ: Standup Reports and Meeting Recaps"
date: 2026-11-01
toc: true
draft: false
tags:
  - Lark
  - Feishu
  - Workflow
category: "guides"
description: "Straight answers on Feishu's two lark-workflow-* skills: the --complete=false trap, one-month search windows, and why a 4.6 KB file pulls 469.8K installs."
faq:
  - question: "What are the two lark-workflow-* skills?"
    answer: "They are composition skills, not API wrappers. `lark-workflow-standup-report` (4,626 bytes) chains `calendar +agenda` with `task +get-my-tasks` and formats a daily or weekly briefing. `lark-workflow-meeting-summary` (7,150 bytes) chains `vc +search` into `vc +detail` into `note +detail` and then `drive metas batch_query` to produce a meeting recap or weekly report. Both orchestrate other lark-cli skills rather than calling raw API methods."
  - question: "Why are these two files written in Chinese while the rest of the pack is English?"
    answer: "No idea why, but it is true: standup-report and meeting-summary are the only two SKILL.md files in larksuite/cli written entirely in Chinese — headings, tables, warnings and everything. Every other skill I have read in that repo (lark-im, lark-mail, lark-sheets, lark-calendar, lark-event) is English. An agent following them works fine, since the output format they specify is Chinese too, but if your team expects English briefings you will be rewriting the template block yourself."
  - question: "Which identity do they run as, and what scopes do I need?"
    answer: "User only. Both files state it outright — bot identity is not supported. Standup needs `lark-cli auth login --domain calendar,task` and touches exactly two scopes: `calendar:calendar.event:read` for the agenda and `task:task:read` for tasks. Meeting summary needs `--domain vc` at minimum; add `drive` if you want it to read note bodies or write the report document, and add `minutes` if you want the Minutes fallback path for meetings with no note_id."
  - question: "Why does my standup report list tasks I already finished?"
    answer: "Because `+get-my-tasks` returns completed and unfinished tasks together unless you pass `--complete=false`, and the skill calls this out in bold as the thing that must not be skipped. The default page holds 20 items; past that you need `--page-all`. For briefings it also recommends `--due-end <ISO timestamp>` to cut the payload, and folding anything created more than 30 days ago into one 'other N historical items' line."
  - question: "Can I just ask for 'tomorrow'?"
    answer: "Not with `+agenda`. `--start` and `--end` accept ISO 8601 or a Unix timestamp and nothing else — `tomorrow`, `next monday` and `这周` all fail. The skill's instruction is that the agent computes the target date from the current date and passes real timestamps; the defaults cover today, so a plain `calendar +agenda` with no flags is the common case."
  - question: "What does the standup report actually look like?"
    answer: "Three blocks: a schedule table (time, event, organizer, RSVP status), a task checklist with due dates, and a closing summary line with meeting count, task count, conflict warnings and free slots. Four conversion rules do the work — Unix timestamps become HH:mm using the returned timezone, RSVP values map accept/decline/needs_action/tentative to 已接受/已拒绝/待确认/暂定, events sort by start time, and a conflict is any adjacent pair where the earlier end_time is later than the next start_time. Declined events stay visible but are excluded from busy time and from conflict checks."
  - question: "vc +detail says 'no notes available' — does that mean the meeting has no content?"
    answer: "No, and the skill is explicit that you must not label it 无纪要 on that message alone. Check whether `vc +detail` returned a `minute_token`; if it did, the Minutes path applies: `minutes +detail --minute-tokens <token> --transcript --output-dir ./transcripts --as user`. Minutes and smart notes are two independent product chains, so a missing note says nothing about the recording. Only when both note_id and minute_token are absent may you mark it as having no notes."
  - question: "Why does a single week of meetings turn into several CLI calls?"
    answer: "Hard caps everywhere. `vc +search` returns at most 30 records per page and refuses a range longer than one month, so anything wider has to be split into monthly queries; `page_token` must be followed until the list ends. `vc +detail` takes at most 50 meeting IDs per call. `drive metas batch_query` takes at most 10 documents per call. Passing `--end` includes that day, which is how you query a single day — start and end both set to today."
  - question: "Is standup-report really a top-150 skill?"
    answer: "On skills.sh today it is: 469.8K installs at rank #147, weekly `[7,501, 6,656, 6,569, 6,387, 3,310, 4,030, 5,303, 5,238]`. Sibling entries move with it — larksuite/cli lark-doc 483.8K and lark-base 481.2K — which is the pack-counter pattern this family has shown all year. Note that the open.feishu.cn listing counts separately: it shows lark-doc at 840.3K for the same skill."
  - question: "Where is the meeting-summary counter, then?"
    answer: "Not on the board. The 184 entries I pulled on 2026-11-01 include standup-report and skip lark-workflow-meeting-summary entirely, even though the file exists in the repo at 7,150 bytes and declares `lark-meeting` as a required skill. Read that as a listing gap rather than a signal about quality — install counts on this site track aggregates, not per-file activity."
---

The two `lark-workflow-*` skills are the only place in larksuite/cli where the product documents a chain instead of a command. Neither invents an API. Standup-report staples a calendar read to a task read and prints a briefing; meeting-summary walks meeting search into note metadata and lands a report. Read them as recipes for the agent, not as tooling.

I pulled both files on 2026-11-01 along with the skills.sh board, and the interesting material sits in the failure modes they warn about — places where a plausible-looking call returns data that is wrong rather than missing.

## What Each File Assumes Before It Starts

Both open with the same blocking line: read `lark-shared/SKILL.md` first, because authentication and permission handling live there and nowhere else. Meeting-summary adds a second requirement — read `lark-meeting/SKILL.md` too, since that file owns the routing between meeting artifacts. Its frontmatter is the only one of the two that declares a dependency at all: `skills: [lark-meeting]` against standup-report's bare `bins: [lark-cli]`.

Identity is user-only in both. There is no bot path, no service account, no shared mailbox trick. That closes off a whole class of automation people reach for first — a cron job with a bot token cannot generate your standup.

## The Traps Worth Memorising

**The `--complete=false` one.** `task +get-my-tasks` without it returns finished tasks mixed with open ones. The file's own comment says the completed ones then get presented as todos. If your briefing has been showing work you closed last month, this is why.

**The date-format one.** `--start` and `--end` take ISO 8601 or Unix timestamps. Natural language fails. DeepSeek-era agents are happy to pass "tomorrow" and then apologise; the skill's fix is to compute the date first and pass real values.

**The one-month ceiling.** `vc +search` will not span more than a month in one query, so "this quarter" becomes three calls and a merge. Add the 30-per-page cap and `page_token` handling, and a 40-meeting week is four or five round trips before you have a single summary.

**The missing-note assumption.** `no notes available` reads like "no content" and is not. Smart notes and Minutes are separate chains; when `note_id` is absent but `minute_token` is present, the Minutes path still gets you a transcript. Permission failures have their own dance: `No read permission` (code 2091005) means telling the user, getting consent, then `minutes +apply-permission` with the singular `--minute-token`, after which an owner has to approve in the client before a retry can succeed.

**The unified-note routing.** When `note_display_type` is `normal`, the transcript is its own document and `verbatim_doc_token` links to it. When it is `unified`, there is no separate transcript document to share, and the only route to the text is `note +transcript --note-id <id>`. Recaps that quietly cite a transcript link for a unified note are citing something that does not exist.

## Where the Counts Sit

Standup-report shows 469.8K installs at rank #147, with weekly `[7,501, 6,656, 6,569, 6,387, 3,310, 4,030, 5,303, 5,238]` — the same four-week dip and three-week recovery as lark-doc at 483.8K and lark-base at 481.2K. Meeting-summary is absent from the 184-entry board entirely. Neither number says much about usefulness; the pack counter has never tracked per-file activity in this family.

If you want the artifact model behind the second workflow — when a meeting has a note, a minute, both, or neither — the [lark-meeting FAQ](/tutorials/guides/lark-meeting-skill-faq/) walks through it, and the [lark-calendar guide](/tutorials/guides/lark-calendar-procedural/) covers the `+agenda` command the standup chains from. For the rest of the family in one place, the [lark deep-dive roundup](/tutorials/guides/lark-family-deep-dive-roundup-2026/) covers five skills I read end to end.

## Start Here

```bash
lark-cli auth login --domain calendar,task
lark-cli calendar +agenda
lark-cli task +get-my-tasks --complete=false --due-end "2026-11-01T23:59:59+08:00"
```

Run those three by hand once before letting an agent chain them. You will see your own schedule in the raw shape the skill parses — Unix timestamps, RSVP codes, a task list that quietly includes finished items if you forget the flag — and that is the fastest way to know whether the summary it generates later is honest.
