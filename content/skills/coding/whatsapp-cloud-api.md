---
title: "WhatsApp Cloud API"
date: 2026-07-23
draft: false
tags:
  - DevOps
  - AI Coding
  - Backend
  - WhatsApp
  - API Integration
description: "An AI agent skill for the WhatsApp Cloud API — send messages, manage templates, handle webhooks, and integrate conversational workflows from a single CLI."
version: "1.0.0"
author: "bellopushon"
repo_url: "https://github.com/bellopushon/whatsapp-cloud-api"
install_cmd: "npx skills add https://github.com/bellopushon/whatsapp-cloud-api --skill whatsapp-cloud-api"
compatibility:
  - Claude Code
  - Cursor
  - Windsurf
  - GitHub Copilot
category: "coding"
rating: 4
github_stars: 85
github_forks: 12
installs: 3200
last_updated: "2026-07-23"
ai_friendliness:
  score: 4
  documentation: 5
  setup: 4
  config: 3.5
---

## Overview

The WhatsApp Cloud API skill is a structured reference for AI coding assistants that need to work with Meta's official WhatsApp Business Platform. Instead of digging through Facebook developer docs every time you need to send a message, upload media, or verify a webhook, your agent loads the relevant specification on demand — with real payload examples, error codes, and best practices baked in.

This skill follows a **progressive disclosure** design. It loads only ~100 tokens at startup (just the skill name and a brief description). When your agent detects WhatsApp-related work, it loads the main reference (~4500 tokens). Specific topic files — messaging, templates, webhooks, media — stay at zero tokens until your agent actually needs them. The result is a comprehensive reference that doesn't bloat your context window.

### What It Includes

| Module | What It Covers |
|--------|---------------|
| **Core API** (`SKILL.md`) | Quick reference, common patterns, authentication, rate limits |
| **Messaging** | Text, media, location, contacts, reactions — payloads for every type |
| **Webhooks** | Incoming message handling, status callbacks, verification challenges |
| **Templates** | Categories, variable substitution, lifecycle management, approval flow |
| **Conversations** | 24-hour window rules, pricing categories, service conversations |
| **Media** | Upload, download, supported formats (images, audio, video, documents), size limits |
| **Interactive** | Buttons, lists, product catalogs, Flows — rich message components |
| **Phone Numbers** | E.164 formatting, phone number IDs, verification, display name setup |
| **Error Codes** | Common HTTP errors, Webhook error codes, rate limit retry strategies |
| **Coexistence** | Running Business App + Cloud API on one number, onboarding, sync webhooks |

### Why This Matters

The WhatsApp Cloud API is powerful but verbose. A typical message-send payload requires correct formatting of the phone number ID, recipient number in E.164, message type headers, and optional context fields — one wrong field and you get a generic 400 error with no hints about what went wrong. This skill eliminates the back-and-forth by embedding the exact schemas your agent needs, tested against Meta's actual API responses.

## How to Install and Use It

```bash
# Install the skill
npx skills add https://github.com/bellopushon/whatsapp-cloud-api --skill whatsapp-cloud-api

# Then ask your agent:
# "Send a WhatsApp text message to +1-555-0123 saying 'Your order is confirmed'"
# "Upload this image as a WhatsApp media object"
# "Verify the webhook callback from WhatsApp"
```

Once installed, your AI agent can reference the skill's documentation to construct correct API calls for any WhatsApp Business Platform operation. The progressive disclosure means common tasks like sending a text message resolve instantly, while complex operations like setting up a template with variables trigger the deeper reference files automatically.

### Quick Example

After installation, you can ask your agent to send a message like this:

> "Send a WhatsApp message to +14155551234 with the text 'Your verification code is 884291'"

The agent reads the messaging reference, constructs the correct POST to `https://graph.facebook.com/v22.0/PHONE_NUMBER_ID/messages` with the proper payload format, handles the auth header from your stored credentials, and returns the API response with the message ID.

## Who It's For

**Get this skill if:**
- You build WhatsApp chatbots or notification systems with AI coding assistants
- You need to send transactional messages (order confirmations, OTPs, shipping updates)
- You manage WhatsApp template approval workflows across multiple business accounts
- You integrate webhook-driven conversational flows where the AI agent handles incoming messages

**Skip it if:**
- You're using a high-level WhatsApp SaaS platform that abstracts the API entirely
- You send fewer than 100 WhatsApp messages per month and can afford manual API lookups
- You don't use AI coding assistants that support the Agent Skills specification

For a broader look at AI-powered integration skills, see our [guide to building AI agent email automation workflows](/tutorials/guides/ai-agent-email-automation/).

## Bottom Line

The WhatsApp Cloud API skill turns eight hundred pages of Meta documentation into an on-demand reference your AI agent can actually use — without eating your context budget. Install it once, and your agent handles payload formats, error codes, and authentication patterns correctly every time.
