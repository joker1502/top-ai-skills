---
title: "general-video: HyperFrames' Catch-All Video Builder (594K)"
date: 2026-10-15
draft: false
tags:
  - HyperFrames
  - AI Video
  - HeyGen
category: "image"
description: "HyperFrames' general-video skill routes by project state, then fans out scene packets only past six scenes: 9 min inline vs 21 min dispatched. 594K installs."
---

`general-video` is the HyperFrames skill you land on when a video brief matches no shipped workflow — and its most valuable content is the arithmetic about when *not* to parallelize. I read the whole SKILL.md (21,964 bytes, inside [heygen-com/hyperframes](https://github.com/heygen-com/hyperframes), 64,315 stars, last push 2026-10-15) and scraped the skills.sh detail page the same day: **594.1K installs**, weekly [18,371, 16,183, 15,346, 28,322, 57,814, 41,804, 61,758, 97,530]. The pack around it is riding that curve together — sibling [media-use](/skills/automation/media-use/) reads 912.1K, hyperframes-core 823.4K. What the skill actually delivers is a router that refuses to guess your intent, plus a dispatch rule that only pays for itself at scale.

## It Routes on Project State, and Only the First Matching Row Counts

Four states, evaluated top-down, and the instruction is explicit: stop at the first match, never keep reading lower rows.

| State | What the skill does |
|:------|:--------------------|
| A specific edit | Make the edit, preserve prior project decisions, rerun affected checks. Discovery stays closed. |
| `BRIEF.md` exists | Read it. If `workflow` names another workflow and `flow` isn't `companion`, hand off. Ask no brief questions. |
| No brief, but `hyperframes.json` or `STORYBOARD.md` exists | Resume from the files and recorded preferences. Backfill the brief only from known facts. |
| Fresh creation | Run `/hyperframes` first. Return here only for `workflow: general-video` or `flow: companion`. |

The brief vocabulary is deliberately tiny: `flow` (automation vs companion), `storyboard` (yes/no), and a derived `mode` the skill tells you never to ask the user to name. It also bans inventing synonyms for those states — an ongoing "just build it" arrives as `flow: automation`, `storyboard: no`, not as a phrase the model gets to reinterpret. Before any of that, `npx hyperframes usage --json` runs at the start and again at milestones; if usage is unknown, the skill wants the agent to say so rather than quote a guessed allowance.

Scaffolding is one command, and the state lives on disk rather than in the conversation:

```bash
npx hyperframes init "videos/<project>" --non-interactive --example=blank --skill=general-video
```

## Dispatch Pays for Itself Only Past Six Scenes — They Measured It

Most "use sub-agents for speed" advice comes with no number attached. This file ships one: a film of up to ~6 short scenes builds **faster inline, in the same context** — measured at 5 short scenes ≈ 9 minutes inline versus ≈ 21 minutes when packetized. Fan out only when the plan exceeds that, and then the shape matters more than the trigger: 2–3 scenes per worker rather than one, and all workers spawned in a **single wave**, because a second wave nearly doubles the window.

The mechanics behind it are worth knowing even if you never dispatch anything:

- `node <SKILL_DIR>/scripts/frame-packets.mjs` writes one bounded packet per scene under `.hyperframes/frame-packets/` — the scene's storyboard block, the blueprint body, and every cited rule recipe, inlined — plus a `_role.md` that concatenates the worker role verbatim.
- Each worker reads only its own packets and the design truth file. It never opens `STORYBOARD.md` or the skill documents.
- The builder then waits on each scene's configured `src` plus an adjacent `<frame_id>.motion.json` sidecar, and step 5 merges those sidecars into assembly.
- No delegation channel available? Fall back to serial, one packet at a time, still working from the packet alone.

The interview-ready detail: each scene needs a `## Frame N` block in `STORYBOARD.md` with `status: outline`, a declared `src:`, and its blueprint or rules citation — **even when `storyboard: no`**. The block is the dispatch unit; the storyboard sheet is only the review surface.

## Hard Cuts Are Clip Copies, and Catalog Search Needs Nothing Installed

Two habits separate a working composition from a guess.

For any trim, splice, or reorder of existing footage, the skill duplicates the same video source into multiple clip elements. Each copy gets its source range via `data-media-start` plus `data-duration`, and its authored placement via `data-start`. The audio stays on the clip (`data-has-audio="true"`), so cutting the video cuts its sound — no separate audio surgery. Keyframes are reserved for visual-property animation only: zoom, punch, pan, crop, mask, `clip-path` on an inner wrapper.

For anything the brief names as a look — "CRT scanlines", "film grain", "shimmer sweep" — the plan must first run a registry search:

```bash
npx hyperframes catalog --query "the look, in plain English" --json
```

That search needs **nothing installed**: no project, no prior `add`, no account. It ranks roughly 400 hosted blocks and components from any directory, so it also applies mid-build when the user asks for a look you hadn't planned. Hand-author a look only after a search for it came back empty.

Then the gates, in order: `npx hyperframes lint` for fast feedback after the first HTML pass, and `npx hyperframes check` as the final gate — which reruns lint internally, so a redundant standalone lint right before it is waste. Music under a voice track gets carved (`/hyperframes-audio` → `scripts/carve.mjs --comp index.html`); a volume duck does not finish the mix. And the render waits for approval of the final Studio preview, in autonomous mode included — opening the preview asks nothing, and it's the one question the autonomous path keeps.

## Where general-video Sits in the HyperFrames Lanes

The skill is explicit that it does not own the pieces it depends on. Read this as a routing table, not a feature list:

| Need | Owner |
|:-----|:------|
| Short unnarrated motion-first unit, including an animated title | `motion-graphics` |
| Fresh creation of any kind | `/hyperframes` and its intent layer first |
| Composition HTML, layout, temporal edits, determinism | `/hyperframes-core` |
| Story spine, house style, visual styles, design picker | `/hyperframes-creative` |
| Motion, animation, scene transitions | `/hyperframes-animation` |
| Audio, image, voice, grade, LUT, captions | [media-use](/skills/automation/media-use/) |
| Named look, block, or transition | `npx hyperframes catalog` search before hand-authoring |

Design identity resolves in a fixed order too — `frame.md` → `design.md` → `DESIGN.md`, first file found is brand truth. With no design spec at all, four things get settled before any composition HTML: identity grounded in the house style, one sentence naming the concept angle, an embeddable font pairing (an unbundled display font may simply not exist in cloud rendering), and a defined focal element, edge anchors, supporting detail, plus background treatment.

**In short:** `general-video` is a state machine with a measured cost model attached. The routing table kills intent guessing, the packet math stops you from burning a second wave of workers on a five-scene film, the catalog search replaces half-remembered look recipes, and `check` (not `lint`) is what actually closes a build.

Next step: run `npx hyperframes skills update general-video` — a successful no-op means you're current, and the skill wants an update failure surfaced rather than papered over from memory. If you're still choosing a framework for the video layer, the [HyperFrames vs Remotion comparison](/tutorials/comparison/hyperframes-vs-remotion/) lays out where each one stops being the right call.
