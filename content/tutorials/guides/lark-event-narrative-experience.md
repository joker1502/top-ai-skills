---
title: "I Streamed Feishu Events: The lark-event Subprocess Contract"
date: 2026-09-28
toc: true
draft: false
tags:
  - Lark
  - Feishu
  - Automation
category: "guides"
description: "lark-event (450.1K installs) streams Feishu IM, VC, and Minutes events as NDJSON. The subprocess contract — ready markers, stdin EOF, exit reasons — matters."
---

Event subscriptions are where agents quietly die. A consumer that looks alive while dropping every event is worse than one that crashes loudly, and Feishu's `lark-event` skill (v1.0.0 inside [larksuite/cli](https://github.com/larksuite/cli), 450.1K installs at #110 on skills.sh, scraped 2026-09-28) spends most of its 11,475-byte SKILL.md teaching you to avoid exactly that failure. I read the file cover to cover, plus the seven topic references (IM, VC, Minutes, Task, Approval, Application, Whiteboard). The stream command is the small part. The subprocess contract — a stderr ready marker, stdin-EOF graceful shutdown, exit reasons, and a `kill -9` warning — is the part your orchestrator actually needs.

## Three Lines That Rescue Every Orchestrator

The core is one command: `lark-cli event consume <EventKey>` writes events to stdout as NDJSON. Everything else in the skill is scaffolding around three behaviors a parent process can't live without.

**The ready marker replaces `sleep`.** `event consume` emits a fixed stderr line — `[event] ready event_key=<key>` — when the subscription is live. The SKILL.md is explicit: parents should block on stderr until that line appears, then start reading stdout. Do not fall back to `sleep`. An agent that `sleep 5` after spawning a consumer may read nothing, or may miss the subscription error that the ready marker would have surfaced.

**stdin EOF is a shutdown signal.** Close the consumer's stdin and it exits gracefully — wired deliberately for AI subprocess callers. The trap: unbounded runs (no `--max-events`, no `--timeout`) treat `< /dev/null` or `nohup` as immediate exit (`reason: signal`). To keep an unbounded run alive you must feed stdin something that never EOFs — `< <(tail -f /dev/null)` — or simply run bounded: `--timeout 10m` for a ten-minute session.

**Exit codes carry reasons, not just 0/1.** 0 = `limit` (max-events reached), `timeout`, or `signal`; 1 = Lark API business failure during pre-consume setup; 2 = validation failure (unknown EventKey, bad `--param`, another bus already connected); 3 = auth failure; 4/5 = network/internal. Every failure emits a structured JSON envelope on stderr with `error.type` / `error.subtype` / `error.param` / `error.hint` — parse those fields, don't regex-match message text. Orchestrators should treat `limit/timeout/signal` as business completion and everything else as failure.

## The fromjson Trap: It Fails On Every Event, Silently

The jq advice in this skill saved me from a bug I've shipped before. `im.message.receive_v1` runs a Process hook that pre-renders `.content` to human-readable text for `text` / `post` / `image` / `file` / `audio` and friends — only `interactive` cards keep raw JSON. Blindly applying `fromjson` to an already-decoded text field makes jq error **on every single event and silently drop it**: the consumer looks alive but emits nothing, with one `WARN` line buried on stderr. The loop never aborts.

The schema command is the antidote, and the skill tells you exactly which of the four things to read: `jq_root_path` (`.`, or `.event` for V2-enveloped keys), `resolved_output_schema.properties` (field list, and don't strip `.description` — that's the field that tells you whether a field is already decoded), the `format` tags (Lark's own semantic tags: `open_id` / `chat_id` / `message_id` / `timestamp_ms` — same string type, different meanings), and the decoded-state notes. Two of the twelve IM keys are flattened to `.xxx` by the CLI; the other ten pass through as V2 envelopes and live at `.event.xxx`. Filter by `chat_type=="p2p"`, by `message_type=="text"`, or by `sender_id` — the recipes in `references/lark-event-im.md` cover all three.

## One Key Per Process — On Purpose

`event consume` takes exactly one positional EventKey. `k1,k2` and wildcards are unsupported; listening to N keys means N subprocesses, and the SKILL.md calls that intentional: one shape per stdout, fault isolation, independent `--as` / `--jq` / bounds per key. All consumers share a single bus daemon over local UDS IPC, so the overhead stays small. Hooking five keys into zsh with `&` and `wait` is the documented pattern.

The domain catalog splits across seven references — 12 IM keys, 7 VC meeting-lifecycle keys (`participant_meeting_started/joined/ended_v1`, recording + transcript), 1 Minutes key, 2 Approval keys, 1 Task key (`task.task.update_user_access_v2`), and `board.whiteboard.updated_v1`, which is the odd one: it subscribes **per whiteboard** and demands `-p whiteboard_id=<token>` up front (missing it fails param validation before any subscription, good), and it requires manage access or the subscribe OAPI returns 403 before the ready marker ever fires.

## Never kill -9 — the Leak Is Server-Side

The most expensive lesson in the file is the last one. EventKeys whose PreConsume registers a server-side subscription and unsubscribes on exit — minutes, vc, board — **leak if you `kill -9`**: the OAPI unsubscribe never runs, and restart shows `subscription already exists` with duplicate event delivery. SIGTERM or closing stdin is the right shutdown for every key; `kill -9` is the one that bites. Task and approval keys hold durable relations with no cleanup so they don't leak the same way, but the rule stands universally.

That single paragraph explains more about how to run a Lark bot than any quickstart. Feishu's event surface is genuinely broad — messages, reactions, chat lifecycle, meeting lifecycle, transcripts, approvals, boards — and `lark-event` is the narrow pipe that streams it all without a dispatcher. Hands-on users of the family will recognize the shape: same schema-first discipline as [lark-meeting](/tutorials/guides/lark-meeting-skill-faq/), same identity handling as the shared auth setup, packaged as a contract your code can actually rely on. Install it with `npx skills add https://github.com/larksuite/cli --skill lark-event`, then run `lark-cli event list --json` to see the catalog, `lark-cli event schema im.message.receive_v1 --json` for the field map, and start a bounded consume before you trust any unbounded one.