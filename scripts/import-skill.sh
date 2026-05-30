#!/usr/bin/env bash
# AI-Native Skill Importer
# Usage: ./scripts/import-skill.sh https://github.com/owner/repo
#
# Takes a GitHub URL, fetches repo metadata + README,
# and generates a standardized Hugo skill page.
# Can be invoked by an AI agent or used manually.

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <github-url>"
  echo "Example: $0 https://github.com/anthropics/claude-code"
  exit 1
fi

URL="$1"
CONTENT_DIR="content/skills"
TODAY=$(date +%Y-%m-%d)

# Parse owner/repo from URL
if [[ "$URL" =~ github\.com/([^/]+)/([^/]+) ]]; then
  OWNER="${BASH_REMATCH[1]}"
  REPO="${BASH_REMATCH[2]}"
  REPO="${REPO%.git}"
else
  echo "✗ Not a valid GitHub URL: $URL"
  exit 1
fi

echo "→ Importing $OWNER/$REPO ..."

# Fetch GitHub API data
API_URL="https://api.github.com/repos/$OWNER/$REPO"
if [ -n "${GITHUB_TOKEN:-}" ]; then
  DATA=$(curl -sf -H "Authorization: Bearer $GITHUB_TOKEN" "$API_URL" 2>/dev/null || echo "")
else
  DATA=$(curl -sf "$API_URL" 2>/dev/null || echo "")
fi

if [ -z "$DATA" ]; then
  echo "⚠  Could not fetch repo data (rate limit?). Using defaults."
  DESCRIPTION="A skill from $OWNER/$REPO"
  STARS=0
  FORKS=0
  UPDATED="$TODAY"
else
  DESCRIPTION=$(echo "$DATA" | python3 -c "import sys,json; print(json.load(sys.stdin).get('description','') or '')" 2>/dev/null || echo "")
  STARS=$(echo "$DATA" | python3 -c "import sys,json; print(json.load(sys.stdin).get('stargazers_count',0))" 2>/dev/null || echo "0")
  FORKS=$(echo "$DATA" | python3 -c "import sys,json; print(json.load(sys.stdin).get('forks_count',0))" 2>/dev/null || echo "0")
  UPDATED=$(echo "$DATA" | python3 -c "import sys,json; print(json.load(sys.stdin).get('pushed_at','')[:10])" 2>/dev/null || echo "$TODAY")
fi

# Create slug from repo name
SLUG=$(echo "$REPO" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')
FILE="$CONTENT_DIR/$SLUG.md"

# Check for duplicate
if [ -f "$FILE" ]; then
  echo "✗ Skill already exists at $FILE"
  exit 1
fi

# Detect tags from repo topics
TAGS_JSON=$(echo "$DATA" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    topics = data.get('topics', [])
    lang = data.get('language', '')
    if lang: topics.insert(0, lang)
    print(json.dumps(topics[:5]))
except: print('[]')
" 2>/dev/null || echo "[]")

# Guess compatibility from README
README_TEXT=$(echo "$DATA" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    readme = data.get('readme', '')
    print(readme[:2000])
except: print('')
" 2>/dev/null || echo "")

# Generate the skill page
cat > "$FILE" << SKILLEOF
---
title: "$(echo "$REPO" | sed 's/-/ /g; s/^./\u&/; s/ ./\u&/g')"
date: $TODAY
draft: true
tags:
  - $(echo "$TAGS_JSON" | python3 -c "import sys,json; [print(t) for t in json.load(sys.stdin)]" 2>/dev/null || echo "general")
description: "${DESCRIPTION:-A skill from $OWNER/$REPO}"
version: "1.0.0"
author: "$OWNER"
repo_url: "https://github.com/$OWNER/$REPO"
install_cmd: "skills add $OWNER/$REPO"
compatibility:
  - Claude Code
category: "general"
rating: 4.0
github_stars: $STARS
github_forks: $FORKS
installs: 0
last_updated: "$UPDATED"
ai_friendliness:
  score: 4.0
  documentation: 4.0
  setup: 4.0
  config: 4.0
---

## Overview

${DESCRIPTION:-A skill from $OWNER/$REPO}

## Installation

\`\`\`bash
skills add $OWNER/$REPO
\`\`\`

## Links

- Repository: https://github.com/$OWNER/$REPO
SKILLEOF

echo "✓ Created: $FILE"
echo "  ⭐ $STARS ⑂ $FORKS"
echo "  ℹ  This file is draft: true — edit and set draft: false to publish."
