---
title: "hyperframes-studio: What Keeps a Timeline Editable (370K)"
date: 2026-10-16
draft: false
tags:
  - HyperFrames
  - AI Video
  - HeyGen
category: "image"
description: "hyperframes-studio keeps HyperFrames timelines editable: every scene its own sub-composition, one caption track, 90%/80% safe boxes. 370,619 installs."
---

`hyperframes-studio` decides whether a HyperFrames project opens as a short, readable timeline or as a wall of unlabeled rows you cannot trim part by part. It is the newest entry in the heygen-com/hyperframes pack and the fastest-rising one: **370,619 installs, rank 404** on the skills.sh board I scraped on 2026-10-16, weekly installs `[0, 0, 0, 0, 21,751, 57,106, 84,410, 115,369]` — five weeks listed, and every week bigger than the last. I read the entire SKILL.md (11,640 bytes, one file, no references folder) against the repo at 65,128 stars, pushed 2026-10-16.

## It Answers Before It Builds

Section 0 is a router, and it runs before any file opens. The skill sorts the message into seven buckets and acts on the match:

| The person says | The skill does |
|:---|:---|
| "make the title bigger" (names a change) | Makes it |
| "the intro feels jolty" (a felt note) | Finds the cause, changes the measurable thing, records it in STORYBOARD.md |
| "why does the title jump?" (question, no change) | Answers. Changes nothing |
| "don't change anything, just thinking" | Changes no file, not even a fix it noticed. Offers it in words |
| "I want the ending to feel bigger" (idea, no change) | Proposes the change, adds it to the plan, touches no composition file |
| "I have a new film for you" | Plans it (§5) |
| "build it" | Builds what was approved |

The reasoning behind the caution is stated flatly: *"a wrong answer costs one message; a wrong build costs a long run and a round of notes."* The one wrinkle worth knowing is where the plan lives. Not in chat — it goes into STORYBOARD.md, because the next message may start a new session that cannot see this one. If the person asked for nothing to change, the skill writes nothing at all and offers to save the plan.

## Nested Markup Disappears Into One Opaque Row

Studio draws one timeline row per *top-level* element. So the skill's first structural rule: every scene becomes its own file, loaded with `data-composition-src`. A title with a subtitle, a div with children, a chart — each one is a sub-composition. Leave that nested markup inside the root composition and it does not become a row of its own; it hides inside a single opaque row that cannot be trimmed or moved in pieces. The skill tells the agent to author "as if a structure lint rejects any violation."

Tracks follow the same logic. One element kind per track, declared with `data-track-kind`:

| Kind | Attribute |
|:---|:---|
| Base video / A-roll | `video` (comes from the tag) |
| Scenes, overlays, graphics | `graphics` |
| Captions | `captions` |
| Audio (voiceover, music, SFX) | `audio` (comes from the tag) |

Two details trip people up. First, `<video>` and `<audio>` need no `data-track-kind` at all — the kind is derived from the tag itself. Second, `data-track-index` is *display only*: the number never changes what renders on top of what. Layering is a CSS problem, and the file says so in as many words.

## Captions Get One Row, and the Safe Boxes Are 90% and 80%

All captions live on one track — a single sub-composition host, marked `data-track-kind="captions"`, carrying every caption group in order. Never one row per caption group, and never captions mixed onto a track with another kind. Word-timing mechanics are deliberately out of scope here; they belong to the `/embedded-captions` skill and the `caption_*` lint rules.

Safe zones are Premiere's defaults, and the skill names the source constants rather than leaving you to eyeball it:

| Box | Share of frame | Inset per edge |
|:---|:---|:---|
| Action-safe | 90% | 5% |
| Title-safe | 80% | 10% |

Everything visible stays inside action-safe. Captions and key content stay inside title-safe. Values come from `ACTION_SAFE_PERCENT` and `TITLE_SAFE_PERCENT` in `packages/studio/src/utils/previewSafeMargins.ts`, and the ruler overlay is drawn by the preview pane — so no guide elements go into the composition HTML. Two-up and 50/50 layouts keep each half's content inside the title-safe box.

## The Launch-Film Rules Are Allergic to Fake Product Shots

Section 5 is where this file stops reading like a lint spec. New films follow the order the actual HyperFrames launch films used — brief, directions, storyboard, build, notes — with each step owned by another skill in the pack. What `/hyperframes-studio` adds is the footage discipline:

- **Ask for a real screen recording of the launched product** unless the workflow captures the site itself, and hold that slot with a labelled placeholder until it arrives. Never approximate the launched product's UI. A third-party tool shown as context gets rebuilt faithfully from a capture.
- **One world.** The same window or canvas continues across beats. Scrub every cut — whatever persists must not jump.
- **Cursors and scrolled content exit through the window or frame edge.** Not by fading out mid-frame.
- **Close on the command or the address,** with the logo landing in footage that is still moving.
- **State the runtime at every version.** Running past the target is the person's call, not the agent's.

If you have watched an AI-generated launch video drop a cursor into thin air halfway through a window, that exit rule is the patch for it.

## Where It Sits in the Pack

It is the newest skill in the pack and the only live one whose weekly installs have never gone down — four zero weeks, then four straight increases. The numbers around it show the scale it is catching up to:

| Skill | Installs | Last week |
|:---|:---|:---|
| hyperframes-cli | 1,065,582 | 146,752 |
| hyperframes | 1,015,133 | 137,375 |
| [media-use](/skills/automation/media-use/) | 929,932 | 146,510 |
| [general-video](/skills/image/general-video/) | 607,910 | 97,530 |
| **hyperframes-studio** | **370,619** | **115,369** |

The division of labor is clean. `/hyperframes-studio` owns timeline layout and new-film order; how to perform one edit — split, trim, retime, volume, copy, swap — is `creator-editing-recipes.md` inside `/hyperframes-core`, and the skill's own description says not to use it for that. Intent routing and dispatch thresholds live in [general-video](/skills/image/general-video/); CLI behavior, catalog search and render gates are covered in the [hyperframes-cli FAQ](/tutorials/guides/hyperframes-cli-faq/).

When you finish, run `hyperframes check` — it runs lint internally — and fix every finding. Then open the project in Studio and confirm four things: a base row, one row per scene host, one caption row, the audio rows. If you see an opaque row you cannot open, a scene is still nested and belongs in its own file.

If you are starting out with the pack, pair this with the [HyperFrames vs Remotion comparison](/tutorials/comparison/hyperframes-vs-remotion/) before you commit to a rendering stack — the timeline conventions above only matter if HyperFrames is where you land.
