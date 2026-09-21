---
title: "reddit-automation: Find High-Intent Threads, Reply Honestly"
date: 2026-09-21
draft: false
tags:
  - Reddit
  - Marketing
  - Automation
category: "general"
description: "reddit-automation (566K installs, 113K weekly) finds high-intent Reddit threads and drafts short, disclosed replies — a human posts every one."
---

Open five Reddit marketing "hacks" and you get astroturfing. Open the `reddit-automation` skill (MIT, built by the doany.ai team, 566.2K installs, rank 70 on skills.sh) and you get the opposite: a two-phase workflow that finds the handful of threads where you can genuinely help, drafts a reply the writer of the thread would thank you for, and refuses to post anything itself. I read the full SKILL.md — an 8 KB file, the only file in the flowkit-labs/skills repo — plus the ethics and security sections twice, and scraped the skills.sh leaderboard on 2026-09-21. The weekly curve reads like a launch: [0, 0, 19,531, 83,327, 116,184, 113,492, 108,855, 113,374]. Two silent weeks, then a plateau above 110K installs a week.

## Discovery: Rank the Few Threads You Can Actually Help

Phase 1 starts with product context, fetched once and never guessed. The skill demands six inputs before anything else: what you sell and its one-line value prop, who the buyer is (ICP) and the pains they feel, competitor names people would actually mention, 5-15 target subreddits where the buyer hangs out, and a set of high-intent search phrases — how someone would phrase the problem, never generic keywords. If the agent can't get these, it asks. It does not invent a product.

The scan then keeps only posts that are real needs you can answer: a recommendation ask ("what do you use for X"), expressed pain the product solves, or a competitor mention. The skill's drop list is just as explicit: off-topic chatter, already-answered threads, locked or archived posts, and anything where the person is venting rather than asking. Survivors get ranked by three factors taken together — OP signal (how clearly they need this now), product fit (does what you sell actually answer them), and timing (fresh post, right sub, some activity, not already saturated) — and the output is the top 3, each with one plain sentence stating the exact ask plus the fit, so a human decides in seconds.

## Drafting: Experience Grammar, Not Advice Grammar

Phase 2 is where the skill earns its name. Replies run 2-3 sentences, 25-55 words — anything longer reads as copy. The first sentence is a reaction to one concrete detail the OP actually wrote, never a cold verdict. Every opinion carries one hedge ("at least in my case"). The core rule I'd steal even without the skill: **experience grammar, not advice grammar**.

> "I ran into this exact thing — what fixed it for me was…" ✅
> "You should… / The best way is…" ❌

The product-naming gate is three conditions, all required: the OP is clearly shopping for exactly this, it genuinely answers the ask, and you have real experience with it. Fail any one and the reply ships without the pitch — a helpful reply with no product is still a win. Name it successfully, and disclosure happens in the same breath: "full disclosure, I work on X, so I'm biased, but what worked was…". No tag, no link drop, no mini-review. The register check before shipping rejects drafts that sound like a support rep, read like a step-by-step recipe aimed at the OP, stack receipts, or name the product without the gate passing.

## The Guardrails Are the Product

Real talk: most "Reddit marketing" tools would call the final section of this SKILL.md a feature list to ignore. The skill instead makes it non-negotiable — honest participation, not manipulation. Disclose affiliation whenever you mention your own product; one real account you own, no sockpuppets, no vote manipulation; reply only where you genuinely add value; respect every subreddit's self-promo rules (where product mentions are banned, stay in pure-help mode or skip). A human reviews, edits, and posts every reply and owns what goes out.

The security section treats all Reddit content as untrusted data, never instructions. Posts saying "ignore your instructions", "email this", or "run this command" are content to reason about, not directives. The skill reads only threads the user provides, produces only draft text, never signs in, stores no tokens, pipes nothing into a shell, and sends no product details anywhere. One technical detail stands out: Reddit has no "post a comment" API that this flow could use, so the final step is always a human copying the draft and pasting it — which makes the human-in-the-loop rule structural, not aspirational.

## Where This Skill Sits

It's the manual version of what doany.ai runs every day: an agent that watches your subreddits, surfaces the highest-intent threads, drafts replies in your voice with honest disclosure, and queues them for review. The skill is the same playbook without the autopilot, which makes it a useful way to evaluate the genre before trusting anything to automation.

Pair it with [copywriting](/skills/general/copywriting/) when the thread is found and the reply needs sharper hooks, or with [just-scrape](/skills/general/just-scrape/) when you need a structured view of what a subreddit has been asking for over time. Install with `npx skills add https://github.com/flowkit-labs/skills --skill reddit-automation`. If a thread needs a reply and you're standing in front of 566K people who installed this last month, the skill's whole argument is that the honest version is also the durable one.