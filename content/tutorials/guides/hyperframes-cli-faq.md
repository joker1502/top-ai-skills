---
title: "HyperFrames CLI FAQ: Gates, Catalog Search, and Rendering"
date: 2026-10-13
toc: true
draft: false
tags:
  - HyperFrames
  - Video
  - CLI
category: "guides"
description: "Straight answers from HyperFrames' 24.5 KB CLI SKILL.md: the check gate, catalog search tiers, 200 MB cloud cap, and 981.9K installs."
faq:
  - question: "What does the hyperframes-cli skill actually cover?"
    answer: "The whole HyperFrames development loop rather than one command: init, add, catalog, capture, lint, check, snapshot, compare, grade-compare, preview, play, present, beats, keyframes, single and batch render, publish, cloud, cloudrun, lambda, feedback, doctor, browser, info, upgrade, skills, compositions, timeline, history, clean, docs, benchmark, telemetry, transcribe, auth, tts, and remove-background. It also covers diagnosing build and render failures. Local, HeyGen-hosted cloud, AWS Lambda, and Google Cloud Run rendering are all in scope. Requirements are Node.js 22 or newer plus FFmpeg."
  - question: "How has the skill changed since HyperFrames' earlier releases?"
    answer: "It grew. The copy I pulled on 2026-08-30 was 18,291 bytes; today's SKILL.md is 24,551 bytes. The additions are mostly collaboration machinery: a `history` system that records every project write as an undoable entry, `npx hyperframes catch-up` for picking up edits someone made in the desktop app after a hand-off, and `npx hyperframes open` to hand the project to the HyperFrames desktop app, where the chat picks up the conversation under Claude Code, Codex, or Grok. A `doctor --json` gate and a `benchmark` command are in the description now too."
  - question: "What is the one command I must not skip before rendering?"
    answer: "`npx hyperframes check`. Run `npx hyperframes lint` while authoring for fast feedback, then let `check` serve as the final gate — it reruns lint itself before opening a browser, so prepending a redundant standalone lint call just wastes a run. `check` uses one browser session and one seek pass to audit runtime errors, failed requests, layout, `*.motion.json` assertions, and WCAG contrast. Persistent findings gate the exit code; transient entrance and exit findings are informational. Add `--snapshots` for annotated overview frames and finding crops, or `--strict` when warnings should gate too. `validate`, `inspect`, and `layout` still work as aliases but must not appear in new instructions or scripts."
  - question: "Why does catalog search return nothing for my query?"
    answer: "Because the catalog indexes English only. A query written in another script produces no searchable terms, which is why the error reads `No searchable words in query` — that is a language problem, not a missing component, so do not file it as a catalog gap. Query in English even when the final video is not; the on-screen copy stays in whatever language the brief needs."
  - question: "What are the two search tiers and how do I tell which one answered?"
    answer: "`words` is the default local tier and ranks on vocabulary shared with an item's name, title, description, and tags. It is fast and entirely offline, but it misses any phrasing that does not reuse the catalog's own wording. `on-device` ranks by meaning using a quantized ONNX build of `bge-small-en-v1.5` pinned to a fixed revision — roughly a 33 MB one-time download cached under `~/.hyperframes/`, never added to your project or package. Declaring the size and getting consent before passing `--on-device` is the skill's rule. With `--json`, the envelope's `tier` field names the answering tier: never infer it from results appearing. A weak result on `words` is expected; the same weak result on `on-device` is a bug."
  - question: "What does top_score mean, and is there a threshold?"
    answer: "There is no threshold. `top_score` appears only on the on-device tier, and the ranker returns the whole catalog in some order for every query, so read it as evidence rather than pass or fail. Treating it as a cutoff is the mistake."
  - question: "What do the dropped and unindexed counts mean?"
    answer: "They are opposite skews between the registry and the local index, and rewording your query fixes neither. `dropped` counts ranked names the registry cannot install, so your strongest matches are the ones being lost. `unindexed` counts registry moves the index cannot see at all — no query will ever return them. Refreshing the registry is not the remedy for either, since its manifest carries a 24-hour TTL and heals itself. Re-running with `--on-device` refetches the vector index when `unindexed` is above zero, which is the fix to hand the user. The pure over-coverage case — `dropped` above zero with `unindexed` at zero — does not trigger that refetch, so clearing `~/.hyperframes/catalog/` is the only way out. Both counts count names, not results, so either can exceed `total`."
  - question: "How do I report a component the catalog does not have?"
    answer: "Use `npx hyperframes feedback --search-miss \"<query>\" --wanted \"<move you needed>\" --tier <tier>`. You rarely have to assemble that line by hand: `catalog --query` prints it pre-filled, and every `--json` search envelope carries it as `report_gap` with query and tier already correct. Fill in `--wanted` and send. This is the only path that sends a query anywhere, which is exactly why plain `catalog --query` can promise to send nothing. Report on either tier whenever the results do not do the thing — the on-device tier needs that consented 33 MB download and stays off in most agent runs, so waiting for it means never reporting at all."
  - question: "What are the render quality levels?"
    answer: "Three. `--quality draft` while iterating, `--quality looks` for the first real encode (also the CLI default), and `--quality delivery` for the final file. After rendering, confirm the output exists and is non-empty, then read the render summary's second line: `beginframe` versus `screenshot`, GPU, and stage timings. `screenshot` with a software GPU on Linux is the slow path. Finish with `ffprobe -v error -show_format -show_streams` and compare duration against the root `data-duration`."
  - question: "Do passing checks mean I can render?"
    answer: "No. The skill states it directly: never render merely because checks pass. Stop at the final preview, verify the URL returns HTTP 200, hand the timeline project URL to the user, and wait for approval. Keep the preview alive until review ends. The plan in chat and the `storyboard.html` sketch sheet are not approval of the final video."
  - question: "What are the cloud rendering limits?"
    answer: "Hosted cloud projects approaching or exceeding the 200 MB upload limit need investigation rather than deletion: run `npx hyperframes cloud render --dry-run --json` and follow the `.hyperframesignore` guidance in the cloud reference. The skill forbids ignoring an asset simply because it is large."
  - question: "How should agents call doctor and other commands?"
    answer: "`npx hyperframes doctor --json` always exits zero, so exit codes tell you nothing — gate on the payload instead: `npx hyperframes doctor --json | jq -e '.ok' >/dev/null`. Prefer `--json` for agent and CI calls in general, with one exception: server-mode `render`, `preview`, and `play` have no ordinary JSON output, and only `preview --selection --json` and `preview --context --json` exist as query-mode exceptions. Use a single `HYPERFRAMES_RUN_ID` for every command in one verification loop."
  - question: "What do the install numbers say?"
    answer: "As of 2026-10-13, skills.sh lists hyperframes-cli at 981.9K installs and rank #8 overall, with weekly [35,245, 32,591, 36,139, 46,204, 85,128, 73,279, 96,486, 146,752] — the last two weeks are 4.2x the two before them, so the growth is recent and still climbing. The rest of the pack moves in the same wave (hyperframes-animation 832.0K, hyperframes-registry 831.3K, hyperframes-core 792.0K), which is the pack-counter pattern rather than per-skill demand. The genuinely separate counter is the newborn `hyperframes-studio`, at 308.5K with weekly [0, 0, 0, 0, 21,751, 57,106, 84,410, 115,369] — roughly five weeks old and accelerating, the way the sibling skills looked when HyperFrames launched."
