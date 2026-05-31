#!/usr/bin/env bash
# AI-Native Skill Importer
# Usage: ./scripts/import-skill.sh https://github.com/owner/repo [category]
#
# Fetches repo metadata, releases, and README to generate a complete skill page.
# You only need to write the article body content.
# Can be invoked by an AI agent or used manually.

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <github-url> [category]"
  echo "Example: $0 https://github.com/anthropics/claude-code coding"
  echo ""
  echo "Categories: general, coding, image, search, automation"
  exit 1
fi

URL="$1"
CATEGORY="${2:-}"
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

# === Helper: call GitHub API ===
gh_api() {
  local path="$1"
  local url="https://api.github.com$path"
  if [ -n "${GITHUB_TOKEN:-}" ]; then
    curl -sf -H "Authorization: Bearer $GITHUB_TOKEN" "$url" 2>/dev/null || echo ""
  else
    curl -sf "$url" 2>/dev/null || echo ""
  fi
}

# === 1. Fetch repo metadata ===
DATA=$(gh_api "/repos/$OWNER/$REPO")

if [ -z "$DATA" ]; then
  echo "⚠  Could not fetch repo data. Using defaults."
  DESCRIPTION=""
  STARS=0
  FORKS=0
  UPDATED="$TODAY"
  LANGUAGE=""
else
  DESCRIPTION=$(echo "$DATA" | python3 -c "import sys,json; print(json.load(sys.stdin).get('description','') or '')" 2>/dev/null || echo "")
  STARS=$(echo "$DATA" | python3 -c "import sys,json; print(json.load(sys.stdin).get('stargazers_count',0))" 2>/dev/null || echo "0")
  FORKS=$(echo "$DATA" | python3 -c "import sys,json; print(json.load(sys.stdin).get('forks_count',0))" 2>/dev/null || echo "0")
  UPDATED=$(echo "$DATA" | python3 -c "import sys,json; print(json.load(sys.stdin).get('pushed_at','')[:10])" 2>/dev/null || echo "$TODAY")
  LANGUAGE=$(echo "$DATA" | python3 -c "import sys,json; print(json.load(sys.stdin).get('language','') or '')" 2>/dev/null || echo "")
fi

