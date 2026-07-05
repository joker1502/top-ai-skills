---
title: "I Let My AI Agent Manage Lark Documentation for a Week — Here's What Happened"
date: 2026-07-05
draft: false
toc: true
tags:
  - Lark
  - Feishu
  - Document Automation
  - AI Skills
  - Narrative
description: "I handed my AI agent the keys to our team's Lark documentation for a full work week — reading, writing, organizing, and searching across 40+ docs. Here is what worked, what broke, and how the LarkDoc skill changed how I think about AI-assisted documentation."
category: guides
related_skills:
  - lark-doc
---

## Why I Put Documentation on the Chopping Block

Our team lives inside Lark (Feishu). Meeting notes, technical specs, project briefs, onboarding guides — it is all in Lark documents. And like most teams that use collaborative docs heavily, we have a mess: 40+ documents scattered across spaces with inconsistent naming conventions, outdated meeting notes that nobody archived, and a growing pile of "untitled document" orphans that were created during a call and never revisited.

I wanted to see whether the LarkDoc AI skill could clean this up — not through a grand automation script, but by letting my AI agent browse, summarize, create, and organize docs the same way I would, just faster.

The experiment: one work week, five working days, real team documentation. No simulation, no curated test data. Just point the agent at our Lark tenant and see what happens.

## Setup: First Impressions and Speed Bumps

The initial setup took about 25 minutes — slightly longer than the procedural guide suggests, but that is mostly because I had to figure out Lark's permission model.

Installing the larksuite CLI was straightforward:

```bash
npx @larksuite/cli@latest install
```

That downloads the binary and hooks it into the agent's toolchain. Adding the LarkDoc skill took one more command:

```bash
npx skills add https://github.com/larksuite/cli --skill lark-doc
```

The friction point was authentication. You need to create a custom app in the Lark Developer Console, grab the App ID and App Secret, then run `lark-cli config init` to store them. If you have admin access to your Lark tenant, this takes five minutes. If you do not — say, you are on a free tier or your IT team controls app creation — you will need to loop someone in.

The `lark-cli auth login --recommend` step opened a browser window for authorization. I ran this on my laptop, but if you work primarily through a headless dev environment, the `--headless` flag prints a URL you can authenticate from any device. That saved me.

I also hit the `--api-version v2` gotcha during my first test. The CLI defaults to v1 if you omit it, which gives you a different response format. After the first confusing error message, I aliased the full command in my shell config and moved on.

## Day 1 — Document Inventory (The "What Do We Actually Have?" Phase)

I started simple: ask the agent to list what documents existed. The LarkDoc skill does not have a direct "list all documents" endpoint — it searches and fetches by URL or query. So I searched for broad terms like "meeting notes", "spec", "guide", and "Q1" to discover what was out there.

The agent returned results fast — each search took about two seconds. By the end of the first afternoon, I had a rough inventory: 38 documents across three Lark spaces, with about a dozen that were clearly stale (last edited more than six months ago).

**What surprised me**: the search quality. Lark's built-in search already works well, but the agent could chain searches — look for "onboarding", find five results, then fetch each one to summarize the content — in a single conversation. Doing that manually would have taken 20 minutes of clicking and tabbing. The agent did it in about two minutes of wall-clock time while I reviewed the output.

**What frustrated me**: no bulk operations. The skill operates one document at a time. For an inventory exercise, I would have loved a "list all docs in space X" endpoint. The workaround was acceptable (iterative search queries), but it added cognitive overhead to what should be a straightforward scan.

## Day 2 — Summarization and Cleanup

Day two was the heavy lifting day. I had a list of stale documents and wanted to:
1. Fetch the content of each potentially-outdated doc
2. Summarize what it contained
3. Decide whether to archive, update, or leave it alone

The agent fetched documents one by one using their URLs. Each fetch took 1-2 seconds and returned the document content as structured XML — headings, paragraphs, bullet lists, tables, all preserved. The agent then summarized each document in natural language.

This workflow was genuinely useful. I handed the agent a list of 10 URLs, and within five minutes I had summaries of all 10 docs. In my normal workflow, I would have clicked through each doc, skimmed the content, and made a mental note — easily 20 minutes of context-switching.

**The table handling surprised me**. Lark documents use a block-based structure where tables are represented as nested row/column blocks. The agent parsed these cleanly and included table summaries in its output. For one document — a project timeline with a complex table of milestones — the agent correctly extracted all dates, owners, and statuses from the table blocks and presented them in a readable format. I did not expect structured data extraction to work this well from a document-reading skill.

**Where it struggled**: documents with embedded images or whiteboard content. The skill returns the text content of the document, but images, embedded whiteboards, and mind maps are represented as placeholders (block type markers without visual data). The agent honestly reported "image block found — content not available" rather than hallucinating a description, which I appreciated but it meant I still had to visually review image-heavy docs.

## Day 3 — Creating and Structuring New Content

Day three was the creation test. I wanted the agent to draft new documents based on brief instructions and publish them to Lark.

I gave the agent a short brief: "Create a meeting notes template doc with sections for date, attendees, agenda, discussion notes, action items, and next meeting date."

The agent used `docs +create` with XML content:

