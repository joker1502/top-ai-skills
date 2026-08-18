---
title: "Domain Modeling With AI: Build a CONTEXT.md Glossary"
date: 2026-08-18
toc: true
draft: false
tags:
  - Domain Modeling
  - AI Coding
  - Documentation
description: "A step-by-step domain modeling walkthrough with Matt Pocock's skill — run the five moves, write a CONTEXT.md glossary, offer ADRs when all three tests pass."
category: "guides"
---

Your AI keeps calling everything an "account" while your codebase has Customer, User, and Subscription scattered across three modules. Fixing that mismatch is what domain modeling is for: pin down one canonical term, list the rejected synonyms, and record the decisions that were genuinely hard to reverse. I ran Matt Pocock's domain-modeling skill (412.8K installs, All-Time #65 on skills.sh) against a real repo and read its format files line by line — the skill looks trivial at first glance, but the bar it sets for writing anything down is the part worth copying even without the skill installed. This guide walks the full procedure: when the skill engages, the five moves it makes during a session, and the exact format rules for `CONTEXT.md` and ADRs.

## Before You Start: What This Skill Is (and Isn't)

`/domain-modeling` builds and sharpens your project's **ubiquitous language** while you design. Its own spec draws the line hard: reading `CONTEXT.md` to borrow vocabulary is a one-line habit any skill can do — this skill is for when you are *changing* the model, not consuming it. That distinction matters because it predicts behavior. A passive skill waits for a clean moment and produces a tidy glossary at the end of the conversation. This one interrupts you mid-sentence, writes a resolved term into `CONTEXT.md` the moment it resolves, and updates the file as the session's actual output rather than a summary of it.

You need nothing set up in advance. The skill writes into two places and creates both lazily: a `CONTEXT.md` at the repo root (born when the first term resolves) and a `docs/adr/` folder (born when the first qualifying decision appears). No scaffolding, no speculative files.

## How to Start a Session

Invoke `/domain-modeling` in Claude Code, Codex, or any agent that supports the skills.sh format. Install first if you haven't:

```bash
npx skills@latest add mattpocock/skills
```

Select `domain-modeling` when the installer asks, then restart your session. You can also let the agent fetch it automatically when the task fits — though the docs are blunt that automatic invocation is the weakest part of the skill. When `grill-with-docs` or `wayfinder` say to load it, models frequently load `grilling` and skip this one. Tell-tale sign: a grilling session ends and your `CONTEXT.md` is untouched. The fix is to name the skill explicitly alongside the other one.

## The Five Moves of a Domain Modeling Session

The skill's spec defines five moves it repeats whenever the words are the problem. I watched all five fire in a single refactoring session.

**1. Challenge the term against the glossary.** When you use a term that conflicts with existing language in `CONTEXT.md`, it calls it out immediately: *"Your glossary defines 'cancellation' as X, but you seem to mean Y — which is it?"* If two people mean different things by "cancellation," the skill picks the canonical term and lists the loser under `_Avoid_`.

**2. Sharpen fuzzy language.** Vague, overloaded words get forced into precision. *"You're saying 'account' — do you mean the Customer or the User?"* This move alone caught the mismatch I opened with: "account" was doing three jobs in three files, and the split into Customer and User took minutes, not hours.

**3. Stress-test relationships with concrete scenarios.** When domain relationships come up, it invents edge-case scenarios that force you to draw boundaries exactly: what happens to an Order when the customer's payment fails *after* the warehouse already picked it? The scenario does the work that abstract discussion avoids.

**4. Cross-reference with code.** When you state how something works, the skill checks whether the code agrees: *"Your code cancels entire Orders, but you just said partial cancellation is possible — which is right?"* This is the move that makes the skill click — the language and the code are made to agree out loud, before either changes. The limit: it cross-references code and committed files, not your issue tracker, so a naming decision argued out in a closed issue months ago gets re-surfaced as new.

**5. Update CONTEXT.md inline.** Resolved terms are written right there, mid-conversation, never batched up at the end. The spec is absolute about what the file may hold: *"a glossary and nothing else"* — no implementation details, no spec, no scratch pad.

## What Goes in CONTEXT.md (the Format Rules)

