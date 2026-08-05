---
title: "How to Set Up Lark Knowledge AI: Build an AI-Searchable Team Knowledge Base"
date: 2026-08-05
toc: true
draft: false
tags:
  - Lark
  - Knowledge Management
  - AI Agents
category: "guides"
description: "Set up Lark Knowledge AI in six steps — structure Wiki knowledge spaces, enable AI search and summaries, and connect the lark-wiki skill to your coding agent."
---

Your team's knowledge is scattered across documents, wikis, chat messages, and meeting notes — and when someone needs an answer, they search for ten minutes, ping a colleague, or re-ask a question that was already answered. The documentation exists; the problem is that nobody can find it. Lark Knowledge AI is Lark's answer: AI search and summarization layered on top of your knowledge base, so the answer surfaces instead of the file. This guide walks through setting it up from scratch.

## Why Teams Can't Find Answers in Their Own Docs

The failure isn't a lack of documentation — it's a retrieval problem. Most teams store knowledge in three places at once: wiki pages for structured documentation, chat messages for decisions, and meeting minutes for context. When a new teammate asks "what's our policy on X?", the answer lives somewhere, but no single search covers all three sources.

Generic search makes this worse because it matches keywords, not meaning. A question phrased as "how do we approve a budget over $5k?" won't match a doc titled "Expense Approval Process" if the doc never uses the word "budget." The searcher gives up, the question gets asked in chat again, and the knowledge base slowly loses trust — which is why studies of enterprise knowledge tools consistently find that people default to asking a human instead of searching.

This is exactly the gap Lark's AI layer is built to close. Lark already centralizes documents, wiki knowledge spaces, and meeting minutes in one suite — which means AI search has a single, permissioned corpus to work with. Instead of keyword matching, the AI layer retrieves relevant passages semantically and summarizes them in context of your question, the same way a RAG pipeline works. The underlying structure is still your wiki; AI just makes it findable.

## Step-by-Step: Set Up Lark Knowledge AI

The setup has six steps and takes about an hour for a small team. You'll need admin access to your Lark tenant and a Lark Wiki knowledge space to work with.

### Step 1: Create Your Knowledge Space Structure

Lark Wiki is the foundation — it's where knowledge spaces, nodes, and documents live. From the Wiki app in Lark, click **New Space** and create one knowledge space per major domain (Engineering, HR, Sales, Product). Inside each space, build a node tree with a consistent hierarchy: a home node, a "Policies" branch, a "How-to" branch, and an "Archived" branch.

Structure matters more than content volume. AI retrieval is only as good as the organization of what it retrieves — a flat pile of 500 pages retrieves worse than a well-labeled tree of 100. Set node titles that describe the page's topic in plain language ("Approving expenses over $5,000" instead of "EXP-014"), because titles are strong retrieval signals.

### Step 2: Move Decision Records Into Wiki

The single biggest retrieval win is getting decisions out of chat and into the wiki. In Lark, decisions made in messages can be converted directly: open a message thread, select the messages that contain the decision, and use **Add to Wiki** to create a node from them. Meetings follow the same pattern — Lark meeting minutes (summary, todos, and transcript) can be attached to a wiki node so the context lives next to the policy it produced.

The rule of thumb: if a question was asked and answered in chat, it deserves a wiki node. Each migrated decision becomes a retrieval target that AI search can surface later.

### Step 3: Enable AI Search and Summarization

With the structure in place, turn on Lark's AI knowledge features. In the Wiki space settings, enable AI search for the space so queries can retrieve from it, and make sure your tenant has the AI assistant enabled in admin settings — the AI layer needs to be active for your workspace before any search or summary features appear.

Test it immediately: search for a question phrased the way a human would ask it ("what's our remote work policy?"), not the doc title. AI search should return the relevant node and a synthesized answer. If results are thin, the usual cause is Step 1 — nodes are poorly titled or the content is buried in chat, not wiki.

### Step 4: Connect the lark-wiki Skill to Your AI Agent

