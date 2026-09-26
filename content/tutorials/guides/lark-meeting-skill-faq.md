---
title: "Lark-Meeting Skill FAQ: Meeting IDs, Notes, and Minutes"
date: 2026-09-26
toc: true
draft: false
tags:
  - Lark
  - Feishu
  - Meeting
description: "Straight answers on Feishu's lark-meeting skill: meeting_id vs minute_token vs note_id, user vs bot identity, transcripts from Minutes — with 126.9K installs."
category: "guides"
faq:
  - question: "What does the lark-meeting skill actually do?"
    answer: "It is the unified entry point for Feishu video-meeting data: past meeting records, live meeting content, Minutes (妙记), and AI smart notes (智能纪要). One command tree — `lark-cli vc`, `lark-cli minutes`, `lark-cli note` — covers search, detail, transcript download, live interaction, and bot attendance. Scheduling, busy-time, and room management do not live here; those go to lark-calendar."
  - question: "What's the difference between meeting_id, meeting_no, note_id, and minute_token?"
    answer: "Four different objects that never substitute for each other. meeting_id is the long digit ID of one actual meeting. meeting_no is the 9-digit number users read aloud — the CLI calls the parameter --meeting-number. note_id points to an AI smart-note collection. minute_token points to a Minutes recording (taken from a URL like /minutes/obcxxx). Mismatching them across domains is the most common failure mode."
  - question: "What's the difference between Note and Minutes?"
    answer: "Two independent pipelines. Note (智能纪要) comes from AI summarization when a meeting has AI summary enabled. Minutes (妙记) comes from recording — either a recorded meeting or a local audio/video file uploaded afterward. A meeting may have both, only one, or neither, and you cannot infer one from the other. This is the file's central domain invariant."
  - question: "Can Minutes exist without a meeting?"
    answer: "Yes. Minutes can be generated directly from a local audio/video file via upload, so a minute_token is not guaranteed to map back to any meeting_id or calendar event_id. The skill's domain model is explicit: Minutes are independent of the meeting they might be linked to."
  - question: "When do I use --as user vs --as bot?"
    answer: "User identity covers what the logged-in user can see and do — meetings they attend, their own notes. Bot identity (--as bot) requires a target --user-id and only returns meetings where the target user is in the meeting *and* the bot is also in it. The skill's rule: once you pull an ID with one identity, keep using that identity for the rest of the chain. Switching silently is forbidden."
  - question: "Why did the bot return an empty meeting list?"
    answer: "Empty from bot identity does not mean the user is in no meeting — it means no meeting exists where the target user and the bot are together. The bot must actually be in the meeting to see it. The skill also forbids inferring 'user is idle' from that empty list, and warns against re-running auth checks when the real cause is permissions on the bot app."
  - question: "How do I get a transcript out?"
    answer: "Two routes. From Minutes: `lark-cli minutes +detail --minute-tokens obcxxx --transcript` writes a transcript file, by default to ./minutes/{minute_token}/transcript.txt — combine with --output-dir to redirect. From a unified smart note: `note +transcript`, but it only works with user identity; a bot that receives note_display_type=unified must not silently switch identity to fetch it."
  - question: "What happens if I call minutes +detail without flags?"
    answer: "You get base info only — the title — and none of the AI artifacts. The --summary, --todo, --chapter, --keyword, and --transcript flags are opt-in and must be passed explicitly. Request everything at once with the full flag list; batch up to 50 minute tokens comma-separated."
  - question: "How is lark-meeting different from lark-vc-agent?"
    answer: "[lark-vc-agent](/skills/automation/lark-vc-agent/) is a tiny compatibility shim that routes straight into lark-meeting; lark-meeting carries the actual domain model, hard rules, and scene manuals. If you installed the family, you already have lark-meeting under the hood. Install lark-meeting directly for the full routing and the six workflow manuals."
  - question: "Does it require reading lark-shared first?"
    answer: "No — one of the few lark-cli skills that does not mandate the pre-read. It says to touch lark-shared/SKILL.md only when you hit an auth, token, identity, or scope error. The skill ships a progressive-loading rule instead: run quick actions first, read one scene manual only when the task matches, and consult command references only when parameters are missing."
  - question: "Is the 126.9K install number real?"
    answer: "Yes — skills.sh on 2026-09-26 shows 126,900 all-time installs on the open.feishu.cn counter with a weekly series of 0, 0, 0, 4,845, 27,641, 27,011, 25,324, 25,744, plus 35.2K on the larksuite/cli counter (0, 0, 0, 1,413, 6,988, 7,460, 6,671, 6,602). Three zero weeks, then a launch spike to a steady ~27K/week — a newborn skill that hit the board around 2026-08-20."
