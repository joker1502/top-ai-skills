---
title: "Using the Copywriting Skill to Ship a Landing Page in One Afternoon"
date: 2026-06-19
draft: false
toc: true
tags:
  - Copywriting
  - Marketing
  - AI Writing
description: "I used the Copywriting skills.sh agent to go from product description to live landing page in 4 hours. Here is what worked, what did not, and what surprised me."
category: guides
---

## Why I Went Down This Rabbit Hole

I had a new side project — a small SEO tool I'd been building on weekends — and I needed a landing page and an email sequence to launch it. The tool itself was done, but the marketing copy was sitting in a Notion doc of half-finished sentences. I could either spend a week polishing drafts or find a faster way.

I had seen the Copywriting skill on skills.sh a few weeks earlier and wrote it off as something for people who run newsletters, not someone shipping a bare-bones MVP. But the launch deadline was Friday and it was already Wednesday afternoon. I installed it.

## Setup: How Long It Actually Took

Five minutes. The skill had zero dependencies — no API keys, no configuration files, no model setup. I ran:

```
npx skills add coreyhaines31/copywriting
```

Then inside Claude Code, I activated it with `/skills add copywriting`. That was it. The skill showed up as active on the first try, which is rare enough in the skills ecosystem that I should note it.

I did spend another 15 minutes reading through the skill's prompts to understand what formats it supported. The README on GitHub lists the capabilities but doesn't show example output, so I had to test each format to see the actual structure it produces.

## What I Built With It

I needed three things for the launch: a landing page hero section, a 3-email launch sequence, and social posts for Twitter and LinkedIn.

For the landing page, I gave the skill a two-sentence description of the tool:

*"An SEO monitoring tool that checks your site against Google's GEO guidelines. It runs weekly audits and emails you a report. Targets small site owners who don't have a dedicated SEO person."*

The skill returned a landing page draft with a headline, subheadline, three feature bullets, and a CTA. The headline was usable — not great, but a solid starting point. I ended up tweaking it from "Never Miss a GEO Update Again" to "Weekly GEO Checks for Sites That Can't Afford an SEO Team." The feature bullets were all generic and I rewrote every single one.

The email sequence was where the skill actually impressed me. It generated three emails with proper open-loop hooks, a value-add middle section, and clear CTAs. The first email subject line was "Your site is probably failing GEO right now" — which I kept as-is because it worked. The second and third emails needed restructuring because they assumed the reader had already engaged with the tool, but the structural bones were correct.

Social posts were the weakest output. The LinkedIn post read like a generic AI-generated thought leadership piece, and the Twitter thread was too long for the format. I ended up writing those from scratch.

## What Surprised Me

The skill handled tone consistently across formats. The voice was the same in the landing page and the emails — a bit professional, a bit direct, no marketing fluff. That consistency is harder to get from prompting a general model fresh each time, because you never phrase the tone instruction exactly the same way twice.

I also did not expect the skill to know about copywriting frameworks. The email sequence used an AIDA structure (Attention, Interest, Desire, Action) without being asked. I noticed it because the second email started with a story hook rather than a recap, which is a textbook AIDA move. Whether the skill's instruction set explicitly teaches that or it emerged from the training data, it saved me from having to restructure the sequence.

## Things That Annoyed Me

The skill has no concept of word limits. I asked for "short social posts" and got 300-word LinkedIn posts that took more editing than writing from scratch would have. There is no parameter for output length — you have to add it to your request in natural language, and the skill doesn't always respect it.

The landing page output also came as a markdown blob rather than structured sections I could copy-paste. I had to split the hero, features, and CTA into separate files myself. For a skill named "Copywriting," I expected awareness that landing pages have distinct visual sections, not a continuous wall of text.

## When I Use It vs When I Don't

I use the skill now whenever I need first-draft marketing copy for a new project — landing pages, email sequences, ad headlines. It saves me the blank page problem and gives me something to edit rather than stare at.

I do not use it for anything that needs a specific brand voice or deep audience knowledge. If I were writing for an established product with existing customers, the skill's generic tone would create more cleanup work than it saves. The output is a draft, not a deliverable, and treating it as the latter would ship mediocre copy.

For the launch that Wednesday, the skill got me from zero to a published landing page and a scheduled email sequence in about four hours. I could not have done that in one afternoon writing from scratch, even if the final copy ended up being mostly my words.
