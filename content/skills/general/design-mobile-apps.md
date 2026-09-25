---
title: "design-mobile-apps: Sleek Mobile Design Skill (428K)"
date: 2026-09-25
draft: false
tags:
  - AI Design
  - Mobile Apps
  - Sleek
category: "general"
description: "design-mobile-apps wraps Sleek's AI design API into a mobile workflow: chat an intent, screenshot the result, implement from HTML. 428K installs, rank 120."
---

You describe a screen in plain English, the agent hands back renders you can implement. That is what [design-mobile-apps](https://github.com/designed-by-ai/skills) does — it wraps [Sleek](https://sleek.design), an AI mobile app design service, into one skill: create a project, send a chat message with your intent, poll the run, screenshot every screen, then pull each screen's HTML for implementation. I read the full SKILL.md (564 lines of API contract) and pulled the leaderboard on 2026-09-25: **428.2K installs, rank 120 of 600**, with a weekly series of [0, 0, 0, 0, 0, 53,048, 140,177, 138,479]. Five flat weeks, then 140K a week for two straight weeks. The visible launch is three weeks old, and it's already the fastest-moving design entry on the board.

## A Client With a Single Host

The whole skill talks to exactly one server. Every request goes to `https://sleek.design/api/v1/*` with a bearer token, CORS is enabled across all of it, and no data leaves that one host. Auth is `SLEEK_API_KEY`, and there's a device flow so the user never handles the raw key: POST a start request, show the `verificationUrl` and `userCode`, poll until approved, store the returned `sk_...` key. Codes expire after 15 minutes, and on expiry you start over. A fallback URL (sleek.design/agents/setup) handles sign-in, plan upgrade, and key creation in one trip.

Keys are scoped five ways — `projects:read` / `projects:write` / `components:read` / `chats:read` / `chats:write` / `screenshots`. The skill's rule: create keys with only the scopes a task needs, prefer short-lived ones. Pricing is stated plainly in the SKILL.md: free accounts get roughly one trial design run, and sustained use needs Pro at $49.99/month — or $30/month billed yearly ($360/year), which includes 20,000 AI credits, about 650 screens. The price never ambushes anyone; when an upgrade matters, the skill says so before any payment step.

## One Message, One Run, Screenshots Before Done

Designing starts with a project, and the rule is one project per design variation — each project owns its theme, style, and design system. Next a single chat message with full intent: don't decompose the request into screens, don't add product details the user never asked for. Sleek plans screen content and layout itself; give it room and it produces richer designs.

When the user supplies anything to ground a look in — reference images, apps they like, vibe adjectives — the skill makes you author a **style direction**: one paragraph covering mood, color logic, typography feel, layout philosophy, component style, imagery. Committed, opinionated, no hedging. Pass that inside the message; or pass a `referenceId` from Sleek's curated catalog instead. Never both — a reference already carries a full style guide.

The loop runs async: send a message, get a `runId`, poll every 2 seconds (back off to 5s after 10s), give up after 5 minutes. One active run per project — a second message while one is running gets a `409 CONFLICT`, and the skill's fix is to cancel the stale run, not improvise. A run is never done until the user has seen a screenshot of every screen it created or updated. No silent finishes, ever.

## The HTML Is the Contract

Screenshots are for people; HTML is for shipping. Every component carries a `versions[]` array with an `activeVersion` — default to the active version's code unless the prompt pins specific versions (a pin block names `cmp_abc: ver_001`-style ids, and pinned screenshots take `componentVersionOverrides`). The code is a complete HTML document; save it straight to a `.html` file, no build step.

For native frameworks the skill is explicit about the pair: HTML tells you *how* to build it, the screenshot tells you *what* it should look like. Icons come from Iconify in `prefix:name` form — `solar:`, `material-symbols:`, `lucide:` are the common sets — and must match exactly, no substitution. The trap worth knowing: `@expo/vector-icons` does not support those sets, so the skill fetches SVGs from the Iconify API and renders them with `react-native-svg`'s `SvgXml`, which works in Expo Go with no native dependencies. Fonts come from the Google Fonts `<link>` tags in the HTML, and navigation is in scope: shipping screen content while leaving the default tab bar untouched is treated as a miss.

## Four Traps From the Mistakes Table

The SKILL.md ends with a common-mistakes table, and four entries deserve headline treatment.

1. **Viewport screenshots lie.** A viewport shot crops everything below the fold, so content that "looks missing" is usually just lower on the page. Never call a screen incomplete from a viewport screenshot — re-shoot with `fullHeight: true`, or check the component HTML, which is the ground truth. Full-height frames cap at 4× the default frame height, so a very long screen needs the HTML as authority. Framing rule of thumb: viewport shots for the user, full-height shots for your own review.
2. **screenId ≠ componentId.** Every screen has both. Chat targeting takes `screenId`; screenshots and component reads take `componentId`. Mixing them up is the most common mistake in the table.
3. **Never pipe JSON through echo.** In zsh, `echo` expands the escaped `\n` inside string values and breaks the JSON. Write the body to a file with `curl -o` and parse the file.
4. **An unreadable run status is not "not done yet".** If the poll response can't be read, stop and report it — treating it as still-running spins the loop for minutes after the run already finished.

| | Screenshot for the user | Screenshot for your own review |
|:--|:--|:--|
| `fullHeight` | off — phone framing is the point | on, one screen per request |
| Batch | combined shot + one per screen | parallel requests per screen |
| Purpose | show the result | judge your own work |

## Bottom Line

Install the skill from the [designed-by-ai/skills](https://github.com/designed-by-ai/skills) repo, grab a trial key (one free design run before any payment decision), describe one screen, and watch it render live in the Sleek editor. The one-run-at-a-time rule fits agent loops cleanly, and the single-host model caps the blast radius at one key and one server. On the design-skills side of the board, [design-taste-frontend v1 vs v2](/tutorials/comparison/design-taste-frontend-v1-vs-v2/) is the taste layer that decides what good looks like, and [prototype](/skills/general/prototype/) turns a chosen direction into a buildable plan — design-mobile-apps sits between them, making the screens while the others make the decisions.