---
title: "lark-vc-agent: The 559K-Install Skill That Just Redirects"
date: 2026-08-25
draft: false
tags:
  - Lark
  - Feishu
  - Video Meetings
description: "Lark's lark-vc-agent ranks #38 with 559K installs, but its SKILL.md is a 466-byte shim routing every request to lark-meeting."
version: "1.0.0"
author: "larksuite"
repo_url: "https://github.com/larksuite/cli"
install_cmd: "npx skills add https://github.com/larksuite/cli --skill lark-vc-agent"
compatibility:
  - Claude Code
  - Cursor
  - Codex
category: "automation"
rating: 4.0
github_stars: 16742
github_forks: 1344
installs: 559144
last_updated: "2026-08-25"
ai_friendliness:
  score: 4.0
  documentation: 4.5
  setup: 3.5
  config: 4.0
---

Lark's lark-vc-agent sits at #38 on the skills.sh leaderboard with 559,144 installs — and its entire SKILL.md is a 466-byte redirect. I pulled the file from `larksuite/cli/skills/lark-vc-agent/` and found zero commands and zero scene logic: one routing rule telling the agent to read `../lark-meeting/SKILL.md` in full and execute it. Any request that lands here gets handled by the meeting skill under a name that no longer owns the work.

## Why the Leaderboard Still Shows the Old Name

Two separate sources on skills.sh still list lark-vc-agent, and both keep stacking installs. The open.feishu.cn marketplace copy shows 559,144 total, with weekly installs sliding from 46,393 to 27,320 over the last two months. The larksuite/cli GitHub copy adds another 304,980, weekly down from 28,803 to 6,731. Combined, roughly 864,000 installs keep landing on a stub. All numbers checked on 2026-08-25.

The stub knows what it is. Its own frontmatter describes the job in one line: only use this skill when a user or an upstream config explicitly names lark-vc-agent, and hand every such request to lark-meeting. Old tutorials, saved agent configs, and muscle memory keep referencing the legacy name, so the shim stays in the repo to keep those installs working.

Real talk: this is the backwards-compatibility pattern you see across renamed packages, and the leaderboard shows what that looks like from the outside. The install count keeps climbing while the weekly trend falls — 46K down to 27K on the marketplace, 28K down to 6.7K on GitHub. The name still gets picked because the totals look big. The work moved elsewhere.

## What Actually Runs: the lark-meeting Skill

lark-meeting is Feishu's video-conference skill, and it is dense the way CLI-built skills usually are. Four objects anchor the domain model. Meetings carry a `meeting_id`, a long numeric string — not the 9-digit invite code, which is `meeting_no` and gets passed as `--meeting-number`. Smart notes use `note_id`; recordings use a `minute_token`. Doc tokens are content carriers, and the SKILL.md is explicit that you cannot substitute one identifier for another.

The rule I found most useful is also the most counterintuitive: Note and Minutes come from two independent pipelines. A Note is the AI summary of the discussion. Minutes are the recording, wrapped in AI-generated chapters, todos, and keywords. A single meeting can produce both, exactly one, or neither — and Minutes can even be generated from a local audio or video file that was never a meeting at all. The skill refuses to guess one from the other.

Commands run through three CLI namespaces: `lark-cli vc`, `lark-cli minutes`, and `lark-cli note`. Six scene handbooks split the workflows: finding historical meetings and their artifacts, searching minutes, creating and editing minutes plus permissions, querying smart notes, bot attendance with live interaction, and in-meeting events like reading what's on screen or sending reactions. Identity stays explicit across the whole run — operations execute as `--as user` or `--as bot` — and the skill refuses to swap identities mid-task without an explicit user decision.

## Where It Earns Its Install Count

The scenarios that justify the install:

- **Post-meeting recap** — "what did we decide in Tuesday's design review?" Search the meeting, pull the smart note or verbatim transcript, and answer from the record.
- **Minutes archaeology** — search 妙记 by title, owner, or participant, then read summaries, todos, and chapters or download the raw recording.
- **Live meeting Q&A** — with the bot sitting in the room, ask what's being shared right now, read the chat, or drop a reaction without leaving the CLI.
- **Local recording processing** — upload a voice memo or screen capture and get chapters, keywords, and a transcript back.

What it won't do: booking and room management belong to `lark-calendar`, and the skill says so in its own description. You also need the `lark-cli` binary plus an authenticated Feishu app identity — this is not a zero-setup skill, and the setup step is where most abandoned installs die.

The 559K number on the leaderboard belongs to a redirect, but the thing it points at earns the attention. Feishu teams get a searchable record of every call — smart note, verbatim, recording artifacts — all queryable in natural language. Install it with `npx skills add https://github.com/larksuite/cli --skill lark-vc-agent`, or skip the middleman and go straight for lark-meeting. If you're inside the Lark family already, this slots next to the [lark-doc skill intro](/skills/automation/lark-doc/) — docs, wiki, and meetings each own their slice.