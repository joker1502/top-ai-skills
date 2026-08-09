---
title: "NotebookLM Skill: Query NotebookLM from Claude Code"
date: 2026-08-09
draft: false
tags:
  - NotebookLM
  - Document Research
  - Agent Skills
description: "Query NotebookLM notebooks from Claude Code for source-grounded, citation-backed answers from Gemini — minimal hallucinations, zero RAG infrastructure."
version: "1.3.0"
author: "PleasePrompto"
repo_url: "https://github.com/PleasePrompto/notebooklm-skill"
install_cmd: "git clone https://github.com/PleasePrompto/notebooklm-skill ~/.claude/skills/notebooklm"
compatibility:
  - Claude Code
category: "general"
rating: 4.5
github_stars: 7590
github_forks: 861
installs: 0
last_updated: "2026-08-09"
ai_friendliness:
  score: 4.5
  documentation: 5
  setup: 4
  config: 3
---

## What It Is

NotebookLM Skill is a 7.6k-star Claude Code skill that lets your coding agent chat directly with [Google NotebookLM](https://notebooklm.google.com) — the source-grounded knowledge base powered by Gemini. The [official README](https://github.com/PleasePrompto/notebooklm-skill) describes it in one line: "Use this skill to query your Google NotebookLM notebooks directly from Claude Code for source-grounded, citation-backed answers from Gemini. Browser automation, library management, persistent auth. Drastically reduced hallucinations — answers only from your uploaded documents."

It solves the problem every developer hits when they tell an agent to "search through my local documentation": massive token consumption from re-reading files, keyword-matching that misses context, hallucinations when the agent can't find something and invents plausible-sounding APIs, and the endless copy-paste dance between NotebookLM in the browser and your editor. With this skill, Claude asks NotebookLM directly, Gemini synthesizes an answer from your uploaded sources, and Claude writes the code — no manual switching, no invented APIs.

The mechanics are simple. When you mention NotebookLM or paste a notebook URL, Claude loads the skill's instructions, runs its Python scripts, opens a real Chrome browser (via Patchright, a Playwright fork), asks your question, and returns the answer straight in the CLI. One-time Google authentication persists across sessions, and your notebook library — names, topics, tags — is stored locally in the skill folder as `library.json`.

## What Makes It Different

**The core difference is source grounding.** Every answer comes exclusively from the documents you uploaded, which is why the README calls hallucinations "drastically reduced": if the information isn't in your notebook, the model says so instead of inventing content. That's a fundamentally different behavior from feeding docs into context or letting an agent web-search.

Second, it's **NotebookLM rather than local RAG**, and the README makes the trade-off explicit. Local RAG costs hours of setup — embeddings, chunking, a vector database — and still has retrieval gaps. NotebookLM does the preprocessing server-side: upload docs once, get Gemini-synthesized answers with citations, multi-source correlation across 50+ documents, and zero infrastructure on your machine.

Third, it's **a skill, not an MCP server** — and the author maintains both. The skill version is Python, stateless (fresh browser per question), and Claude-Code-only, designed for quick integration; the [MCP server version](https://github.com/PleasePrompto/notebooklm-mcp) is TypeScript, keeps persistent chat sessions, and works with Codex, Cursor, and other tools. Each answer even ends with "Is that ALL you need to know?" to prompt Claude into comprehensive follow-ups — a small touch that turns single queries into real research.

## Who It's For

NotebookLM Skill fits three types of users. First, **Claude Code users who already keep docs in NotebookLM** — API docs, workshop manuals, spec sheets. The README's flagship example is querying a Suzuki GSR 600 workshop manual for brake fluid type, oil specs, and torque values, with Claude returning DOT 4, SAE 10W-40, and 100 N·m with citations.

Second, **developers building against their own documentation**. The second official example is building an n8n workflow for Gmail spam filtering using an "n8n notebook" — Claude asks the notebook comprehensive questions, then produces a working workflow on the first try without debugging hallucinated APIs.

Third, **anyone who wants RAG-quality answers without RAG infrastructure**. If you've been avoiding local RAG because of the embedding/chunking/vector-DB setup tax, this gives you the payoff in about five minutes: clone, authenticate once, upload docs, query.

Skip it if you use Claude in the web UI (skills run in a sandbox without network access, so this won't work there), or if you need persistent multi-turn sessions — that's what the [MCP server](https://github.com/PleasePrompto/notebooklm-mcp) is for. Also note the free-tier NotebookLM rate limits and the requirement that notebooks be shared with anyone with the link. It's MIT licensed.

## Bottom Line

NotebookLM Skill turns Google's source-grounded knowledge base into a back-end for Claude Code: upload your documents once, then ask questions directly from the terminal and get citation-backed answers with minimal hallucination risk. The install is a single `git clone` into `~/.claude/skills`, authentication takes one Chrome session, and the payoff is no more copy-paste between browser and editor. If you work with manuals, API docs, or research collections, it pairs naturally with the [Kreuzberg/Xberg document intelligence skill](/skills/general/kreuzberg/) for extraction on one side and this for grounded Q&A on the other — or with [anything-to-notebooklm](/skills/general/anything-to-notebooklm/) to get documents into a notebook in the first place. For broader research workflows, see our [AI search & research FAQ](/tutorials/guides/ai-search-research-faq-2026/).
