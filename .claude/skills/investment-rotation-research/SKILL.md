---
name: investment-rotation-research
argument-hint: [sector, theme, or rotation thesis]
description: Investment research for a sector/theme with dual-track picks (one ETF + one single name per realm), backed by a fundamental decision matrix and a technical entry-confidence overlay. Use when the user asks to research a sector rotation, evaluate a theme, find ETF + single-name picks, or apply dual-layer scoring (e.g. "research the silver theme", "rotation into power names", "AI infrastructure picks"). User-invoked only; not auto-routed.
disable-model-invocation: true
allowed-tools: Task, WebSearch, WebFetch, Read, Write, Bash
---

# Investment Rotation Research

**Invocation:** user-invoked only (e.g. `/investment-rotation-research silver`, `/investment-rotation-research "AI infrastructure" --output=~/research/rotations/`). The skill is not auto-routed.

Orchestrate a sector/theme investment-rotation research workflow in two phases: elicit inputs in the parent session, then spawn a research sub-agent that screens for entry quality first, applies a fundamental decision matrix to the survivors, picks one ETF + one single name per realm, and writes a publishable article to disk.

## The core inversion (why two phases)

A naive workflow goes: thesis → candidate picks → validate with technicals. This workflow inverts that — entry-quality signals screen the universe first, then fundamental scoring is applied to the survivors. Phase 1 (parent session) frames the request and confirms inputs; Phase 2 (sub-agent) runs the inverted workflow end-to-end. See [references/research-protocol.md](references/research-protocol.md) for the full rationale.

## Phase 1: Elicit inputs (parent session)

Do not start web research yet. Parse `$ARGUMENTS` for the realm/theme string and any flags (see [references/arguments.md](references/arguments.md) for the full flag list), then ask the user only for what's missing.

**Required to proceed:** realm/theme, output directory.

**For the realm/theme:** If `$ARGUMENTS` is empty or vague (no identifiable realm), ask **one** focused clarifying question that covers realm(s) AND any priming thesis. Do not split into multiple questions — single combined prompt. (See pitfalls below.)

**For the output directory**, ask:

> "Where should I save the report? Defaults to `~/research/rotations/`. Provide a path or press enter for the default."

After elicitation:
1. Expand `~` in the output path. Create the directory with `mkdir -p -- "<path>"` — quote the path and use `--` to disable option parsing, so paths containing spaces or starting with `-` are handled safely.
2. Derive the theme slug: lowercase, replace spaces and `/` with `-`, strip remaining punctuation (see [references/arguments.md](references/arguments.md) for the exact rule).
3. Compute the filename: `Rotation_{theme-slug}_{YYYY-MM-DD}_{HHMMSS}.md` (parent session's current local date and 24-hour time including seconds; `HHMMSS` avoids collisions on rapid same-day reruns).
4. Confirm: "Spawning research sub-agent for **{theme}**, output to **{path}/{filename}**. Expect 4–8 minutes for a typical 1–3 realm analysis. Proceed? (yes/no)"
5. On confirmation, proceed to Phase 2.

## Phase 2: Spawn the research sub-agent

Use the **Task tool** with `subagent_type: general-purpose`. **Do not specify a model** — the sub-agent inherits the parent session's model and effort level.

The Task prompt must contain:

1. All collected inputs (realm/theme string, priming thesis if any, absolute output path, full filename)
2. Today's date
3. An instruction to read [references/research-protocol.md](references/research-protocol.md) for the core inversion, workflow phases 0–4, entry confidence rubric, fundamental decision matrix, and research sources
4. An instruction to read [references/report-template.md](references/report-template.md) for the exact output structure
5. An instruction to read [references/calibration.md](references/calibration.md) for tone, formatting rules, and analytical pitfalls
6. An instruction to return only a concise summary (≤15 lines) to the parent

When the sub-agent returns, print its summary verbatim. Do not re-elaborate.

## Return summary format (sub-agent → parent)

```
✅ Report saved: {output_file_path}

Theme: {theme}
{REALM 1}: ETF {ticker} ({conf}% COLOR) | Single {ticker} ({conf}% COLOR)
  Action: {one-line action}
{REALM 2}: ETF {ticker} ({conf}% COLOR) | Single {ticker} ({conf}% COLOR)
  Action: {one-line action}
Pattern flag: {one cross-realm honest observation}
```

If a realm lacks a viable ETF pick (no basket above 17/25), the sub-agent flags this in the realm row (e.g. `ETF: none viable — paired two single names instead`).

## Example

Invocation:

```
/investment-rotation-research silver --output=~/research/rotations/
```

Phase 1 confirms output path with default; if `silver` is identifiable as a realm, no further questions. Phase 2 spawns the sub-agent, which writes `~/research/rotations/Rotation_silver_2026-05-13_143215.md` and returns:

```
✅ Report saved: /Users/you/research/rotations/Rotation_silver_2026-05-13_143215.md

Theme: silver
Silver: ETF SIVR (72% ✅ GREEN) | Single AG (54% ⚠️ YELLOW)
  Action: Build SIVR now (60–70%). Defer AG sizing until after May 12 earnings.
Pattern flag: Insider selling at AG accelerated to ~\$100M trailing 12M while price ran 80%. Smart money already moved.
```

A bare `/investment-rotation-research` works too — Phase 1 elicits the realm via the single combined question.

## Supporting files

- [references/arguments.md](references/arguments.md) — argument parsing, the one-question rule, and theme-slug derivation
- [references/research-protocol.md](references/research-protocol.md) — core inversion, workflow phases, entry confidence rubric, fundamental decision matrix, research sources
- [references/calibration.md](references/calibration.md) — important behaviors, tone rules, writing principles, common scoring mistakes
- [references/report-template.md](references/report-template.md) — full markdown output structure, section by section

## Pitfalls

- **The "one clarifying question" rule is intentional.** If the realm is vague, ask ONE focused question that covers realm(s) and any priming thesis. The deliberate UX rule is "do not ask three questions."
- **Don't default-override a user-specified output path.**
- **Don't specify a model in the Task call** — inherit from session.
- **The bullion-ETF scoring exception** (Backlog and Margin marked n/a, scored out of 15 instead of 25) is documented inline in [references/research-protocol.md](references/research-protocol.md). Keep it inline with the criteria it modifies if editing.
- See [references/calibration.md](references/calibration.md) for analytical pitfalls the sub-agent should avoid.
