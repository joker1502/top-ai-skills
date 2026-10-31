---
title: "Superpowers' 15 Standalone Skills: Iron Laws and Counters"
date: 2026-10-31
draft: false
tags:
  - Superpowers
  - Skills
  - Methodology
category: "guides"
description: "I read 15 obra/superpowers SKILL.md files (141 KB) and their counters, where six mirror repos report the same skills at more than double the original's numbers."
---

obra/superpowers ships fifteen skills, and eight of them sit on the skills.sh leaderboard under the original repo's name while six mirror repos republish neighboring skills at more than twice the install numbers. That gap is the first thing to understand about this pack, and the SKILL.md files themselves are the second.

I pulled all fifteen files on 2026-10-31 — 141,020 bytes of markdown — plus the repo's counter rows. The repo carried 309,866 stars and had been pushed two days earlier. What follows is what those fifteen files actually teach, sorted by the parts you can reuse outside Superpowers.

## What's Inside

The README sorts the fifteen into four groups. File sizes matter here, because they show where the author spent words:

| Skill | Bytes | Group |
|:--|--:|:--|
| subagent-driven-development | 19,506 | Collaboration |
| executing-plans | 18,103 | Collaboration |
| writing-skills | 16,738 | Meta |
| brainstorming | 13,602 | Collaboration |
| writing-plans | 10,335 | Collaboration |
| test-driven-development | 9,578 | Testing |
| systematic-debugging | 9,530 | Debugging |
| finishing-a-development-branch | 7,781 | Collaboration |
| diagnosing-superpowers | 6,941 | Debugging |
| using-git-worktrees | 6,813 | Collaboration |
| receiving-code-review | 6,203 | Collaboration |
| dispatching-parallel-agents | 6,078 | Collaboration |
| verification-before-completion | 3,646 | Debugging |
| using-superpowers | 3,192 | Meta |
| requesting-code-review | 2,974 | Collaboration |

The two execution skills swallow a third of the prose between them. That ratio tells you where the pack thinks agents fail: not in knowing what TDD is, but in running twenty tasks without drifting.

## Three Iron Laws, One Sentence Shape

Four files contain a block literally labelled "The Iron Law." Three of them read the same way — all-caps, no qualifier, no exception:

- Test-driven development: `NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST`
- Systematic debugging: `NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST`
- Verification before completion: `NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE`

Each file follows the law with the same move: a line that closes the loop between compliance and intent. TDD writes "Violating the letter of the rules is violating the spirit of the rules." Systematic debugging runs its own variant about the process.

Then comes the inventory of ways an agent talks itself out of the rule. Eight of the fifteen files carry a "Common Rationalizations" section, seven carry a "Red Flags" table, and the tables are written in the agent's own voice — the thought on the left, the correction on the right. Brainstorming's version includes "I'll fill in sensible defaults" paired with "Good. Say them out loud. A default they never heard is one they couldn't reject."

That pairing is the whole design. A rule alone gives an agent something to argue with. A rule plus a list of the exact arguments it will generate gives it a tripwire.

## writing-skills Holds the Only Measured Numbers

The most valuable file in the pack is also the one that almost never gets installed — writing-skills did not appear in the leaderboard's top 186 rows today, despite being the 16,738-byte manual for creating the other fourteen.

It opens by claiming skill authoring is TDD on documentation, then proves it with a mapping table: a test case is a pressure scenario run against a subagent, production code is the SKILL.md, RED is the baseline where the agent violates the rule without the skill present, GREEN is the same scenario with the skill loaded, and refactoring means closing the loopholes that survived.

The measurable part sits in a section called "Match the Form to the Failure." Four failure types get four different remedies, and the file warns that the wrong form backfires:

| Baseline failure | Right form | Wrong form |
|:--|:--|:--|
| Breaks a rule under pressure | Prohibition + rationalization table + red flags | Soft guidance ("prefer…", "consider…") |
| Complies, wrong output shape | Positive recipe stating what the output is | Prohibition list |
| Omits a required element | REQUIRED slot in the template | Prose reminder near the template |
| Behaviour depends on a condition | Conditional keyed to an observable predicate | Unconditional rule plus exemptions |

