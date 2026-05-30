#!/usr/bin/env bash
# Fetch GitHub Stars & Forks for each skill and update Front Matter
# Usage: GITHUB_TOKEN=ghp_xxx ./scripts/fetch-github-stats.sh
# If GITHUB_TOKEN is not set, unauthenticated requests are used (lower rate limit)

set -euo pipefail

CONTENT_DIR="content/skills"
TMP_FILE=$(mktemp)

find "$CONTENT_DIR" -name '*.md' -not -name '_index*' -print0 | while IFS= read -r -d '' file; do

  repo_url=$(grep -oP 'repo_url:\s*["\x27]?\K[^"\x27\n]+' "$file" || true)
  [ -z "$repo_url" ] && continue

  # Extract owner/repo from GitHub URL
  if [[ "$repo_url" =~ github\.com/([^/]+)/([^/]+) ]]; then
    owner="${BASH_REMATCH[1]}"
    repo="${BASH_REMATCH[2]}"
    repo="${repo%.git}"
  else
    continue
  fi

  echo "→ Fetching $owner/$repo ..."

  api_url="https://api.github.com/repos/$owner/$repo"
  if [ -n "${GITHUB_TOKEN:-}" ]; then
    data=$(curl -sf -H "Authorization: Bearer $GITHUB_TOKEN" "$api_url" 2>/dev/null || echo "")
  else
    data=$(curl -sf "$api_url" 2>/dev/null || echo "")
  fi

  [ -z "$data" ] && echo "  ✗ Failed to fetch $owner/$repo" && continue

  stars=$(echo "$data" | python3 -c "import sys,json; print(json.load(sys.stdin).get('stargazers_count', 0))" 2>/dev/null || echo "0")
  forks=$(echo "$data" | python3 -c "import sys,json; print(json.load(sys.stdin).get('forks_count', 0))" 2>/dev/null || echo "0")
  updated=$(echo "$data" | python3 -c "import sys,json; print(json.load(sys.stdin).get('pushed_at', '')[:10])" 2>/dev/null || echo "")

  echo "  ⭐ $stars ⑂ $forks"

  # Update Front Matter using awk
  awk -v stars="$stars" -v forks="$forks" -v updated="$updated" '
    /^---$/ { count++; if (count == 1) { print; next } }
    count == 1 && /^github_stars:/ {
      if (stars != "0") print "github_stars: " stars;
      else print;
      next
    }
    count == 1 && /^github_forks:/ {
      if (forks != "0") print "github_forks: " forks;
      else print;
      next
    }
    count == 1 && /^last_updated:/ && updated != "" {
      print "last_updated: \"" updated "\"";
      next
    }
    { print }
  ' "$file" > "$TMP_FILE" && mv "$TMP_FILE" "$file"
done

echo "✓ Done"
