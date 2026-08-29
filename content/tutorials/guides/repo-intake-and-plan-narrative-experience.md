---
title: "I Ran repo-intake-and-plan on 3 Real Repos: What It Caught"
date: 2026-08-29
toc: true
draft: false
tags:
  - Deep Learning
  - Reproducibility
  - AI Agents
description: "RigorPilot's repo-intake-and-plan (450K installs, #70) scanned micrograd, makemore, and nanoGPT for me: 2, 3, and 16 commands — plus one it invented."
category: "guides"
---

Repo intake sounds like a formality until the report lands. RigorPilot's `repo-intake-and-plan` helper (450,025 installs, #70 on skills.sh) is the scan-and-plan step of the family's README-first reproduction pipeline, and today I ran its own scripts against three repos it would plausibly be handed: karpathy's micrograd, makemore, and nanoGPT. Twenty-one commands came out of the three READMEs. One of them was a name the script invented, three more carried labels I'd have argued with, and the misses taught me more about the skill than the hits. Every number below is the scripts' actual output, run on shallow clones at 2026-08-29 17:06 UTC.

## The Skill Spends Its Bytes Refusing Work — On Purpose

`repo-intake-and-plan` is the intake tier of the RigorPilot family: the flagship `ai-research-reproduction` invokes it early, before anything runs, to get a fast map of the repo and its documented commands. The SKILL.md I read is short (2,123 bytes) and spends most of those bytes on what it will not do. It does not install environments. It does not prepare large assets. It does not execute substantive reproduction commands. It does not decide high-risk patching. "This skill scans and plans," the file says, and the description block is a refusal list: don't use it for environment setup, asset download, command execution, final reporting, paper lookup, or end-to-end orchestration.

Its input contract is one repository path plus the README, and its output contract is five items: a concise structure summary, a documented command inventory, candidate categories (inference / evaluation / training / other), a minimum trustworthy reproduction recommendation, and a list of notable ambiguity or risk. The work happens in two plain-Python scripts under `scripts/`: `scan_repo.py` checks for nine key files (`README.md`, `requirements.txt`, `environment.yml`, `pyproject.toml`, `setup.py`, `Dockerfile`, and friends) and seven signal directories (`configs/`, `scripts/`, `examples/`, `notebooks/`, `checkpoints/`, two spellings of `config/`), then `extract_commands.py` pulls shell commands out of the README's code fences and inline `$` prompts, tags each one with a category, and flags any that need placeholder substitution. Reading the SKILL.md felt like reading a contract for a service that guarantees, up front, what it won't do to you.

## Three Intake Reports, Measured

I cloned all three repos shallow and pointed the scripts at them. Here is what came back, unchanged.

| Repo | Scan detected | Commands extracted | Category counts | Standout |
|:--|:--|:--|:--|:--|
| micrograd | `README.md`, `setup.py`; no signal dirs | 2 | other: 2 | The training demo never shows up |
| makemore | `README.md` only; genuinely no env files | 3 | inference: 3 | One of the three is a name: `sherrith` |
| nanoGPT | `README.md`; `config/` flagged | 16 | training: 10, inference: 3, other: 3 | eval configs land under training |

**micrograd** came back cleanest and least useful. The scanner found `README.md` and `setup.py`, zero signal directories, no warnings. The extractor surfaced exactly two commands: `pip install micrograd` (setup) and `python -m pytest` (run). The repo's whole point — a two-layer MLP trained on the moon dataset — lives in `demo.ipynb` at the top level, and nothing flags it, because the signal list is a *notebooks/ directory*, not notebook files, and the demo is documented in prose, not as a shell command. This is the conservative behavior rule working as written: prefer explicit README evidence, and if a command isn't documented, don't invent one. micrograd therefore intakes as "install and run tests," which is honest and nearly useless for reproduction.

**makemore** produced the false positive that made me go read the source. The Usage section's bash block yields `python makemore.py -i names.txt -o names` and its `--sample-only` variant, both tagged inference off the "Usage" heading. Then the block's example output — Karpathy's README prints generated baby names — leaked in as a command: `sherrith`. It passed `looks_like_command` because that function checks `candidate.startswith(("python", "pip", "conda", "bash", "sh", "make", "docker"))`, and *sherrith* starts with "sh". A generated name became an inference command in the intake plan.

