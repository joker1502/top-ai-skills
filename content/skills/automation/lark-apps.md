---
title: "lark-apps: Build and Host Apps Inside Feishu (633K Installs)"
date: 2026-09-23
draft: false
tags:
  - Lark
  - Feishu
  - App Development
category: "automation"
description: "Feishu's lark-apps skill builds and hosts Miaoda apps from the CLI — local git or cloud AI sessions, releases, env vars, databases. 632,894 installs, #45."
---

The fastest way to ship a small internal tool on Feishu is not to build a website. You create a Miaoda (妙搭) app and let `lark-apps` run its whole lifecycle from a terminal. The official skill (v1.0.0, inside [larksuite/cli](https://github.com/larksuite/cli), 17.4K stars) routes about thirty `lark-cli apps +<command>` operations in one intent map — create, develop, publish, inspect, and maintain apps that run on Miaoda's cloud at `*.aiforce.cloud`. I read the SKILL.md end to end and scraped skills.sh on 2026-09-23: the open.feishu.cn counter shows **632,894 all-time installs, rank 45 of 600**, with a weekly band of [37,125, 33,728, 31,176, 27,562, 27,772, 27,261, 25,429, 25,909] sliding off a 37.1K peak. A separate npx counter on the repo adds 294,248 more.

## The App-Type Question Decides the Whole Session

The SKILL.md opens with a routing table, and the first fork is not technical — it's a product question: **does this app store data on a server?** Three `app_type` values follow:

| Signal | Result |
|---|---|
| Login, CRUD, signups, multi-user records — anything persisted | `full_stack` |
| Pure static display, no JS interaction (deck, landing page, poster, wireframe) | `html` |
| JS interaction but no database (prototype, SPA, form validation, external API calls) | `frontend` — the **default** when nothing says otherwise |

The file explicitly biases toward `frontend` when the user hasn't asked for persistence, and says to ask when the storage question is genuinely ambiguous — phrased toward the lighter option ("looks like a frontend app; does it need to save data?"). The trap worth noting: the CLI refuses to upgrade a `frontend` app to `full_stack` locally. That upgrade only happens in a cloud session, where you describe the backend need in natural language at `https://miaoda.feishu.cn/app/{app_id}`.

## Two Development Paths, and a Poster Child for "Done ≠ Published"

"Who writes the code?" is a separate, orthogonal question, and the skill keeps the two axes apart. Local development initializes a git-backed workspace with `+init` (or `+git-credential-init` plus stock git), pulls source down, and pushes back up. Cloud development starts a session — `+session-create` → `+chat` → `+session-get` — and the Miaoda AI generates and iterates the app. If the user hasn't said who writes the code, the skill says to ask, and not to pick a side silently.

`+export` is the escape hatch: it downloads a zip snapshot of the source **without** configuring git credentials or creating a workspace — the right move when you only need a copy, or when you're reading someone else's shared app you have no permission to modify.

The publication guardrail is the sharpest part of the file. A cloud-session "completed" status, or `is_published=true` on a list call, does **not** mean the latest content is live. Publishing is its own chain: confirm the code is committed and pushed, then `+release-create`, then poll `+release-get` until it returns `online_url` (or `error_logs` on failure). Dev and published states even live on different link shapes — and creative-mode HTML apps collapse both to one URL, `https://{tenant}/page/{meta_token}`, which looks exactly like a Feishu document link. The skill warns that it's a Miaoda app, not a doc, and to resolve the `meta_token` via `+get` before doing anything else with it.

## Four Rules That Save You the Expensive Edits

The SKILL.md pairs every hazard with a discipline, and four stand out.

**App IDs have two prefixes.** A Miaoda app_id starts with `app_`. A `cli_` ID is the Feishu app ID that lark-cli itself authenticates with — never hand one to any `apps +*` command. There's also `meta_token` for creative-mode apps, resolved through `+get`.

**Media never enters git.** Images, fonts, and audio belong to the platform's file store, uploaded per app with `+file-upload`, and referenced by the returned URL — and links are app-isolated, so a URL from one app cannot be reused in another. Inlining, local paths, and base64 in source all violate the boundary.

**Destructive commands demand explicit confirmation, even after pre-authorization.** `+cache-clear` wipes an entire environment's cache, `+env-delete` removes a variable, role and member removals are irreversible. The baseline is `--dry-run` first, then `--yes` only against a confirmed target. "Let me clear the cache" names an operation, the file says, but it does not confirm nuking the whole environment — one of the few rules the skill marks as non-waivable.

**Error hints are advice to the user, not commands to the agent.** When a command fails, the agent relays `error.hint` as a fix suggestion and stops, instead of chaining follow-up actions off it. And at runtime, application code never shells out to `lark-cli` — apps use in-project SDKs, with the CLI reserved for platform verification and changes.

## Where It Sits in the Lark Family

Real talk from the walking-through-it: this skill is an intent router with unusually strict guardrails, and the family numbers on skills.sh confirm it's pack-level, not skill-level, counting — lark-base at 724,268, lark-approval 723,463, [lark-markdown](/skills/automation/lark-markdown/) 688,326, [lark-vc-agent](/skills/automation/lark-vc-agent/) 666,177, lark-apps 632,894, lark-note 506,023, all matching the same open.feishu.cn counter. The boundary map in the SKILL.md keeps the siblings clean: file uploads and document editing go to [lark-doc](/skills/automation/lark-doc/), and [lark-base](/skills/automation/lark-base/) owns the spreadsheet-style database — while lark-apps owns the hosted-app lifecycle.

If you manage tools on Feishu, install it with `npx skills add https://github.com/larksuite/cli --skill lark-apps`, then let `+create` make the first app and walk the type question before anything else. The guardrails give you room to be wrong cheaply.