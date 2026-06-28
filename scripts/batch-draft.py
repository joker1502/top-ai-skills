#!/usr/bin/env python3
"""Generate draft skill pages from skills-catalog.json for Hermes to fill in."""
import json, os, glob, re

catalog = json.load(open("scripts/data/skills-catalog.json"))

existing = set()
for f in glob.glob("content/skills/**/*.md"):
    slug = os.path.basename(f).replace(".zh.md", "").replace(".md", "")
    existing.add(slug)

today = "2026-06-28"
created = 0

for item in catalog:
    slug = item["slug"]
    if slug in existing:
        continue
    category = item.get("category", "general")
    tags = item.get("tags", [])
    owner = item.get("owner", "")
    repo = item.get("repo", slug)
    repo_url = f"https://github.com/{item['source']}"
    title = " ".join(w.capitalize() for w in slug.replace("-", " ").split())

    dir_path = f"content/skills/{category}"
    os.makedirs(dir_path, exist_ok=True)
    filepath = f"{dir_path}/{slug}.md"

    tags_yaml = "\n".join(f"  - {t}" for t in tags[:5])

    content = f"""---
title: "{title}"
date: {today}
draft: true
tags:
{tags_yaml}
description: ""
version: ""
author: "{owner}"
repo_url: "{repo_url}"
install_cmd: ""
compatibility:
  - Claude Code
category: "{category}"
rating: 0
github_stars: 0
github_forks: 0
installs: 0
last_updated: "{today}"
ai_friendliness:
  score: 0
  documentation: 0
  setup: 0
  config: 0
---

## Overview

<!-- Hermes: fill in description and usage here -->

"""
    with open(filepath, "w") as f:
        f.write(content)
    existing.add(slug)
    created += 1

print(f"Draft pages created: {created}")
