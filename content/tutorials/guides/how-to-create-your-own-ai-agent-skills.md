---
title: "How to Create Your Own AI Agent Skills: A Step-by-Step Guide"
date: 2026-05-31
toc: true
draft: false
tags:
  - Coding
  - Skills
  - Agents
description: "Create, test, and publish your own AI agent skills. Step-by-step guide covering skill structure, triggers, quality checks, and installation."
category: "guides"
rating: 5
---

Create, test, and publish your own AI agent skills. Step-by-step guide covering skill structure, triggers, quality checks, and installation.

### What This Gets You

You will produce a working SKILL.md file that an AI assistant can read, parse, and execute without extra configuration. The process takes roughly twenty minutes from blank file to verified package. You end up with a structured text file that defines triggers, instructions, and output formats, ready to drop into any agent workspace or share with a team.

### What You Need Before Starting

- A text editor that handles Markdown without adding hidden formatting
- A local terminal with Python 3.8+ or Node 18+ installed
- Access to an AI model that accepts system prompts or custom skill files
- A small test dataset or dummy input to run against your skill
- Basic familiarity with YAML frontmatter and Markdown syntax

### Step-by-Step

**1. Initialize the skill directory and file**
What to do: Create a dedicated folder and add an empty SKILL.md file inside it.
Why: Agents look for specific filenames in known paths. Keeping everything in one folder prevents path confusion and makes version control straightforward.
Command: `mkdir -p ~/my-skill && cd ~/my-skill && touch SKILL.md`
Expected output: No output on success. The directory structure appears when running `ls`.
Gotcha: Do not name the file `skill.md` or `Skill.md`. Some loaders are case-sensitive and will ignore anything that does not match exactly.

**2. Write the metadata header**
What to do: Add a YAML frontmatter block at the top of SKILL.md that defines the name, version, and trigger phrases.
Why: The AI reads this block first to decide if the skill applies to the current user request. Without clear triggers, the model will ignore your instructions or apply them at the wrong time.

```yaml
---
name: csv-cleaner
version: 0.1.0
triggers:
  - "clean csv"
  - "format spreadsheet"
  - "normalize data columns"
---
```

Expected output: The file opens, you paste the block, save, and exit. No terminal output.
Gotcha: YAML requires two spaces for indentation. A single tab or missing space will cause the parser to treat the block as regular text, which breaks the trigger matching.

**3. Define the core instructions**
What to do: Below the frontmatter, write the exact steps the AI must follow when the skill activates. Use imperative sentences and specify input/output formats.
Why: AI models follow explicit constraints better than open-ended requests. Defining column names, error handling, and output structure prevents hallucinated formats.

```markdown
### Instructions

When triggered, perform these actions in order:
1. Read the provided CSV text or file path.
2. Strip whitespace from all header names.
3. Convert date columns to YYYY-MM-DD format.
4. Replace empty cells with `null` (do not use quotes around null).
5. Output a clean CSV block wrapped in a code fence.

### Constraints

- Never modify numeric values unless explicitly instructed.
- Return exactly one code block.
- If the input lacks headers, stop and ask for clarification.
```

Gotcha: Markdown code fences inside instructions can confuse parsers. Use backticks carefully, or escape them with HTML entities if the loader is strict.

**4. Add validation and testing prompts**
What to do: Create a test file that feeds dummy data into the skill and checks the output against expected results.
Why: Skills fail when edge cases like missing commas or malformed dates hit the model. Pre-written test prompts catch format drift before you share the skill.

```csv
name , join_date , id
Alice , 12/04/2023 , 42
Bob , , 17
```

Gotcha: CSVs with trailing newlines or Windows CRLF line endings often break parsers. Run `file test_input.csv` to confirm it uses Unix LF endings before testing.

### Verification

Load the skill into your agent workspace and run a direct test. Open your terminal or editor, point the agent to the SKILL.md file, and feed it `test_input.csv`. The response should match this exact structure:

```csv
name,join_date,id
Alice,2023-04-12,42
Bob,null,17
```

Check three things: headers have no spaces, the empty date became `null` without quotes, and dates switched to YYYY-MM-DD. If the model adds commentary outside the code fence, return to Step 3 and add `Output ONLY the code block. No explanations.` to the constraints.

### One Thing That Tripped Me Up

I spent an hour debugging why the agent kept ignoring the date formatting rule. The problem was not the instructions. I had accidentally placed a blank line between the YAML closing `---` and the first `## Instructions` header. Some parsers treat that blank line as the end of the frontmatter block, while others swallow it into the YAML and fail to parse the whole file. Removing the extra line fixed it instantly.
