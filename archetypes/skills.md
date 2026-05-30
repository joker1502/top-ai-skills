---
title: "{{ replace .File.ContentBaseName "-" " " | title }}"
date: {{ .Date }}
draft: true
tags:
  - tag1
  - tag2
description: "Brief one-line description of what this skill does"
version: "1.0.0"
author: "Author Name"
repo_url: "https://github.com/author/repo"
install_cmd: "skills add author/repo"
compatibility:
  - Claude Code
  - Cursor
category: "coding"
rating: 4.0
github_stars: 0
github_forks: 0
installs: 0
last_updated: "{{ now.Format "2006-01-02" }}"
ai_friendliness:
  score: 4.0
  documentation: 4.0
  setup: 4.0
  config: 4.0
---

## Overview

Brief introduction to the skill — what problem it solves, who it's for.

## Key Features

- Feature 1
- Feature 2
- Feature 3

## Installation

```bash
{{ .Params.install_cmd }}
```

## Configuration

```yaml
# Configuration example
key: value
setting: true
```

## Usage

Step-by-step instructions for common use cases.

## Notes

Any caveats, prerequisites, or additional information.
