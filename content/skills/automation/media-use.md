---
title: "media-use: The Agent Media OS for HyperFrames (535K Installs)"
date: 2026-09-24
draft: false
tags:
  - Video
  - HeyGen
  - Media Assets
category: "automation"
description: "HeyGen's media-use skill resolves music, SFX, images, voices and color grades for HyperFrames with one command, free OAuth path, 535K installs, rank 79."
---

You do not search for a music track, dig out a logo, then hand-tune a color grade. With [media-use](https://github.com/heygen-com/hyperframes/tree/main/skills/media-use) you run one command and the asset lands as a frozen local file with a ledger entry. It is the HyperFrames skill that owns every media need in a video project — background music, sound effects, images, icons, logos, voiceovers, color grades, LUTs — and on 2026-09-24 its skills.sh counter read **535.5K installs, rank 79 of 600**, with weekly installs at [40,022, 33,673, 36,304, 30,738, 31,683, 31,601, 47,488, 81,708] — the last two weeks nearly doubled, riding the same wave as the rest of the pack. I read the full SKILL.md plus its setup and memory references to map how it behaves.

## One Verb, Eight Asset Types

The skill's whole interface is a single verb — `resolve` — with a type flag and a plain-language intent:

```bash
npx hyperframes media-use resolve --type <type> --intent "<description>" --project <dir>
```

The command returns exactly one line: `resolved <id> → <path> (<type>, <metadata>)`. Every search hit it ever considered stays on disk, out of your context window.

| Type | What you get | Source |
|:-----|:-------------|:-------|
| `bgm` | Background music | HeyGen catalog, 10k+ tracks |
| `sfx` | Sound effects | Bundled 19-file library + catalog |
| `image` | Photos, backgrounds | HeyGen asset search, 75k+ vectors |
| `icon` | Transparent icons, symbols | HeyGen asset search |
| `logo` | Official brand marks | theSVG → GitHub avatar → favicon, never redrawn |
| `voice` | TTS voiceover | HeyGen free path, optional local Kokoro |
| `grade` | Measured correction candidate | Local analysis, not a replacement LUT |
| `lut` | Reusable validated `.cube` file | User-provided or explicitly chosen |

Before resolving anything fresh, `--candidates` lists reusable matches and the skill wants you to judge fit yourself — reuse is the default, generation the fallback.

## The Free Path Is an OAuth Session, Not an API Key

Setup surprises most people: the free allowance rides on OAuth, not on a key. You install the HeyGen CLI (v0.3.0+), run `heygen auth login --oauth`, and catalog search, TTS, and avatar video ride the free subscription credits. Feed it `--api-key` instead and every call bills API credits. `npx hyperframes media-use resolve --doctor` verifies the whole chain — one run after first install, then it nudges older CLIs to update.

The skill holds no keys of its own. Each provider owns its auth, and local tools are opt-in alternatives: mflux for images, Kokoro for voice, Parakeet for transcription, LTX for on-device video. `resolve` spec-checks your available RAM against a model ladder before choosing a local model, and `--provider <name>` pins a specific generator when you want one. `--local-only` skips every network provider, the free HeyGen ones included. The cost rule is explicit: an agent-initiated paid call confirms first, a user-requested one just runs — and `--type video` is flagged paid because the free allowance is metered.

## The Opportunity Pass Runs Once, Then Asks Once

The sharpest mechanic in the file is the media opportunity pass. The skill scans a composition exactly once and offers exactly one consolidated suggestion — grounded, not naggy:

| Signal it detects | What it proposes |
|:------------------|:-----------------|
| Script or on-screen text with no voiceover | TTS voiceover |
| Emoji or icon-styled divs | Real resolved icons |
| Placeholder, tiny, or upscaled-looking images | A better image or an upscale |
| Hard cuts with no sound | Transition SFX |
| A piece over ~10s with no music bed | Background music |
| Footage under/over-exposed or color-cast | A corrective grade, inspected with `--analyze` first |
| Flat or off-topic photographic media | One specific source-appropriate treatment |
| A static media entrance or reveal | One seek-safe treatment animation |

Four rules keep it a help and not a nag: no signal means no suggestion, propose the concrete fix with defaults chosen, ask once per project and respect "leave it", and surface — never silently mutate. The color-grade line says it plainly: a gray-world "correction" ruins an intentional sunset or neon look.

## What the Skill Refuses to Do

The file is as much about refusals as actions. Do not generate a `.cube` LUT just to encode exposure, shadows, contrast, or warmth — a LUT needs a real source or a treatment that owns one. Do not recreate supported vignette, grain, blur, pixelate, or color effects with CSS or SVG overlays; that bypasses Studio controls and the canonical render shader path. Do not read individual frames one by one — inspect one labeled early/middle/late contact sheet, apply one candidate, inspect one after-sheet, and only escalate to single frames when the result is ambiguous, temporal, stylized, LUT-based, private, or brand-critical.

Memory compounds across projects. Confirmed brief answers land in `.media/preferences.json` — project-tier committed to the repo, personal-tier promoted to `~/.media/` only after the same choice survives two different projects. Approved runs freeze as named, versioned recipes: re-freezing a name bumps the version and archives the old bundle as `<name>@v<N>`, so the next project starts from an approved bundle instead of a blank brief.

## Where It Sits in the HyperFrames Family

Real talk from walking the repo: media-use is a heavyweight in a pack that counts as one unit. The whole hyperframes family jumped together on this week's scrape — hyperframes-cli 661.2K (rank 43), hyperframes 630.9K, hyperframes-registry 571.6K, media-use 535.5K (rank 79), hyperframes-core 535.1K — several of them roughly doubling weekly installs in the same window, the pack-level counter signature we first documented in the [hyperframes domain skills roundup](/tutorials/guides/hyperframes-domain-skills-roundup-2026/). Media-use is the media-resolution layer for video projects built on the framework the [hyperframes-vs-remotion comparison](/tutorials/comparison/hyperframes-vs-remotion/) evaluates against Remotion.

If you build video with HyperFrames, install it with `npx skills add https://github.com/heygen-com/hyperframes --skill media-use`, run `--doctor` once, and let the first `resolve` prove the OAuth path before you touch any flags. The one-verb design turns a dozen asset chores into a pipeline you can audit from a single line.