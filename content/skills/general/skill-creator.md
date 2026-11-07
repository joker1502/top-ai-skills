---
title: "skill-creator: Anthropic's Own Validator Rejects One of Its Own Skills"
date: 2026-11-07
toc: true
draft: false
tags:
  - Agent Skills
  - Skill Authoring
  - Anthropic
description: "skill-creator enforces a 1024-char description cap and drops evals/ from packages. Run over Anthropic's own 19 skills, it rejects claude-api at 1,068."
version: "1.0.0"
author: "Anthropic"
repo_url: "https://github.com/anthropics/skills"
install_cmd: "npx skills add anthropics/skills"
compatibility:
  - Claude Code
  - Claude.ai
  - Cowork
category: "general"
rating: 4.2
github_stars: 188527
github_forks: 22100
installs: 426400
last_updated: "2026-11-07"
ai_friendliness:
  score: 4.2
  documentation: 4.5
  setup: 4.0
  config: 4.0
---

skill-creator is the skill Anthropic uses to build and grade other skills: a writer, a validator, a packaging script, and a description optimizer in one folder. I cloned `anthropics/skills` on 2026-11-07 and ran its tooling against its own 19 skills. Eighteen passed. `claude-api` failed, on a limit the skill file itself sets.

That result is the useful part of this page. "Helps you create skills" tells you nothing about whether the tooling holds up.

An older version of this page described a `init_skill.py` scaffolding step and a "6-step: understand, plan, initialize, edit, package, iterate" workflow. Neither exists in the repo anymore. The folder now ships a different machine, and it is worth reading on its own terms.

## What actually ships in the folder

Nineteen files, 224,992 bytes. One SKILL.md at 33,168 bytes — 485 lines, 7,322 tokens under cl100k. Three subagent contracts (`agents/analyzer.md`, `comparator.md`, `grader.md`), a schema reference for eval data, eight Python scripts, and an HTML review viewer.

Loading cost splits the way the skill's own progressive-disclosure section predicts. The description you pay for on every turn is one paragraph. The body costs 7.3K tokens when the skill fires. Reference docs (16,732 tokens) and scripts (16,759 tokens) sit on disk until something reads or runs them. A 225 KB folder that looks expensive costs 7.3K tokens to use and one line to advertise.

The line budget has 15 lines of slack. SKILL.md tells authors to keep files under 500 lines and stops at 485. I checked, because a rule nobody follows is worth nothing.

## The validator is stricter than the skills it validates

`scripts/quick_validate.py` enforces a small, specific contract:

| Check | Rule | Failure message |
|:--|:--|:--|
| Frontmatter keys | Only `name`, `description`, `license`, `allowed-tools`, `metadata`, `compatibility` | `Unexpected key(s) in SKILL.md frontmatter` |
| Name | kebab-case, no leading, trailing or doubled hyphens, ≤ 64 chars | `Name 'X' should be kebab-case` |
| Description | ≤ 1,024 chars, no `<` or `>` | `Description is too long (1068 characters)` |
| Compatibility | ≤ 500 chars, string | `Compatibility is too long` |

I ran it across every skill in the repo. `skills/claude-api` returns exactly that middle failure: 1,068 characters against a 1,024 cap. Every other skill passes.

Two things follow. The allowed-key list is the real spec — a `version:` or `model:` key in your frontmatter gets rejected outright, which is why packaged skills from other authors so often bury those fields under `metadata:`. And 44 characters of overrun is not a moral failing. It is what happens when a description is written by hand and never machine-checked, inside the repo that wrote the checker.

Second-order annoyance: `quick_validate.py` imports `yaml`, so a bare Python 3.14 with no packages dies at `ModuleNotFoundError: No module named 'yaml'` before reading a single file. I ran it through `uv run --with pyyaml`. Not a bug — an unstated dependency that eats ten minutes if you hit it cold.

## Packaging: what gets dropped, and how to call it

`scripts/package_skill.py` zips a skill into a `.skill` archive and refuses to build if validation fails. I built a throwaway skill with an `evals/` folder, a `.DS_Store`, a `__pycache__` directory holding a `.pyc`, plus `references/`, `assets/` and `scripts/`:

```
Skipped: my-thing/.DS_Store
Skipped: my-thing/evals/evals.json
Skipped: my-thing/scripts/__pycache__/x.pyc
Added:   my-thing/SKILL.md
```

Test cases do not ship. Neither do build artifacts. The zip's top-level entry is `my-thing/`, not a bare `SKILL.md`, so the archive carries its own folder. Root-only exclusion, too: a nested `references/evals/` folder would survive, because `ROOT_EXCLUDE_DIRS` only checks the first path segment.

One trap worth writing down. Calling the file directly fails:

```
$ python3 scripts/package_skill.py my-thing
ModuleNotFoundError: No module named 'scripts'
```

It has to run as a module from the skill-creator directory — `python3 -m scripts.package_skill <path>` — because it imports `scripts.quick_validate`. The script's docstring still says `python utils/package_skill.py`, a path that no longer exists. Follow SKILL.md, not the help text.

## The description optimizer measures instead of rewriting

Most "optimize your description" features ask a model for a better sentence. This one scores.

`scripts/run_loop.py` takes a JSON file of 20 queries tagged `should_trigger` true or false, splits it stratified by tag at a 0.4 holdout with `seed = 42`, and runs the current description three times per query at a 0.5 trigger threshold. Ten parallel workers, 30 seconds per query. The failures — "should have triggered but didn't", "triggered but shouldn't have" — go to a model, which proposes a new description. Both halves get rescored. Five iterations by default.

Selection happens on the held-out half: `best = max(history, key=lambda h: h["test_passed"])`. That single line is the reason to care. Candidates win on the 40% they never saw, so a description that memorizes the training queries loses on purpose.

The fixed seed is a tradeoff nobody documents. Same 20 queries in, same split out, every run — reproducible for you, identical for everyone who leaves the default alone. Fine for a personal skill. Less fine if you publish trigger benchmarks.

Two constraints on the eval set, both stated in SKILL.md, both easy to skip. Queries must be realistic — file paths, half-typed filenames, a boss's request — because "Format this data" tests nothing. And Claude only consults a skill for work it cannot trivially do alone, so a one-step query like "read this file" will not trigger any description, however good. Negative cases have to be near-misses, not obviously irrelevant ones.

`scripts/improve_description.py` adds a belt-and-braces call: if the new description still blows past 1,024 characters, it asks a second time for a shorter version instead of writing an invalid file. Which is, once more, the check that `claude-api` does not pass.

## Where it stops being useful

The skill is honest about scope. It covers authoring, grading, packaging and triggering. It does not cover eval infrastructure — the grader and comparator are prompt files you or a subagent run, not a test runner. Blind comparison needs subagents, and SKILL.md says most people won't need it.

For the narrower question of phrasing instructions so an agent follows them, [the 15 standalone Superpowers skills](/tutorials/guides/superpowers-standalone-skills-roundup-2026/) spends far more words on instruction design. Different job: that one writes rules, this one ships the loop that proves the rules work.

Install with `npx skills add anthropics/skills` and read SKILL.md before anything else. 7.3K tokens is cheap, and the sections most people skip — the description optimizer, the 500-line budget — are the ones that change outcomes. If you want to see the validation loop from the other direction — a skill whose validator I ran against a local stub to find where its checks stop biting — [the caveman-compress guardrail test](/tutorials/guides/caveman-compress-guardrails-tested/) does exactly that.
