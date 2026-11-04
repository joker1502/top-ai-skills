---
title: "Two Ways a Skill Counter Dies: Deletion vs Consolidation"
date: 2026-11-04
toc: true
draft: false
tags:
  - Skill Registry
  - Data Analysis
  - HyperFrames
category: "comparison"
description: "HyperFrames deleted 14 skills and taste-skill folded 13 into one file. Both counters kept ticking, and their floors differ by 30x — 335 weekly vs 12."
---

A skill's install counter keeps ticking after the file is gone. I watched two families prove it on the same day, and the floor each one lands on differs by a factor of thirty — 335 installs a week in one case, 12 in the other.

The scrape is mine: skills.sh homepage, 186 rows, weekly sparkline values read from the `aria-label` of each sparkline on 2026-11-04. The verification is GitHub's contents API plus raw file fetches, run against each repo the same afternoon. Two families had already been crawled before in [the HyperFrames domain-skills roundup](/tutorials/guides/hyperframes-domain-skills-roundup-2026/) and the [taste-skill presets comparison](/tutorials/comparison/taste-skill-presets-comparison/), which makes the before-and-after clean.

## HyperFrames Removed 14 Skills From the Folder

Fourteen heygen-com/hyperframes skills dropped into a narrow band overnight:

| Skill | Previous bucket | Last bucket |
| --- | --- | --- |
| hyperframes-animation | 64,260 | 335 |
| hyperframes-studio | 48,567 | 313 |
| hyperframes-creative | 58,088 | 332 |
| faceless-explainer | — | 332 |
| hyperframes-core | 55,617 | 330 |
| hyperframes-keyframes | — | 327 |
| general-video | — | 327 |
| hyperframes-audio | — | 325 |
| product-launch-video | — | 324 |
| motion-graphics | — | 324 |
| embedded-captions | — | 323 |
| pr-to-video | — | 321 |
| music-to-video | — | 321 |
| talking-head-recut | — | 321 |

That trailing column is not demand. It is the residue of listing pages, and the spread inside it — 313 to 335, a 22-install window across fourteen products that used to differ by hundreds of thousands of cumulative installs — gives the game away.

The repo explains it. `GET /repos/heygen-com/hyperframes/contents/skills` returns 10 entries: seven skill directories, one test file, and nothing else. The seven survivors all still sell: media-use at 125,622 weekly, hyperframes-cli at 125,767, hyperframes at 121,306, hyperframes-registry at 117,525, remotion-to-hyperframes at 44,877, slideshow at 41,602, figma at 40,421. Raw `SKILL.md` fetches for the seven dead names I tested — core, creative, animation, audio, general-video, product-launch-video, hyperframes-studio — returned 404 across the board.

Two names in that directory listing never appeared on today's board at all: `reverse-any-video` and `style-sampling`. Both return 200. They are new arrivals with zero counter, which means the pack shrank and grew in the same commit window.

## Taste-Skill Folded 13 Presets Into One File

The second death looks similar from the outside and is mechanically different. Thirteen leonxlnx/taste-skill presets fell to a floor of 12–32 weekly installs:

- redesign-existing-projects 32, image-to-code 29, brandkit 26, full-output-enforcement 25, high-end-visual-design 23
- minimalist-ui 19, gpt-taste 14, industrial-brutalist-ui 14, imagegen-frontend-mobile 14
- stitch-design-taste 13, imagegen-frontend-web 13, design-taste-frontend-v1 12

The fall is sharp and recent. High-end-visual-design ran `[16,884, 16,838, 19,325, 22,911, 21,875, 25,705, 3,141, 23]` — twenty-five thousand, then three thousand, then twenty-three. Minimalist-ui reads `[…, 25,362, 2,915, 19]`. Design-taste-frontend-v1 reads `[…, 22,679, 2,747, 12]`.

Nothing was deleted outright, though. `contents/skills` returns a single directory named `taste-skill`, and its SKILL.md opens with `name: design-taste-frontend` at 39,537 bytes. The presets were absorbed into the v2 flagship, which still reads 39,089 weekly installs at rank 42 — healthy, and now the only door into the repo.

So the same week produced two different endings: fourteen files deleted, thirteen skills merged into one. Both left their old counters running.

## Four Floors, and What Each One Tells You

Put the dead counters side by side and the floor becomes a signature:

| Family | Floor | Cause |
| --- | --- | --- |
| heygen-com/hyperframes | 313–335 | files deleted this week, listing pages still cached |
| leonxlnx/taste-skill | 12–32 | presets folded into one surviving skill |
| microsoft/azure-skills | 0 | rbac and hosted-copilot-sdk sat at zero for all eight buckets |
| mattpocock/skills | 2–46 | graduated or renamed; to-prd, to-issues, writing-great-skills |

Azure's zeroed entries had a full eight buckets of nothing — a long-dead removal. Mattpocock's residual 2 to 46 marks skills whose pages barely ever drew traffic before graduating. HyperFrames landed mid-flight, 335 from a 64,260 bucket, because the crawl that removed the file also cut the week in half.

Practically: never quote a weekly install number without a file check. Two commands settle it. `curl -s https://api.github.com/repos/<owner>/<repo>/contents/skills` tells you which directories still exist. A raw fetch of `<dir>/SKILL.md` returns 404 for anything gone. Do both before you write a headline number, and do them on the same day as the scrape.

One more habit worth keeping: when a counter collapses but the skill page still ranks high — hyperframes-animation sat at rank 19 while measuring 335 installs — treat the rank as stale and the number as residue. The ranking sorts on cumulative history, the sparkline sorts on the last eight crawls, and they stop agreeing the moment a repo changes shape.

If a family's counters have to be trusted, watch the directory listing over a month, not the leaderboard over a week.
