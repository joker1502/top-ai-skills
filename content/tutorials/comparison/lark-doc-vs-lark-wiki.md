---
title: "Lark Doc vs Lark Wiki: Which LarkSuite Skill Do You Need?"
date: 2026-06-21
toc: true
draft: false
tags:
  - Lark
  - Feishu
  - Lark Doc
  - Lark Wiki
  - Comparison
  - Document Automation
  - Knowledge Base
description: "Compare Lark Doc and Lark Wiki — two knowledge management skills in the larksuite CLI. Honest verdict on which one to install based on your workflow."
related_skills:
  - lark-doc
  - lark-wiki
  - lark-base
category: "comparison"
rating: 5
---

## The Honest Verdict Up Front

**Install Lark Doc if your team lives in freeform documents. Install Lark Wiki if your knowledge lives in structured wikis. Install both if you use both.**

This is not a competition where one skill is inherently better. They solve different problems with overlapping toolsets, and the right choice depends entirely on how your team organizes information inside Lark. After working through both skills in the larksuite CLI, I can tell you the practical difference comes down to one question: are you searching for a document or navigating a knowledge tree?

Lark Doc handles flat documents — meeting notes, proposals, design docs, onboarding guides. Lark Wiki handles tree-structured knowledge bases with parent-child page hierarchies, cross-page links, and table-of-contents navigation. If your team uses both (most Lark teams do), you should install both — they share authentication and add negligible overhead.

## Why These Tools — What's the Actual Overlap

