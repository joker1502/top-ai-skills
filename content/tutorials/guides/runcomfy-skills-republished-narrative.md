---
title: "The Same RunComfy Skills Ship From Two Orgs, and the New Copy Has More Installs"
date: 2026-11-13
toc: true
draft: false
tags:
  - Agent Skills
  - Skill Registry
  - Video Generation
category: "guides"
description: "34 markdown files, one md5, two GitHub orgs. I diffed the RunComfy skill packs and found the four-week-old copy carrying 540K installs per skill."
---

Five skills from `gencraft-labs/skills` sat on the leaderboard this morning at roughly 540K installs each, with weekly curves that start at three zeros and then jump to 73,745. Ten skills with the same names live under `prime-skills/runcomfy-agent-skills` at 376.5K to 448.0K, moving 3,000 to 3,800 installs a week. I cloned both repos to see whether the names were a coincidence.

They are not. The files are identical.

## Two commands settled it

```bash
git clone --depth 1 https://github.com/gencraft-labs/skills.git gencraft
git clone --depth 1 https://github.com/prime-skills/runcomfy-agent-skills.git runcomfy
diff -rq gencraft runcomfy
```

`diff -rq` printed nothing except `.git` internals and three directories that exist only in the newer repo: `seedance-2-5-image-to-video`, `seedance-2-5-reference-to-video`, `wan-3-0-prime-reference-to-video`. Markdown count came out 34 against 31. Everything else — all 31 shared skill files — matched byte for byte, and `md5sum` on `video-edit/SKILL.md` returned `a59a7afa985218d90556042ed14c8b0a` for both, 11,231 bytes on each side.

The new repo does not pretend otherwise. Its `README.md` opens with `# runcomfy-agent-skills`, and its install line still reads `npx skills add agentspace-so/runcomfy-agent-skills --skill <skill-name>`. Commit authorship points the same way: `kalvinrv <xiaoximew@gmail.com>` on 2026-10-06 for the new org, `Kalvin <kalvinrc9@gmail.com>` on 2026-05-15 for the original. Same first name, different address, five months apart. This is a re-publish under a second org, not a scraped fork.

## The counters reset, then outran five months of the original

Here is the part I did not expect. The registry never merged the two packs. Side by side, from this morning's leaderboard:

| Skill | New org total | Weekly buckets (last 3) | Original total | Weekly |
|:---|:---:|:---|:---:|:---:|
| ai-music | 541.2K | 104,607 / 105,207 / 98,440 | 377.1K | ~3,200 |
| video-edit | 540.5K | 103,998 / 105,503 / 98,480 | 448.0K | ~3,200 |
| ai-video-generation | 540.4K | 104,041 / 105,574 / 98,332 | 391.1K | ~3,100 |
| ai-image-generation | 540.0K | 103,789 / 105,316 / 98,373 | 391.3K | ~3,100 |

Four same-name pairs, and the gap runs from 92.5K to 163K in favour of the four-week-old org. Read the weekly columns again: the new pack pulls about 100K a week per skill, the original 3.1K to 3.8K. Nothing in the repository changed to cause that — the only differences are the org name and the three added skills. The original's remaining six skills (`wan-2-7` 444.5K, `kling-3-0` 421.3K, `codex-pet` 409.7K, `runcomfy-cli` 388.3K, `image-inpainting` 385.8K, `ace-step` 376.5K) sit in the same band.

The shape of the curve matters for anyone quoting install counts. The `gencraft-labs` pack shows `0, 0, 0, 73,745, 97,074, 104,607, 105,207, 98,440` — three empty buckets, then a first week at 73K. That is a counter that started four weeks ago, not a pack that grew. The original's buckets sit flat in the low thousands the whole way across.

## What you actually download

Each `SKILL.md` is a router into the RunComfy model catalog plus the prompting notes for each model it can call. The `video-edit` file carries `displayName: "Video Edit — Pro Pack on RunComfy"`, `homepage: https://www.runcomfy.com`, and `allowed-tools: Bash(runcomfy *)`; it picks between Wan 2.7 Edit-Video, Kling 2.6 Pro Motion Control and Lucy Edit Restyle, then runs `runcomfy run <vendor>/<model>/<endpoint>` through the local CLI. Install either org and your agent calls the same binary.

The three files that exist only in the newer repo are the only functional difference I found: `seedance-2-5-image-to-video` (12,139 bytes), `seedance-2-5-reference-to-video` (17,659 bytes) and `wan-3-0-prime-reference-to-video` (15,774 bytes). One of them is also formatted slightly differently — `seedance-2-5-image-to-video` is missing the `allowed-tools: Bash(runcomfy *)` line its two siblings carry, so an agent installing it may not get shell access scoped the same way.

## Which pack to install

If you want the RunComfy catalog and nothing else, either org gives you the same 31 files. The practical difference is coverage, and it runs opposite to the counters: the newer pack is the superset by three skills, and its install line still points at the old path, so `npx skills add agentspace-so/runcomfy-agent-skills` gets you the May snapshot without Seedance 2.5 or Wan 3.0.

Two checks worth running before you cite any install number from this family. Pull the repo and `diff` it against the sibling; a 540K figure on a file that matches another repo byte for byte measures the registry's counter, not adoption. Then look at where the weekly buckets start. Three zeros followed by a six-figure week is a fresh counter, and it will keep looking impressive until the floor drops out.

For the same registry-counter problem in a video framework family, the [dead-counter audit](/tutorials/comparison/dead-skill-counters-comparison/) covers skills that vanished from disk while their totals stayed on the board.
