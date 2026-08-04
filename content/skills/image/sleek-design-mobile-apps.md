---
title: "Sleek Design Mobile Apps"
date: 2026-08-04
draft: false
tags:
  - Mobile Design
  - AI Design
  - UI Design
description: "Design mobile apps with Sleek's official agent skill — create projects, direct AI screen design, and implement results in React Native or SwiftUI."
version: "1.0.0"
author: "sleekdotdesign"
repo_url: "https://github.com/sleekdotdesign/agent-skills"
install_cmd: "npx skills add sleekdotdesign/agent-skills -s sleek-design-mobile-apps"
compatibility:
  - Claude Code
  - Cursor
  - Codex
  - OpenClaw
  - Gemini
category: "image"
rating: 4.0
github_stars: 488
github_forks: 43
installs: 21900
last_updated: "2026-08-04"
ai_friendliness:
  score: 4.5
  documentation: 4.5
  setup: 4.0
  config: 4.0
---

## What It Is

Sleek Design Mobile Apps is the official agent skill for [Sleek](https://sleek.design), the AI-powered mobile app design tool. The [repo's own description](https://github.com/sleekdotdesign/agent-skills) defines it in one line: "Design mobile apps, create screens, and manage Sleek projects with AI." The skill ships as a single `design-mobile-apps` capability that connects your coding agent to Sleek's REST API at `/api/v1/*`.

Per the official docs, "sleek.design is an AI-powered mobile app design tool. You interact with it via a REST API at `/api/v1/*` to create projects, describe what you want built in plain language, and get back rendered screens." All communication is standard HTTP with bearer token auth — the agent sends your design intent as a plain-language chat message, and Sleek plans the screen content and layout, renders the screens, and returns them as images you can review and iterate on.

The workflow is deliberately simple: create a project (each project carries its own theme, style, and design system), send a chat message describing what you want, then watch the screens render live in the Sleek editor. When you're happy with the result, the agent fetches the component HTML and implements it — either as a standalone HTML prototype or ported into React Native or SwiftUI with matching icons and fonts.

## What Makes It Different

The first thing that stands out is the **live design session**. Runs render in the Sleek editor in real time — after the agent sends your first message, it shares the editor link (`https://sleek.design/project/:projectId`) so you watch your screens being designed as they happen. The skill explicitly tells the agent to never complete a run silently: after every run that creates or updates screens, it takes screenshots and shows them to you, one per screen plus a combined shot of the whole project.

Second, the skill is built around **style directions instead of raw prompts**. The official docs instruct the agent to author "a single comprehensive paragraph, included in the message, covering mood (2–3 adjectives), color strategy (the logic, not hex codes), typography feel, layout philosophy, component style (radii, borders vs shadows, nav treatment), imagery and illustration style, and one or two distinctive details." Sleek also curates a catalog of design references (`GET /api/v1/references`) — pass a `referenceId` and the reference's style guide seeds the entire project. If you want multiple variations, the skill creates a separate project per variation so each gets its own coherent design system.

Third, the skill handles **the full design-to-code handoff**. It never implements from screenshots alone — it fetches each component's actual HTML code, uses the exact Iconify icons (`solar:heart-bold`, `material-symbols:search-rounded`, etc.) instead of substitutes, pulls the same Google Fonts and weights from the `<link>` tags, and matches navigation structure. For React Native it renders icons with `react-native-svg`'s `SvgXml`, which works in Expo Go with no extra native dependencies. It even has pinned-version support: if you want a specific historical version of a component implemented, you pin `cmp_abc: ver_001` in the prompt and the agent fetches exactly that version's code.

Finally, there's a **device-flow auth path** that keeps API keys out of the conversation: `POST /api/v1/device/start` returns a verification URL and user code, the user approves on Sleek's site, and the agent polls until it receives a `sk_...` key — no copy-pasting secrets. Keys are scoped (`projects:read`, `chats:write`, `screenshots`, etc.), and the skill's security model is single-host: all requests go exclusively to `https://sleek.design`.

## Who It's For

Sleek Design Mobile Apps fits three types of users. First, **founders and solo developers** who need app screens fast — you describe your idea in plain language and get rendered, editable screens instead of starting from a blank Figma canvas or hiring a designer. The README's example flow is exactly this: "design a mobile app" and the agent creates the project, plans the screens, and shows you the result live.

Second, **React Native and SwiftUI developers** who want a visual target to build against. The skill's handoff is designed for you: HTML code as the implementation reference (exact structure, colors, spacing, icon names), screenshots as the visual target, and the icon/font extraction handled automatically. The docs summarize it as "The HTML tells you how to build it; the screenshot tells you what it should look like."

Third, **product teams iterating on design variations**. Because each project carries its own design system, you can spin up separate projects for different style directions and compare rendered screens side by side — a fast way to A/B test visual concepts before committing to one.

Skip it if you need a free tool or fully bespoke visual identity work. Sleek's pricing starts with one-time trial credits on free accounts (about one design run), then requires the Pro plan or higher at $49.99/month (or $30/month billed yearly, ~$360/year), which includes 20,000 monthly AI credits — roughly 650 screens. It's a design production tool, not a free image generator.

## Bottom Line

Sleek Design Mobile Apps is the most complete mobile-app design skill in the agent ecosystem: plain-language briefs in, rendered screens out, and a real design-to-code handoff with exact icons, fonts, and pinned component versions. If you want your agent to design app screens you can actually ship, this is the fastest path from idea to implementation. For related design workflows, see our [GPT Image 2 skill intro](/skills/image/gpt-image-2/) and the [top AI image generation tools roundup](/tutorials/guides/top-ai-image-generation-tools-2026/).
