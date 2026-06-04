---
title: "Improve Codebase Architecture"
date: 2026-06-03
draft: true
tags:
  - Architecture
  - Code Quality
  - Refactoring
  - Coding
description: "Matt Pocock 出品的代码架构改进 Skill，让 AI 从领域语言和 ADR 中发现深层改进机会，不只是表面重构"
version: "1.0.0"
author: "Matt Pocock"
repo_url: "https://github.com/mattpocock/skills"
install_cmd: "npx skills@latest add mattpocock/skills"
compatibility:
  - Claude Code
  - Codex
  - Cursor
category: "coding"
rating: 5.0
github_stars: 115864
github_forks: 10160
installs: 205000
last_updated: "2026-06-03"
ai_friendliness:
  score: 5.0
  documentation: 5.0
  setup: 4.0
  config: 4.0
---

## 它能做什么

让 AI 扫描你的代码库，基于领域语言和 ADR（架构决策记录）发现深层的架构改进机会。不是表面地帮你提取一个函数或者改个变量名，而是识别出模块耦合、职责混乱、抽象层次不当这些需要系统性重构的问题。

## 跟同类产品有什么区别

你让 AI 「帮我优化代码」，它通常会做局部优化——提取函数、加类型、改命名。这个 Skill 会让 AI 先理解你的领域模型，再基于模型找架构层面的改进点。需要配合 Matt Pocock 套件的 CONTEXT.md 使用，AI 才知道你项目里的术语是什么意思。

## 哪些人适合用

代码库已经有一定规模（不是新项目），开始出现「技术债务」迹象的团队。如果你经常觉得代码能跑但越来越难改，这个 Skill 能帮你系统性地发现哪里该重构。

## 一句话总结

AI 不只帮你写代码，还帮你找出代码的架构问题在哪。
