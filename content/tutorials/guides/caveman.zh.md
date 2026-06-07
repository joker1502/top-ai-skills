---
title: "Caveman 使用教程，让 AI 少说废话的必备技能"
date: 2026-06-07
toc: true
draft: false
tags:
  - Productivity
  - Token
  - AI Agent
description: "Caveman 装进 Claude Code 后，AI 的回复直接砍掉 75% 废话，技术精度不变，速度还快了 3 倍。附详细安装和配置方法"
category: "guides"
rating: 5
related_skills:
---

## Caveman 是什么

一个让 AI 编程助手「闭嘴」的 Skill。不是让 AI 变笨，而是让它不再说废话。

装完之后，Claude Code 原本这样的回复：

「The reason your React component is re-rendering is likely because you're creating a new object reference on each render cycle. This causes React to see the prop as changed, triggering a re-render...」

会变成：

「New object ref each render. Inline object prop = new ref = re-render. Wrap in `useMemo`.」

同样的技术方案，从 69 个 token 变成 19 个，减少 72%。

## 装起来要多久

30 秒。

```bash
# macOS / Linux / WSL
curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh | bash

# Windows PowerShell
irm https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.ps1 | iex
```

需要 Node.js 18 以上。安装脚本会自动检测你装了哪些 AI 编程工具，只往对应的工具里装。

装完之后，在 Claude Code 里输入 `/caveman` 或者直接说「talk like caveman」就激活了。说「normal mode」可以关掉。

## 四个压缩级别

| 级别 | 效果 | 适合场景 |
|------|------|---------|
| lite | 只删填充词，保留完整句子 | 日常使用 |
| full | 默认模式，穴居人风格 | 大多数场景 |
| ultra | 电报式，极度精简 | 快速排查 bug |
| wenyan | 文言文风格，更短 | 玩耍 |

输入 `/caveman ultra` 切到极简模式，整个会话生效。

## 它还附带了什么

除了压缩回复，还有几个实用命令：

`/caveman-commit` — 生成 Conventional Commit 消息，主题行不超过 50 字符，强调「为什么」而不是「改了什么」。

`/caveman-review` — PR 审查评论，单行格式：`L42: 🔴 bug: user null. Add guard.`

`/caveman-stats` — 显示当前会话的 token 用量和终身节省金额，带 `--share` 可以生成一行可分享的统计。

最有用的是 `/caveman-compress <file>`，可以重写你的 CLAUDE.md 或项目记忆文件。实测平均减少 46% 的输入 token，代码片段、URL、路径这些保留原样。

## 什么让我意外

压缩效果比预期好。官方基准测试 10 个任务平均减少 65% token，我的体验接近这个数字。解释 React 重渲染那个例子，从 1180 个 token 压到 159 个，减少 87%。

另一个意外是它只影响输出 token，思考/推理 token 完全不受影响。所以不用担心 AI 变笨了，它只是不爱说废话了。

还有一篇 2026 年 3 月的论文，发现约束大模型用简洁回复在某些基准上准确率提高了 26 分。所以不只是省钱，有时候更短的回复反而更准确。

## 有几点要注意

Caveman 不支持所有工具的 30+ 种 AI 代理。主流的 Claude Code、Cursor、Codex、Windsurf、Cline、Copilot 都支持，但一些小众工具可能需要手动配置。

`/caveman-stats` 的状态栏徽章在 Claude Code 里显示为 `[CAVEMAN] ⛏ 12.4k`，每次运行 stats 命令更新。如果觉得碍眼，设 `CAVEMAN_STATUSLINE_SAVINGS=0` 关掉。

## 下一步

装好之后试试不同的压缩级别，找到你日常最舒服的那个。配合 caveman-shrink（MCP 中间件）可以压缩工具描述，配合 cavecrew 子代理可以减少子任务的 token 消耗。
