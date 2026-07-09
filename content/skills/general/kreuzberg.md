---
title: "Kreuzberg (Xberg): Document Intelligence & PDF Extraction"
date: 2026-07-09
draft: false
toc: true
tags:
  - Document Intelligence
  - PDF Extraction
  - OCR
  - RAG
description: "Extract text, tables, images, and metadata from 97+ document formats with this open-source Rust-based framework. Supports Python, Node, CLI, REST, and MCP."
version: "0.20.0"
author: "xberg-io"
repo_url: "https://github.com/xberg-io/xberg"
install_cmd: "pip install kreuzberg"
compatibility:
  - Claude Code
  - Any AI Agent
  - CLI
  - REST API
category: "general"
rating: 4
github_stars: 8603
github_forks: 512
installs: 125000
last_updated: "2026-07-09"
ai_friendliness:
  score: 4
  documentation: 5
  setup: 4
  config: 3
---

## Overview

Kreuzberg (now part of the Xberg ecosystem) is a polyglot document intelligence framework built with a Rust core. It extracts text, metadata, images, and structured information from over 97 file formats — PDFs, Office documents, images, EPUB, HTML, and more. If you've ever fought with a PDF library that couldn't handle a simple table or mangled your Chinese characters, Kreuzberg is the relief you've been looking for.

The project started as a standalone skill for AI coding agents and grew into a full framework with bindings for Rust, Python, Ruby, Java, Go, PHP, Elixir, C#, R, C, and TypeScript (Node/Bun/Wasm/Deno). You can also use it via CLI, REST API, or MCP server. The Rust core means it's fast — we're talking milliseconds per page on modern hardware.

## Why It Matters for AI Workflows

Every RAG pipeline, every document processing workflow, every "upload this PDF and ask questions about it" feature — they all hit the same wall: extracting clean text from messy documents. Kreuzberg solves this at the infrastructure level.

**Key capabilities:**
- **PDF extraction** — text, images, embedded tables, annotations, and metadata
- **OCR pipeline** — Tesseract integration for scanned documents and image-heavy PDFs
- **Table extraction** — preserves row/column structure instead of dumping a wall of text
- **97+ format support** — DOCX, XLSX, PPTX, ODT, EPUB, HTML, Markdown, and more
- **WASM build** — runs directly in the browser with no server needed

## Performance You Can Count On

The Rust core handles heavy lifting while the bindings give you a familiar API in whatever language you're working in. In benchmarks against popular Python libraries (PyMuPDF, pdfplumber, pdfminer), Kreuzberg consistently delivered 2-5x faster extraction with better accuracy on complex layouts.

Scanned documents? The built-in OCR pipeline detects image-based pages automatically and routes them through Tesseract. No manual switching between text and OCR modes.

## Getting Started

```bash
# Python (most common for AI workflows)
pip install kreuzberg

# CLI usage
kreuzberg extract document.pdf --output text

# Python API
from kreuzberg import extract_text
result = extract_text("annual-report.pdf")
print(result.text)
```

For AI agent integration, the MCP server is the cleanest path:

```bash
npx @xberg/mcp-server
# Now your AI agent can read any document format natively
```

## Who Should Use It

- **RAG pipeline builders** — replace brittle PDF parsers with something that actually works
- **AI agent developers** — give your agents the ability to read real-world documents
- **Data extraction teams** — batch process thousands of documents with consistent output
- **Full-stack devs** — the WASM build means browser-only document processing

## Final Thoughts

Kreuzberg is one of those tools that quietly solves a massive pain point. Document extraction isn't glamorous, but every AI developer hits it sooner or later. Having a single framework that handles 97+ formats with a Rust-speed core and bindings in every major language is a massive time saver. The project has 8,600+ GitHub stars and growing fast — the community is active, and the maintainers ship updates regularly.

