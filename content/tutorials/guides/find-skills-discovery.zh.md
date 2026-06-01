---
title: "用 find-skills 在终端里淘 AI 技能，比刷 GitHub Trending 快多了"
date: 2026-06-01
toc: true
draft: false
tags:
  - AI Search
  - Discovery
  - Skills
  - Tutorial
description: "find-skills 让你在终端里直接搜索 skills.sh 注册表，不用切窗口不用开浏览器"
category: "guides"
rating: 4
related_skills:
  - find-skills
---

## 为什么我会去折腾这个

事情是这样的。前阵子在写 topaiskills.com，需要不断地发现新的 Agent Skill 包来收录。

我的流程是这样的：先刷 GitHub Trending，再看 Twitter/X 上的推荐帖，然后去 skills.sh 网站上一个个翻。每找到一个看起来不错的，复制 `npx skills add` 命令，切回终端安装，切回浏览器看下一个。来回切几次，我就开始烦了。

而且 GitHub Trending 上大部分是独立工具，不是 Agent Skill。我需要的是那种能在 Claude Code 或 Cursor 里跑的东西，不是又一个 SaaS 产品。筛选成本很高。

正好看到 Vercel 出了个 find-skills，说是直接在终端里搜索 skills.sh 注册表。我寻思这不就是我刚需吗，装了一个试试。

## 装起来要多久

一句话：一分钟。

```bash
npx skills add vercel-labs/skills
```

装完之后，直接在终端里跑：

```bash
npx skills find browser automation
```

它就返回搜索结果了，每个结果带描述、GitHub Stars、安装命令。你不用切出编辑器，不用打开浏览器，不用记任何网址。

不过有个小坑。我第一次跑的时候返回说「No skills found」，愣了一下。后来发现是因为我搜的关键词太长了，改成更短的词就好了。比如搜 `browser` 而不是 `browser automation tool`。这个在文档里没写，我自己试出来的。

## 我用它找到了什么

装好之后，我搜了几个方向试效果。

搜 `browser`，返回了 Browser Use（96k Stars），就是那个让 AI 代理操控浏览器的技能。我之前在 Twitter 上看到过它但一直没去安装，因为懒得切出去找安装命令。find-skills 直接给出 `npx skills add browser-use/browser-use`，复制粘贴就装好了。

搜 `seo`，返回了 SEO Audit（31k Stars）。这个我之前完全不知道，顺着找到 Corey Haines 的 marketingskills 仓库，发现里面还有好几个营销相关的技能。

搜 `debug`，返回了 Systematic Debugging（214k Stars，来自 Obra 的 Superpowers）。这个我之前就听说过，但一直不知道确切的名字和安装方式，在终端里一搜就找到了。

最有意思的是，我搜了 `postgres` 想看看有没有数据库相关的技能，返回了 Supabase Postgres Best Practices（2.1k Stars）。这个星星数不高，但刚好我最近在搞 Supabase，装了一个试了试，内容质量比我想象中好。

## 什么让我意外

一个是搜索结果的质量。我原本以为注册表里的技能不会很多，搜出来的可能就几个。但实际上覆盖得还不错，我搜了大概七八个方向，每个都有至少一两个结果。怎么说呢，它不会取代 GitHub Trending，但它是一个跟 Trending 互补的发现渠道。Trending 告诉你现在什么火，find-skills 告诉你什么技能可用。

另一个意外是它的搜索速度。每次查询基本一秒内返回，不需要联网等待。它是拉取注册表缓存在本地的，所以体验比打开浏览器加载网站快得多。

## 什么让我想吐槽

搜索结果不显示安装量或者热度排名。同一个关键词可能出来好几个技能，但你看不到哪个用得最多、哪个评价最好。找技能变成了「看到一个名字觉得还行就装来试试」，缺少决策信息。

还有就是之前说的，搜长句子容易返回空结果。我觉得它用的是关键词匹配，不是语义搜索。所以你得事先知道大概用什么词来搜，这有点悖论——如果我连关键词都不知道，我为什么要搜呢？

另外，它目前搜到的技能数量还是有限的。skills.sh 上的 Agent Skill 包整体数量还不大，如果你已经很熟悉这个生态了，可能搜不出太多你不知道的东西。它的价值更多的在「入门和探索阶段」。

## 什么时候用 什么时候不用

我现在这么用：每周花五分钟跑一次 `npx skills find`，关键词换着搜几个方向，看看有没有新上架或者之前漏掉的技能。对我来说这是一个补丁，不是主渠道。

如果你刚开始接触 Agent Skill 生态，不知道有哪些可以装、不知道该搜什么关键词，find-skills 更适合在你知道关键词之后用。如果你已经有固定的技能集，不太需要发现新东西，那它基本用不上。

不过作为一个「把发现链路缩短到终端里」的工具，方向是对的。等 skills.sh 的技能数量多起来，它的价值会更大。
