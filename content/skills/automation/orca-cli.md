---
title: "orca-cli: Orca's Skill That Loads Its Guide From the Binary"
date: 2026-10-31
draft: false
tags:
  - Orca
  - Agent Worktrees
  - CLI
category: "automation"
description: "Orca's orca-cli skill is a 2,312-byte stub that pulls a version-matched guide from the binary itself plus the handoff and terminal rules behind 356.7K installs."
---

Run `cat` on Orca's orca-cli skill and you get 2,312 bytes: a frontmatter block, a four-step ladder for choosing which executable to call, and one instruction — go fetch the real guide from the binary. That is the file.

The 28,948-byte version sits in the repo under `skill-guides/`, and the copy your agent actually reads comes from `ORCA skills get orca-cli` on the machine that will run the next command. Orca's stub spells out the reason without hedging: the guide is "kept out of this file on purpose so it can never drift from the binary that will actually run your commands."

I pulled the stub, the repo guide, both orchestration files, and the per-skill stub listing on 2026-10-31, the same day the skills.sh counter read 356.7K installs for orca-cli — weekly installs [19,873, 16,602, 16,892, 18,317, 16,058, 14,647, 31,412, 30,873]. The packaging choice is the interesting part, and it has a sharp edge worth knowing before your agent runs anything.

## A Stub, a Guide, and a Third Copy That Only Exists at Runtime

Three artifacts carry the same knowledge, and they are not backups of each other:

| Layer | Size | Who reads it |
|:--|:--|:--|
| `skills/orca-cli/SKILL.md` | 2,312 bytes | The agent, on skill load |
| `skill-guides/orca-cli.md` | 28,948 bytes | Reviewers, git history, humans |
| `ORCA skills get orca-cli` output | served by the binary | The agent, before commands |

The repo also carries `skill-stubs/` — one 251-to-436-byte marker per skill, with orchestration as the outlier at 2,512 bytes. Ten skill directories exist under `skills/` (computer-use, jira-tickets, linear-tickets, orca-cli, orca-emulator, orca-emulator-android, orca-jira, orca-linear, orca-per-workspace-env, orchestration), and every one of them routes through the same hook.

Compare that with a pack that ships everything inline. The HyperFrames CLI skill I read on 2026-10-13 was one 24,551-byte SKILL.md, self-contained, no fetch step — see the [hyperframes-cli FAQ](/tutorials/guides/hyperframes-cli-faq/) for what that costs in staleness risk. Orca traded file size for version matching. If the desktop app updates and the guide changes, the agent gets the new guide or gets told to update Orca. It never gets a 6-month-old command list that a cached SKILL.md remembered.

## The Executable Ladder Ends in a Screen Reader

Choosing the executable comes first, because Orca ships several of them, and this is the part where a careless agent breaks something on a Linux box:

1. `ORCA_CLI_COMMAND` set → use it. Orca exports this for managed WSL sessions.
2. A dev checkout with `ORCA_DEV_REPO_ROOT` in the session → `orca-dev`.
3. Linux, outside an Orca-managed terminal → `orca-ide`.
4. Everything else → `orca`.

Step three exists to dodge a collision: on Linux, bare `orca` usually resolves to `/usr/bin/orca`, the GNOME screen reader, and running it starts speech on the user's machine. The skill writes the warning as a prohibition, not a suggestion — "Never run bare `orca` there."

Two rules follow and both are the kind you only learn by burning a run. Substitute the selected path in place of the `ORCA` placeholder; do not create a shell variable, because the docs work identically in POSIX shells, PowerShell, and cmd.exe. And when the chosen executable fails, report the exact error and stop. Falling through to another executable can silently target a different Orca build, which means your child worktree and your terminal handles came from two different runtimes.

## "Hand Off" and "Have Another Agent Report Back" Are Different Commands

The two skills split on request phrasing, and the split is not cosmetic. A request phrased "hand off," "handover," "give this to another agent," or "another worktree" is a full handoff: ownership transfers, then the original agent stops.

```text
ORCA worktree create --name <task> --no-parent --agent codex --prompt "<brief>" --json
```

