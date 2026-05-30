---
title: "GitHub Copilot"
date: 2026-05-30
draft: false
tags:
  - AI Coding
  - IDE
  - Agent
description: "AI pair programmer that integrates with your editor"
version: "1.0"
author: "GitHub / OpenAI"
repo_url: "https://github.com/features/copilot"
install_cmd: ""
compatibility:
  - VS Code
  - JetBrains
  - Neovim
  - Cursor
category: "coding"
rating: 4.7
github_stars: 0
github_forks: 0
installs: 5200000
last_updated: "2026-05-27"
ai_friendliness:
  score: 4.6
  documentation: 4.8
  setup: 4.5
  config: 4.5
---

GitHub Copilot is an AI pair programmer that offers code completion and chat in your editor.

## Key Features

- Code autocomplete
- AI chat in editor
- Multi-language support
- Pull request summaries

## Usage

Install the extension in your editor:

```bash
# VS Code
code --install-extension GitHub.copilot
```

## Configuration

```yaml
# .vscode/settings.json
{
  "github.copilot.enable": {
    "*": true,
    "yaml": false,
    "markdown": true
  },
  "github.copilot.editor.enableAutoCompletions": true,
  "github.copilot.chat.localeOverride": "en"
}
```
