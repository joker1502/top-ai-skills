---
title: "Browser Use"
date: 2026-06-01
draft: false
tags:
  - Automation
  - Browser Automation
description: "让 Claude 控制真实浏览器执行网页测试、表单填写、截图和数据提取，处理 JavaScript 渲染内容和登录会话"
version: "1.0.0"
author: "Browser Use"
repo_url: "https://github.com/browser-use/browser-use"
install_cmd: "npx skills add browser-use/browser-use"
compatibility:
  - Claude Code
  - Cursor
  - Codex
category: "general"
rating: 4.0
github_stars: 98910
github_forks: 11040
installs: 77900
last_updated: "2026-06-15"
ai_friendliness:
  score: 4.0
  documentation: 4.0
  setup: 4.0
  config: 4.0
---

## 它能做什么

Browser Use 让 AI 代理能像人一样操控浏览器——打开网页、点击按钮、填写表单、提取数据。不是截图后分析页面，而是真正地执行 DOM 交互，像用户一样完成操作流程。96k GitHub Stars 证明了它在代理工具生态中的位置。

## 它与众不同在哪

市面上大多数"浏览器自动化"工具本质上是截图+分析，依赖视觉识别来理解页面。Browser Use 直接操控 DOM 树，能精确点击任何元素、读取隐藏内容、处理 JavaScript 渲染后的页面状态。跟 Playwright/Puppeteer 这类传统自动化框架相比，它的优势在于由 AI 驱动决策——你不需要写选择器，告诉它"提取这个表格"即可。

## 谁不适合用它

如果你的任务只是定期抓取同一个页面，用 Playwright 写一个固定脚本更稳定可靠。Browser Use 适合需要动态决策的场景——页面结构不固定、操作步骤取决于返回内容的情况。另外，它目前对验证码和复杂登录流程的处理还不够成熟。

## 总结

Browser Use 是让 AI 代理真正能用浏览器的关键技能——不是看网页截图，而是像人一样操作网页。
