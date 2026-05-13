---
name: equity-analysis
description: Equity research report for a publicly traded stock — a two-phase workflow (input elicitation, then a sub-agent that writes a scored decision matrix, action grid, and falsifiable forecast to disk). Use when the user asks to analyze a stock, run equity research, evaluate a ticker, or decide buy/sell/hold (e.g. "analyze NVDA", "should I buy TSLA", "research PLTR"). User-invoked only; not auto-routed.
disable-model-invocation: true
allowed-tools: Task, WebSearch, WebFetch, Read, Write, Bash
---

# Equity Analysis

**Invocation:** user-invoked only (e.g. `/equity-analysis NVDA --horizon=long`). The skill is not auto-routed.

Orchestrate an equity research workflow in two phases: elicit inputs in the parent session, then spawn a research sub-agent that writes the report to disk.

## Phase 1: Elicit inputs (parent session)

Do not start web research yet. Parse `$ARGUMENTS` for any pre-supplied flags (see [references/arguments.md](references/arguments.md) for the full flag list), then ask the user only for what's missing.

**Required to proceed:** ticker, output directory.

**For the output directory**, ask:

> "Where should I save the report? Defaults to `~/research/equities/`. Provide a path or press enter for the default."

**For optional inputs**, ask them in a single combined prompt with defaults shown. If the user presses enter, accept defaults silently.

After elicitation:
1. Expand `~` in the output path. Create the directory with `mkdir -p -- "<path>"` — quote the path and use `--` to disable option parsing, so paths containing spaces or starting with `-` are handled safely.
2. Compute the filename: `{TICKER}_Analysis_{YYYY-MM-DD}_{HHMMSS}.md` (parent session's current local date and 24-hour time including seconds; `HHMMSS` avoids collisions on rapid same-day reruns).
3. Confirm: "Spawning research sub-agent for **{TICKER}**, output to **{PATH}/{FILENAME}**. This takes 2–4 minutes. Proceed? (yes/no)"
4. On confirmation, proceed to Phase 2.

## Phase 2: Spawn the research sub-agent

Use the **Task tool** with `subagent_type: general-purpose`. **Do not specify a model** — the sub-agent inherits the parent session's model and effort level.

The Task prompt must contain:

1. All collected inputs (ticker, output path, horizon, position state, cost basis, risk tolerance, peers, sections flag, sector flag)
2. Today's date
3. An instruction to read [references/research-protocol.md](references/research-protocol.md) for what searches to run
4. An instruction to read [references/report-template.md](references/report-template.md) for the exact output structure
5. An instruction to read [references/calibration.md](references/calibration.md) for tone, formatting rules, and analytical pitfalls
6. An instruction to return only a concise summary (≤10 lines) to the parent

When the sub-agent returns, print its summary verbatim. Do not re-elaborate.

## Return summary format (sub-agent → parent)

```
✅ Report saved: {output_file_path}

{TICKER} · Composite {score} · {HEADLINE_RECOMMENDATION}
Support: \${support} · Resistance: \${resistance}
Overall bias: {bias}
Headline: {one-sentence single-most-important finding}
```

## Example

Invocation:

```
/equity-analysis NVDA --horizon=long --risk=conservative --output=~/research/equities/
```

Phase 1 confirms inputs (no further questions needed — all flags supplied). Phase 2 spawns the sub-agent, which writes `~/research/equities/NVDA_Analysis_2026-05-13_143215.md` and returns:

```
✅ Report saved: /Users/you/research/equities/NVDA_Analysis_2026-05-13_143215.md

NVDA · Composite +2.3 · BUY
Support: \$88.50 · Resistance: \$142.00
Overall bias: Bullish
Headline: GPU cycle recovery momentum offsetting macro headwinds; insider accumulation signals confidence.
```

A bare `/equity-analysis NVDA` works too — Phase 1 will prompt for the output path and any other flags it needs.

## Supporting files

- [references/arguments.md](references/arguments.md) — flag parsing reference
- [references/research-protocol.md](references/research-protocol.md) — required searches and grounding rules
- [references/report-template.md](references/report-template.md) — full output structure, scoring matrix, and section spec
- [references/calibration.md](references/calibration.md) — tone, formatting rules, and pitfalls to avoid

## Pitfalls

- Don't skip Phase 1 — always ask for the output path even if the user only provided a ticker.
- Don't default-override a user-specified output path.
- Don't specify a model in the Task call — inherit from session.
- See [references/calibration.md](references/calibration.md) for analytical pitfalls the sub-agent should avoid.
