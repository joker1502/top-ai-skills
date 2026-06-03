---
title: "Agent Browser 安装指南：Vercel 出品的浏览器自动化 CLI"
date: 2026-06-03
toc: true
draft: true
tags:
  - Browser Automation
  - AI Agent
  - Tutorial
description: "Agent Browser 是 Vercel Labs 用 Rust 写的浏览器控制 CLI，专为 AI 代理设计，装好后你的 AI 助手就能通过命令行直接操控浏览器"
category: "guides"
rating: 4
related_skills:
  - browser-use
---

## Agent Browser 有什么用

装完 Agent Browser，你的 AI 助手可以通过终端命令直接打开浏览器、点击按钮、填表单、截图、提取页面内容。它不是让你手动写自动化脚本的那种工具，而是给 AI 代理用的——AI 看到页面快照后自己决定下一步该点什么。

跟 Browser Use（Python 生态）不同，Agent Browser 是 Rust 原生实现的，走 Chrome DevTools 协议，不需要 Node.js 运行时，启动速度快，适合集成在 CLI 工作流里。

## 开始前的准备

确认你有以下环境：

- Node.js 18+（用于 npm 安装 CLI 本身，浏览器控制不需要 Node）
- 或者 macOS 上可以用 Homebrew，或者有 Rust 环境用 Cargo 装
- 大约 500MB 磁盘空间（首次安装会下载 Chrome for Testing）

```bash
node -v   # 确认 18 以上
```

## 安装

最快的方式是 npm 全局安装：

```bash
npm install -g agent-browser
```

装完之后，首次使用前需要下载浏览器：

```bash
agent-browser install
```

这一步会自动下载 Chrome for Testing。如果你已经本地装了 Chrome 或 Brave，Agent Browser 也能自动识别复用。

如果你在 Linux 上跑，加一个参数安装系统依赖：

```bash
agent-browser install --with-deps
```

macOS 用户也可以用 Homebrew：

```bash
brew install agent-browser
agent-browser install
```

## 验证安装

打开一个网页试试：

```bash
agent-browser open https://example.com
```

如果浏览器弹出来了（或无头模式下没报错），说明装好了。接下来取一个页面快照：

```bash
agent-browser snapshot -i --json
```

它会返回页面的可访问性树，每个可交互元素带一个引用标记（`@e1`、`@e2` 这样的格式）。AI 代理就是靠这些标记来定位页面元素的。

用引用标记操作元素：

```bash
agent-browser click @e2        # 点击标记为 @e2 的按钮
agent-browser fill @e3 "hello"  # 在标记为 @e3 的输入框填入 hello
```

## 配置项

项目根目录放一个 `agent-browser.json` 可以自定义行为：

```json
{
  "$schema": "https://agent-browser.dev/schema.json",
  "headed": true,
  "proxy": "http://localhost:8080",
  "profile": "./browser-data"
}
```

优先级从低到高：用户配置（`~/.agent-browser/config.json`）→ 项目配置（`agent-browser.json`）→ 环境变量（`AGENT_BROWSER_` 前缀）→ CLI 参数。

## 有几点要注意

Agent Browser 的默认操作超时是 25 秒。如果你设置超过 30 秒，CLI 可能返回 EAGAIN 错误。碰到操作卡住的情况，先检查是不是超时设置的问题，而不是去重装浏览器。

另外 Windows 用户如果要复用 Chrome 的登录状态（`--profile` 参数），需要先关闭所有 Chrome 窗口，否则配置文件会被锁住读不了。

## 跟 Browser Use 怎么选

简单说，如果你主要在 Claude Code 或 Cursor 里用，两个都能干。Browser Use 生态更成熟（96k Stars），社区大；Agent Browser 性能更好（Rust 原生），多浏览器支持更强（Chrome、Safari、iOS 模拟器、云浏览器都行），还有安全特性（域名白名单、操作策略）。

如果你需要操控 iOS Safari 或者对接云浏览器服务，选 Agent Browser。如果只是基本的网页自动化，Browser Use 的上手门槛更低。

## 下一步

试试让 AI 助手跑一个完整的任务流，比如「打开某个网站，登录，提取某段数据」。Agent Browser 支持批量命令和会话持久化，复杂任务流可以串起来执行。配合 find-skills 发现更多可用技能，浏览器自动化只是开始。
