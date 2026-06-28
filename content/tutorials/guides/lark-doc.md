---
title: "How to Install and Use LarkDoc: Read and Write Lark Documents with AI"
date: 2026-06-20
draft: false
tags:
  - Lark
  - Feishu
  - Document Automation
  - AI Skills
  - CLI
description: "Step-by-step guide to installing the LarkDoc skill, authenticating with Lark/Feishu, and using AI agents to read, create, and edit documents through natural language."
toc: true
category: "guides"
related_skills:
  - lark-doc
---
## What This Gets You

This tutorial walks through installing LarkDoc — a skill inside the larksuite CLI that gives your AI agent direct access to Lark (Feishu) documents. By the end, your assistant will be able to fetch document content, create new docs, append or update blocks, insert images, and generate whiteboards — all through natural language. The process takes about 15 minutes if you already have a Lark tenant, or 20 minutes if you need to create one.

## What You Need Before Starting

- **Node.js 18 or later** — the larksuite CLI is distributed through npm. Check with `node --version`.
- **A Lark or Feishu account** — any tenant works, including the free tier. If you do not have one, sign up at larksuite.com.
- **A terminal** — macOS, Linux, or WSL on Windows.
- **Permissions to create a custom app in your Lark tenant** — you need admin or developer access to configure the app credentials.

## Step-by-Step

### 1. Install the larksuite CLI

The LarkDoc skill runs inside the larksuite CLI, which is installed as a single npm package:

```bash
npx @larksuite/cli@latest install
```

This downloads the CLI binary and helper scripts. Expected output:

```
✔ lark-cli installed successfully
```

**Gotcha**: If you see a permissions warning about npm global installs, you may need to use `sudo npx @larksuite/cli@latest install` or configure a local npm prefix. On macOS and Linux the npx cache usually handles this without issues.

### 2. Add the LarkDoc skill

Once the CLI is installed, register the LarkDoc skill so your AI coding assistant can use it:

```bash
npx skills add https://github.com/larksuite/cli --skill lark-doc
```

Expected output:

```
✔ Skill lark-doc added from larksuite/cli
```

This registers the skill locally and makes it available to any compatible AI agent (Claude Code, Cursor, Codex, etc.). The larksuite CLI ships 26 skills total — you can browse them on the [LarkDoc skill page](/skills/automation/lark-doc/) — but you only need to add the ones you plan to use.

### 3. Create a Lark app and get credentials

LarkDoc needs API credentials to authenticate with Lark's platform. You create a custom app in the Lark Developer Console:

1. Go to [open.feishu.cn/app](https://open.feishu.cn/app) (or `open.larksuite.com/app` for international tenants).
2. Click **Create App** → choose **Custom App**.
3. Give it a name like "AI Agent CLI" and select the appropriate scope (internal app is simplest for personal use).
4. Once created, go to **Credentials & Basics**. Copy the **App ID** and **App Secret**.

You will need these values in the next step.

### 4. Configure authentication

Back in the terminal, run the config initialization:

```bash
lark-cli config init
```

This launches an interactive prompt. Paste your App ID and App Secret when asked. The CLI stores credentials in your OS-native keychain.

Expected interaction:

```
? App ID: cli_abc123...
? App Secret: [hidden input]
✔ Config saved
```

Next, log in to generate access tokens:

```bash
lark-cli auth login --recommend
```

The `--recommend` flag auto-selects commonly used permission scopes. A browser window opens asking you to authorize the app. After approving, return to the terminal.

Expected output:

```
✔ Authorization successful
```

**Gotcha**: If you are running on a headless server without a browser, use `lark-cli auth login --headless`. This prints a URL you can open on another device, then paste the returned code back into the terminal.

### 5. Fetch your first document

With auth set up, test the skill by reading a document. Find any Lark document URL — it looks like `https://xxx.feishu.cn/docx/abc123` or `https://xxx.larksuite.com/docx/abc123`. Run:

```bash
lark-cli docs +fetch --api-version v2 --doc "https://xxx.feishu.cn/docx/abc123"
```

Replace the URL with an actual document from your tenant. Expected output is the document content rendered as XML with block structure:

```
<document>
  <title>Document Title</title>
  <p>First paragraph content...</p>
  ...
</document>
```

The `--api-version v2` flag is required — the skill defaults to v2 API and will error if you omit it.

### 6. Create a new document

Now test creation. Run:

```bash
lark-cli docs +create --api-version v2 --content '<title>Test Doc</title><p>Created by my AI agent.</p>'
```

Expected output includes the new document URL and token:

```
✔ Created
Document URL: https://xxx.feishu.cn/docx/new_token_here
```

You can open this URL in a browser to verify the content rendered correctly.

### 7. Append content to an existing document

To add content after creation, use the update command with `--command append`:

```bash
lark-cli docs +update --api-version v2 --doc "https://xxx.feishu.cn/docx/new_token_here" --command append --content '<p>Appended by AI.</p>'
```

Expected output:

```
✔ Updated
```

### 8. Search across documents

Find documents by keyword:

```bash
lark-cli docs +search --api-version v2 --query "quarterly planning"
```

This returns a list of matching documents with their titles, URLs, and snippets. Useful when you need your AI agent to find something without knowing the exact URL.

## Verification

Run this sequence to confirm everything works end-to-end:

```bash
# Create a doc
DOC_URL=$(lark-cli docs +create --api-version v2 --content '<title>Smoke Test</title><p>Hello from LarkDoc</p>' --json | python3 -c "import sys,json;print(json.load(sys.stdin)['url'])")

# Fetch it back
lark-cli docs +fetch --api-version v2 --doc "$DOC_URL"

# Clean up
lark-cli docs +update --api-version v2 --doc "$DOC_URL" --command overwrite --content '<title>Smoke Test</title><p>Deleted</p>'
```

Expected: the fetch returns the content you just created, confirming read and write both work.

## One Thing That Tripped Me Up

The `--api-version v2` flag is easy to forget. The LarkDoc skill documentation states it uses v2 API, but the CLI also supports older v1 endpoints with different parameter structures. If you run `docs +fetch` without `--api-version v2`, the CLI defaults to v1 and either errors with an unrecognized parameter message or returns a different response format. I learned to add it as the first argument after the subcommand — that way muscle memory builds correctly before you start chaining more flags.

## Next Step

Try having your AI agent create a meeting notes template document — instruct it to use `lark-cli docs +create` with a structured XML layout including headings, bullet lists, and a table. Once that works, explore the other 25 skills in the larksuite CLI: lark-sheets for spreadsheet operations, lark-base for database management, and lark-calendar for event scheduling.
