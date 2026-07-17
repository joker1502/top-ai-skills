---
title: "I Let AI Handle My Team's Approval Workflow for a Week — Here's What Happened"
date: 2026-07-17
draft: false
toc: true
tags:
  - Approval Workflow
  - Lark
  - Feishu
  - AI Agent
  - Workflow Automation
  - Narrative
description: "I handed my AI agent control over our team's approval workflow for five days. Expense reports, leave requests, purchase orders — all processed through the lark-approval AI skill. Here is what went right, what broke, and whether I would do it again."
category: guides
related_skills:
  - lark-approval
---
I handed my AI agent control over our team's approval workflow for five days. Expense reports, leave requests, purchase orders — all processed through an AI skill. Here is what went right, what broke, and whether I would do it again.

## Why I Decided to Try This

Our team runs on Lark. I manage a group of fifteen engineers, a couple of product managers, and a rotating cast of interns. Every week brings a steady stream of approval requests. Leave applications, hardware purchase requests, conference travel approvals, expense reports from team lunches — the kind of administrative overhead that is simple but constant.

I was spending about thirty to forty minutes each morning clearing pending approvals. Open Lark, check the approval center, read each request, make a decision, move to the next. It is not hard work. It is just *there*, every single day, eating into focus time before I even touch code.

When I discovered the lark-approval AI skill, I wondered: could my AI agent handle this instead? Not all of it — I was not about to let an algorithm approve a team member's two-week vacation without a human check. But the routine stuff? The predictable, rule-based approvals? That felt like a fair experiment.

I set a boundary going in: anything under a preset threshold (expenses under $200, standard leave under three days, any hardware under $500) goes to the AI agent. Everything else gets flagged for human review. One work week. Real approvals. Real consequences.

## Setup: Getting the Skill Working

The lark-approval skill is part of the larksuite CLI ecosystem. Installing it was the easy part:

```
npx skills add https://open.feishu.cn
```

That single command pulled in the entire Lark skill suite — including lark-doc, lark-base, lark-approval, and others. The approval skill registered itself automatically.

The harder part was authentication. Lark's permission model is layered. You need API access enabled on your Lark tenant, a bot token with the right scopes, and the approval management scope specifically checked in the Lark admin console. If you have never touched Lark's admin panel before, budget about thirty minutes for this step. I spent most of that time searching for the right permission checkbox. Once I found it (it lives under "Security and Permission" → "API Access" → "Approval"), everything else clicked.

I configured the skill with a set of rules written as plain instructions to my AI agent:

- Leave requests shorter than three days: auto-approve unless the requester has taken leave in the last two weeks
- Expense reports under $200: auto-approve if category is "team meals" or "office supplies"
- Hardware requests under $500: auto-approve for standard items (keyboard, monitor, docking station)
- Everything else: flag for my review with a summary

I started the experiment on Monday morning.

## Day 1: The Honeymoon Phase

Monday hit with eleven pending approvals. Most of them had accumulated over the weekend. My AI agent processed the entire batch in under two minutes while I was making coffee.

It approved three leave requests for the following week (two single days, one two-day stretch). It greenlit four expense reports from Friday's team lunch. It flagged a $1,200 monitor request and a two-week leave application for my review, each with a one-sentence summary of why it needed human eyes.

Coffee in hand, I reviewed the flags. The monitor request was for a designer who needed a color-accurate display — easy approve. The two-week leave was for a senior engineer going to a wedding abroad — also fine, just needed a quick check on coverage.

Total time spent on approvals that morning: maybe four minutes. Down from the usual thirty-five. I felt like I had discovered a cheat code.

The AI agent also surfaced something I had missed: an expense report from two weeks ago that was stuck in draft mode. The submitter had attached receipts but never actually sent it. The skill picked it up because it scanned all approval-related records, not just pending items. That alone saved me from chasing someone manually later.

## Day 2: The First Edge Case

Tuesday brought the first genuine edge case. A team member submitted a leave request for "one day" — a Friday before a public holiday Monday. Technically a single day. Technically under my three-day auto-approve rule. But anyone who has managed a team knows a Friday before a long weekend is not really one day. It is four days of coverage gap in practice.

The agent approved it. The rule said under three days, and that was that.

