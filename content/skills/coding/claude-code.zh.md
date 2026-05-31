---
title: "Claude Code"
date: 2026-05-30
draft: false
tags:
  - AI 编程
  - CLI
  - 智能代理
description: "Anthropic 出品的智能编程工具，直接在终端中运行"
version: "0.1.0"
author: "Anthropic"
repo_url: "https://github.com/anthropics/claude-code"
install_cmd: "npm install -g @anthropic-ai/claude-code"
compatibility:
  - Claude Code
  - Cursor
  - VS Code
category: "coding"
rating: 4.8
github_stars: 128514
github_forks: 20954
installs: 185000
last_updated: "2026-05-30"
ai_friendliness:
  score: 4.2
  documentation: 4.5
  setup: 4.0
  config: 4.0
---

Claude Code 是 Anthropic 推出的智能编程工具，直接在终端中运行，能理解你的整个代码库并协助你更快地编码。

## 核心特性

- 深度理解代码库
- 终端原生交互
- 多文件编辑
- Git 感知操作

## 使用方法

在项目目录中运行 `claude` 启动会话。

```bash
cd my-project
claude
```

## 配置

在项目根目录创建 `.clauderc` 文件：

```yaml
model: claude-sonnet-4-20250514
system_prompt: "你是一名经验丰富的开发者……"
allowed_tools:
  - Read
  - Edit
  - Bash
  - Glob
```

## 最佳实践

- 始终从明确的目标开始
- 使用 `/help` 探索可用命令
- 在修改之前让 Claude 先了解代码库结构
