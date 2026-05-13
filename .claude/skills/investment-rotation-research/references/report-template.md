# Report Template

The sub-agent writes a single Markdown file to the exact path passed in by the parent session (pattern: `{OUTPUT_DIR}/Rotation_{theme-slug}_{YYYY-MM-DD}_{HHMMSS}.md`) using the structure below, in this order. Length: 8–15 printed pages typical. The TL;DR should be scannable in under 30 seconds — a reader should be able to identify the picks and their entry confidence from the first section alone.

## Color/emphasis conventions

Use color emojis for the GREEN/YELLOW/RED entry-confidence labels (only here — they communicate the color band cleanly in markdown; do not sprinkle emojis elsewhere):

- GREEN: bold + leading emoji ✅ or a `> GREEN` blockquote tag
- YELLOW: bold + leading emoji ⚠️ or a `> YELLOW` blockquote tag
- RED: bold + leading emoji ⛔ or a `> RED` blockquote tag

## Section 1: Title block

Four lines:

```
> MARKET ANALYSIS | [THEME] | [VERSION OR DATE IDENTIFIER]

# [Headline of the research]

*[One-sentence description of the analytical approach]*

Published [DATE]  |  Technicals as of market close [DATE]
```

## Section 2: TL;DR with entry confidence

The most important section. A reader should be able to identify the picks and their entry quality from this section alone.

Open with one short paragraph framing the dual-track approach. Then:

*Confidence framing note (italic):* one sentence noting that confidence scores blend technicals, flows, insider activity, valuation, and catalysts — and are not statistical probabilities.

**The TL;DR table.** Five columns:

| Realm | Type | Ticker | Entry Conf. | One-Line Read |

Each realm gets two rows: one for the ETF pick, one for the single-name pick. Add a third row if a defensive complement is included.

In the **Entry Conf.** cell, label like `70% ✅ GREEN`, `58% ⚠️ YELLOW`, or `32% ⛔ RED`.

In the **One-Line Read** cell, write a 12–20 word characterization combining current state and action. Examples:
- "Off 29% from Feb peak. Cleanest macro proxy; cheapest expense ratio (0.30%). Watch CPI catalyst."
- "Best business, worst price. Insiders dumped ~\$100M last year. Wait for pullback to \$980–1000."
- "Do not chase. Q1 loss, overbought RSI, analyst targets BELOW current price."

**Ranked best-entry-today list** (right below the table). Brief intro sentence followed by bullets ranked by entry confidence, formatted as:

`[TICKER] (XX%) — [12–15 word characterization]`

End the TL;DR with a one-paragraph disclaimer in italic.

## Section 3: The thesis

Two to four paragraphs explaining the underlying investment thesis driving the picks. If a priming article exists, cite it. If not, derive the thesis from current market structure.

Cover:
- The setup (what the thesis claims will happen)
- Why now (macro tailwinds or sector inflection)
- The "kicker" (the strongest argument for the thesis)

Write like a senior analyst briefing a portfolio manager, not academic prose.

## Section 4: Methodology

Two clearly labeled subsections:

**Layer 1: Fundamental Decision Matrix.** Lead paragraph explaining the 25-point scoring (or 15-point for commodity ETFs). Bullet the five criteria with one-line definitions.

**Layer 2: Entry Confidence Read.** Lead paragraph explaining the 0–100% synthesis. Bullet the five components. End with one sentence on color thresholds (65+ GREEN, 50–64 YELLOW, <50 RED).

## Section 5: Per-realm deep dive

One H1 (`#`) section per realm. Inside each:

**5.1 Realm context** — Two to three paragraphs. Macro context (supply/demand setup, regulatory backdrop), recent price action across the sector, why this realm is in the thesis at all.

**5.2 Decision matrix table** — All candidates in this realm with their fundamental scores. Eight columns:

| Ticker | Type | Pure | Back | Marg | Val | Cat | Total |

Bold the selected ETF pick and the selected single-name pick rows; show their total scores in bold. For physical-commodity ETFs (bullion trackers), show "n/a" in Backlog and Margin columns and score them out of 15.

**5.3 ETF pick deep dive**

H3 heading: `### ETF Pick: [TICKER] — [Full Name]`

Two H4 subsections:

*Thesis Fit* — Two paragraphs: what the ETF actually holds; why it's the right basket for this trade; competing ETFs you considered and rejected (and why); cost or structural advantages (expense ratio, AUM, liquidity).

