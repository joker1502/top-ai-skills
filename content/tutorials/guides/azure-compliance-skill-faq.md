---
title: "Azure Compliance Skill FAQ: azqr and Key Vault Audits"
date: 2026-09-16
toc: true
draft: false
tags:
  - Azure
  - Compliance
  - Security
category: "guides"
description: "Straight answers on Microsoft's azure-compliance skill: what azqr's Excel output holds, how Key Vault expiry audits rank findings, what 583K installs signal."
faq:
  - question: "What does the azure-compliance skill actually do?"
    answer: "Two assessments. One runs Azure Quick Review (azqr) across a subscription, resource group, management group, or single service, and produces an Excel workbook with nine sheets: Recommendations, ImpactedResources, Inventory, Advisor, DefenderRecommendations, Azure Policy, Costs, Defender, and OutOfScope. The other audits Key Vault keys, secrets, and certificates for expiration. Both run through MCP tools in the agent — no CLI juggling."
  - question: "What permissions do I need to run it?"
    answer: "Reader role on the target subscription or resource group is the floor. azqr needs read access to resource configuration. The Key Vault half needs Key Vault Reader plus data-plane access to list and read secrets, keys, and certificates. Authentication is a plain `az login`."
  - question: "What does the azqr Excel output contain?"
    answer: "Nine sheets. Recommendations and ImpactedResources are the two to read first — they list every finding against a concrete resource count. Inventory covers all scanned resources with SKU, tier, and SLA. Advisor and DefenderRecommendations add reliability and security signals. Azure Policy lists non-compliant resources, Costs gives a three-month history, Defender reports plan status, and OutOfScope names what couldn't be scanned."
  - question: "Which services does azqr cover?"
    answer: "70+ Azure resource types, including AKS, API Management, App Service, Container Apps, Cosmos DB, Container Registry, Key Vault, Load Balancer, MySQL, PostgreSQL, Redis, Service Bus, SQL Database, Storage Accounts, Virtual Machines, and Virtual Networks. A resource type not on the list lands in OutOfScope."
  - question: "How does the Key Vault expiration audit work?"
    answer: "It lists keys, secrets, and certificates in a vault, pulls their expiration metadata, and compares it against a configurable threshold — 30 days by default. Findings split into expired, expiring soon, missing expiration (a null expiresOn is flagged as a security risk), and disabled. Four patterns cover single-vault quick scans, multi-vault compliance reports, single-resource-type focus, and an emergency finder for already-expired items during an incident."
  - question: "How should I prioritize the findings?"
    answer: "The skill uses four classes: Critical means immediate remediation for high-impact exposure, High means resolve within days, Medium means plan into the next sprint, Low means track during regular maintenance. Key Vault items get a tighter ladder: expired → rotate immediately, 0-7 days → within 24 hours, 8-30 days → within a week, no expiration → apply a policy, more than 30 days → monitor."
  - question: "How often should I run scans?"
    answer: "The reference file recommends weekly Key Vault audits and a full azqr pass weekly or monthly, with findings tracked over time so you can verify remediation actually landed. It also suggests Event Grid notifications 30 days out and a rotation cadence: secrets every 60-90 days, keys annually, certificates per CA requirements — a year max."
  - question: "What are the common failure modes?"
    answer: "\"Please login\" means you skipped `az login`. \"Forbidden\" means role assignments are wrong — check Reader on the scope, and Key Vault Reader plus data-plane access for the vault pass. \"Not found\" usually means a wrong subscription or resource group selection. If the MCP Key Vault tools time out past 30 seconds, the reference includes a full `az keyvault` CLI fallback table."
  - question: "Is the 583K install number real?"
    answer: "Yes. skills.sh on 2026-09-16 showed azure-compliance at #53 with 583,170 all-time installs and a weekly series of 17,071 → 12,955. It rides the same lockstep curve as the rest of the azure-skills pack — azure-diagnostics 585,469, azure-prepare 585,017, azure-validate 584,169 — with the usual ~1K spread between siblings."
  - question: "Is this a compliance certification tool?"
    answer: "No. It audits against Azure best practices and Azure Policy, not SOC 2 or ISO 27001 frameworks. What you get is a prioritized list of security, reliability, performance, cost, and operations issues with remediation guidance — evidence for an audit, not an attestation result."
