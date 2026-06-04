---
title: "Improve Codebase Architecture 使用教程，让 AI 帮你找出架构问题"
date: 2026-06-03
toc: true
draft: true
tags:
  - Architecture
  - Code Quality
  - Refactoring
description: "Matt Pocock 套件里的架构审查 Skill，让 AI 从领域语言和 ADR 出发发现深层改进机会"
category: "guides"
rating: 5
related_skills:
---

## 它能帮你发现什么

你跟 AI 说「帮我优化这段代码」，它通常做的是局部优化——提取函数、加类型、改命名。这些有用，但不触及架构。

Improve Codebase Architecture 做的事不一样。它会让 AI 先理解你的领域模型，然后从模型出发找架构问题。比如「用户模块不应该知道订单的内部结构」，这种跨模块的耦合问题，局部优化是看不到的。

## 属于 Matt Pocock 套件

这个 Skill 是 Matt Pocock 的 18 个技能之一。安装整个套件：

```bash
npx skills@latest add mattpocock/skills
```

安装后先运行 `/setup-matt-pocock-skills`，设置你的 Issue 跟踪器、标签和文档路径。这一步很重要——AI 需要知道你的项目用 GitHub Issues 还是 Linear，文档放在哪里。

## 怎么用

先确保项目里有 CONTEXT.md（项目术语和上下文）。没有的话可以先手动写一个，告诉 AI 你的项目里「用户」「订单」「支付」这些概念分别对应什么。

然后运行 `/improve-codebase-architecture`。AI 会扫描代码库，结合领域语言和 ADR 给出改进建议。每条建议都会说明：问题是什么、为什么是问题、建议怎么改。

## 跟直接问 AI 有什么区别

直接问 AI 「我的架构有什么问题」，它可能会给你一些泛泛的建议。这个 Skill 的优势在于它结合了项目文档（CONTEXT.md）和 ADR，给出的建议是跟你的具体业务领域挂钩的，不是那种放到任何项目都说得通的废话。

## 有几点要注意

这个 Skill 需要你已经有了一定规模的项目。新项目的架构问题通常靠直觉就能看出来，不需要 AI 帮你分析。

另外它只是给出建议，不会自动帮你改代码。每个建议你都需要自己判断是否采纳。建议配合 `/grill-me` 使用——让 AI 先盘问你的重构方案，再动手。

## 下一步

配合 `/to-issues` 把架构改进建议拆成可独立领取的 GitHub Issue，一个一个跟进。
