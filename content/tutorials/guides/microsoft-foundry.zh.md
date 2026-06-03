---
title: "不打开 Azure Portal 就部署好模型？Microsoft Foundry 使用教程"
date: 2026-06-03
toc: true
draft: true
tags:
  - Azure
  - AI Models
  - Deployment
  - Tutorial
description: "微软官方 Azure Skills 插件里的 Foundry 技能，让 AI 助手直接帮你发现模型、部署模型、管理 AI Agent 工作流"
category: "guides"
rating: 4
related_skills:
  - ai-image-generation
---

## Microsoft Foundry 是什么

Microsoft Foundry 是微软的 AI 模型平台，你可以把它理解成微软版的「AI 模型超市」。在上面可以浏览、测试、部署各种 AI 模型——包括 OpenAI 的 GPT 系列、微软自研模型、以及第三方开源模型的托管版本。

microsoft-foundry 这个 Agent Skill 是微软 azure-skills 插件的一部分，装好之后，你的 AI 助手就能直接通过 Foundry MCP 服务帮你查模型列表、部署模型、配置 Agent 工作流，不用你自己去 Azure Portal 上点来点去。

## 前置条件

装这个技能之前，你需要有：

- 一个 Azure 账户和订阅
- Node.js 18+
- Azure CLI 安装好并且完成认证：`az login`

没有 Azure 账户的话，去 Azure 官网注册一个免费账户就行，有 200 美金的试用期额度。

## 安装

microsoft-foundry 是 azure-skills 插件里的一个技能，不能单独安装。你需要装整个插件：

```bash
npx skills add microsoft/azure-skills
```

如果你用 Claude Code，也可以这样装：

```bash
/plugin install azure@claude-plugins-official
```

装完之后，插件会同时配置好三个能力层：

1. Azure Skills（知识层）：AI 知道怎么用 Azure
2. Azure MCP Server（执行层）：AI 能直接操作你的 Azure 资源
3. Foundry MCP（专项层）：AI 能操作 Foundry 的模型和 Agent

## 验证有没有装好

装完之后，问 AI 助手一个问题：

```
What AI models are available in Microsoft Foundry?
```

如果返回的是你 Azure 账户里真实可用的模型列表（而不是一堆通用废话），说明 Foundry MCP 层生效了。

你也可以试：

```
Help me deploy GPT-4o as an endpoint in Foundry.
```

AI 应该能帮你走完整个部署流程，包括选模型、配置参数、创建 endpoint、输出调用代码。

## 跟直接用 Azure Portal 比

用 Azure Portal 部署模型，你需要自己点十几个页面：选模型、配参数、设配额、创建 endpoint、等部署完成、拿 endpoint URL。整个流程不熟的话要花半小时。

装了这个 Skill 之后，你告诉 AI 「我要部署 GPT-4o」，它会帮你走完所有步骤，包括检查你的订阅额度够不够、推荐合适的参数配置。复杂度从「学用 Azure Portal」降到了「用自然语言描述你要什么」。

## 有几点要注意

一是这个 Skill 需要认证才能操作你的 Azure 资源。`az login` 是必须的，如果你要在生产环境操作，建议用服务主体凭证而不是个人账户，权限更可控。

二是 azure-skills 插件装完之后默认是连接 Azure 公有云的。如果你用的是 Azure 中国云，需要修改 MCP 配置里的 `--cloud` 参数为 `AzureChinaCloud`。

三是 Foundry 上的模型按 token 计费，部署一个模型 endpoint 之后即使不调用也会产生费用。AI 帮你部署的时候不会自动提醒你关掉，记得用完之后手动删掉不需要的 endpoint。

## 适合什么人用

用 Azure 做项目的人，特别是需要频繁部署和管理 AI 模型的场景。如果你只是偶尔调一下 OpenAI API，不需要这么重的东西。但如果你在做 AI 应用的原型开发、需要反复切换不同模型测试效果，这个 Skill 能省很多在 Portal 里点页面的时间。
