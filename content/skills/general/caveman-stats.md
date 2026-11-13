---
title: "caveman-stats: Three Lines of Transcript, One Counted Response"
date: 2026-11-13
toc: true
draft: false
tags:
  - Agent Skills
  - Token Accounting
  - Observability
category: "general"
description: "caveman-stats reports 12,000 tokens where a naive sum says 36,000, and drops mode attribution on a single log field. I ran the reader to see which."
version: "2.2.0"
author: "juliusbrussee"
repo_url: "https://github.com/JuliusBrussee/caveman"
install_cmd: "curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/v4.1.0/install.sh | bash"
compatibility:
  - Claude Code
  - Gemini CLI
---

`/caveman-stats` reports what your Claude Code transcript recorded and stops there — it will not turn that number into a saving. I wanted to know what "recorded" means precisely, so I built a transcript this week and ran the reader against it. Two surprises: it deduplicates far more aggressively than the docs suggest, and a single word in a log row decides whether you get a per-mode breakdown or one flat number.

The skill itself is small. `skills/caveman-stats/SKILL.md` is 1,964 bytes and mostly a host contract; the arithmetic lives in `src/hooks/caveman-stats.js` at 31,264 bytes, with `caveman-mode-tracker.js` at 24,368 bytes handling the transition log. Install counts sit at 378.9K (rank 242), with the weekly curve at 13,692 → 11,247 → 10,367 → 8,962 → 7,754 → 7,949 → 7,550 → 8,168 — the one bucket that rose 8.2% last week while `caveman-commit` fell 6.6% and `caveman-help` fell 7.8%.

## One response, one count — even when the host writes three lines for it

Claude Code writes one JSONL line per content block of an API response: the text block, then each tool_use block. All of them carry the same `requestId` and `message.id`, and all of them repeat the same `usage` object. Add up the lines and you count the same tokens once per block.

I built a 12-response session with three blocks each, 1,000 output tokens and 2,400 cache-read tokens per response. That is 36 lines carrying 36,000 output tokens if you sum naively.

The report printed:

```
Turns:    12
Output tokens:         12,000
Cache-read tokens:     28,800
```

Three times lower. The code comments claim 1.5–2.1x inflation measured on real tool-heavy sessions; my three-block shape is the worst case of that same pattern, and it costs nothing to get wrong if you eyeball `wc -l` instead of trusting the reader. Entries without a `message.id` — synthetic and legacy logs — keep per-line counting, because there is no key to dedupe on.

## The mode split hinges on a word the log writer picked

A transcript alone cannot say which mode generated which response. That comes from `.caveman-mode-log.jsonl`, a file of `{ts, mode, prev}` rows written on each transition. Each row gets validated against `VALID_MODES`, which is `off`, `caveman`, `ultracave`, `megacave`, `commit`, `review`, `compress`.

I wrote a transition row at the midpoint of my session with `mode: "caveman"` and `prev: "none"`. The report ignored it and printed `Mode: caveman off (current mode; no transition log)`, attributing all 12,000 tokens to one mode. Then I changed `prev` to `"off"` and got:

```
Mode changed mid-session — output attributed per mode:
  off: 6,000 tokens
  caveman: 6,000 tokens
```

Same tokens, same timestamp, one character of a log value apart. The reason is that `none` is the reader's internal label for "no mode" on output (`currentKey = mode || 'none'`), but it is not a legal input value, so the row is dropped without a warning. If you hand-write or migrate transition logs, this is the failure you will hit, and it fails toward "whole session, one mode" — the more confident-looking answer.

## Lifetime totals dedupe by session, and byte pairs are not savings

Every run appends a snapshot, so four invocations on one session leave four rows in `.caveman-history.jsonl`. `--all` keeps the latest row per `session_id` and sums across sessions, which read back as `Sessions: 1` and 12,000 tokens rather than four rows of 12,000. Malformed windows fail fast: `--since 7x` exits 2 with `--since takes Nh or Nd (e.g. 7d, 24h), got: 7x`.

Memory-file pairs are reported by bytes only. A 4,000-byte `CLAUDE.original.md` next to a 1,200-byte `CLAUDE.md` produced `1 pair, 4,000 original bytes → 1,200 current bytes (2,800 fewer bytes)` plus one line of plain text: `File sizes do not measure provider token or billing savings.` A second pair of exactly 500 bytes each was skipped outright — the scanner requires the original to be strictly larger.

What the report gives you, and what it will not:

| Field | Value in my test | Meaning |
|:---|:---|:---|
| Turns | 12 | Counted responses, not log lines |
| Output tokens | 12,000 | Deduplicated per `requestId:message.id` |
| Cache-read tokens | 28,800 | Sum of `cache_read_input_tokens` |
| Mode attribution | `log` or `whole-session` | Decided by the transition log |
| Savings | unknown | No comparison session exists |
| Memory bytes | 2,800 fewer | Bytes, never provider tokens |

## What to do with it

Read the report as an inventory, not a scoreboard. Run `/caveman-stats --share` if you want the one-line version (`🪨 12 turns, 12,000 output tokens this session; savings unknown — caveman.sh`), and `--all` when you want sessions counted once each.

Two habits keep the numbers honest. First, check the mode line before quoting anything per-mode — if it says "no transition log" while you know the mode changed, your log rows are being rejected, not absent. Second, treat the byte pairs as a file-size note. The skill's own `README.md` says earlier releases applied a fixed ratio without a committed benchmark; those estimates are gone from session reports, lifetime totals and the statusline, and they should be gone from your notes too.

For the measurement side of the same family, see the [compress guardrail test](/tutorials/guides/caveman-compress-guardrails-tested/) and the [review format token study](/skills/general/caveman-review/).
