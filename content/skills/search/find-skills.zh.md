---
title: "Find Skills"
date: 2026-06-01
draft: false
tags:
  - Search
  - AI Search
  - Discovery
description: "在 Claude Code 中搜索和发现 AI 技能的官方工具，充当技能包管理器，按安装量和来源质量筛选推荐结果"
version: "1.0.0"
author: "Vercel"
repo_url: "https://github.com/vercel-labs/skills"
install_cmd: "npx skills add vercel-labs/skills"
compatibility:
  - Claude Code
  - Cursor
  - Codex
  - Perplexity
category: "search"
rating: 4.0
github_stars: 23189
github_forks: 1876
installs: 1800000
last_updated: "2026-06-20"
ai_friendliness:
  score: 4.0
  documentation: 4.0
  setup: 4.0
  config: 4.0
---

## 它能做什么

Find Skills 是 Agent Skill 生态里的"搜索工具"——它让你在代理环境中直接搜索 skills.sh 注册表，按关键词、分类、流行度查找可安装的 AI 技能包。Vercel Labs 出品（20k Stars），本质上是 `npx skills find [query]` 的命令封装。

## 它与众不同在哪

目前发现新 Skill 的主要方式是靠社交媒体推荐、GitHub Trending 或者人工整理的目录站。Find Skills 提供一个直接在代理内部完成的发现链路——你在用 Claude Code 或 Cursor 开发时，输入需求，它直接搜索注册表并返回可安装的技能包，不需要切出窗口去谷歌搜索。跟 skills.sh 网站相比，它的优势是无缝集成；跟手动搜索相比，它的搜索结果只包含可安装的 Agent Skill，排除掉那些不兼容的独立工具。

## 谁不适合用它

如果你只用一个固定的技能集合（比如常用那三五个），不需要频繁发现新工具，那这个技能对你没什么用。另外，目前 skills.sh 上的 Agent Skill 总量还不大，搜索的覆盖面有限——有时候搜出来的结果不够新或不够全。

## 总结

Find Skills 把"寻找新技能"这件事从分心的浏览器搜索变成了代理内部的一句话指令——适合那些想探索 Agent Skill 生态、但不想在工具间来回切换的人。
