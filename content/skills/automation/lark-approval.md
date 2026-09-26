---
title: "lark-approval: File and Approve Feishu Requests From CLI (729K)"
date: 2026-09-26
draft: false
tags:
  - Lark
  - Feishu
  - Approvals
category: "automation"
description: "Feishu's lark-approval skill handles the full approval lifecycle from the CLI — file instances, approve, transfer, rollback, remind. 728.9K installs, rank 127."
---

The most expensive noun in Feishu automation is "task": an approval waiting on you is called a task, but it is **not** a Feishu task. The official `lark-approval` skill (v1.2.0, inside [larksuite/cli](https://github.com/larksuite/cli), 17.4K stars) opens with exactly that warning — its routing table says any request whose core object is an approval document, approval todo, or approval instance belongs here, and only non-approval todos may drift to `lark-task`. I read its 6,969-byte SKILL.md and all 16 reference files end to end, then scraped skills.sh on 2026-09-26: the open.feishu.cn counter shows **728,900 all-time installs**, and the larksuite/cli direct counter adds **422.4K more (rank 127)** with its own slower weekly band of 9,286, 7,972, 7,262, 6,736, 7,506, 7,564, 6,732, 6,670.

## The Routing Rule That Decides the Whole Session

The SKILL.md's first section is a priority declaration, and it exists because agents routinely lose approval requests to the wrong tool. The trigger list is explicit: approve, reject, transfer, rollback, withdraw, remind, add-sign, cc, plus any query about todos, initiated requests, or instance details. **If the final action touches an approval document, route here.** `lark-task` only gets you when the object is a plain non-approval todo.

The behavior rules matter more than the command list. Ops must grab the minimum first — `tasks query` returns the `instance_code` + `task_id` pair, and **every write operation needs both**, so the skill says to stop there unless the user actually asks for details, current node, form content, or progress. Only then call `instances get`. If the user hands you an `instance_code` directly, do not query a list to re-find it.

## Filing an Approval: the Never-Skip Step

Starting a request runs a fixed chain: `approvals search` → `approvals get` → `instances create`. The middle step is the one agents skip and the file forbids skipping — you cannot assemble a valid create payload without the definition's control snapshot and node list. Two hard stops live here:

- A definition flagged `is_external=true` is third-party. Return its `create_link`; calling `instances create` on it is explicitly forbidden.
- `approvals.get.form` is a **snapshot for reading control IDs, types, and option ranges — not a payload template**. The real `instances create --data.form` is a JSON *array string*, and each control type formats its value differently: `date` wants RFC3339, `amount` wants a number plus a `currency` field, `contact` accepts only `open_ids`, `telephone` needs `countryCode` + `nationalNumber`, `document` needs a `token` plus `type: docx`, `department` values are `open_department_id` entries.

The honesty rule is the sharpest part of the file: if the target definition contains a control the create API does not support — `mutableGroup`, `tripGroup`, `serialNumber`, `account`, or any of the `apaascorehr*` onboarding groups — the skill says tell the user the definition cannot be fully filed via API, instead of guessing a value and firing a broken request.

## The 1395001 Discipline: Stop Retrying

Write operations return error `1395001` (task state abnormal / pre-write validation failed) when the world changed under you — another colleague approved it first, the instance moved to a node where the action is no longer allowed, or your permission expired. The reference file for the whole family of actions (reject, transfer, rollback, withdraw, remind) is a retry-limiting decision tree: **at most one retry**, then a single status re-check (`tasks query` or `instances get`), then report a conclusion and the next step to the user. No query/write loops, no blind re-submits — the file explicitly calls those "token and time burners." Withdraws (`instances cancel`) are flagged `high-risk-write` and demand `--dry-run` first, then `--yes` only against a confirmed target, and they take just an `instance_code` — no `task_id` needed.

## Where It Sits in the Lark Family

The open.feishu.cn numbers confirm the family is one counter, not seven: lark-doc 730.0K, lark-approval 728.9K, lark-okr 708.2K, [lark-markdown](/skills/automation/lark-markdown/) 693.8K, [lark-vc-agent](/skills/automation/lark-vc-agent/) 671.5K, [lark-apps](/skills/automation/lark-apps/) 638.3K, lark-note 511.3K — every one riding the same [37K → 25K] weekly decline. The direct larksuite/cli counter tells a different story: 422.4K at rank 127 with a flat 7-9K/week band, meaning real npx-style installs keep coming after the platform push faded. All commands default to `--as user` because approvals are a person's action, and the skill requires reading `lark-shared/SKILL.md` (auth and permission handling) before anything else.

If your agent keeps answering "approve" requests with task tools, install this one — `npx skills add https://github.com/larksuite/cli --skill lark-approval` — and let the routing declaration do the work. The next time someone says "approve the leave request on my desk," the agent will know exactly which noun it's holding.