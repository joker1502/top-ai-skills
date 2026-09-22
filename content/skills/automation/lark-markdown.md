---
title: "lark-markdown: The 685K-Install Skill for Raw .md in Lark"
date: 2026-09-22
draft: false
tags:
  - Lark
  - Feishu
  - Markdown
category: "automation"
description: "Lark's lark-markdown skill edits native .md files in Drive — fetch, create, overwrite, patch, diff — and never converts them to docx. 684,911 installs."
---

Lark Drive stores a plain `.md` file as a file, and that is exactly what most agent tools refuse to leave alone — they convert it into a docx document the moment you touch it. The `lark-markdown` skill (v1.2.2, MIT, shipped inside the official [larksuite/cli](https://github.com/larksuite/cli) repo, 17.4K stars) takes the opposite route: it fetches, creates, overwrites, patches, and diffs the raw Markdown, format unchanged. I read its 70-line SKILL.md end to end and scraped skills.sh on 2026-09-22 — 684,911 all-time installs, rank 38, weekly band [37,191, 33,693, 31,059, 27,356, 27,720, 27,082, 25,322, 25,844] drifting down from the 37K peak.

## Five Shortcuts, and They Only Touch .md Files

Every operation hangs off `lark-cli markdown +<verb>`. `+fetch` pulls a file's content, `+create` uploads a new `.md` into Drive or a Wiki node, `+overwrite` replaces an existing file wholesale. `+patch` edits a chunk in place, and `+diff` compares two remote versions or a remote file against a local draft. Nothing here renders, converts, or previews — the skill treats Markdown as text with a `.md` suffix and stops there.

Identity rules come first in the SKILL.md, not the commands. Markdown files usually sit in a user's cloud space, so the skill defaults to `--as user` and expects `lark-cli auth login` to have run; `--as bot` only fits automation where the app created the file and holds its ACL. When a create or overwrite fails, the skill says to judge the error before flipping identity: bots mostly hit app-scope or folder-ACL gaps, users mostly hit missing grants — blind toggling between the two just burns retries.

Two small details bite copy-pasters. `--name` and a local `--file` must carry an explicit `.md` suffix, or the shortcut errors out. And `--content` takes a raw string, `@file` to read a local file, or `-` for stdin, so piping a draft in is the idiomatic move.

## The Patch Illusion: Download, Replace, Re-Upload

`+patch` looks like a server-side partial update, and it is not. The skill's own wording is blunt: the shortcut fully downloads the Markdown, performs the text replacement locally, then overwrites the whole file upstream. That ordering decides what you can and can't do with it.

Only one `--pattern` / `--content` pair runs per call, so multi-spot edits need repeated invocations. The final content must be non-empty — Drive rejects zero-byte Markdown, and the CLI treats an empty result as a mistyped pattern. Regex replacement trips people on escaping, since `--pattern` is parsed as a regex: `"version (1.0)"` matches the parenthesized group as a capture, not a literal string. The skill's example spells the fix out — `"version \\(1\\.0\\)"` for parens and dots — which reads like a lesson paid for in failed patches.

## What It Refuses to Do (and Who Does It)

The boundary list is half the file, and it maps each rejection to a sibling skill. Turning a local `.md` into a new online docx document goes to `lark-drive`'s `+import --type docx`. Rename, move, delete, search, permissions, and comments all leave this skill too, to `lark-drive`. Version history is a prerequisite, not a feature: grab version numbers with `lark-cli drive +version-history` first, then come back for diff, download, or rollback.

Retry discipline is equally strict. `missing scope`, `permission denied`, `not found`, `quota_exceeded`, and `version limit` stop the run immediately — the agent follows the error's own hint. Only `rate_limit`, `server_error`, or transient network failures earn a bounded backoff retry. Target tokens follow the same no-guessing rule: Drive folders take `--folder-token`, Wiki nodes take `--wiki-token`, and a paste-able URL works because the CLI normalizes it — but a doc, sheet, or wiki URL dropped into `--folder-token` is a guaranteed miss.

**The one-line map:** `lark-markdown` edits `.md` files as files; `lark-drive` manages Drive objects — import, move, versions, ACLs; [`lark-doc`](/skills/automation/lark-doc/) and [`lark-wiki`](/skills/automation/lark-wiki/) operate Lark's docx-style documents and wiki trees. Each keeps its own SKILL.md in the same repo, and none overlaps another.

One caution from the leaderboard: 684,911 installs is a pack number, not a lark-markdown number. The whole `open.feishu.cn` family locks step — lark-vc-agent at 662,804, lark-apps at 629,466, lark-note at 502,652, all within a couple thousand installs of each other per week — the same counter signature we've seen across the azure-skills pack. The skill itself is a thin, sharp router onto the `lark-cli` extension, which is exactly what a skill on a 200-command CLI should be.

If your workflows live on plain Markdown files in Lark, install it with `npx skills add https://github.com/larksuite/cli --skill lark-markdown`, then read the sibling SKILL.md for [lark-doc](/skills/automation/lark-doc/) to see where document import takes over. The edge cases are documented; the .md suffix rule is not negotiable.