```bash
lark-cli docs +create --api-version v2 --content '<title>Meeting Notes Template</title><heading1>Date</heading1><p></p><heading1>Attendees</heading1><p></p><heading1>Agenda</heading1><p></p><heading1>Discussion Notes</heading1><p></p><heading1>Action Items</heading1><p></p><heading1>Next Meeting</heading1><p></p>'
```

The document was created instantly. Opening it in the Lark web UI showed the structure rendered correctly — headings, empty paragraphs ready to be filled in.

**The XML content format is the main friction point**. Writing Lark document XML by hand is not something I want to do regularly. The agent handled it transparently — I described what I wanted in natural language and it produced the XML. But when I reviewed the output and wanted to tweak the structure, I had to refine my prompt rather than drag-and-drop sections in the UI. For template creation, this works fine. For ad-hoc formatting tweaks, you will want to open the doc in Lark's editor eventually.

I also tested **appending content** to an existing document — adding action items to a running meeting notes doc after the fact. The `docs +update --command append` endpoint worked as expected. This is where the skill shines for ongoing documentation workflows: your agent can keep a living document updated without you opening it.

## Day 4 — Real Workflow: Research → Summarize → Archive

Day four was the acid test: a real work task. I needed to review three months of sprint retrospective notes — 12 documents spread across our team's Lark space — and produce a summary of recurring themes and action items.

I told the agent: "Find all sprint retrospective docs from the last three months. Fetch each one. Identify recurring themes and any action items that carried over across multiple sprints."

The agent searched for "sprint retrospective", found 14 results, fetched each by URL, and started processing. The search returned all 14 docs in about 3 seconds. Fetching all of them took about 15 seconds total.

The output was structured and useful:
- Three recurring themes identified (estimation accuracy, cross-team communication, test environment stability)
- Two action items that appeared in three consecutive sprints without being resolved
- A summary of what the team felt was working well (code review turnaround time, automated testing)

**This took the agent about 40 seconds from prompt to output**. Doing the same task manually — open each doc, skim it, take notes, cross-reference — would have taken me at least an hour, probably more given how easy it is to get distracted clicking between tabs.

The one limitation: the agent cannot update documents based on its analysis unless I explicitly command it. I had to separately ask it to create a new "Sprint Retrospective — Q2 Summary" document with the findings. An "analyze and create summary doc" workflow would be a natural extension, but the current skill requires the creation step as a separate command.

## Day 5 — The Maintenance Test

The last day was about ongoing maintenance: could the agent watch for changes and keep things organized?

I set up a simple daily task: search for newly created or recently modified documents each morning and flag any that looked like duplicates or untitled orphans.

The agent searched for documents modified in the last 24 hours each morning. Most days returned 3-5 modified docs — some legitimate updates, some automated system notes. The agent summarized the changes without me asking.

**The honest finding**: this was the least impressive use case. Lark's notification system already tells you when documents change. The agent's summary was a nice bonus but did not save significant time. The real value was catching orphan documents — two untitled docs showed up during the week that someone had created in a meeting and never named. The agent identified them by content and suggested titles. That was genuinely helpful.

## What I Wish I Knew Before Starting

A few things I learned the hard way:

**The XML content format deserves respect**. LarkDoc uses Lark's document block structure as XML. For simple documents (text with headings and bullet points), the agent generates correct XML without issues. For complex layouts — nested tables, multi-column sections, embedded whiteboards — the XML gets intricate fast. The agent handles the complexity, but if you plan to edit the XML yourself, study the block structure documentation first.

**Rate limits are real but generous**. I hit a rate limit once during the mass-fetch exercise on Day 2 after about 30 rapid-fire requests. The CLI returned a clean 429 error. Waiting 30 seconds and retrying worked. For normal interactive use, you will never notice the limits.

**Permissions matter more than I expected**. The LarkDoc skill inherits the permission scope of the custom app you create. If your app only has "read document" permission, the skill will fail silently on write operations with a confusing "unknown error" message. Make sure your app has both read and write scopes if you plan to create or update documents.

## The Verdict After One Week

The LarkDoc skill is genuinely useful for three things:

1. **Document discovery and summarization** — when you need to find, read, and synthesize information across many documents, the agent completes in seconds what takes humans tens of minutes.
2. **Template creation** — generating structured documents from natural language descriptions is faster than building them in the UI.
3. **Living document maintenance** — appending action items, updating status fields, keeping running notes without opening the editor.

It is **not** a replacement for browsing documents visually. Image-heavy docs, whiteboards, and documents where visual layout conveys information (dashboards, design specs) are better viewed in the Lark UI.

Would I keep using it? Yes — but as a **co-pilot for documentation**, not an autonomous document manager. I use it for the discovery and summarization workflow multiple times a week now. The creation workflow I use less often — templates are a one-time setup — but the append workflow for meeting notes is becoming part of my regular routine.

The biggest win, unexpectedly, was the **search-sidekick pattern**: during a conversation with my agent about a project decision, I could ask "find the document where we discussed this tradeoff" without context-switching to Lark's search bar. The agent fetched the doc, summarized the relevant section, and kept the conversation flowing. That alone was worth the 25-minute setup.
