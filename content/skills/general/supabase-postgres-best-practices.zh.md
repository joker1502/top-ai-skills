---
title: "Supabase Postgres Best Practices"
date: 2026-06-01
draft: false
tags:
  - Database
  - PostgreSQL
description: "Supabase 官方 PostgreSQL 优化指南，涵盖查询性能、索引策略、RLS 安全策略和平台特定最佳实践"
version: "1.0.0"
author: "Supabase"
repo_url: "https://github.com/supabase/agent-skills"
install_cmd: "npx skills add supabase/agent-skills"
compatibility:
  - Claude Code
  - Cursor
  - Codex
category: "general"
rating: 4.0
github_stars: 2250
github_forks: 157
installs: 207600
last_updated: "2026-06-09"
ai_friendliness:
  score: 4.0
  documentation: 4.0
  setup: 4.0
  config: 4.0
---

## 它能做什么

这个技能让 AI 代理掌握 Supabase 推荐的 PostgreSQL 最佳实践——从索引策略到查询优化，从行级安全策略到实时订阅配置。Supabase 官方出品（agent-skills 仓库，2.1k Stars），专为那些在 Supabase 上构建后端的开发者设计。

## 它与众不同在哪

网上 PostgreSQL 优化建议大多是通用的——"建索引"、"避免 N+1"这类大原则。Supabase Postgres Best Practices 的不同在于它了解 Supabase 平台的具体特性：如何利用 Row Level Security 来简化数据访问逻辑、什么时候用 Realtime Subscription 而不是轮询、Supabase 的 Connection Pooler 如何影响查询行为。这些不是通用数据库知识，而是来自 Supabase 团队对自家平台的理解。

## 谁不适合用它

如果你不用 Supabase，它基本没用——这是针对 Supabase 平台的技能，不覆盖通用 PostgreSQL 知识。另外，如果你已经是 Supabase 重度用户，这个技能教的东西你可能早就知道了，它更适合理清思路而非学习新东西。

## 总结

在 Supabase 上用 Postgres，别靠通用的 SQL 知识猜——这个技能让你避免那些"在文档里写着但没人会告诉你"的坑。
