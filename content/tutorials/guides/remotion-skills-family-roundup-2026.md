---
title: "Remotion's 13 Agent Skills: Two Trees and One Version Pin"
date: 2026-11-05
toc: true
draft: false
tags:
  - Remotion
  - Agent Skills
  - Video
category: "guides"
description: "All 13 Remotion skills pin 4.0.541, the exact npm latest. The repo ships each file twice, and only 8 of the 13 ever reach the install board."
---

Thirteen skills, one version string, and two copies of every file — that is what [remotion-dev/skills](https://github.com/remotion-dev/skills) looks like when you walk the tree instead of the leaderboard. Every SKILL.md carries the same `version: 4.0.541`, and `npm view remotion version` returned 4.0.541 today. The skills ship in lockstep with the framework release, not on their own clock.

I read all 13 SKILL.md files on 2026-11-05, tokenised the set with `cl100k_base`, diffed the bundled copies against the standalone ones, and ran the search call that one of the skills hands you. The repo was pushed the same morning and sits at 6,405 stars. None of the numbers below come from the leaderboard.

## Two Trees, One Source of Truth

Look at `skills/` and you see 13 sibling folders. Look inside `skills/remotion-best-practices/` and the same 13 names appear again as subdirectories holding `REFERENCE.md` instead of `SKILL.md`.

That is not a build artifact. It is the design: `remotion-best-practices` is a router whose body is a list of conditional loads — build a video, load `./remotion-create/REFERENCE.md`; write markup, load `./remotion-markup/REFERENCE.md`; captions, maps, multimedia, interactivity, SaaS, docs, license, upgrade, one line each. The router works because those files sit next to it.

The standalone copies differ in exactly one way. Diff `skills/remotion-create/SKILL.md` against `skills/remotion-best-practices/remotion-create/REFERENCE.md` and every cross-skill mention becomes a markdown link. Standalone reads "see Remotion Best Practices". Bundled reads `[Remotion Best Practices](../SKILL.md)`. Same for `[Remotion Studio](../remotion-studio/REFERENCE.md)` and `[Compositions and stills](../remotion-markup/compositions.md)`. The bundled file is 2,973 bytes against 2,711 — 262 bytes of link syntax. Markup: 13,560 vs 13,345, a 215-byte gap.

One exception breaks the pattern. `remotion-maps` is byte-identical in both trees, same MD5 `e330fa7b722542fc60bef5d718ffa767`, 1,030 bytes each, because it contains no cross-skill mentions to link.

## The Instruction Budget Is Two Files

Ten thousand tokens covers all 13 bodies. Two of them carry 60% of that.

| Skill | Bytes | Tokens | On the board |
| --- | --- | --- | --- |
| remotion-markup | 13,345 | 3,179 | yes |
| remotion-interactivity | 13,703 | 2,948 | yes |
| remotion-best-practices | 4,356 | 1,006 | yes |
| remotion-create | 2,711 | 577 | yes |
| remotion-upgrade | 1,947 | 447 | no |
| remotion-docs | 1,340 | 351 | yes |
| remotion-studio | 1,611 | 331 | no |
| remotion-captions | 1,137 | 282 | yes |
| remotion-maps | 1,030 | 274 | no |
| remotion-render | 1,077 | 259 | yes |
| remotion-saas | 1,053 | 250 | yes |
| remotion-multimedia | 705 | 167 | no |
| remotion-license | 484 | 119 | no |
| **Total** | **44,499** | **10,190** | 8 of 13 |

Six bodies come in under 350 tokens. That is not thinness — it is delegation. `remotion-markup` alone ships 34 companion documents totalling 123,378 bytes, roughly ten times its own body: `effects.md` at 10,900 bytes, `transitions.md` at 8,747, `color-correction.md` at 7,476, `embedding-videos.md`, `audio-visualization.md`, `light-leaks.md`, `arabic-text.md`, down to `measuring-dom-nodes.md` at 995 bytes. Reading the SKILL.md gets an agent the index and the rules; the substance sits one hop away.

## Five Skills the Board Never Counts

Eight of the 13 appear on the [skills.sh](https://www.skills.sh/) homepage, scraped from its sparkline labels on 2026-11-05 across 185 rows. The other five — `remotion-license`, `remotion-maps`, `remotion-multimedia`, `remotion-studio`, `remotion-upgrade` — are nowhere on it, though all five are installable and all five are named in the update command inside `remotion-upgrade`:

```
npx skills update remotion-best-practices remotion-captions remotion-create
remotion-docs remotion-interactivity remotion-license remotion-maps
remotion-markup remotion-multimedia remotion-render remotion-saas
remotion-studio remotion-upgrade --yes
```

That one line is the only complete inventory the family publishes, so treat it as the source of truth when auditing what is installed.

For contrast with the counted eight, the flagship holds its own level and the seven sub-skills climb in lockstep:

| Skill | Rank | Installs | Weekly buckets |
| --- | --- | --- | --- |
| remotion-best-practices | 44 | 754.1K | 10,200 → 10,401 → 14,791 → 24,380 → 32,122 → 37,218 → 42,697 → 45,239 |
| remotion-render | 172 | 279.1K | 8,361 → 8,924 → 12,893 → 21,591 → 24,972 → 26,306 → 38,006 → 41,268 |
| remotion-create | 173 | 277.4K | 8,258 → 8,861 → 12,774 → 21,423 → 24,768 → 26,103 → 37,764 → 40,905 |
| remotion-captions | 174 | 275.5K | 8,153 → 8,784 → 12,711 → 21,316 → 24,736 → 26,162 → 37,881 → 41,122 |
| remotion-markup | 178 | 270.7K | 7,858 → 8,599 → 12,492 → 21,088 → 24,609 → 25,906 → 37,490 → 40,672 |
| remotion-interactivity | 182 | 264.8K | 7,628 → 8,407 → 12,164 → 20,600 → 24,015 → 25,271 → 36,790 → 39,963 |
| remotion-docs | 184 | 262.7K | 7,773 → 8,544 → 12,468 → 20,920 → 24,340 → 25,603 → 37,190 → 40,314 |
| remotion-saas | 185 | 262.5K | 7,472 → 8,313 → 12,161 → 20,460 → 23,892 → 25,126 → 36,667 → 39,870 |

Seven sub-skills grew about fivefold in eight weeks and stayed inside a 1,300-install band the whole way. The router grew 4.4x and sits 1,800 to 4,000 installs above them in every bucket, while the lifetime totals differ by 475,000. Same weekly volume, completely different history — the sub-skills are newer arrivals on the same release cadence.

## A Live Search Key and a Render Ban

`remotion-docs` does not guess at API surfaces. It hands you an Algolia endpoint with the key inline:

```
POST https://plsduol1ca-dsn.algolia.net/1/indexes/*/queries
x-algolia-api-key: 3e42dbd4f895fe93ff5cf40d860c4a85
x-algolia-application-id: PLSDUOL1CA
```

I ran the call exactly as written with the query `useVideoConfig` and got hits back, top result `https://www.remotion.dev/docs/use-video-config`. The key is live, read-only DocSearch credentials, and it saves a round trip through a search engine. The skill also documents the `.md` suffix trick on any docs URL, which is how the reference pages get fetched without burning tokens on site chrome.

Two policies are worth adopting even if you never install a Remotion skill. First, preview before building: start Studio as soon as the project can run, keep it open, and do not render unless the user says render. The router repeats that instruction twice with different wording, and `remotion-render` opens by picking the bundled browser and telling you not to point the renderer at a recording browser or override `--browser-executable` without being asked. Second, preserve user changes: if the code moved while the conversation was elsewhere, assume intent and ask, do not overwrite. That block is duplicated word for word in `remotion-best-practices` and `remotion-markup`, which is a small waste in a 10,190-token set and a clear statement of priority in a tool that writes files.

If your video work sits in the HyperFrames stack instead, the [HyperFrames CLI walkthrough](/tutorials/guides/hyperframes-cli-faq/) covers the same preview-then-render discipline with a different catalog model, and [the Remotion best-practices page](/skills/coding/remotion-best-practices/) takes the router apart section by section. For an agent working alongside you, install `remotion-best-practices` first and let it pull the sub-skills — the bundled tree is already there, and the standalone copies only buy you the link-free wording.