# === 2. Fetch latest version from releases ===
VERSION=$(gh_api "/repos/$OWNER/$REPO/releases/latest" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    tag = data.get('tag_name', '')
    print(tag.lstrip('v'))
except: print('')
" 2>/dev/null || echo "")

# Fallback: try tags
if [ -z "$VERSION" ]; then
  VERSION=$(gh_api "/repos/$OWNER/$REPO/tags" | python3 -c "
import sys, json
try:
    tags = json.load(sys.stdin)
    if tags:
        tag = tags[0].get('name', '')
        print(tag.lstrip('v'))
except: print('')
" 2>/dev/null || echo "")
fi
[ -z "$VERSION" ] && VERSION="1.0.0"

# === 3. Fetch README for install command and compatibility ===
README_DATA=$(gh_api "/repos/$OWNER/$REPO/readme" | python3 -c "
import sys, json, base64
try:
    data = json.load(sys.stdin)
    content = data.get('content', '')
    if content:
        decoded = base64.b64decode(content).decode('utf-8', errors='replace')
        print(decoded[:5000])
except: print('')
" 2>/dev/null || echo "")

# Detect install command from README
INSTALL_CMD=$(echo "$README_DATA" | python3 -c "
import sys, re
readme = sys.stdin.read()
patterns = [
    r'npm install (-g\s+)?(\S+)',
    r'pip install\s+(\S+)',
    r'brew install\s+(\S+)',
    r'cargo install\s+(\S+)',
    r'go install\s+(\S+)',
    r'curl.*?\|\s*(?:bash|sh)',
]
for p in patterns:
    m = re.search(p, readme)
    if m:
        print(m.group(0).strip())
        break
" 2>/dev/null || echo "")

# Detect compatibility from README
COMPAT_JSON=$(echo "$README_DATA" | python3 -c "
import sys, re, json
readme = sys.stdin.read()
known_platforms = ['VS Code','Cursor','JetBrains','Neovim','Vim','Emacs','Web','iOS','Android','Discord','Slack','API','CLI','Docker','Chrome','Firefox','Safari']
found = []
for p in known_platforms:
    if p.lower() in readme.lower():
        found.append(p)
print(json.dumps(found[:4]))
" 2>/dev/null || echo "[]")

# === 4. Auto-detect category ===
if [ -z "$CATEGORY" ]; then
  CATEGORY=$(echo "$DATA" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    topics = [t.lower() for t in data.get('topics', [])]
    lang = (data.get('language') or '').lower()

    coding_keywords = {'coding','code','programming','developer','cli','ide','terminal','language','sdk'}
    image_keywords = {'image','vision','design','creative','generation'}
    search_keywords = {'search','research','knowledge'}
    automation_keywords = {'automation','workflow','integrate','no-code','low-code'}

    if any(k in topics for k in coding_keywords) or lang:
        print('coding')
    elif any(k in topics for k in image_keywords):
        print('image')
    elif any(k in topics for k in search_keywords):
        print('search')
    elif any(k in topics for k in automation_keywords):
        print('automation')
    else:
        print('general')
except:
    print('general')
" 2>/dev/null || echo "general")
fi

# Validate category
VALID_CATEGORIES=("general" "coding" "image" "search" "automation")
VALID=0
for c in "${VALID_CATEGORIES[@]}"; do
  [ "$c" = "$CATEGORY" ] && VALID=1 && break
done
if [ "$VALID" -eq 0 ]; then
  echo "✗ Invalid category: $CATEGORY"
  echo "  Valid: ${VALID_CATEGORIES[*]}"
  exit 1
fi

# === 5. Create slug and file ===
SLUG=$(echo "$REPO" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')
mkdir -p "$CONTENT_DIR/$CATEGORY"
FILE="$CONTENT_DIR/$CATEGORY/$SLUG.md"
FILE_ZH="$CONTENT_DIR/$CATEGORY/$SLUG.zh.md"

# Check for duplicate
if [ -f "$FILE" ]; then
  echo "✗ Skill already exists at $FILE"
  exit 1
fi

# === 6. Detect tags from repo topics ===
TAGS=$(echo "$DATA" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    topics = data.get('topics', [])
    lang = data.get('language', '')
    if lang: topics.insert(0, lang)
    print('\\n'.join(topics[:5]))
except: print('general')
" 2>/dev/null || echo "general")

# Format tags as yaml list
TAGS_YAML=""
while IFS= read -r tag; do
  [ -n "$tag" ] && TAGS_YAML="$TAGS_YAML  - $tag"$'\n'
done <<< "$TAGS"

# Format compatibility as yaml list
COMPAT_YAML=""
if [ "$COMPAT_JSON" != "[]" ]; then
  COMPAT=$(echo "$COMPAT_JSON" | python3 -c "import sys,json; [print(c) for c in json.load(sys.stdin)]" 2>/dev/null)
  while IFS= read -r c; do
    [ -n "$c" ] && COMPAT_YAML="$COMPAT_YAML  - $c"$'\n'
  done <<< "$COMPAT"
fi
[ -z "$COMPAT_YAML" ] && COMPAT_YAML="  - Web"$'\n'

# === 7. Generate title from repo name ===
TITLE=$(echo "$REPO" | sed 's/-/ /g; s/^./\u&/; s/ \([a-z]\)/\u\1/g')

# === 8. Write EN file ===
cat > "$FILE" << SKILLEOF
---
title: "$TITLE"
date: $TODAY
draft: false
tags:
$TAGS_YAML
description: "${DESCRIPTION:-$TITLE — a skill from $OWNER/$REPO}"
version: "$VERSION"
author: "$OWNER"
repo_url: "https://github.com/$OWNER/$REPO"
install_cmd: "$INSTALL_CMD"
compatibility:
$COMPAT_YAML
category: "$CATEGORY"
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

<!-- Write your article body here -->

${DESCRIPTION:+$DESCRIPTION

}
## Key Features

<!-- List key features here -->

## Usage

<!-- Describe how to use this skill -->

$([ -n "$INSTALL_CMD" ] && echo "\`\`\`bash
$INSTALL_CMD
\`\`\`")

## Configuration

<!-- Configuration details -->

## Notes

<!-- Additional notes -->
SKILLEOF

# === 9. Write ZH file ===
cat > "$FILE_ZH" << SKILLEOF
---
title: "$TITLE"
date: $TODAY
draft: false
tags:
$TAGS_YAML
description: "${DESCRIPTION:-$TITLE — $OWNER/$REPO 的技能}"
version: "$VERSION"
author: "$OWNER"
repo_url: "https://github.com/$OWNER/$REPO"
install_cmd: "$INSTALL_CMD"
compatibility:
$COMPAT_YAML
category: "$CATEGORY"
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

## 概述

<!-- 在此撰写文章正文 -->

${DESCRIPTION:+$DESCRIPTION

}
## 核心特性

<!-- 列出核心功能 -->

## 使用方法

<!-- 描述使用方法 -->

$([ -n "$INSTALL_CMD" ] && echo "\`\`\`bash
$INSTALL_CMD
\`\`\`")

## 配置

<!-- 配置详情 -->

## 备注

<!-- 额外备注 -->
SKILLEOF

echo "✓ Created: $FILE (category: $CATEGORY)"
echo "  ⭐ $STARS ⑂ $FORKS | version: $VERSION"
echo "  ℹ  Article body needs manual writing — front matter is auto-filled."
