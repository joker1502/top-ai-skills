---
title: "lark-im: Feishu Messages, Cards, Feed Shortcuts From CLI"
date: 2026-09-29
draft: false
tags:
  - Lark
  - Feishu
  - Messaging
category: "automation"
description: "Feishu's lark-im sends messages, manages group chats, and pins feed shortcuts from the CLI — 736.5K installs plus a hard user-vs-bot identity split per call."
---

Feishu's `lark-im` is where the lark family gets opinionated about identity. I read the whole v1.0.0 SKILL.md (25,322 bytes, 280 lines) inside [larksuite/cli](https://github.com/larksuite/cli), plus the skill detail page, and scraped skills.sh on 2026-09-29: **736,515 installs, rank #18 on the leaderboard, on the open.feishu.cn source** (first seen Apr 14 2026) with weekly [33,753, 31,136, 27,446, 27,769, 27,230, 25,421, 25,883, 17,827], and a second counter at larksuite/cli 456,743. The two counters drift in lockstep with [lark-contact](/skills/automation/lark-contact/) and the rest of the pack — same pack-wave signature. The skill itself is not a thin shim like some siblings: ~30 shortcuts covering chats, messages, threads, reactions, flags, pins, and the feed sidebar.

## The Identity Wall on Every Shortcut

Almost every command in lark-im reads `--as user` or `--as bot`, and the token choice changes who the operator is. The same API can succeed under one identity and fail under the other because owner/admin status, chat membership, tenant boundary, and app availability are all checked against the caller. Three shortcuts are **bot-only** and the server rejects users: `+messages-edit` (PUT /open-apis/im/v1/messages/:message_id), `messages.merge_forward`, and the whole urgent family (`urgent_app` / `urgent_phone` / `urgent_sms`). The reverse holds on the feed side: every `+feed-*` shortcut and `+flag-*` are **user-only** — they sign with `user_access_token`, so a bot can't touch your bookmarks or sidebar pins.

The read-status split is the subtlest: `+message-read-users` lets a user query messages they sent within the last 7 days, but a bot can only query messages *that bot* sent within 7 days. Same endpoint, different window depending on who calls it.

## No Contact Scope Needed for Sender Names

Fetching messages via `+chat-messages-list` or `+messages-mget` returns display names for users and bots alike — the read APIs hand back `sender_name` (plus the full `sender_i18n_names` locale map) directly on each message. No name lookup, no extra permission, **no contact scope**, and no `application:bot.basic_info:read`. When the server provides no name, the sender shows by id and the command still exits 0; there is no contact-directory fallback. System messages come back without a sender name — that is normal, not an error.

Those four message-pulling shortcuts also auto-attach a `reactions` block and (for edited messages) `update_time` to every returned message — no separate `im.reactions.batch_query` call needed. Pass `--no-reactions` to opt out, or `--concise` for compact Markdown output.

## Downloads, Cards, and the Feed Sidebar

`--download-resources` saves eligible attachments into `./lark-im-resources/` and lists them per message. Stickers are not downloadable, and a failed attachment reports on that resource without aborting the pull. The trap: **folder resources are containers, not files** — you cannot download a folder `file_key` directly. Expand it first with `lark-cli im files folder --recursive --file-key <folder_key> --srctype message --srcid <message_id>`, then fetch the files inside.

Interactive cards carry their own gate. Before sending, replying with, or updating any `interactive` message you MUST read `references/card/lark-im-card-create.md` and follow its workflow — the card JSON passed to `--msg-type interactive --content` must be that workflow's output, never a hand-written or copied payload. Cards support callback events (`card.action.trigger`), and updating one via `messages.patch` has a 14-day window and a 30 KB JSON cap.

Feed shortcuts are the personalization layer: they pin chats to the current user's feed sidebar, distinct from flags (bookmarks). Only **CHAT-type** entries (`oc_xxx` open_chat_id) are exposed via OpenAPI — docs, apps, and subscriptions exist internally but are not whitelisted. All three operations are user-identity only, batch 10 per call, and partial failures return an `ok:false` ledger instead of aborting. Feed groups (tags) come in two flavors: `normal` (members managed explicitly) and `rule` (members auto-derived).

Two more edges worth remembering: `--audio` accepts only Opus (`.opus` / Ogg Opus), so MP3 and WAV need conversion or `--file`; and when forwarding doc content into chat, fetch with `--doc-format im-markdown` and send in `--markdown`, keeping the content untouched.

Install with `npx skills add https://github.com/larksuite/cli --skill lark-im`, run `lark-cli im --help` once, and internalize the one rule that matters: identity is not a flag you guess — it is the first design decision of every call. If your automation reads or writes messages as a bot it will hit the user-only walls fast; [lark-event](/tutorials/guides/lark-event-narrative-experience/) handles the subscription side of that same conversation.