*Entry Read: [XX%] [COLOR] — [Short Characterization]* — Three paragraphs: current price, % from 52-week high, technical state (RSI, MA alignment, trend); institutional/fund flow data; specific entry guidance (`Best entry zone: [price level]`) and catalysts.

**5.4 Single-name pick deep dive**

Same H3 + H4 structure.

*Thesis Fit* — Two paragraphs: what the company does and how it captures the thesis; recent quarterly evidence (orders, backlog, margins); specific products/segments driving sector exposure; trade-offs (operational risk, geographic concentration, execution dependencies).

*Entry Read* — Three to four paragraphs: technical state (price, % from high, RSI, MA alignment, support); institutional positioning (ownership %, recent changes, notable holders); insider activity — explicit and quantified, naming executives where behavior is notable; valuation vs. analyst targets (flag any consensus-below-current-price); specific entry guidance with price levels.

**5.5 Defensive complement (when applicable)** — Include a third pick if the realm lacks a good basket option (ETF scored below 17/25), if a second single name offers genuine portfolio balance (low-beta + high-beta pair), or if the user benefits from the optionality.

**5.6 Suggested pairing** — One paragraph with a **bolded lead** recommending the position-size ratio (e.g., "**60–70% SIVR / 30–40% AG**"). Explain — typically that the ETF anchors macro thesis and the single name provides torque, with weighting adjusted by entry-confidence gap.

**5.7 Signals to watch** — Bulleted list of 4–6 specific things to monitor. Concrete and observable, not vague. Good:
- "April CPI print: if YoY exceeds 3-month T-bill yield, the negative-real-rates thesis activates"
- "GEV quarterly electrification order intake. Q1 was the tell; another step-up in Q2 confirms thesis."

Avoid vague signals like "watch the macro" or "monitor sentiment."

## Section 6: Cross-realm summary

Two paragraphs synthesizing patterns across realms. What does the analysis collectively reveal? Where are the strongest and weakest entries?

**Final Picks at a Glance** — Summary table:

| Realm | ETF Pick | Single Pick | Entry Conf. | Suggested Action |

The **Suggested Action** column is critical — one concrete instruction per row:
- "Build SIVR now (60–70%). Defer AG sizing until after May 12 earnings."
- "Build LIN now (70%). Hold CC slot at 30%; defer purchase until \$22–24."

**Position Sizing Across the Realms** — One to two paragraphs on whether equal-dollar allocation makes sense or whether thesis-weighted allocation is more honest. Address correlation between the realms.

**Two Patterns Worth Flagging** — Two bolded callouts on cross-cutting observations. Keep them sharp; this is where the report says what most other research won't.

## Section 7: What breaks the thesis

A short bear-case stress test. Open with one sentence framing this as honest risk disclosure. Then three bulleted scenarios with bolded leads:

- **Scenario name:** One to two sentences explaining how this scenario would damage the thesis and which picks would be hit first.

Common scenarios: Fed/macro pivot; demand-side disappointment (capex slowdown, end-customer pullback); sentiment shift (multiple compression even with fundamentals intact); regulatory action; geopolitical disruption.

## Section 8: Honest meta-observation

One to two paragraphs. This is where the report says the thing that's true but uncomfortable. Common version: "These are already crowded trades. [Names] are up [%] in [period]. The framing implies another leg up, but you're not buying at consensus-skeptical levels — you're paying for a thesis the smart money already moved on."

Close with a one-paragraph statement of why the dual-track structure helps hedge this exact risk.

## Section 9: Disclaimer

At the very end, in italic, separated by a horizontal rule:

> *This document is analytical research, not financial advice. It applies a structured framework — fundamental decision matrix plus technical entry confidence overlay — to identify candidate vehicles for expressing the underlying thesis. All scoring is subjective and based on publicly available information as of [DATE]. Confidence scores synthesize technical signals, institutional flows, insider activity, valuation, and catalyst proximity; they are not statistical probabilities of success. Past performance does not predict future results. Conduct your own due diligence and consult a licensed financial advisor before making investment decisions. The author holds no positions in any securities mentioned at the time of writing.*

## After writing the file

Return the concise summary (≤15 lines) to the parent in the format defined in `SKILL.md` (Return summary format). The parent prints it verbatim. Do not open or render the report — the user reviews it on their own. If they want a `.docx` version, they can run `pandoc <file>.md -o <file>.docx` themselves.
