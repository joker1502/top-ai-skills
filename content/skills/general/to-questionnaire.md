---
title: "to-questionnaire: Pull Answers From One Person's Head"
date: 2026-08-29
draft: false
tags:
  - AI Skills
  - Async Communication
  - Decision Making
description: "Matt Pocock's to-questionnaire (217K installs, #225) turns knowledge locked in one person's head into a fillable doc: two interview questions, then it drafts."
version: "1.0"
author: "mattpocock"
repo_url: "https://github.com/mattpocock/skills"
install_cmd: "npx skills add mattpocock/skills"
compatibility:
  - Claude Code
  - Codex
  - Cursor
category: "general"
rating: 4.5
github_stars: 240807
github_forks: 20479
installs: 217193
last_updated: "2026-08-29"
ai_friendliness:
  score: 4.5
  documentation: 5.0
  setup: 4.0
  config: 4.0
---

Your plan stalls on a fact only one person holds — a client's business rule, an exec's call, a teammate's context. Matt Pocock's `to-questionnaire` skill (217,193 installs, #225 on the skills.sh all-time board, scraped 2026-08-29) exists for that exact moment: it turns the missing knowledge into a Markdown questionnaire that person fills in async, or the two of you work through on a call. I read its SKILL.md, its design doc, its agent config, and the live leaderboard today. The whole method compresses into five words: grill the send, not the subject.

## The Interview Has Exactly Two Questions, Then It Drafts

Most agents over-interview. This one refuses to. `to-questionnaire` asks you two things in two exchanges and then stops asking: **who is it going to** — the recipient's role, expertise, and relationship to you, which fixes the tone and how much context the document must carry — and **what do you need back**, the concrete decisions or facts you can't resolve alone. Every question in the finished file targets the gap between what that recipient knows and what you need. The design doc's "it's working if" list draws the line hard: *a question about the subject itself is the skill off the rails.* Interviewing you about the topic is pointless, the doc argues — not knowing the topic is why you're writing to someone else.

The config backs the same discipline. The SKILL.md carries `disable-model-invocation: true`, and its <a href="https://github.com/mattpocock/skills/blob/main/skills/productivity/to-questionnaire/agents/openai.yaml" rel="nofollow">agent config</a> sets `allow_implicit_invocation: false` — the agent never reaches for it on its own. You type `/to-questionnaire` (display name "To Questionnaire"), and what you get back is one file at `to-questionnaire-<slug>.md` in the current directory. No setup, no workspace, nothing to configure.

## The Document Is Engineered for One Async Pass

The output is framed as a **discovery questionnaire** — you lack the context, the recipient holds it — and that framing drives its shape. A purpose line names the decision riding on it. A one-paragraph Context section orients a recipient who was never inside your head. How to answer spells out the deadline and effort up front, and says plain: partial answers and "I don't know" are useful — flag the uncertainty rather than skipping the question, because a vague answer and a confidently wrong one look identical once they're back in your context.

Then the questions, ordered **most-important-first** and grouped under `##` headings by theme, because async means you may only get one pass. Each question carries one idea — never compound — with an answer stub directly beneath it, and a one-line *why this matters* only where the question could be misread or invite a throwaway reply. The template ends with a catch-all: "Anything else?" — anything we didn't ask that we should know?

Two things the document deliberately is not. It is not **branching**: a flat, grouped list, not a tree that skips section D if you answered A — the dependent-question design was explored and didn't ship, on the grounds that a model planning more than two or three questions ahead of a real answer plans badly. It is not **multi-recipient**: one run produces one document for one person, and if three people hold three parts of the answer, you run it three times. Delivery is yours too — the skill writes the file and tells you the path; pasting it into a ticket, dropping it in Slack, or emailing it is your job, and people have wired up all four by hand.

## It's the Family Member That Hands Work to Humans

Matt Pocock's skills split on one axis, and the design doc prints the table: where the answers actually live decides which skill you reach for.

| The answers live in… | Reach for |
|:--|:--|
| Your own head, unsharpened | [grill-me](https://aihero.dev/skills-grill-me){:rel="nofollow"} |
| The codebase | [grill-with-docs](https://aihero.dev/skills-grill-with-docs){:rel="nofollow"} |
| Someone else's head | `to-questionnaire` |
| Nobody's head yet, the question needs something to react to | [prototype](https://aihero.dev/skills-prototype){:rel="nofollow"} |

The common trigger is a [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling){:rel="nofollow"} session that stalls because some of what surfaced isn't yours to answer — run `/to-questionnaire` in that same conversation to take those questions offline, then bring the answers back. And the "same conversation" part matters: the skill has no ingest phase. It won't read your grilling session and extract the loose questions; it asks about the send and drafts. The session's value rides on being already in context when the drafting starts. Start it fresh and you'll be re-supplying the topic yourself.

The live board shows the family's newest members riding the same wave. I scraped skills.sh today: `to-questionnaire` sits at **#225 with 217,193 installs**, ahead of its same-week siblings — `writing-for-agents` (#259, 162,983) and `wait-what` (#264, 157,289). Its weekly installs read `0, 0, 14,825, 20,661, 19,562, 41,844, 40,766, 43,485`: two silent weeks, then three straight weeks above 40K. The questionnaire is the one skill in the trio that hands work to a human instead of mining the model — and it's the one with the most installs.

## Bottom Line

When planning snags on knowledge you don't hold, the next move is a person, not a prompt. Ask the two questions, draft the doc, hand it over, and keep going when the answers land. Install the family with `npx skills@latest add mattpocock/skills`, run `/to-questionnaire` mid-flow next time a grilling session stalls, and let the file do the interview. Its sibling [wait-what](/tutorials/guides/wait-what-skill-faq/) shows the family's verbosity discipline in action, and [writing-for-agents](/skills/writing/writing-for-agents/) explains why the wording of the questions you ship decides whether the answers come back usable. New to skills? The [AI agent skills FAQ](/tutorials/guides/ai-agent-skills-faq/) covers installation and invocation first.