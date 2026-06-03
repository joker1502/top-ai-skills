---
title: "Agent Browser"
date: 2026-06-03
draft: true
tags:
  - 浏览器自动化
  - CLI
  - AI 代理
description: "Vercel Labs 用 Rust 写的浏览器控制 CLI，专为 AI 代理设计，装好后你的 AI 助手就能通过命令行直接操控浏览器"
version: "0.27.1"
author: "Vercel Labs"
repo_url: "https://github.com/vercel-labs/agent-browser"
install_cmd: "npx skills add vercel-labs/agent-browser"
compatibility:
  - Claude Code
  - Cursor
  - Codex
category: "general"
rating: 4.0
github_stars: 35092
github_forks: 2210
installs: 0
last_updated: "2026-06-01"
ai_friendliness:
  score: 4.0
  documentation: 4.0
  setup: 4.0
  config: 4.0
---

## 它能做什么

Agent Browser 是一个用 Rust 写的浏览器控制 CLI，专门给 AI 代理用的。装好之后，你的 AI 助手可以通过终端命令打开网页、点击按钮、填表单、截图、提取页面内容。它走的是 Chrome DevTools 协议，不是模拟 DOM，所以能处理 JavaScript 渲染的动态内容。

## 跟同类产品有什么区别

最大的区别是语言架构。Browser Use 是 Python 生态的，Agent Browser 是 Rust 原生，启动快，不需要 Node.js 运行时。返回的页面快照是结构化的可访问性树，每个可交互元素带一个引用标记，AI 靠这个判断「下一步点什么」比看截图精确得多。另外它支持多浏览器引擎，Chrome、Safari、iOS 模拟器都能控，还支持云浏览器服务，这些是 Python 工具一般不做的。

## 哪些人适合用

适合需要让 AI 代理跟网页交互的场景——填多步表单、爬 JavaScript 重的站点、做 Web 应用测试。如果你只是偶尔让 AI 帮你读个网页，用简单的 fetch 工具就够了，没必要装这个。Windows 用户复用时要注意先关掉所有 Chrome 窗口，否则配置文件会被锁住。

## 一句话总结

Agent Browser 让你的 AI 助手真正能用浏览器，不是看图说话，而是像人一样操作网页。
