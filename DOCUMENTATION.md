# topaiskills.com 项目文档

## 概述

**topaiskills.com** 是一个基于 Hugo 构建的 AI 技能学习与教程静态站点。本站点提供 AI 技能介绍、教程指南和对比分析内容，帮助用户了解和掌握各类 AI 工具与技能。

---

## 技术栈

| 组件 | 版本/详情 |
|------|-----------|
| **Hugo** | v0.162.1 (静态站点生成器) |
| **主题** | Terminal 主题 + 自定义覆盖 |
| **CSS 框架** | Tailwind CSS v4 |
| **分析工具** | Google Analytics (ID: G-6CC8HV421L) |
| **搜索引擎** | Google Search Console (已验证) |


## 内容模型

### 内容目录结构

```
content/
├── skills/               # 技能介绍页
│   └── <category>/
│       └── <slug>/       # 单个技能页面
├── tutorials/
│   ├── guides/           # 教程指南
│   └── comparison/       # 对比分析文章
```

### URL 规则

| 内容类型 | URL 模式 |
|---------|----------|
| 技能介绍 | /skills/<category>/<slug>/ |
| 教程指南 | /tutorials/guides/<slug>/ |
| 对比分析 | /tutorials/comparison/<slug>/ |

### 多语言支持

- **默认语言**: 英文 (English)
- **中文版路径**: /zh/ (URL 前缀)

---

## Frontmatter 格式

### 技能页 (skills)

```yaml
---
title:        # 页面标题
date:         # 发布日期 (YYYY-MM-DD)
draft:        # 是否为草稿 (true/false)
description:  # 页面描述 (用于 SEO)
tags:         # 标签列表
keywords:     # 关键词列表
category:     # 技能分类
readingTime:  # 阅读时间 (分钟)
faq:          # 可选: 常见问题 (结构化数据)
---
```

### 教程页 (tutorials)

```yaml
---
title:        # 页面标题
date:         # 发布日期 (YYYY-MM-DD)
draft:        # 是否为草稿 (true/false)
description:  # 页面描述 (用于 SEO)
tags:         # 标签列表
keywords:     # 关键词列表
category:     # 教程分类
readingTime:  # 阅读时间 (分钟)
---
```

> **注意**: FAQ schema 和 llms.txt 文件均为自动生成，无需手动管理。

---



## 内容写作规则

1. **外部链接**: 所有指向站外的链接必须添加 rel="nofollow" 属性。
2. **分类规范**: 教程文章统一放在 guides/ 或 comparison/ 目录下，不再使用 coding/ 分类。
3. **内部链接**: 站点内部链接请使用相对路径。

---

## 部署流程

### 源码仓库

- **GitHub**: github.com/joker1502/top-ai-skills

### 构建命令

```bash
hugo
```

> 构建要求: **0 error / 0 warning**。

### CI/CD 管道

1. **GitHub Actions** 自动监听 git push 事件。
2. 推送到仓库后自动触发构建。
3. 构建产物部署到 **GitHub Pages** (源站)。
4. **Cloudflare DNS** 代理作为 CDN 加速分发。

> **不需要手动触发部署**，git push 后自动完成全部流程。

---

## 项目人员分工

| 角色 | 姓名 | 职责范围 |
|------|------|---------|
| **代码/运维** | 大K (OpenCode) | 管理代码、layouts 模板、hugo.yaml 配置、static 静态资源 |
| **内容编辑** | 小K (Hermes/我) | 只管 content/ 目录下的文章内容 |

### 协作原则

- 两人的工作文件**不重叠**。
- git merge 自动合并，无冲突。

---

## 本地开发环境

### 前置依赖

- Hugo v0.162.1 或兼容版本
- Node.js (用于 Tailwind CSS 构建)
- Git

### 快速开始

```bash
# 克隆仓库
git clone git@github.com:joker1502/top-ai-skills.git
cd top-ai-skills

# 安装依赖
npm install

# 本地开发 (热重载)
hugo server -D

# 生产构建
hugo
```

---

## 维护备忘

- 新增技能页 -> 在 content/skills/<category>/ 下创建新目录和 index.md
- 新增教程 -> 在 content/tutorials/guides/ 或 content/tutorials/comparison/ 下创建
- 构建前请确保 hugo 命令输出 **0 error / 0 warning**
- 修改后 git push 即可触发自动部署，无需手动操作

---

*文档维护者: 小K (Hermes)*
*最后更新: 2026-07-06*
<<<<<<< HEAD
=======


## 引流推广

### 社交媒体分发策略

| 平台 | 内容风格 | 频率 |
|-----|---------|------|
| X/Twitter | 单条技能推荐、AI 工具小技巧 | 每周 3-5 条 |
| LinkedIn | AI 技能行业应用趋势 | 每周 1 条 |
| Reddit r/AITools | 工具对比、使用心得（自然引用） | 每月 2-3 条 |

### 素材生产方式

1. 每篇文章发布后，提炼 3 个分发角度
2. 写 Strong Hook 文案（反常识/痛点开场 → 价值点 → 行动号召）
3. Pexels/Unsplash 找背景图或直接用纯色底
4. Python Pillow 脚本合成为 1080×1080 Slide 卡片
5. Postiz 排程发布

### 外链建设优先级

topaiskills 是成熟站（12月+），外链策略以内容驱动为主：
- **主攻**：内容驱动（教程自然获取外链）+ Skyscraper 技术
- **辅助**：导航站/目录站（Tier 1-2）
- **补充**：客座博客（Guest Post）

具体执行方法见项目根目录的 `docs/growth-plan.md`。
>>>>>>> e64c1a1 (docs: add DOCUMENTATION.md)
