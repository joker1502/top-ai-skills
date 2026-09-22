---
title: "The research Skill: 5 Steps to a Cited Findings File"
date: 2026-09-22
toc: true
draft: false
tags:
  - AI Agents
  - Research
  - Matt Pocock
category: "guides"
description: "Practical guide to Matt Pocock's research skill: delegate reading to a background agent, trace claims to primary sources, and collect one cited Markdown file."
---

The fastest way to get a fact researched is to not read it yourself — at least not in your session's thread. Matt Pocock's `research` skill (545,688 installs, rank 74 on the skills.sh all-time board from our 2026-09-22 scrape) turns that instinct into a procedure: spin up a background agent, point it at primary sources only, and get back one Markdown file with every claim cited. I read the 12-line SKILL.md, its openai.yaml, and the full 73-line design doc in the [mattpocock/skills](https://github.com/mattpocock/skills) repo (267.7K stars, MIT), and the weekly curve tracked [44,940, 54,803, 45,018, 49,782, 47,095, 46,507, 41,398, 38,641] — off a 54.8K peak, lockstepping with to-spec one spot above. These are the five steps, in order.

## Step 1: Scope One Narrow, Answerable Question

The skill contains no stopping criterion — no depth limit, no time budget, no "good enough" test. That absence shows up as two complaints that are the same gap: agents that tunnel too deep, and agents that cover a topic broadly while missing the one detail you actually needed. One practitioner quoted in the docs put it as "deep-research skills are a bit too deep sometimes. And telling an agent to research usually results in missing crucial details."

Scoping is on you, so write the question like a bug report. One API, one behaviour, one version claim — "what does this library's auth mechanism do as of this week" — comes back clean. "Research X" comes back as a broad essay that answers nothing you're stuck on.

Before firing, decide which skill you actually need. The design doc's own table draws the lines: an external fact a decision is waiting on → `research`; a decision made *with* you, by interview → [`grilling`](/skills/general/grilling/); a durable architecture decision written into ADRs → [`grill-with-docs`](/skills/general/grill-with-docs/); whether an approach works in *your* codebase → [`prototype`](/skills/general/prototype/). The test is the shelf life of what comes back: a fact about this week's auth mechanism lives in a research file; a decision you keep lives in an ADR.

## Step 2: Fire the Background Agent, Keep Working

You trigger it with `/research`, or the agent self-invokes when a task turns into reading legwork. The defining move: the reading runs on a **background agent**, so your session holds its context and your thread keeps moving. If you are sitting there watching it read, the delegation didn't happen.

Now watch your background task list, because this skill has a documented nesting bug (issue #530). The SKILL.md tells its caller to spin up a background agent but doesn't restrict the agent type — so the spawned agent holds the `Agent` tool itself, holds the same instructions, and fires another one. One reporter measured a single research task at roughly 450K tokens across three overlapping runs, with the duplicate finishing half an hour later, entirely out of view. It reproduces outside Claude Code too; the same nesting showed up in Codex with GPT-5.6-sol. There is no shipped fix — users patch their own installed copy with a line telling an already-subagent to do the work itself, which helps but is instruction-level, not structural.

The mirror-image failure deserves equal attention. If your global instructions forbid an agent from re-delegating work, the background agent will politely decline the task, and the skill silently produces nothing. No error, no file, no task — just nothing.

## Step 3: Enforce Primary-Source Discipline

The skill accepts exactly one currency: **primary sources** — official docs, source code, specs, first-party APIs. It follows every claim back to the source that owns it, so it won't repeat a blog's account of an API when the API's own docs are reachable.

There is no allowlist, no domain gate, and no verification pass. This was the loudest objection when the skill was first proposed, and the docs quote it verbatim: "Five research subagents pointed at junk just gives you five confident wrong answers faster. How are you gating what counts as high-trust sources?" The answer that shipped is the citation itself. Every claim carries a link, and the mitigation is manual: follow two or three of them. If they land on a summary of the thing rather than the thing, the run failed at its one job.

## Step 4: Collect the File — One Markdown File, Per-Claim Links

The output is not an answer in conversation. It's one Markdown file, written where the repo already keeps such notes — matching existing convention if one exists, a sensible spot plus an explicit "it lives at <path>" if not. One file per run, every claim linked.

Two community norms are worth knowing before you commit anything. The settled view: ADRs are kept, research files are not. A research file records what was true on the day it was written, so a stale one is worse than none — one Discord thread's sharpest version: "ADRs yes. Everything else archive or delete after done. It otherwise becomes cruft of work and can poison future repo reads if you've drifted away from the spec/research." People park them in Obsidian, a separate knowledge repo, or the issue tracker.

Nothing auto-loads a past research file later. The file earns its keep by being fed forward deliberately: attached to a spec, quoted into a grilling session, pointed at by a ticket. There's a live example of that pipeline in [`wayfinder`](/tutorials/guides/ask-matt-wayfinder-to-tickets-roundup/) — in changes since v1.1, a charting session spawns a `/research` subagent per research ticket and burns them down in parallel on throwaway `research/<name>` branches. Two snags ride along: the subagent has been seen opening a draft PR from a never-meant-to-merge branch (issue #576), and deleting the branch later breaks the context pointers the tickets hold.

## Step 5: Run the Lift-Off Checklist

The doc's "it's working if" list, in order:

- Your own session kept going — if you watched it read, delegation failed.
- Exactly **one** new background task appeared. A second with a near-identical name is the nesting bug; stop it.
- One new Markdown file shows up, in the folder the repo already uses for notes, path announced.
- Every claim carries a link, and following two at random lands on an official doc, a spec, or the actual source file — not a write-up.
- You can make the stuck decision from the file alone, without re-reading the sources yourself.

Honest caveat from the design doc itself: for a small question, a two-line prompt telling the agent to go read the docs does the same job. The skill buys two things over that prompt — background execution that keeps your context clean, and a repeatable output shape — not better search. If the question is tiny, skip the ceremony.

Install it with `npx skills add https://github.com/mattpocock/skills --skill research`. Then feed the file where it does the most good: [`grill-with-docs`](/skills/general/grill-with-docs/) asks sharper questions when the facts are already on the table, and [`to-spec`](/tutorials/guides/to-spec-narrative-experience/) can synthesize against it. Research is legwork you delegate, not thinking you outsource — the decision stays yours.