The supporting claim is unusually specific for a skill file: in head-to-head wording tests on dispatch-prompt guidance, the prohibition arm produced clearly more of the unwanted content than the recipe arm, with fully separated distributions, and trended worse than even the no-guidance control. It also reports that appending a single nuance clause to a winning recipe degraded its output "from consistent to noisy."

I have no access to those underlying tests, so treat the numbers as the author's report rather than something I reproduced. The direction matches what I've seen in my own skill files, where "never do X" invites negotiation and a stated output shape does not.

## Inline or Subagent: The Cost Argument Is Written Out

executing-plans and subagent-driven-development solve the same problem two ways, and the pack refuses to pretend one is free. Executing-plans states the bill directly: subagent-driven development pays for a fresh implementer and a fresh reviewer on every task, each re-reading the codebase from zero, while inline execution pays for one context plus one reviewer at the branch's end.

The choice gets made by availability and size. No subagent tool, or a human who wants to watch, means inline. Independent tasks with a plan worth gating means subagents.

Both share a rule about plan granularity that I keep stealing. From writing-plans: a task is the smallest unit that carries its own test cycle and is worth a fresh reviewer's gate, and you "split only where a reviewer could meaningfully reject one task while approving its neighbor." Everything else — setup, config, scaffolding, docs — folds into the task that needs it.

The residency rule in subagent-driven-development is the one I'd frame on a wall. Everything pasted into a dispatch prompt, and everything a subagent prints back, stays resident in the orchestrator's context for the rest of the session and gets re-read on every later turn. Hand artifacts over as files. Record `git rev-parse HEAD` before dispatching, since the review package and fix-round diffs need that base.

## Never Poll, and Four Other Anti-Patterns Worth Copying

The waiting discipline in subagent-driven-development contradicts what most agents do by default. Never poll a wait interface with short timeouts, and never park in one silent open-ended wait either. Keep working while local work exists, because child results arrive on their own. When genuinely idle, wait in bounded stretches of five to ten minutes, post one status line between stretches, and reconcile the live children — list them and chase any that finished without reporting.

dispatching-parallel-agents supplies the case study: six test failures across three files after a refactor, split into abort logic, batch completion, and race conditions, with each agent getting one file and never inheriting the session history. It also lists the conditions where parallel dispatch is wrong — related failures where one fix might resolve others, work that needs the whole system in view, exploratory debugging, and anything sharing state.

Two more habits round out the set. using-superpowers enforces the 1% rule — if there's even a chance a skill applies, invoke it before responding, including before clarifying questions. And brainstorming bans the menu: ask what the person wants described, don't offer options, because options steer.

## The Counter Math

Eight original skills chart between 249,500 and 412,800 installs, a 1.65x spread across files that carry the same author and the same release:

| Skill (obra/superpowers) | Installs | Last week |
|:--|--:|--:|
| brainstorming | 412.8K | 8,941 |
| systematic-debugging | 315.1K | 9,353 |
| writing-plans | 289.8K | 6,988 |
| using-superpowers | 276.1K | 5,533 |
| requesting-code-review | 268.3K | 6,442 |
| test-driven-development | 266.0K | 6,777 |
| verification-before-completion | 259.7K | 8,571 |
| executing-plans | 249.5K | 6,652 |

The mirrors publish a different skill set with the same lineage — ai-video-generation, ai-image-generation, twitter-automation, ai-avatar-video — and they report far larger totals. 101-skills/superpowers sits at 915.6K to 913.6K across four of them, with weekly installs [13,241, 64,317, 213,120, 240,489, 130,740, 72,792, 67,895, 67,605]. qu-skills/superpowers reports 598.2K, skills-shell 534.2K, its-a-skill-issue 446.5K after a leading zero week.

Two things follow. A spike of 240,489 weekly installs that decays to 67,000 in three weeks is a campaign, not organic adoption. And the totals on this site are counters, not demand — the mirror with the largest number is republishing someone else's work.

What the counters cannot tell you is which file has the most transferable idea. That answer is sitting in a 3,646-byte file that almost nobody installs: open [verification-before-completion](https://github.com/obra/superpowers/tree/main/skills/verification-before-completion) first, read the gate function, then compare it with the [TDD skill page](/skills/general/tdd/) we already cover and the [Matt Pocock methodology roundup](/tutorials/guides/mattpocock-new-skills-roundup-2026/) for the second family trying to solve the same discipline problem.