The format file defines the glossary entries precisely. Every entry is a bolded term name, a one or two sentence definition of what the thing **is** (not what it does), and an `_Avoid_` line listing rejected synonyms:

```md
**Customer**:
A person or organization that places orders.
_Avoid_: Client, buyer, account
```

Four rules govern what may enter. Be opinionated — when multiple words exist for one concept, pick the best and list the rest. Keep definitions tight, one or two sentences max, defining what it IS. Only include terms specific to this project's context — general programming concepts like timeouts or error types don't belong even if the project uses them constantly. Group terms under subheadings when natural clusters emerge.

Repos with one context get a single root `CONTEXT.md`. Repos with several get a root `CONTEXT-MAP.md` listing each context, where it lives, and the relationships between them — which context emits what events and who consumes them. The skill infers which structure applies; if neither file exists, it creates a root `CONTEXT.md` lazily.

## When an ADR Actually Gets Written

This is where the skill shows its spine. The docs hold ADRs to a three-part bar, and all three must pass:

1. **Hard to reverse** — changing your mind later costs real money or time
2. **Surprising without context** — a future reader will wonder "why did they do this?"
3. **The result of a real trade-off** — genuine alternatives existed and you picked one for a reason

Miss any one and there is no ADR. An easily-reversed choice will just get reversed; an unsurprising one is nobody's question; a non-choice records that you did the obvious thing. When all three pass, the skill *offers* — it never assumes — and writes to `docs/adr/` with sequential numbering (`0001-slug.md`). The format is deliberately brutal: one to three sentences covering context, the choice, and the reason. That's it. Optional sections exist (status, considered options, consequences) but only when they add value, and the docs say most ADRs won't need them.

The qualification list makes the bar concrete. Architectural shape ("the write model is event-sourced"), integration patterns between contexts, technology choices that carry lock-in (database, message bus, auth provider — not every library), boundary and scope decisions ("Customer data lives in the Customer context; others reference it by ID"), deliberate deviations from the obvious path, constraints not visible in the code, and rejected alternatives whose rejection would be re-litigated. Any of those that clears the three-test bar earns an ADR; every other decision stays out of the folder.

## Real Talk: The Failure Modes the Docs Admit

Three things went wrong enough times that the skill's own docs document them, and knowing them saves you a day each.

First, the most-reported problem across models: `CONTEXT.md` turning into a running spec. The moment models read "write to CONTEXT.md" as permission to persist every answer you give, the file balloons — one user reported 3,000 lines. The fix is a direct instruction: `/grill-with-docs make my CONTEXT.md more concise and remove any implementation details from it`. The docs warn that growth prevention is still an open issue.

Second, the untouched-file trap. `domain-modeling` is a reference skill that runs *underneath* other skills more often than on its own — grill-with-docs drives it, wayfinder loads it while charting, triage uses it to keep tickets in project vocabulary. When it silently doesn't load, you get a grilling session with nothing written down. Name it explicitly when that matters.

Third, small but real: an unreviewed, agent-authored glossary is worse than none — the docs call it "confident-sounding lore that later sessions treat as truth." Review entries, or skip the whole practice on a one-day build.

## Quick Verification Checklist

The docs end with an "it's working if" list worth stealing. The skill is working when it stops you mid-sentence to ask which of two things you meant instead of picking one and moving on — when `CONTEXT.md` changes *during* the conversation, not in a burst at the end — when it refuses an ADR for something you could undo tomorrow and says which test failed — and when new entries define what a thing is in one or two sentences with the words you're giving up listed under `_Avoid_`.

## Bottom Line

Domain modeling pays for itself the first time your AI builds a feature around a term the whole team calls something else. The skill enforces the discipline with an interruptive style that feels annoying for the first ten minutes and indispensable by the end of the session. It runs inside the bigger [Grill with Docs](/skills/general/grill-with-docs/) flow or standalone here, and it composes with the same family's [Grilling](/skills/general/grilling/) interview primitive when you want the vocabulary settled before a plan is approved. Install it with `npx skills@latest add mattpocock/skills`, and if your repo has no glossary yet, ask for one explicitly — the docs report a 50-question session to scaffold a brownfield codebase, which beats years of "which account did you mean?" in review threads.