Lark's agent skills extend the same knowledge base to your coding assistant. The larksuite CLI ships a `lark-wiki` skill that covers "knowledge spaces, nodes, and documents" — your agent can search across wikis, read page trees, and create new pages from the terminal, which means it can answer questions against your internal docs mid-conversation instead of guessing.

Install it with:

```bash
# 1. Install the larksuite CLI (one time)
npx @larksuite/cli@latest install

# 2. Register the wiki skill with your agent
npx skills add larksuite/cli -y -g --skill lark-wiki
```

Then authenticate once with `lark-cli config init` followed by `lark-cli auth login --recommend`. The `--recommend` flag selects the OAuth scopes the skill needs, including wiki read/write. Credentials are stored in your OS keychain, so you log in once.

### Step 5: Test the Full Loop

Ask your agent a question that only exists in your wiki: "What's our expense approval limit?" The agent should search the wiki skill, retrieve the policy node, and answer with the source. Then test a creation flow: ask it to write a new onboarding node from a bullet list. Both directions — retrieval and writing — should work against the same knowledge space your team uses.

### Step 6: Maintain Retrieval Quality

AI search decays as the wiki accumulates stale content. Set a quarterly cleanup: archive nodes older than a year with no views, merge duplicate policy pages, and re-title nodes that consistently fail to surface. Lark's AI summaries on wiki home nodes help here — a generated overview of a space reveals which areas are well-documented and which are thin.

## Lark Knowledge AI vs Plain Wiki Search vs No Knowledge Base

| Aspect | No Knowledge Base | Plain Wiki Search | Lark Knowledge AI |
|--------|-------------------|-------------------|-------------------|
| **Finding answers** | Ask a colleague | Keyword matching | Semantic search + synthesis |
| **Time to answer** | Minutes to hours | Minutes, if wording matches | Seconds, in your wording |
| **Chat decisions captured** | Lost | Manual copy-paste | Direct Add-to-Wiki flow |
| **Meeting context** | Lost | Separate tool | Minutes attached to nodes |
| **Agent access** | None | Read-only manual | Read/write via lark-wiki skill |
| **Setup effort** | Zero | Low | One hour + structure upkeep |
| **Maintenance** | None | None | Quarterly cleanup |

The AI layer doesn't replace the wiki — it makes the wiki worth maintaining. Teams that adopt it find the retrieval loop feeds back into documentation quality: when every question surfaces an answer, gaps in the knowledge base become obvious, and the wiki stops being a graveyard of unused pages.

## Common Mistakes and Solutions

**Mistake: Enabling AI search before structuring the wiki.** Retrieval quality depends on node titles and hierarchy. If you flip on AI features over a flat, messy space, you get confident-sounding answers that cite the wrong pages. Structure first, then enable.

**Mistake: Keeping decisions in chat.** The AI layer can only retrieve what's in the wiki. Make "decisions go to wiki" a team rule — the Add-to-Wiki flow exists precisely because chat decisions were the biggest retrieval gap.

**Mistake: Expecting AI to fix bad permissions.** AI search respects the same permission boundaries as regular search. If a node is restricted, the AI won't surface it — which is correct for security, but means you should audit space permissions before rolling out, or teammates will wonder why some answers are missing.

**Mistake: Skipping agent authentication.** The lark-wiki skill fails with `91403` permission errors when the authenticated user lacks access to the target space. Run `lark-cli auth login --recommend` and verify the user has at least read access to the spaces your agent will search.

## Set Up Lark Knowledge AI This Week

The setup is one focused afternoon: an hour to structure your first knowledge space, twenty minutes to enable AI features, ten minutes to connect the lark-wiki skill, and a quarter-day to migrate your team's most-recent decisions out of chat. Start with a single domain — Engineering or HR — and prove the retrieval loop before expanding.

For more on the underlying skills, see our [Lark Wiki skill intro](/skills/automation/lark-wiki/), the [Lark Doc tutorial](/tutorials/guides/lark-doc/), and the [Lark Base FAQ](/tutorials/guides/lark-base-faq/). If your team is on Confluence instead, the same structure-first approach applies — see our guide to [building an AI support chatbot with RAG](/tutorials/guides/build-ai-customer-support-chatbot/) for the general pattern of layering AI retrieval over existing documentation.
