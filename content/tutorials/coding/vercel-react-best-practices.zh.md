---
title: "Vercel React Best Practices 使用教程，让 AI 写出高性能 Next.js 代码"
date: 2026-06-03
toc: true
draft: true
tags:
  - React
  - Next.js
  - Performance
  - Tutorial
description: "Vercel 官方出的 React/Next.js 性能优化技能，64 条规则覆盖 8 个类别，装进 Claude Code 后 AI 写的代码直接符合 Vercel 的最佳实践"
category: "coding"
rating: 5
related_skills:
  - frontend-design
---

## 这个技能干什么用的

Vercel 出了一个 Agent Skill，叫 React Best Practices。装进 Claude Code 或 Cursor 之后，AI 写 React/Next.js 代码时会自动遵循 64 条性能优化规则，覆盖渲染、状态管理、组件设计、数据获取等 8 个类别。

本质上它是把 Vercel 团队多年积累的 React 性能经验做成了一个 AI 可读的规则库。以前这些知识散落在 Vercel 博客、Next.js 文档、React 官方指南里，现在打包成一个 Skill，AI 助手装上就能用。

## 装起来要多久

这个 Skill 是 vercel-plugin 的一部分，Vercel 把 25 个技能打包在一个插件里。装的话有两种方式：

如果你只想装这一个 Skill：

```bash
npx skills add vercel-labs/vercel-plugin@react-best-practices
```

如果你想装整套 Vercel 生态技能（AI SDK、Next.js、部署、存储等一共 25 个）：

```bash
npx plugins add vercel/vercel-plugin
```

前置条件是 Node.js 18+ 和 Bun。

我试了第一种方式，直接装单个 Skill。装完之后在 Claude Code 里随便写一段 React 代码，AI 的回复里就能看到区别了——它会主动用 `React.memo` 包裹纯组件、提示你用 `useMemo` 缓存计算、建议 Server Component 优先之类的。

## 64 条规则都覆盖了什么

这 64 条规则分成 8 个类别：

- 渲染策略（Server Component vs Client Component 什么时候用哪个）
- 状态管理（state 放哪里、怎么避免不必要的 re-render）
- 组件设计（拆分粒度、组合模式、props 设计）
- 数据获取（fetch 在服务端还是客户端、缓存策略、流式加载）
- 性能优化（memo、useMemo、useCallback 的使用时机）
- 类型安全（TypeScript 类型设计、泛型使用）
- 可访问性（a11y 基础规范）
- 测试策略（组件测试、集成测试的写法）

每条规则不是简单的「推荐用 X」，而是带有条件判断的：在什么场景下用什么方案、为什么、有什么 tradeoff。

## 跟直接让 AI 「遵循 React 最佳实践」有什么区别

你当然可以在 prompt 里写「请遵循 React 最佳实践来写代码」，但这跟装了这个 Skill 的效果差很远。

prompt 里写的那句话太笼统了，AI 的理解因模型而异，今天 Claude 的「最佳实践」和明天 GPT 的「最佳实践」可能不是一回事。而这个 Skill 里的 64 条规则是 Vercel 团队明确写死的，不会漂移。

更重要的是，这套规则是专门针对 Next.js 生态的。普通的 React 最佳实践不会考虑 Server Component、App Router、`use cache` 这些 Next.js 独有的东西。而这 64 条里有相当一部分就是围绕这些来写的。

## 有几点要注意

一是这个 Skill 依赖 Bun 运行时，如果你没装 Bun，先装一下。macOS 和 Linux 都支持，Windows 也有 WSL 方案。

二是装了 vercel-plugin 之后，默认情况下它不会在每次对话都注入全部上下文，只有在检测到你的项目是 Next.js 项目时才会自动激活。你也可以手动触发，用斜杠命令 `/vercel-plugin:status` 看当前项目状态。

三是这 64 条规则是跟 Next.js 16 和 React 19 对齐的。如果你还在用旧版 Next.js（比如 14 以下），部分规则可能不适用，需要你自己判断。

## 值不值得装

如果你在用 Next.js 或 React 写项目，装了不亏。它是那种装上之后不会打扰你、但 AI 写的代码质量会明显提升的技能。特别是如果你在 Vercel 上部署，这些规则就是官方推荐的做法，省得你自己去翻文档。

如果你不用 Next.js，只是纯 React 项目（Create React App 或者 Vite），那收益会小一些，但渲染优化和状态管理的规则照样适用。