It counts as done when the new worktree id and agent handle are reported and the prompt landed — `prompt.outcome` reads `journaled` or `handed-to-terminal`, or an already-running agent returned `accepted: true`. Nothing more. Do not wait for the receiving agent to finish, and do not reach for `orca orchestration task-create`, `dispatch --inject`, or `check --wait`, which record coordinator-owned tracking state that nobody asked for.

Add "review this and report back" and you flip skills. That phrasing means an Orca worker under the orchestration skill — `worker-start`, then end your turn, because Orca wakes you when mail arrives. The orchestration file is blunt about the failure mode: "Never poll or run watch scripts: a script's plain `check` takes your mail, so it is hidden from you and Orca has nothing to wake you with."

One recovery detail deserves memorizing. A lost launch reply is not a reason to fire a second launch and hand the same brief to two agents. Reissue the identical command with `--retry-launch <operationId>` from the same directory against the same execution host, and the host replays the accepted launch instead of starting another agent.

## Terminal Reads Lie in Predictable Ways

`ORCA terminal read` returns accumulated output with escape sequences stripped. Not the rendered screen — accumulated bytes. Shells, progress bars, and full-screen CLIs repaint constantly, so that stream reads back as stacked fragments of half-drawn frames. Orca's answer is `--screen`, which returns the current frame only, and it cannot be combined with `--cursor`, because a single frame has no history to page.

The receipt semantics trip up more agents than the read path does:

- `accepted: true` proves the input was accepted. It does not prove the agent started a turn. Ask for `--wait-submit` when submission proof matters.
- A send watches for zero seconds by default, so a receipt that stops at `input_accepted` is normal, and its warning means "unproven," not "failed."
- Never resend on silence. Repeat the exact command with `--retry-request <id>` after an ambiguous transport failure.
- Never re-find a terminal by its title. Agents repaint `terminals[].title` constantly. Join `worktree ps --json` `agents[].paneKey` (`<tabId>:<leafId>`) to a `terminal list` row instead.

Two smaller wins land in the same file. `ORCA ports --json` reports the ports tied to a workspace, with `owner.confidence` set to `cwd` or `command`, so you skip hand-rolled `lsof` calls. And worktree ids are two-part addresses, `<repoId>::<worktreePath>` — a bare `repo-123` names the repository, not the checkout, and half the fumbling I see in logs is an agent confusing the two.

## Two Switches Only a Human Can Flip

Headless agents tend to assume every capability has a CLI flag. Orca ships two that don't, and both fail loudly enough to waste a retry loop if you don't know.

Artifact publishing needs the device-wide "Allow publishing public artifact links" setting, and the guide states there is no CLI or RPC route to grant it. A denied share returns `artifact_sharing_disabled` before any upload. On a headless Orca server the same commands fail with `sharing_unavailable_on_host`, because no cloud sign-in exists there.

Agent session search is gated the same way, under Settings → Agent Session History. When `enabled` is false, the correct move is to say so and stop. While `phase` reads `indexing`, results are partial, `--fresh` waits up to five seconds for the host to catch up, and `truncated.candidates: true` means the query outran the host's ranking — narrow it rather than paging.

## The Counters Doubled in Two Weeks

Six flat-to-sagging weeks at 14,647 to 19,873 weekly installs, then 31,412 and 30,873. The sibling orchestration skill ran the same shape from a higher start: [39,202, 26,556, 21,591, 21,851, 19,240, 16,705, 33,569, 33,122].

The two curves are not lockstep the way pack counters usually behave. Across the first six buckets they sit 19,300 installs apart, then the last two land within 2,700 of each other. Azure, HyperFrames, and Prisma packs move in near-perfect lockstep from the first bucket; these two converged late. The repo behind them showed 111,582 stars and had received a push earlier the same day.

Read that as two independent counters that got pulled toward each other by an update, not as proof that Orca usage is three times what it was in August. Weekly installs on a new tool move with release notes.

Before your agent touches Orca state, run `ORCA skills get orca-cli --json` and read what that binary actually ships, then check the [media-use breakdown](/skills/automation/media-use/) if you want the other end of the packaging spectrum — one fat self-contained file with no runtime fetch at all.