---

{{< faq-schema >}}

## Why an azure-compliance FAQ Exists

Microsoft's azure-compliance skill (v1.2.2, MIT) is one of the pack's highest-installed entries, yet most write-ups stop at "it runs azqr." The SKILL.md routes two distinct jobs — comprehensive resource assessment and Key Vault expiration monitoring — and the reference files carry the actual workflow details: the Excel sheet layout, the scope options, the priority ladder, the CLI fallback. I read all three files plus the live leaderboard on 2026-09-16; every answer above traces to one of them.

## The Short Answers

- **Two jobs, one skill.** azqr compliance scans plus Key Vault expiry audits.
- **Reader role suffices.** Read-only access on the target scope; Key Vault needs data-plane read.
- **Nine sheets in the workbook.** Recommendations and ImpactedResources carry the actionable findings.
- **70+ resource types.** Anything unscannable lands in OutOfScope, not in the silent void.
- **Weekly cadence.** Key Vault every week, full scan weekly or monthly, Event Grid heads-up at 30 days.

## Reading the azqr Workbook

The Excel output is where the skill earns its keep, because the sheet layout tells you what to read in what order. Recommendations and ImpactedResources carry severity-ranked findings with resource counts — that's the "what is actually wrong" list. Inventory is your "what did we even scan" reference with SKU, tier, and SLA for every resource. Advisor folds in Azure's own reliability and performance advice, DefenderRecommendations brings the security posture, and Azure Policy flags governance non-compliance with actual policies rather than vibes.

OutOfScope deserves real talk: a resource type azqr can't scan shows up on its own sheet instead of vanishing. When a compliance pass "looks clean," check OutOfScope first — a clean report with an empty inventory is a scan that didn't happen, and the skill names that explicitly. Slow scans get the same treatment: the troubleshooting table says a long-running scan is a reason to narrow scope to a resource group, not to stare at the spinner.

## The Key Vault Ladder

Expiry audits live on their own priority scale because a certificate that expired yesterday is an incident, while one expiring in 25 days is a calendar item. The skill spells out the boundaries: expired means rotate immediately; 0–7 days means within 24 hours; 8–30 days means within a week; no expiration date at all means apply a policy, because a null `expiresOn` is flagged as a security risk rather than ignored. Active items past 30 days just get monitored.

The rotation cadence in the reference is concrete: secrets every 60–90 days, keys annually, certificates per CA requirements with a one-year ceiling. Event Grid notifications 30 days in advance give you the lead time to schedule a rotation instead of discovering an outage. For incident mode, the emergency pattern scans for already-expired items — negative days — which is the difference between "we're down, find the cert" and rolling through a checklist.

## Skills That Surround It

azure-compliance pairs with the pack's other audit tools rather than overlapping them. [azure-cost](/skills/automation/azure-cost/) uses azqr as a gate for its optimize workflow, so the compliance scan results feed cost recommendations. [azure-validate](/skills/automation/azure-validate/) enforces that a deployment plan is actually Verified before release — compliance finds the problems, validation stops them reaching production in the first place. The Key Vault half also slots into [azure-storage](/tutorials/guides/azure-storage-procedural/) work: storage account keys and connection strings follow the same 60–90 day rotation rhythm the vault audit enforces.

## Start With One Subscription

Install with `npx skills add https://github.com/microsoft/azure-skills --skill azure-compliance`, run `az login`, and ask the agent to scan a non-production subscription. Ask it to show you the Recommendations sheet summary — severity counts, top three issues, suggested fixes — then run the Key Vault pattern against a single vault and compare its expiry ladder against your rotation calendar. If findings come back with concrete resource names and the OutOfScope sheet explains what it couldn't see, the skill is working; if it hands you vague "improve security" items, check that the scan actually completed before trusting the summary.