#!/usr/bin/env python3
"""Filter skills-catalog.json: remove entries already in content/skills/,
deduplicate by repo, and sort by category."""
import json, os, glob

catalog = json.load(open("scripts/data/skills-catalog.json"))

existing = set()
for f in glob.glob("content/skills/**/*.md"):
    slug = os.path.basename(f).replace(".zh.md", "").replace(".md", "")
    existing.add(slug)

seen = {}
for item in catalog:
    slug = item["slug"]
    if slug in existing:
        continue
    key = item["source"]
    if key not in seen or slug < seen[key]["slug"]:
        seen[key] = item

filtered = sorted(seen.values(), key=lambda x: (x.get("category",""), x["source"]))

with open("scripts/data/skills-catalog.json", "w") as f:
    json.dump(filtered, f, indent=2)

print(f"Before: {len(catalog)}")
print(f"Existing pages: {len(existing)}")
print(f"After (unique pending): {len(filtered)}")
