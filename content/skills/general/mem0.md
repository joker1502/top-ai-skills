---
title: "Mem0 — Memory Layer for AI Agents"
date: 2026-07-08
draft: false
tags:
  - Memory
  - AI Agents
  - LLM
  - RAG
description: "Mem0 is an open-source memory layer for AI agents that remembers user preferences, facts, and context across sessions using embeddings and retrieval."
version: "0.2.0"
author: "mem0ai"
repo_url: "https://github.com/mem0ai/mem0"
install_cmd: "pip install mem0-cli"
compatibility:
  - Claude Code
  - Cursor
  - Codex
  - OpenAI
  - LangChain
  - LlamaIndex
category: "general"
rating: 4.5
github_stars: 60411
github_forks: 7012
installs: 0
last_updated: "2026-07-08"
ai_friendliness:
  score: 4.5
  documentation: 4.5
  setup: 4.0
  config: 4.0
---

## What It Is

Mem0 gives AI agents a persistent memory layer. Instead of starting every conversation from scratch, your agent can recall user preferences, past decisions, and relevant facts from previous sessions. It stores memories as embeddings, retrieves the right ones when they're needed, and updates itself as new information comes in.

Think of it as a smart long-term memory that an AI agent can read from and write to, without you having to manage vector databases or retrieval pipelines yourself.

## What's Actually Different

Most approaches to AI agent memory fall into two camps: naive context stuffing (copy everything into the prompt until you hit token limits) or manual RAG setups that require you to manage document pipelines, chunking strategies, and vector stores.

Mem0 sits in the middle. It handles the embedding, storage, and retrieval automatically, but gives you control over how memories are organized and prioritized. You can tag memories by user, session, or type — and the retrieval layer figures out which memories matter for the current conversation.

The key difference from a DIY RAG pipeline: Mem0 updates existing memories instead of just appending new ones. If a user changes their preference, Mem0 can modify the stored memory rather than creating a duplicate that conflicts with the original.

## Who It's For

- **Agent developers** building AI assistants that need to remember user context across sessions — customer support bots, personal assistants, coding agents that track project preferences.
- **RAG pipeline builders** who want a drop-in memory layer without managing vector databases manually.
- **Anyone tired of repeating themselves** to AI tools that forget your preferences, coding style, or domain context between conversations.

## Installation

```bash
pip install mem0-cli
```

Or via npm:

```bash
npm install -g @mem0/cli
```

## Core Features

- **Automatic memory extraction** — Mem0 reads conversations and extracts facts, preferences, and context without manual annotation.
- **Semantic retrieval** — Uses embedding similarity to find relevant memories, not keyword matching.
- **Memory update** — Existing memories get updated when new information conflicts, reducing duplicate storage.
- **User-scoped memory** — Separate memory spaces for different users, so one agent can serve multiple people without mixing context.
- **Framework agnostic** — Works with OpenAI, LangChain, LlamaIndex, and custom LLM setups.

## Example Usage

```python
from mem0 import Memory

m = Memory()

# Store a memory
m.add("The user prefers Python over TypeScript for backend services")

# Retrieve relevant memories
results = m.search("What language should I use for the API?")
# Returns: "The user prefers Python over TypeScript for backend services"
```

## Related

Check out the [Best AI Skills Roundup 2026](/tutorials/guides/best-ai-skills-roundup-2026/) for more tools that enhance your AI agent workflow.