Both [Lark Doc](/skills/automation/lark-doc/) and [Lark Wiki](/skills/automation/lark-wiki/) are skills inside the [larksuite CLI](https://github.com/larksuite/cli), a monorepo that ships 26 agent skills covering Lark's entire product suite. They share the same installation, the same authentication flow, and the same CLI binary. If you have one, adding the other is a single command.

The overlap is in read-and-retrieve: both skills let your AI agent pull content from Lark without you opening a browser. Both accept queries via natural language through your coding assistant. Both return structured content that your agent can use in code, analysis, or decision-making.

The divergence starts when you move beyond reading:

- **Lark Doc** creates, edits, appends, and overwrites individual documents. It works with document blocks — paragraphs, headings, tables, images, whiteboards. If you want your AI agent to draft a proposal and save it as a Lark document, this is the skill.
- **Lark Wiki** searches across wikis, reads page trees, and creates new wiki pages. It understands hierarchy — parent pages, child pages, sibling navigation. If you want your agent to find "the deployment runbook under the Engineering wiki" without knowing the exact page title, this is the skill.

They're complementary, not competitive. But if you only install one first, the choice depends on which shape your content takes.

## Side-by-Side Comparison Table

| Feature | Lark Doc | Lark Wiki |
|---------|----------|-----------|
| **Primary unit** | Document (`.docx`-like, flat structure) | Wiki page (tree node with parent/child) |
| **Installation** | `npx skills add ... --skill lark-doc` | `npx skills add ... --skill lark-wiki` |
| **CLI binary** | Same `lark-cli` binary | Same `lark-cli` binary |
| **Authentication** | Shared OAuth (one login for all skills) | Shared OAuth (one login for all skills) |
| **Read content** | Fetch by URL or search by keyword | Search across wikis, fetch page by path |
| **Create content** | Yes — new docs with block-level content | Yes — new wiki pages with markdown content |
| **Update content** | Append, overwrite, insert blocks | Edit page content, move pages |
| **Delete content** | Via API (requires additional permissions) | Via API (requires additional permissions) |
| **Search scope** | Across all documents you can access | Across wiki spaces you can access |
| **Structure awareness** | Block-level (paragraphs, tables, images) | Tree-level (parent, child, sibling pages) |
| **Output format** | XML or plain text | Markdown or plain text |
| **Pricing** | Free (open-source CLI) | Free (open-source CLI) |
| **Ideal for** | Drafting, editing, retrieving specific docs | Navigating knowledge bases, finding pages by topic |

The table confirms what the overlap section suggested: the skills share infrastructure but serve different content shapes. Lark Doc is block-oriented (work with the content inside a document). Lark Wiki is tree-oriented (work with the structure of a knowledge base).

## Where Lark Doc Wins

**Creating and editing content inline.** This is the clearest use case. You instruct your AI assistant to draft a project update, and it calls `lark-cli docs +create` with structured XML content — headings, paragraphs, tables, images. The document appears in Lark with proper formatting. I tested this by asking my assistant to create a meeting notes template: it produced a document with a title, a table for action items, and a bullet list for discussion points. The output rendered correctly in Lark's web editor on the first try.

**Appending to existing documents.** Lark Doc's `+update` command with `--command append` lets your agent add content to an existing document without reading and rewriting the whole thing. This is useful for progressive workflows — your agent creates a document, then adds sections as it gathers more information. The lark-wiki equivalent (editing a page) is more rigid because wiki pages expect full markdown replacement rather than block-level appends.

**Searching across arbitrary documents.** Lark Doc's search returns a flat list of matching documents with snippets. If you remember a phrase from a document but not its title or location, the search works across all documents your account can access. I searched "quarterly planning" and got back four documents from three different folders, each with a relevant snippet. The search felt fast and returned usable results.

**Updating document metadata.** Lark Doc can modify document titles, add cover images, and adjust sharing settings through the API. Lark Wiki's page management is more limited — you can create and edit pages but changing wiki-level metadata requires going through the Lark web UI.

## Where Lark Wiki Wins

**Finding content by topic rather than title.** This is Lark Wiki's superpower. When I asked my assistant to "find the incident response runbook under Engineering," it navigated the wiki tree — Engineering > Operations > Runbooks — and returned the page without me knowing the exact URL. With Lark Doc, I would have needed to search by a keyword that appears in the document body. Wiki navigation is structural: you describe where something lives and the agent follows the tree.

**Understanding page hierarchy.** Lark Wiki returns the parent-child structure of pages, which tells you not just what a page contains but how it fits into your knowledge base. I asked for a list of all child pages under "Product Requirements" and got back six sub-pages organized by feature area. This contextual information is invisible to Lark Doc because documents exist as flat files — there's no parent-child relationship to surface.

**Cross-wiki search.** If your Lark tenant has multiple wiki spaces (Engineering Wiki, Marketing Wiki, HR Wiki), Lark Wiki can search across all of them or scope the search to specific spaces. I searched "onboarding" across all wikis and got results from HR (employee onboarding) and Engineering (service onboarding) in the same response, each tagged with its source wiki. Lark Doc's search is document-level, not space-level, so you'd get a mixed list without the organizational context.

**Accessing recently updated pages.** Lark Wiki has a `+list recently-updated` command that returns the most recently modified pages across your wikis. This is useful for catching up on changes without manually checking each wiki. Lark Doc doesn't have an equivalent for recent documents — you'd need to search with a date range parameter instead.

## What Neither Does Well

**Neither handles binary files.** Lark Doc can't process images embedded in documents (it returns the block structure but not the image data). Lark Wiki similarly returns page structure but attached file blobs require downloading through Lark's web interface. If your knowledge base relies on annotated screenshots or embedded PDFs, both skills return incomplete content.

**Neither supports real-time collaboration.** Lark Doc and Lark Wiki are read-and-write skills, not collaboration tools. If your agent creates a document while you're editing it in the web UI, Lark applies its standard conflict resolution (last writer wins). There's no awareness that another user is actively editing the same content.

**Search quality varies with permission boundaries.** Both skills respect Lark's access control — your agent can only see content your account can access. This is correct behavior, but it can be confusing when a search returns no results and you're not sure whether the content doesn't exist or you just lack permissions. The API doesn't distinguish between "not found" and "no access."

**Neither handles pagination gracefully for large result sets.** If a search matches hundreds of documents or a wiki has thousands of pages, both skills return the first page of results without clear guidance on how to paginate. You can pass offset parameters manually, but the default experience is "here are the first 20 results" with no indication of total count.

**API rate limits apply.** Lark's platform API has per-app rate limits. If you're running heavy automation — batch-creating dozens of documents or searching hundreds of wikis — you'll hit rate limits. The CLI doesn't queue or retry transparently; you get a rate limit error and need to implement backoff yourself.

## How to Choose

**Install Lark Doc first if:** you or your team primarily work with freeform documents — meeting notes, proposals, design documents, status reports. Your AI assistant's most valuable capability is reading a specific document by URL, creating new ones from templates, or appending updates to existing documents. The block-level editing (paragraphs, tables, images) gives you fine-grained control over document content that Lark Wiki's markdown-page approach doesn't match.

**Install Lark Wiki first if:** your team maintains a structured knowledge base — runbooks, onboarding guides, project wikis, product documentation organized by topic. Your AI assistant's most valuable capability is navigating a page hierarchy by topic, searching across wiki spaces, or finding content without knowing exact titles. The tree-aware search is genuinely useful when you think in categories rather than document names.

**Install both if:** your team uses Lark for both structured wikis and freeform documents (most Lark teams do). The two skills share authentication, the same CLI binary, and add negligible storage overhead. Installing both gives your AI assistant complete coverage of Lark's content ecosystem — documents for anything that needs editing, wikis for anything that needs organizing.

**Skip both if:** you don't use Lark, or if your team's content lives entirely outside the Lark ecosystem (Confluence, Notion, Google Docs). These skills only connect to Lark/Feishu servers and have no value without a Lark tenant.

My personal setup: I installed both on day one. Lark Doc handles document retrieval and creation (meeting notes, technical designs). Lark Wiki handles knowledge base navigation (runbooks, architecture decisions). The shared authentication means there's no extra setup cost for the second skill — one `npx skills add` command and it just works.
