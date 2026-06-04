---
title: "如何安装和使用 Browser Use：让 AI 代理操控浏览器"
date: 2026-06-01
toc: true
draft: false
tags:
  - Browser Automation
  - AI Agent
description: "10 分钟装好 Browser Use，让 Claude Code 或 Cursor 里的 AI 代理像人一样操控浏览器，自动完成网页测试、表单填写和数据采集"
category: "guides"
rating: 4
related_skills:
---

## Browser Use 有什么用？

装完 Browser Use 之后，你可以在 Claude Code 或 Cursor 里直接告诉 AI 代理「打开这个网页，找到某篇文章，把内容提取出来」，它会真的打开浏览器去执行，而不是给你一个「我建议你这样做」的 Plan。

整个过程大约 10 分钟，依赖很少，就一个 Node.js 环境。

## 准备工作

- Node.js 18 或以上（用 `node -v` 确认一下版本）
- Claude Code、Cursor 或 Codex 任一安装好并登录
- 一个想自动化操作的网页场景（先想好目标，不要装好了再想用来干嘛）

## 第一步：安装 Browser Use

在终端里跑：

```bash
npx skills add browser-use/browser-use
```

等几秒，显示 `Skill installed successfully` 就是装好了。没什么花头，一行命令搞定。

## 第二步：确认安装成功

在终端里试一下技能是否可用。随便跑一个搜索类的命令：

```bash
npx skills run browser-use --help
```

如果返回了使用说明和参数列表，就说明装上了。如果报 `command not found`，检查一下 Node.js 版本，18 以下的升级一下。我自己踩过这个坑，系统自带的 Node 是 16 的，跑不了。

## 第三步：在代理里使用

装好之后，打开你的 Claude Code 或 Cursor，在对话里输入类似这样的指令：

```
打开 browser-use 的 GitHub 仓库，找到 README 里的安装部分，提取出来给我
```

Agent 会自动调用 Browser Use 技能打开浏览器、访问页面、提取内容。不需要你写任何选择器或者配置。

第一次执行的时候它会提示需要一些权限（比如打开 Chrome 实例），选同意就行。

## 第四步：验证它在正常工作

让它做一个简单的操作，比如打开百度搜「今天的天气」然后截图保存。如果它成功打开了浏览器、执行了搜索、返回了结果，说明一切正常。

如果不成功，最常见的问题是：

- **Chrome 没装**：Browser Use 依赖本地 Chrome 或 Chromium，没有的话装一下
- **权限不足**：有些环境需要你手动允许它启动浏览器进程
- **搜长句子返回空**：关键词短一点效果更好

## 踩过的坑

我第一次跑的时候，它打开了浏览器但卡在「正在导航」不动了。排查了半天，发现是我公司的 VPN 在拦截本地回环流量。关掉 VPN 就好了。如果你也遇到浏览器开了但不加载页面的情况，优先检查代理和 VPN 设置，不要像我一样去重装 Chrome。

## 下一步做什么

试试让它每天帮你抓某个页面的数据、自动化填表、或者监控某个网页的变化。跟找技能的工具 find-skills 配合使用效果更好——先用 find-skills 发现新技能，再用 Browser Use 去研究它的文档。
