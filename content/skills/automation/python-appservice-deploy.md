---
title: "python-appservice-deploy: Python App Service Deploy Skill"
date: 2026-09-20
draft: false
tags:
  - Azure
  - Python
  - App Service
category: "automation"
description: "python-appservice-deploy (193K installs) ships Flask, Django and FastAPI to App Service Linux — Oryx auto-detect, explicit uvicorn, zero post-deploy checks"
---

Flask, Django and FastAPI apps reach Azure App Service Linux through three commands most of the time, and the `python-appservice-deploy` skill (v1.1.1, MIT, 193.2K installs, rank 275 on skills.sh) is the scripted version of that path — it asks one question, derives the rest, and then refuses to verify anything it just deployed. I read the full SKILL.md plus all eight references (create-app, detect, startup-commands, deploy-azcli, deploy-azd, errors, transient-retry, post-deploy-message) and scraped the skills.sh leaderboard on 2026-09-20: weekly curve [16,565, 15,789, 15,654, 14,646, 13,117, 13,331, 11,858, 12,590] — the same pack-level counter every microsoft/azure-skills record rides.

## One Question, Seven Derived Defaults

The workflow front-loads nothing. Only the app name is interactive: if you leave it empty the skill calls a name generator that slugs the folder, enforces `^[a-z][a-z0-9-]{1,38}[a-z0-9]$`, and appends an 8-hex GUID — `my-flask-app/` becomes `my-flask-app-a3f9c1d2`. Everything else derives: resource group `<app>-rg`, plan `<app>-plan`, region from the `az` CLI default or `eastus2`, current subscription. Every resource creation runs as `show || create`, so an existing user-named RG or plan survives untouched.

Two creation flags carry the pack's signature discipline. The plan must be `--is-linux --sku P0v3` — Windows plans trigger a handoff to `azure-prepare`, not a rebuild. The runtime token must use the colon form `"PYTHON:3.14"`, never `PYTHON|3.14`, because the pipe is a shell operator in Bash, PowerShell and cmd alike; Azure stores the value as `PYTHON|3.14` internally, which looks like a bug in `az webapp show` output but is normal. The skill even documents the escape hatch: `az webapp list-runtimes` prints pipe form, so a runtimes check must be converted back to colons before it touches `--runtime`.

## Oryx Auto-Detects Flask and Django; FastAPI Always Gets an Explicit Command

Framework detection is advisory — an unknown framework never blocks the deploy, it only changes the ending. The dependency scan (`requirements.txt` / `pyproject.toml`) maps tokens to frameworks: `flask` or `django` means App Service's Oryx build system finds the entry point itself, so the skill skips the startup command entirely. Django needs `<project>/wsgi.py` discoverable and `ALLOWED_HOSTS` to include `<app>.azurewebsites.net`, and Flask just works. FastAPI is the exception: the skill sets the startup command unconditionally, on every runtime — `python -m uvicorn main:app --host 0.0.0.0` — precisely because it does not trust Oryx FastAPI auto-detection. The `--host 0.0.0.0` part is load-bearing: uvicorn defaults to `127.0.0.1`, and a loopback-bound app fails App Service's container ping on port 8000 every time.

The conflict rule is deterministic. If both `flask` and `fastapi` sit in the same requirements file, treat the project as FastAPI and set the uvicorn command — no import-order heuristics, no guessing which framework actually serves. Flask is auto-detected happily either way, but a silently-picked Flask means a dead FastAPI app; the reverse mistake is recoverable. Unknown/WSGI-generic/ASGI-generic projects deploy anyway with a warning, and the post-deploy message picks the unknown-framework template so the user gets a concrete `gunicorn --bind=0.0.0.0 --timeout 600` or uvicorn example instead of a dead end.

## The No-Verification Rule Is the Whole Point

Real talk: this skill shipped the most counterintuitive hard rule I've read in the pack — after `az webapp deploy` (or `azd deploy`) returns, the agent must STOP. No `az webapp log tail`, no `curl`, no `Invoke-WebRequest`, no health probe. A zero exit code from `az webapp deploy --type zip --track-status false` only means the SCM endpoint accepted the ZIP; the Oryx build and the `pip install -r requirements.txt` run asynchronously afterward, and the container does not warm until an inbound request hits it. First visits routinely 502 or time out for 2-3 minutes, and a quiet log stream means nothing — so the skill treats silence and early 5xx as non-signals, and the only authoritative build proof is `az webapp log deployment list/show`. The one trap it documents: `az webapp log tail` on a fresh app streams nothing until you run a one-time `az webapp log config --application-logging filesystem --level information`, so a missing log line is often just a missing config.

| Path | When | Deploy command |
|:-----|:-----|:--------------|
| az CLI | No `azure.yaml`, or host isn't `appservice` | `az webapp deploy --src-path app.zip --type zip --track-status false` |
| azd | `azure.yaml` with `host: appservice` | `azd up` first time, then `azd deploy` |

`az webapp up` is deprecated and banned. `azd init -t <template>` inside an existing workspace is banned too — it can overwrite user code; only bare `azd init` is safe. Transient ARM errors (connection resets, `429`, `502-504`) get two silent retries with 5s/15s backoff wrapped around the full `show || create` pair, while `AuthorizationFailed`, `SkuNotAvailable` and `QuotaExceeded` surface immediately. The error matrix reads like a real outage log: `ModuleNotFoundError: No module named 'flask'` means `SCM_DO_BUILD_DURING_DEPLOYMENT=true` never ran, ping timeout on 8000 means the startup command is wrong or bound to loopback, and `gunicorn: command not found` means `gunicorn>=21` is missing from requirements.

## Where This Skill Sits in the Pack

It is a code-only path, deliberately. VNet integration, Key Vault references, databases, multi-environment IaC, Container Apps, Functions or AKS all trigger a hard handoff to [azure-prepare](/skills/automation/azure-prepare/) — the skill's own words: "This deployment goes beyond a code push." [azure-diagnostics](/skills/automation/azure-diagnostics/) owns the troubleshooting half for when the app is live but sick. Install it with `npx skills add https://github.com/microsoft/azure-skills --skill python-appservice-deploy`, and if the target is Kubernetes instead of a platform-managed web app, the [azure-kubernetes](/skills/automation/azure-kubernetes/) skill provisions the cluster side of that story.