I caught it during my midday check. I updated the rules to add context: "If the leave day is adjacent to a public holiday, treat consecutive calendar days as a single leave period." A human manager would have known this instinctively. The AI could not infer it from the rules I gave it. That was on me. Lesson learned: your rules need to account for cultural context, not just arithmetic.

I also noticed the agent had approved an expense report from a team member who had already maxed out their monthly dining budget. Lark's approval system tracks budgets per category, but my rules did not reference that data. I added another rule: "Check the requester's remaining budget before approving any expense."

## Day 3: Building Trust

Wednesday was quiet. Seven approvals came in — the lowest volume of the week. The agent handled six without issue. The seventh was flagged correctly: a purchase order for cloud credits that exceeded the auto-approve threshold.

I started feeling more comfortable. The training wheels were coming off. I stopped checking the approval log every hour and switched to two reviews per day — once mid-morning, once before wrapping up.

The biggest surprise was how the skill handled the approval history feature. A product manager asked me whether a certain expense report from last month had been approved. Normally I would have to dig through Lark's approval center or ask finance. Instead I asked my AI agent through the terminal. It queried the approval history and returned the answer in about four seconds. The expense had been approved on May 12. That alone saved a cross-team Slack thread.

## Day 4: When It Almost Went Wrong

Thursday morning I opened my terminal to find three flagged items. Normal enough. But one of them gave me pause.

The agent had flagged an expense report from a team member who tried to expense a $180 mechanical keyboard under "office supplies." It fit my rules — under $200, standard category. But the agent flagged it anyway because the requester had already purchased two keyboards this quarter.

I had missed that rule. The agent inferred from the approval history that "more than one keyboard per quarter" was suspicious, even though I never explicitly told it to flag repeat hardware purchases. It picked up the pattern from past approval decisions I had made.

That was the moment the experiment shifted in my mind. The skill was not just following rules. It was learning the spirit of my decisions. I did not train it. It just had access to enough context in the approval records to make a smarter call.

I kept the flag. The keyboard request was reasonable (the old one had a broken USB port), so I approved it manually. But I was glad the agent caught it.

## Day 5: The Verdict

Friday wrapped with thirteen approvals processed across the week. Here is the breakdown:

| Category | Auto-Approved | Flagged for Review | Human Decision |
|----------|:------------:|:-----------------:|:--------------:|
| Leave requests | 8 | 3 | All approved |
| Expense reports | 12 | 4 | 3 approved, 1 sent back |
| Hardware requests | 3 | 2 | All approved |
| Purchase orders | 0 | 2 | 1 approved, 1 pending vendor quote |
| **Total** | **23** | **11** | |

The AI agent handled 23 out of 34 approval actions without any human involvement. That is about 68% automation rate. The 11 flagged items took me maybe twelve minutes total to review across the entire week.

Before the experiment, I was spending roughly two and a half hours per week on approvals. With the AI skill handling the routine work, that dropped to about fifteen minutes. A 90% reduction.

## What I Learned

**Rules need context, not just numbers.** The Friday-before-a-holiday edge case was a reminder that approval workflows exist inside a culture, not a spreadsheet. Your rules need to account for real-world patterns, not just thresholds.

**Your approval history is more valuable than you think.** The smartest thing the skill did was not the auto-approvals. It was the pattern matching — flagging the third keyboard purchase even though it technically passed the dollar threshold. That kind of contextual awareness only works because the skill has access to the full approval history.

**Review flags are the sweet spot.** Full automation is risky. Full manual is slow. The middle path — auto-approve the predictable stuff, flag everything else with a summary — is where the real time savings live. I never felt like I lost control, because every unusual request still hit my inbox.

**Start small, expand as trust builds.** Day one felt like handing a teenager the car keys. By day five, I was comfortable letting the agent handle the morning batch without supervision. The key was starting with conservative rules and expanding them as I saw what the skill could and could not handle.

## Would I Do It Again?

Yes. I already have. The lark-approval skill is now a permanent part of my morning routine. I check the flags over breakfast, handle the edge cases in under ten minutes, and spend the rest of my focus time on work that actually requires human judgment.

The experiment changed how I think about AI and approvals. The question is not whether AI can replace human decision-making in workflows. It cannot, and it should not. The question is whether it can handle the predictable, routine decisions so humans have more time for the ones that actually matter. Based on this week, the answer is a clear yes.
