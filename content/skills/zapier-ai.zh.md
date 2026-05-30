---
title: "Zapier AI"
date: 2026-05-30
draft: false
tags:
  - AI 自动化
  - 工作流
  - 无代码
description: "通过 AI 驱动的触发器实现 5000+ 应用之间的工作流自动化"
version: "2.0"
author: "Zapier Inc."
repo_url: "https://zapier.com/ai"
install_cmd: ""
compatibility:
  - Web
  - Zapier
category: "automation"
rating: 4.5
github_stars: 0
github_forks: 0
installs: 890000
last_updated: "2026-05-24"
ai_friendliness:
  score: 4.0
  documentation: 4.2
  setup: 4.5
  config: 3.5
---

Zapier AI 连接你的应用，通过 AI 驱动的触发器和动作实现工作流自动化。

## 核心特性

- 5000+ 应用集成
- AI 驱动的自动化
- 无代码界面
- 多步骤工作流

## 使用方法

通过 Web 界面创建 Zap，或使用 CLI：

```bash
npm install -g zapier-platform-cli
zapier init my-zap
zapier push
```

## 配置

```yaml
app: my-app
version: 1.0.0
triggers:
  - new_file_in_folder
actions:
  - send_email
```
