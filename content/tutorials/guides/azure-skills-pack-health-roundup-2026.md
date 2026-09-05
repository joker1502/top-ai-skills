---
title: "Azure Skills Roundup: Spot the 4 Removed Skills"
date: 2026-09-05
toc: true
draft: false
tags:
  - Azure
  - Agent Skills
  - AI Tools
category: "guides"
description: "4 microsoft/azure-skills - azure-rbac, azure-hosted-copilot-sdk, cost-optimization, observability - deleted while install totals kept climbing."
keywords:
  - azure-rbac
  - azure-hosted-copilot-sdk
  - azure-cost-optimization
  - azure-observability
  - azure-skills
---

Four skills in the [microsoft/azure-skills](https://github.com/microsoft/azure-skills) pack show lifetime install totals that look perfectly healthy: azure-rbac at 488.3K, azure-hosted-copilot-sdk at 439.9K, azure-cost-optimization at 209.4K, azure-observability at 98.3K. All four are gone. Their SKILL.md files return 404 on the main branch today, and the pack's install counter keeps climbing anyway — the totals count the pack's history, not the skill's future. I verified the raw URLs, listed the current `skills/` directory (28 entries, none of them these four), and pulled the full weekly install series for every azure-skills record off the skills.sh leaderboard on 2026-09-05. The weekly curves expose what the lifetime numbers hide.

## Four Skills That Left the Repo

The directory on main now holds 28 skills; these four are not among them. **azure-rbac** handled role-based access control planning for Azure resources — the pack's RBAC brain. **azure-hosted-copilot-sdk** guided SDK work for the hosted Copilot offering. **azure-cost-optimization** ran cost reviews and right-sizing checks. **azure-observability** designed monitoring and log pipelines. Each one's raw SKILL.md returns 404 today. For azure-rbac, the deletion is pinned to a specific commit (6f4ff3f2, 2026-07-17) found in a prior audit; for azure-cost-optimization, the last commit touching its path is a 2026-04-02 sync from GitHub-Copilot-for-Azure; azure-observability's path has no commits on main's history at all, which tells you it never lived on this branch the way the others did. Removal took at least three different shapes inside one repo.

## The Curves That Collapsed

The weekly install series tells the story no lifetime total can:

| Skill | Lifetime | Weekly installs (8 weeks) | Last week |
|-------|----------|---------------------------|-----------|
| azure-rbac | 488,343 | 15,863 → 15,682 → 9,640 → 5,611 → 4,296 → 3,111 → 2,600 → 2,149 | 2,149 |
| azure-hosted-copilot-sdk | 439,867 | 12,958 → 7,749 → 4,839 → 3,499 → 2,952 → 2,233 → 1,958 → 1,690 | 1,690 |
| azure-cost-optimization | 209,410 | 167 → 182 → 170 → 153 → 150 → 111 → 91 → 118 | 118 |
| azure-observability | 98,309 | 11 → 13 → 8 → 12 → 17 → 11 → 10 → 6 | 6 |

Compare that with any live member of the pack. azure-diagnostics sits at 565,433 lifetime and closed last week at 13,741 installs; azure-enterprise-infra-planner at 13,837; the weakest live skill in the last window, python-appservice-deploy, still pulled 13,331. Every living skill in this pack traces the same lockstep rhythm — peak near 17K weekly, drift to the 13.3-13.8K band — because they share one pack-level counter. A dead skill falls off that rhythm forever. The collapse speed varies: rbac decayed through a 15.6K week before sliding, hosted-copilot-sdk dropped immediately, cost-optimization and observability never saw a four-digit week after the pack split. The decay rate is the fingerprint of *when* each skill stopped shipping.

## The Name Twins and the Newcomers

Here's the trap for anyone installing by memory. The pack contains **azure-cost** — alive, 367,394 installs, lockstep curve — alongside the dead azure-cost-optimization. Same family name, same domain, completely different survival status. My 09-05 check confirms azure-cost lives in the repo (its SKILL.md returns 200) and azure-cost-optimization does not. If you let autocomplete or muscle memory pick the longer name, you get a corpse. The opposite pattern exists too: azure-app-onboard and azure-app-onboard-prereq are newborns, weekly series [0, 0, 2,489, 14,370, 14,828, 14,127, 12,741, 13,026] — they broke into four-digit weeks about a month ago and now ride the pack rhythm like veterans. New skills diverge upward; removed ones diverge downward. Direction of divergence is the signal.

Removal also leaves residue. Deleting a SKILL.md doesn't delete its advice: the rbac role guidance survives in `azure-app-onboard/scaffold/references/rbac-roles.md` and inside microsoft-foundry's rbac file, which is why the [azure-rbac intro](/skills/automation/azure-rbac/) still matters as a map to the survivors. Meanwhile references to the dead linger in the living: the [azure-kubernetes](/skills/automation/azure-kubernetes/) SKILL.md routes to `azure-kubernetes-app-deploy` and `automatic-readiness`, siblings that exist in neither the repo nor the leaderboard. A router skill can point at ghosts for weeks after a pack cleanup.

## A 30-Second Pre-Install Check

Real talk: I almost wrote the roundup from the leaderboard alone, and the leaderboard alone would have told me nothing — every dead skill's lifetime total is higher than several live ones'. What caught each one was a raw-URL check. Before you install any pack skill, run the same three steps: `curl -sI` the raw SKILL.md on main (404 = dead), glance at the weeklyInstalls array on skills.sh rather than the installs total (collapse toward zero = removed; divergence upward = newborn), and grep the SKILL.md for references to sibling skills, then verify each of those exists too. Ten seconds of checks, and the dead pool stops being a surprise.

## Where to Start

Check your installed list today. For every azure-skills entry, hit the raw URL and read the weekly curve; if either looks like the table above, uninstall the skill and look for its successor — azure-cost, not azure-cost-optimization, and for RBAC help, the guidance that survived into azure-app-onboard's references. The summary, in one line: lifetime totals are pack history, weekly curves are skill health, and 404 is the only verdict that cannot lie.