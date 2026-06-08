---
title: "Microsoft Foundry"
date: 2026-06-03
draft: false
tags:
  - Azure
  - AI Models
  - Deployment
description: "微软官方 Azure Skills 插件中的 Foundry 技能，让 AI 助手通过 MCP 直接操作你的 Azure Foundry，查模型、部署模型、配置 Agent 工作流"
version: "1.1.64"
author: "Microsoft"
repo_url: "https://github.com/microsoft/azure-skills"
install_cmd: "npx skills add microsoft/azure-skills"
compatibility:
  - Claude Code
  - Cursor
  - Codex
  - GitHub Copilot
category: "automation"
rating: 4.0
github_stars: 1173
github_forks: 182
installs: 365000
last_updated: "2026-06-04"
ai_friendliness:
  score: 5.0
  documentation: 5.0
  setup: 3.0
  config: 3.0
---

## 它能做什么

微软的 AI 模型平台叫 Foundry，可以浏览、测试、部署各种 AI 模型。这个 Skill 是 azure-skills 插件的一部分，装好之后 AI 助手能通过 MCP 直接操作你的 Azure Foundry，查可用模型列表、部署模型 endpoint、配置 Agent 工作流，不用去 Azure Portal 点页面。

## 跟同类产品有什么区别

大多数 AI 工具只能告诉你怎么调 OpenAI API，但不能帮你实际部署一个模型。这个 Skill 给了 AI 真正的执行能力——检查订阅额度、部署模型、返回可用的 endpoint URL。不是给你文档建议，是直接操作你的 Azure 资源。

## 哪些人适合用

在 Azure 上做项目、需要频繁部署和管理 AI 模型的团队。如果在做 AI 应用原型、需要反复切换不同模型测试效果，这个 Skill 能省很多 Portal 操作时间。如果你只是偶尔调一下 API，前置条件（Azure 订阅 + CLI 认证）有点重，不值得折腾。

## 一句话总结

AI 助手变成你的 Azure 运维，用对话就能部署和管理 AI 模型。