---

{{< faq-schema >}}

The HyperFrames CLI skill is the largest moving part of the HeyGen video framework's skill pack, and it is also the one whose instructions changed most since summer. I re-read the full SKILL.md on 2026-10-13 (24,551 bytes, up from 18,291 bytes on 2026-08-30) and checked the live skills.sh detail page for the numbers. Short version: the interesting updates are not new render flags, they are collaboration and search mechanics. Here are the questions worth asking before you point an agent at a HyperFrames project.

## Why This Skill Keeps Showing Up

`hyperframes-cli` covers the development loop end to end — scaffold, find a move in the catalog, author, lint, check, preview, render — plus local, cloud, Lambda, and Cloud Run rendering paths. There is no hosted tier for catalog search: the query text never leaves the machine unless you deliberately report a gap. That privacy default is unusual enough to be worth stating, and the skill states it repeatedly.

Since August the SKILL.md gained a project `history` system (every write is an undoable entry, tied to an agent turn), `npx hyperframes catch-up` for reconciling edits made in the desktop app after a hand-off, and `npx hyperframes open` to move a project into that app. The `preview --background` step now comes with a verification requirement — confirm the URL returns HTTP 200 before handing it over.

## The Questions That Actually Come Up

The FAQ block above covers the ones I keep hitting in practice: which command is the real gate (`check`, not `lint`), why a non-English catalog query returns nothing, the difference between `dropped` and `unindexed` skews, how to file a catalog gap without breaking the offline promise, and why `doctor --json` exits zero no matter what. If you only read one answer, read the one about `top_score`: there is no threshold behind it, and agents inventing one produce confident nonsense.

For the framework-level comparison — how HyperFrames stacks up against Remotion on the same brief — see [HyperFrames vs Remotion](/tutorials/comparison/hyperframes-vs-remotion/), and for the asset-resolution side that runs before the CLI touches anything, see [media-use](/skills/automation/media-use/).

## Install It and Set the Gates

```bash
npx skills add heygen-com/hyperframes
npx hyperframes doctor --json | jq -e '.ok'
npx hyperframes check
npx hyperframes render --quality looks --output out.mp4
test -s out.mp4
```

Node.js 22 or newer, plus FFmpeg. Keep one `HYPERFRAMES_RUN_ID` across a verification loop, write QC frames to a temp directory instead of the project, and let `npx hyperframes clean --dry-run` show you what dead renders left behind before deleting anything.
