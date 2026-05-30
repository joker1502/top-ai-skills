---
title: "GitHub Copilot"
date: 2026-05-30
draft: false
tags:
  - AI 编程
  - IDE
  - 智能代理
description: "集成在编辑器中的 AI 结对编程助手"
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

GitHub Copilot 是一个 AI 结对编程助手，在编辑器中提供代码补全和聊天功能。

## 核心特性

- 代码自动补全
- 编辑器内 AI 聊天
- 多语言支持
- PR 摘要生成

## 使用方法

在编辑器中安装扩展：

```bash
# VS Code
code --install-extension GitHub.copilot
```

## 配置

```yaml
github.copilot.enable:
  "*": true
  yaml: false
github.copilot.editor.enableAutoCompletions: true
```
