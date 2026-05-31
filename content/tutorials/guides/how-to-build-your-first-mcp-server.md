---
title: "How to Build Your First MCP Server: A Step-by-Step Guide"
date: 2026-05-31
draft: false
tags:
  - AI Coding
  - MCP
  - Claude Code
  - Cursor
description: "Build a Model Context Protocol server from scratch. Step-by-step guide covering setup, tool definitions, and configuration for Claude Code and Cursor."
related_skills:
  - claude-code
category: "guides"
rating: 5
---

Build a Model Context Protocol server from scratch. Step-by-step guide covering setup, tool definitions, and configuration for Claude Code and Cursor.

### What This Gets You

When you finish this tutorial, you'll have a working MCP server that exposes custom tools to Claude Code and Cursor. The project gets scaffolded from scratch — typed inputs with Zod, stdio transport layer configured, and the server attached to your local AI editor. You'll also know how to inspect JSON-RPC traffic when things go quiet. Expect roughly 45 minutes from an empty directory to a verified connection.

### What You Need Before Starting

- Node.js 18 or higher installed on your machine
- A terminal you can run commands in
- Cursor or Claude Code installed locally
- Basic comfort with TypeScript and JSON
- A text editor for writing `ts` files
- Read/write permissions to your home directory for config files

### Step-by-Step

**Scaffold the project and install dependencies**
Create a dedicated folder, initialize a Node project, and pull the official MCP SDK along with Zod for schema validation.

```bash
mkdir weather-mcp-server && cd weather-mcp-server
npm init -y
npm install @modelcontextprotocol/sdk zod
npm install -D typescript @types/node tsx
```

Generate a TypeScript configuration file and adjust it to work with modern Node module resolution.

```bash
npx tsc --init
```

Open `tsconfig.json` and verify these three settings:

```json
"target": "ES2022",
"module": "NodeNext",
"moduleResolution": "Node16"
```

Add `"outDir": "./dist"` under `compilerOptions`.
*Gotcha:* The MCP SDK uses ESM-style exports. If your editor throws `ERR_MODULE_NOT_FOUND`, double-check that `moduleResolution` matches `module`. Mismatched resolution is the most common reason imports break on first run.

**Define the tool with typed inputs**
Create `src/index.ts`. MCP tools require a name, a description, a JSON schema for parameters, and an async function that returns a structured content array.

```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

const server = new McpServer({ name: "weather-fetcher", version: "1.0.0" });

server.tool("get_weather", {
  location: z.string().describe("City and state or country"),
  unit: z.enum(["celsius", "fahrenheit"]).optional().default("celsius")
}, async ({ location, unit }) => {
  const temp = Math.floor(Math.random() * 30) + 10;
  const symbol = unit === "celsius" ? "Â°C" : "Â°F";
  return {
    content: [{ type: "text", text: `Current temperature in ${location}: ${temp}${symbol}` }]
  };
});

export default server;
```

*Gotcha:* The AI client reads the `describe()` strings to build its internal tool catalog. Keep descriptions under 100 characters and avoid vague verbs. Clear descriptions mean the AI picks the right tool without guessing.

**Start the stdio transport**
MCP servers talk to clients through standard input/output. This avoids network ports and keeps everything local. Append this to `src/index.ts`:

```typescript
async function start() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("MCP server listening on stdio");
}

start().catch((err) => {
  console.error("Failed to start:", err);
  process.exit(1);
});
```

Update `package.json` scripts:

```json
"scripts": {
  "start": "tsx src/index.ts"
}
```

Test it manually by running `npm start`. You should see `MCP server listening on stdio` in your terminal, followed by silence. The server is waiting for JSON-RPC requests on stdin.

**Attach to Claude Code**
Claude Code reads MCP configurations from a JSON file in your workspace root or user home directory. Create `.mcp.json` in your project folder:

```json
{
  "mcpServers": {
    "weather-fetcher": {
      "command": "npx",
      "args": ["tsx", "src/index.ts"],
      "env": {},
      "disabled": false
    }
  }
}
```

*Gotcha:* Claude Code spawns the command from the workspace root. If `npx` cannot find `tsx`, pass an absolute path to the executable or ensure `tsx` is installed globally.

**Attach to Cursor**
Cursor uses a slightly different discovery path but supports the same JSON schema. Open Cursor settings, navigate to `Features > MCP Servers`, and click `Add Custom Server`. Fill in the fields:
- Name: `weather-fetcher`
- Command: `npx`
- Arguments: `tsx /absolute/path/to/weather-mcp-server/src/index.ts`

Save the entry and restart the editor. Cursor will launch the server as a background process and inject the tool definitions into the next chat session.
*Gotcha:* Cursor caches tool definitions aggressively. If you change a parameter schema, you must restart Cursor completely, not just reload the window.

**Debug with the MCP Inspector**
When an AI client ignores your tool or returns empty text, you need to see the raw JSON-RPC exchange. Install the official inspector:

```bash
npm install -D @modelcontextprotocol/inspector
npx @modelcontextprotocol/inspector npx tsx src/index.ts
```

The command opens a browser window on `localhost:5173`. Click the `Tools` tab, select `get_weather`, enter `{"location": "Seattle"}`, and hit `Run`. Watch the request and response panels. You should see a valid `text` block inside `content`.

### Verification

Open your editor and start a fresh chat. Type: `What is the weather in Austin in celsius?` The AI should display a tool confirmation card. Accept it, and you will see the formatted temperature string appear in the response. To verify without relying on AI interpretation, check the server process logs. The `console.error` statements print to stderr, which editors usually expose in a `MCP Logs` panel or terminal output tab. If you see `MCP server listening on stdio` followed by incoming JSON objects, the transport is healthy. If the AI replies with `I cannot access external tools`, verify that `.mcp.json` sits in the same directory where you opened the editor workspace. Editors isolate projects, and a misplaced config file gets ignored silently.

### One Thing That Tripped Me Up

I spent two hours wondering why my tool kept returning blank text in Cursor. I was returning `{ result: "22Â°C" }` because that is how standard REST APIs format payloads. MCP does not care about arbitrary keys. It requires an array named `content`, where each object contains `type: "text"` and a `text` string. Once I wrapped the output in `{ content: [{ type: "text", text: "22Â°C" }] }`, the client parsed it immediately. The spec is strict about shape, so matching the exact field names matters more than the actual data you send back.

### Next Step

You now have a working server that accepts typed inputs and returns structured text. From here, replace the random number generator with a real HTTP client, add error handling for failed network calls, or register multiple tools to handle different domains.