---

{{< faq-schema >}}

## Why a Lark-Meeting FAQ Exists

Feishu's meeting data comes in four identifier shapes, and every support thread I read boils down to someone mixing them up. `lark-meeting` (v1.0.0, inside [larksuite/cli](https://github.com/larksuite/cli), 17.4K stars) exists to route those correctly — its 12,141-byte SKILL.md is a domain model plus a routing table across three command namespaces. I read the SKILL.md and its five key references (`vc +detail`, `vc +meeting-list-active`, `minutes +detail`, `note +detail`, `vc +meeting-events`) on 2026-09-26, and scraped skills.sh the same day. Every answer below traces to one of those files.

## What the Numbers Say

The lark-family counters on skills.sh usually move in lockstep — lark-doc at 730.0K, lark-approval 728.9K, lark-okr 708.2K all riding the same pack wave. lark-meeting is the exception:

| Counter | All-time | Weekly series (most recent 8) |
|:--|--:|:--|
| [lark-meeting](/skills/automation/lark-vc-agent/) (open.feishu.cn) | 126.9K | 0, 0, 0, 4,845, 27,641, 27,011, 25,324, 25,744 |
| lark-meeting (larksuite/cli) | 35.2K | 0, 0, 0, 1,413, 6,988, 7,460, 6,671, 6,602 |

Three zero weeks, then a spike to a stable ~27K/week plateau. That signature — silence, single launch, plateau — matches a skill that only entered the index around 2026-08-20, and it confirms lark-meeting tracks its own counter rather than borrowing the family's. Newest lark skill on the board, and the only one with fresh growth rather than decline.

## The Identifier Trap, In Practice

Four objects, zero interchangeability:

- **meeting_id** — long digits, one real meeting. Used by `vc +detail --meeting-ids`.
- **meeting_no** — 9 digits, the number a colleague reads aloud. CLI param is `--meeting-number`, deliberately different from the field name.
- **note_id** — AI smart-note collection; a meeting may have it if AI summary is on.
- **minute_token** — Minutes recording, copied from `/minutes/obcxxx` in a URL.

The skill's reference files hammer the same rule from every angle: `minute_token` must not be handed to `note +detail` (resolve note_id via `minutes +detail` first), a Doc token is not an ID, and a calendar `meeting_note` — the user-pinned Doc on a schedule item — is unrelated to any AI note. When a query fails, check which identifier you grabbed before touching anything else.

## Common Mistakes to Avoid

**Mistake #1 — treating a 9-digit number as a join command.** A bare "check meeting 843 122 477" is a filter on active meetings, not an instruction to make the bot join. If no active meeting matches, the skill says stop — do not auto-invite the bot.

**Mistake #2 — calling `+meeting-list-active` without a target.** Bot identity without `--user-id` errors immediately ("--user-id is required when --as bot"). And the `ou_...` format is mandatory; internal user IDs and plain numeric IDs are rejected.

**Mistake #3 — expecting artifacts without flags.** `minutes +detail` returns only the title unless you pass `--summary --todo --chapter --keyword --transcript`. The fields do not appear by default, and the file says the omission is deliberate.

**Mistake #4 — identity switching mid-chain.** IDs fetched as user stay user; IDs fetched as bot stay bot. The one sanctioned exception is the user's explicit, informed consent to switch — and `note +transcript` on a unified note is user-only, so a bot must surface that limitation instead of quietly re-authenticating as the user.

## Start With a Search

Install the family with `npx skills add https://github.com/larksuite/cli --skill lark-meeting` — or grab the whole pack and get [lark-markdown](/skills/automation/lark-markdown/) and [lark-apps](/skills/automation/lark-apps/) alongside it. Then run `lark-cli vc +search` on a recent meeting theme, follow the returned `meeting_id` through `vc +detail`, and watch the note/minute tokens resolve cleanly. Once you know which identifier you're holding, the rest of the tree starts making sense.