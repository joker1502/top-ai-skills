---
title: "I Installed a 9.4k-Star Business Skill Pack and Ran Its Diagnosis"
date: 2026-08-12
toc: true
draft: false
tags:
  - Agent Skills
  - Business Skills
  - Hands-On Test
description: "I installed dbskill's 30 business skills on a live server and ran its diagnosis workflow — the CLI found 31 skills, and 2 of 73 agents rejected the install."
category: "guides"
---

The install finished in under a minute. The surprises came after: the CLI reported 31 skills where the README's badge promises 30, two of the 73 "supported" agents refused the install, and the diagnosis skill dissolved its own example question when I actually ran it. I installed dbskill — a 9.4k-star Chinese business-toolkit pack from dontbesilent — on a small Linux server, ran its `dbs-diagnosis` workflow on a real case, and kept notes on everything that didn't match the marketing. Here's the full test.

## The Install Ran in Under a Minute — Then the Count Didn't Match

I ran the README's command verbatim: `npx -y skills add dontbesilent2025/dbskill -g --all`. The skills.sh CLI cloned the repo, scanned it, and printed "Found 31 skills" before installing "all 31 skills" to "all 73 agents". The README badge says 30. I re-checked the folder: 31 directories — the `dbs` router plus 30 named skills. The badge just doesn't count the router. Minor, but it set the tone: this pack is bigger than its own docs.

The output also showed the install wasn't actually universal. Every skill failed for two agents with the same message: "Eve: Eve does not support global skill installation" and "PromptScript: PromptScript does not support global skill installation". The CLI symlinked everything into `~/.agents/skills/` plus Claude Code's skill directory and dozens of other agent folders — 73 targets — but Eve and PromptScript got nothing. If you use either, you'd need a per-project install instead.

Real talk: I braced for prompts or a config step. None appeared. With `-y` and `-g` the whole thing ran non-interactive — exactly what I want on a headless box. The operation finished in about 30 seconds and left zero manual work.

## Inside the Pack: a Router and Twelve Job Families, All in Chinese

The `dbs` router is a 380-line SKILL.md. Its job is reading your conversation and routing you to the right skill — mode C for first-timers, mode A for direct requests, mode B after another skill finished, and one standing instruction: "if you don't know the next step, come back to `/dbs`." That loop design is the pack's real architecture: you never need to memorize 30 skill names.

The skills themselves split into twelve job families: business diagnosis, benchmarking, content and hooks, a pre-publish risk check, resonance review, goal deconstruction, action unblocking, decision journaling, folder-to-knowledge-base, content systems, and a skill-cleaner that audits your other installed skills. The diagnosis skill alone runs 495 lines with two modes — consultation (问诊) for a specific question and checkup (体检) for a full business scan with seven checks.

Here's the finding that matters for non-Chinese readers: **the README is translated into English, Japanese, Korean, and Traditional Chinese — every SKILL.md inside the pack is Chinese-only.** I checked five of them. The English README is a translation of the marketing, not of the skills. If you can't read Chinese, you'd be running instructions you can't fully parse, which is a bad idea for a skill that "runs with full agent permissions", as the install summary warned.

## Running the Diagnosis: the Skill Dissolved Its Own Example Question

I executed `dbs-diagnosis` in consultation mode on the README's own quick-start example: a children's coding class with 40 paid students and low renewals, where the owner wants to know if the problem is product, pricing, or customer segment. The skill's funnel handles this in layers, and it stops for your answer after every one.

Layer one checks for undefined words. "Renewal rate is low" fails instantly — low compared to what? Private tutoring classes in China churn hard; 40% annual renewal might be healthy, 10% might be normal, and the word "low" carries no benchmark. The skill's script says to stop here and force a definition.

Layer two checks hidden assumptions. The question presumes the cause lives in one of three buckets: product, pricing, or customers. The skill's own example pattern applies almost verbatim — "my product is great but it won't sell" assumes good product equals sellable product. Here the assumption is that low renewal means something's wrong with one of the three named things. What if renewals never had a mechanism? What if the buying decision sits with parents while the experience sits with kids, and the two never meet? The question dissolves before layer three.

That's the design working as advertised: the skill reports that of 8,000+ paid questions, only 0.9% were answered — 99.1% were dissolved because the question was wrong. My run confirmed it. The README's own example, fed through the skill's own rules, dies at the assumption layer. That's either infuriating or excellent depending on whether you came for answers or for better questions.

## What the README Promised vs What I Found

| Claim | Reality |
|-------|---------|
| 30 skills | 31 SKILL.md files — the badge skips the `dbs` router |
| Installs to all 73 agents | 71 got files; Eve and PromptScript rejected global installs |
| Five-language documentation | READMEs translated; every skill body is Chinese-only |
| One-command setup | True — non-interactive with `-y -g`, ~30 seconds |
| Diagnosis answers business questions | It dissolves most of them first — including its own example |
| Free to use | CC BY-NC 4.0 — non-commercial only |

## Should You Try It?

Yes, if you read Chinese and you run a real business question through agents — the funnel genuinely improved how I frame pricing and churn problems, and the router pattern is worth stealing even if you never install the pack. The decision log and procrastination skills are the sleeper hits. Skip it if you're an English-only user (you'd be running unreadable instructions with full permissions) or if you need commercial use (the license forbids it). And check your agent first: if you live in Eve or PromptScript, the global install path silently skips you.

For a closer look at the pack's structure and the diagnosis methodology, read our [dbskill skill intro](/skills/general/dbskill/) — and if you want a Chinese-language content pipeline to pair with it, [Baoyu Skills](/skills/writing/baoyu-skills/) and [Khazix Skills](/skills/writing/khazix-skills/) cover the writing side.
