# Session Context — Top AI Skills

## Rules
- Code changes: local only, NEVER push without explicit "提交线上" approval
- Hermes: pushes articles to `main` directly (content/ only)
- My branch: `code-updates` for code changes → merge to `main` only when approved

## Credentials
- Cloudflare API token: stored in ~/.config/opencode/top-ai-skills.json
- GitHub: SSH key auth (joker1502)
- Hosting: GitHub Pages + Cloudflare CDN
- Domain: topaiskills.com (Cloudflare zone: ceed2c101d062a4a05e7b3d28d8d825d)
- Google Analytics: G-V27BZ7GENQ

## Quick Start
```bash
cd ~/top-ai-skills
git checkout code-updates   # for code changes
# ... make changes ...
git checkout main && git pull  # merge Hermes articles
git merge code-updates       # merge code
```

## Stack
- Hugo v0.162.1, theme: Terminal
- Node 18+ for CLI tool (cli/topaiskills/)
