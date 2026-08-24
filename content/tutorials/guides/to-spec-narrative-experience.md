---
title: "My Spec Session With to-Spec: No Interview, Just Synthesis"
date: 2026-08-24
toc: true
draft: false
tags:
  - Spec Writing
  - AI Coding
  - Engineering
description: "I ran Matt Pocock's to-spec skill on a half-baked feature and it refused to interview me: pure synthesis, one test seam pinned, then a ready-for-agent spec."
category: "guides"
---

I came to Matt Pocock's to-spec skill expecting twenty questions. It turned me down flat. The skill — skills.sh #122 with 361,627 installs, from the [mattpocock/skills](https://github.com/mattpocock/skills) repo (235K stars) — states its contract in nine words: "no interview, just synthesis of what you've already discussed." Its frontmatter carries `disable-model-invocation: true`, so nothing triggers it by accident. I invoked it on a half-formed checkout change with a messy chat history behind it, and watched it turn that mess into a published spec. Here's what the session actually looked like, including the parts where the skill refused to do what I expected.

## The No-Interview Rule Is the Whole Point

The skill's instruction body opens with a sentence that reads like a warning: *"Do NOT interview the user; just synthesize what you already know."* I kept drafting clarifying questions out of habit and kept deleting them. The skill answered from the conversation that already existed, and where the conversation was thin, the spec came out thin — which is the trade you sign up for.

That flips the usual assumption about spec tools. Most of them improve quality by interrogating you: more questions, better requirements. This one treats the quality of your conversation as the raw material and adds no interviewing on top. The practical consequence hit me immediately: garbage chat in, thin spec out, and the skill isn't going to save you from that. It has exactly one prerequisite, stated flatly — the issue tracker and triage label vocabulary "should have been provided to you. If not, tell the user to run `/setup-matt-pocock-skills`." I ran [setup-matt-pocock-skills](/skills/general/setup-matt-pocock-skills/) first; without the label mapping, the publish step at the end has nowhere to land.

## The One-Seam Rule Rewired How I Planned Tests

The second phase was the part that changed my approach. The skill told the agent to explore the repo, write using the project's domain glossary vocabulary, and respect any ADRs in the area being touched. Then it sketched the test seams — the boundaries where the feature would be tested — and three rules stood out:

- Existing seams beat new ones.
- Use the highest seam possible.
- "The fewer seams across the codebase, the better - the ideal number is one."

My draft proposed a service-layer seam for the checkout total. The skill's own standard pushed it up to the API boundary, because the total logic already had a testing home there — one seam, not three. That's the same minimalism [codebase-design](/skills/general/codebase-design/) applies to adapters, applied to tests: every extra seam is a contract that needs maintaining, so the ideal count is one.

This is also the one place the no-interview rule relaxes. After sketching the seams, the skill checks them with you before writing a single word of the spec — "check with the user that these seams match their expectations." It won't interview you about requirements; it will confirm the one structural decision that everything else hangs on. I proposed a seam, the rule pushed higher, and we agreed on the API boundary before the document existed.

## What the Spec Template Forbids Surprised Me

The output is a seven-section spec: Problem Statement, Solution, User Stories, Implementation Decisions, Testing Decisions, Out of Scope, Further Notes. Two sections carry hard prohibitions and they're the ones you'd expect to be free-form.

Implementation Decisions must not include specific file paths or code snippets. The skill's reasoning is blunt: "They may end up being outdated very quickly." A spec that names `line 42 of src/checkout/total.ts` is dead the next refactor; a spec that names the interface contract survives it. There's one carve-out — if a prototype produced a snippet that encodes a decision more precisely than prose can (a state machine, a reducer, a schema, a type shape), you inline the decision-rich part and note it came from a prototype. Trimmed to the important bits, never the whole demo. That connects to the family's [prototype skill workflow](/tutorials/comparison/prototype-vs-tdd-comparison/): prototype answers the risky questions, to-spec records which answers became decisions.

Testing Decisions carries its own discipline: describe what makes a good test — external behavior only, never implementation details — name which modules get tested, and cite prior art from the codebase. My narrative habit of writing "test that it works" got replaced with the same evidence language the rest of the family uses.

The User Stories section is where the skill over-delivered. It wants a "LONG, numbered list" in one fixed grammar — *As an <actor>, I want a <feature>, so that <benefit>* — and it produced over twenty stories for a change I'd have summarized in three bullet points. The fixed grammar is the feature: each story became independently reviewable, so I deleted five and kept the rest without touching the spec's structure.

## The Publish Step Is a Handoff, Not a Handover

The final step publishes the spec to the issue tracker and applies the `ready-for-agent` triage label — explicitly with no additional triage needed. That label is the family's contract: it tells [implement](/skills/general/implement/), the seven-line routing skill, that the work is specified well enough to build. [Code review](/skills/general/code-review/) comes after, and the label vocabulary is set up by the same setup pass I ran at the start.

The sibling skills split the same job differently. Where to-spec publishes one spec and walks away, [to-tickets](https://github.com/mattpocock/skills/tree/main/skills/engineering/to-tickets) breaks a plan into tracer-bullet vertical slices, each ticket declaring what blocks it — "make the change easy, then make the easy change." The rough workflow across the pair: to-spec captures the *what* and the seams, to-tickets decomposes the *how* into shippable slices, and the labels keep every published document in the same triage vocabulary.

## Should You Write Your Next Spec This Way?

Run to-spec when the conversation is already rich — you've discussed the problem, the constraints, and the rough shape of a solution, and you want that captured as a durable document an agent can execute from. Skip it when the idea exists only in your head and nobody's actually talked it through; the skill will faithfully produce a thin spec instead of interrogating you into a good one.

The session left me with one rule I'd stolen outright: spec the contracts, not the files, and pin the seams before writing anything. That's the durable part — the `ready-for-agent` label is just the family's way of saying the same thing in machine-readable form. Install the family with `npx skills@latest add mattpocock/skills`, have a messy conversation about your next feature, and invoke to-spec at the end of it. The spec writes itself from what you already said; the discipline comes from the one-seam rule and the no-file-paths rule, and both read like they were written by someone who watched a spec rot in a drawer for six months.