**nanoGPT** showed the machinery working at its best. Sixteen commands: `pip install ...` and two `data/.../prepare.py` runs as other, ten training (every `train.py` and `torchrun` invocation), three inference (all `sample.py`). The `--eval_iters=20 --compile=False ...` kitchen-sink quick-start line stayed training despite the eval flag — entrypoint-name precedence winning, exactly as the script's comment intends. `config/` got flagged as a signal directory. The two multi-node `torchrun` lines came out classified training, which is right. They also came out flagged `needs_substitution: false` — which is wrong, see below.

## Three Misses, and Where the Human Is Supposed to Catch Them

Every miss maps to a fixed rule in `extract_commands.py`, and each one quietly hands responsibility back to you.

**The entrypoint name beats the config name.** `python train.py config/eval_gpt2.py` — plus the medium, large, and xl variants — all classified training. The script checks section headings first ("baselines" matches nothing), then entrypoint hints, and `train*.py` matches training. The hint list's comment explains the intent: flags like `--eval_iters` on a `train.py` command must not flip training into evaluation, or the downstream training-authorization gate would be bypassed. The side effect is that a config literally named `eval_gpt2` reads as training to the tool and as evaluation to any human.

**Placeholder detection only sees angle brackets.** `PLACEHOLDER_RE` matches `<PATH/TO/DATASET>`-style tokens, and nanoGPT's multi-node lines carry their placeholders as bare literals: `--master_addr=123.456.123.456 --master_port=1234`. No brackets, so `needs_substitution: false` on a command that cannot run verbatim on anything. The substitution flag is the script's way of saying "a human must fill this in," and these lines bypassed it completely.

**The "sh" prefix trap.** The `sherrith` false positive isn't a parser bug in the regex sense — it's a too-broad prefix tuple in `looks_like_command` colliding with the word "she". Any README that prints sample output inside a bash fence leaks those lines into the command inventory whenever a line happens to start with "sh", "py" (think `pytorch` as a bare word), "ma", or any other tuple prefix: `make` catches `makefile` lines too. The plan inherits the leak, and the "notable ambiguity or risk" field is where the skill's own contract says the human reviews it.

The family's `references/repo-scan-rules.md` states the doctrine plainly: prefer explicit README evidence over filename guesses, mark guessed classifications as inferred, and record ambiguity instead of overcommitting. The scripts hold that line — micrograd proves they'd rather say nothing than guess. The blind spots above are the price of the same conservatism, and they're surfaced exactly where the output contract says: the command inventory and the risk list are inputs to a human, never verdicts.

## The Helper Trio Sits Within 845 Installs of Each Other

The lifecycle of a RigorPilot reproduction splits across three helper skills, and the live leaderboard (scraped 2026-08-29) shows them packed shoulder to shoulder: `paper-context-resolver` at #69 (450,785 installs), `repo-intake-and-plan` at #70 (450,025), and `minimal-run-and-audit` at #71 (449,940) — a 845-install spread across the trio. Their weekly install curves move in lockstep (20.5K → 50.2K peak → ~41K), which makes sense: they're installed together as the `--all` family bundle. All three outsell the flagship `ai-research-reproduction` (#165, 310,841) by roughly 45%, because helpers ride along on every reproduction install while the orchestrator only ships when a full run is the job.

The division of labor is clean: intake scans and plans, paper-context resolves the narrow gaps the repo files can't answer, and minimal-run-and-audit verifies that a run is honestly minimal before you waste a GPU day. My three-repo run was the intake step alone — and even that step, on repos I know well, needed a human pass to fix what the heuristics mislabeled.

## Should You Run It Before Your Next Reproduction?

Yes — with the report treated as a draft. The two scripts are plain Python, they finished on all three repos in under three seconds total, and they cost no GPU and no environment. Run them before you clone anything deep: `python scan_repo.py --repo <path> --json` and `python extract_commands.py --readme <path>/README.md --json` give you the structure map and the command inventory that step two of the [nine-step reproduction sequence](/tutorials/guides/ai-research-reproduction-procedural/) wants. Then read the output like you'd read a junior engineer's notes: trust the structure, verify the classifications, and substitute the placeholders — including the ones flagged false. Install the full family with `npx skills@latest add llllllama/rigorpilot-skills --all`, and hand the narrow paper questions to [paper-context-resolver](/skills/general/paper-context-resolver/) when the intake report hits a gap the README never explains.