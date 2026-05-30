---
title: "Claude Code 入门教程"
date: 2026-05-30
draft: false
tags:
  - 教程
  - AI 编程
  - CLI
description: "从安装到精通，手把手教你使用 Claude Code 进行 AI 辅助开发"
related_skills:
  - claude-code
category: "tutorial"
rating: 5
---

Claude Code 是 Anthropic 推出的智能编程工具。本教程带你快速上手。

## 安装

```bash
npm install -g @anthropic-ai/claude-code
```

或者使用安装脚本：

```bash
curl -sS https://claude.ai/install | bash
```

## 基本使用

在项目目录中启动会话：

```bash
cd my-project
claude
```

## 常用命令

- `/help` — 查看可用命令
- `/clear` — 清空对话历史
- 费用模式 — 监控 Token 使用量

## 使用技巧

1. **让它先探索** — Claude Code 会先读完你的整个代码库再动手
2. **结合 Git** — Claude Code 能感知 Git 状态，主动建议提交
3. **描述要具体** — 给的上下文越详细，效果越好
