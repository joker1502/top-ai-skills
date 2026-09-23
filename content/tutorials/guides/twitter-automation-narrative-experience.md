---
title: "Twitter Automation Skill: 213K Installs in One Week"
date: 2026-09-23
toc: true
draft: false
tags:
  - AI Agents
  - Twitter
  - Automation
category: "guides"
description: "Inside the twitter-automation skill — nine belt CLI apps for posting, liking, DMs, and follows — and why six mirror counters on skills.sh all exploded at once."
---

The most-installed social skill on the board this week is sixty lines long, contains nine commands, and never once tells you anything about writing good tweets. `twitter-automation` (from inference-sh/skills, MIT, 137 stars on its aggregator repo) is a thin router onto the `x/` app namespace of the inference.sh CLI. I read the SKILL.md end to end and scraped skills.sh on 2026-09-23, and the leaderboard story is stranger than the file itself: the top mirror shows **390,470 installs with a weekly curve of [0, 0, 0, 0, 0, 13,446, 63,653, 213,285]** — five dead weeks, then a 16x explosion in two.

## What the Thirty-Line Body Actually Contains

The skill declares `allowed-tools: Bash(belt *)` and assumes the `belt` CLI is installed (`npx skills add belt-sh/cli`) and logged in. Everything hangs off one shape: `belt app run <app-id> --input '<json>'`. The whole catalog is nine apps in the `x/` namespace:

| App ID | Does |
|---|---|
| `x/post-create` | Posts text, optionally with media |
| `x/post-like` / `x/post-retweet` | Likes and retweets by tweet ID |
| `x/post-delete` / `x/post-get` | Deletes a tweet, reads a tweet by ID |
| `x/dm-send` | Sends a direct message to a user ID |
| `x/user-follow` / `x/user-get` | Follows a username, reads a profile |

One detail from comparing stored copies: aggregated copies of the skill still say `infsh app run x/post-tweet`, while the current source says `belt app run x/post-create` — the CLI was renamed from `infsh` to `belt`, and the mirrors lag the rename. If a blog post you read last month shows `infsh`, that's the old name, not a different tool. The command payloads stayed the same shape: `--input '{"tweet_id": "1234567890"}'` for interactions, `--input '{"username": "OpenAI"}'` for users.

## The Real Workflow Is Media Handoff, Not Twitter

The skill's interesting half is the two worked examples it carries, and neither is about engagement. The first generates an image with `belt app run falai/flux-dev-lora --input '{"prompt": "sunset over mountains"}' > image.json`, then posts the returned URL through `x/post-create`. The second swaps the generator for `google/veo-3-1-fast` and posts a video. The pattern — run a generation app, capture its JSON output, feed the URL into a posting app — is the actual lesson. The skill is a composition primer: any app that emits a media URL from its `--input`/`--output` pairs with posting.

For media posts specifically, the file favors scaffolding the input over hand-typing it: `belt app sample x/post-create --save input.json` writes a template you edit, then `belt app run x/post-create --input input.json`. Doing this by hand once is fine; the sample command exists because the payload shapes drift.

## The Counter Says More Than the Skill

Here's the part that changed how I read the leaderboard. `twitter-automation` shows up **six times** on the skills.sh board, once per superpowers-family mirror: 101-skills/superpowers at 390,470, qu-skills/superpowers 189,833, magentosh/superpowers 103,467, skills-shell/superpowers 97,485, its-a-skill-issue/superpowers 91,816, bankai-skills/superpowers 75,833 — roughly 950K in total, every curve shaped [0, 0, 0, 0, 0, X, Y, Z] with the ramp offset by the week each mirror picked the skill up. The skill joined the superpowers collection about three weeks ago, and every install of every mirror has counted it since.

Contrast that with [reddit-automation](/skills/general/reddit-automation/), the other social skill that blew up this month: one source (flowkit-labs/skills), 598,515 installs, curve [0, 0, 19,531, 83,327, 116,184, 113,492, 108,855, 113,374] — a launch spike settling into a ~110K plateau. Same two quiet weeks, then a totally different signature. One skill rode a single repo's launch; the other rode a pack family. When a mirror sum explodes in unison like this, the number is pack adoption, and the skill itself is along for the ride.

## Where the Value Landed (and Where It Didn't)

Straight assessment after the read-through: if you already run an X/Twitter pipeline by hand, this is the cheapest way to automate it short of paying for API access directly. One `belt login`, one OAuth grant through inference.sh's X integration docs, and you have posting, media, likes, retweets, DMs, and follows without writing token refresh or rate-limit handling. If you don't run a pipeline, the skill won't create one — there's no scheduler, no content strategy, no analytics, and reads are by ID only.

The honest constraint: the skill lives and dies with `belt`. Its entire surface is nine `x/` apps, and its execution contract is Bash-only — no MCP, no direct API. Its best pairing is the generation skills it links to (`ai-image-generation`, `ai-avatar-video`) plus [reddit-automation](/skills/general/reddit-automation/) if you're spreading the same content across platforms.

Install it with `npx skills add https://github.com/tul-sh/skills --skill twitter-automation` (the canonical source file lives at `inference-sh/skills`, `tools/social/twitter-automation/`), run `belt login`, and post your first tweet with a one-line command. The file says nothing about what to post — that part is still on you.