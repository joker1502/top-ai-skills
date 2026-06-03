---
title: "用 Remotion Skill 让 AI 帮你用 React 写视频"
date: 2026-06-03
toc: true
draft: true
tags:
  - Remotion
  - React
  - Video
  - Animation
  - Tutorial
description: "Remotion 官方的 Agent Skill，装进 Claude Code 后 AI 直接帮你写动画、处理字幕、加音效、做转场，不用记 Remotion 的 API"
category: "guides"
rating: 5
related_skills:
  - agent-browser
---

## Remotion 是什么

Remotion 是一个用 React 代码写视频的框架。你可以用 JSX、CSS、Canvas 这些前端技术来创建视频，而不是在 After Effects 里拖时间轴。

它的核心思路是：视频的每一帧就是一个 React 组件的渲染结果。用 `useCurrentFrame()` 获取当前帧号，用 `interpolate()` 做动画插值，跟写前端动画很像，但输出的是 MP4。

48.8k GitHub Stars，Fireship 的「This video was made with code」就是用 Remotion 做的，GitHub Unwrapped 年度回顾也是。

## 装这个 Skill 能干什么

直接说结论：让 AI 帮你写 Remotion 代码，而不是你自己翻文档。

Remotion 有不少坑，AI 不知道的话会帮你踩一遍。比如 CSS transitions 在视频渲染里不会正确工作，Tailwind 的动画类名也不能用，资源必须放在 `public/` 目录里用 `staticFile()` 引用。这些规则写一遍 prompt 记不住，但装了这个 Skill，AI 会自动遵循。

覆盖的范围很广，除了基础的动画和资源管理，还有 30 多个子规则文件：字幕、音效、转场、3D（Three.js）、GIF 同步、透明视频、音频可视化、旁白生成（ElevenLabs TTS）、Google 字体加载等。

## 装起来要多久

```bash
npx skills add remotion-dev/skills@remotion-best-practices
```

一行命令，装完就能用。

如果你还没有 Remotion 项目，先创建一个：

```bash
npx create-video@latest --yes --blank --no-tailwind my-video
```

装完 Skill 后，在 Claude Code 或 Cursor 里打开这个项目，AI 会自动识别 Remotion 项目并加载规则。

## 试了一下

我让 AI 写一个简单的「标题淡入 + 副标题延迟出现」的动画。在没有装 Skill 的情况下，AI 写了一个用 CSS `transition` 做淡入的组件——这在 Remotion 里是错的，渲染出来不会有动画效果。

装了 Skill 之后，同样的需求，AI 直接用了 `useCurrentFrame()` + `interpolate()` + `Easing.bezier()`，还用了 `<Sequence>` 的 `from` 属性来延迟副标题。代码跑一遍就出片。

这个区别很实际：不是 Skill 让 AI 写了更好的代码，而是 Skill 阻止了 AI 写出根本跑不了的代码。

## 有几点要注意

Remotion 有特殊许可证，非开源。个人项目免费，商用需要购买公司许可证。如果你在做商业项目，先确认许可证条款。

另外这个 Skill 是 `vercel-plugin` 那种模式——规则是 Remotion 官方维护的，会随版本更新同步。如果 Remotion 发了大版本更新（比如现在 v4 已经很成熟了），Skill 的规则也会跟进。但如果你用的是旧版本 Remotion，新规则里提到的 API 可能还不支持。

## 跟手动写有什么区别

如果你已经很熟悉 Remotion，这个 Skill 的价值不大——你都知道这些规则了。它的核心受众是会用 React 但不熟悉 Remotion 特殊规则的开发者，或者是需要快速出原型、不想花时间翻文档的场景。

它的上限也明显：30 多个子规则文件覆盖面广，但每个主题的深度有限。如果你要做复杂的 3D 视频或者多轨道音频混音，Skill 能帮你起步，但深层调优还是得看 Remotion 官方文档。

## 下一步

装好之后，直接跟 AI 说「帮我做一个 30 秒的短视频，主题是产品发布倒计时」，看看它能不能用 `<Sequence>` 组织时间轴、用 `interpolate()` 做数字跳动、用 `<Audio>` 加背景音。配合 find-skills 发现更多视频相关的技能。
