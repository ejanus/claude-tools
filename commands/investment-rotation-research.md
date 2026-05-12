---
description: Research investment picks (ETF + single-name) for a sector/theme with dual-layer scoring and entry-timing confidence
argument-hint: [sector, theme, or rotation thesis]
---

# Investment Rotation Research

**User request:** $ARGUMENTS

You are running a structured, two-phase investment research workflow. Produce a publishable financial analysis document with dual-track picks (one ETF + one single-name per realm) backed by a fundamental decision matrix and a technical entry-timing confidence overlay.

If `$ARGUMENTS` is empty or vague, ask **one** focused clarifying question to pin down the realm(s) and any priming thesis. Do not ask three questions. Then proceed.

---

## The core inversion

A naive workflow goes: thesis → candidate picks → validate with technicals. This workflow inverts that:

1. **Screen for entry quality first** across the candidate universe — technicals, institutional flows, insider activity, valuation gaps. Names with strong setups bubble to the top *before* fundamental scoring begins.
2. **Then apply the fundamental decision matrix** to the screened survivors. This prevents the failure mode of identifying a "great business" that is a terrible buy at current prices.
3. **Then synthesize the dual-track picks** (ETF + single name per realm) with explicit entry guidance.

The reason for this ordering: fundamental analysis is path-independent (a company's moat is roughly the same Tuesday as Wednesday), but entry quality is highly time-sensitive (an RSI of 75 today might be 50 next month after a pullback). Starting with time-sensitive signals ensures the picks you surface are *actionable now*, not just theoretically attractive.

The workflow is **thesis-flexible**: if the user provides a thesis (priming article, macro view, strategist call), incorporate it as framing. If not, derive the implicit thesis from their request and current market structure.

---

## Workflow

Run these phases in order. Each phase has a clear input and output.

### Phase 0: Frame the research

Before any web searches, establish:

- **Realm(s):** What are the 1–4 sectors/sub-themes the analysis will cover? (e.g., "silver, power, chemicals" or just "AI infrastructure")
- **Thesis (if any):** Was a priming article or strategist view provided? If yes, capture it briefly. If no, generate a 2–3 sentence working thesis from the user's request and current market context.
- **Universe per realm:** Identify 4–7 candidate tickers per realm before filtering. Include both ETFs (broad basket + thematic) and single names (pure-play + diversified leader). Do not skip this step — a too-narrow universe biases the picks toward names you already know.

### Phase 1: Entry-quality screen (signals first)

For each candidate in the universe, gather the following signals via `WebSearch` (and `WebFetch` for specific pages). **Run searches in parallel where possible.** Do not skip a category — the absence of data is itself a signal. Phase 1 typically needs 15–25 distinct searches; do not economize on searches at the cost of data quality.

For each ticker, you need:

1. **Technical state** — Current price, 52-week high/low, % from peak, 14-day RSI, MA20/50/100/200 alignment, recent trend characterization, key support and resistance.
2. **Institutional flow** — Institutional ownership %, QoQ direction (accumulating or distributing?), top-holder activity (e.g., "Vanguard increased 2.33%"), and for ETFs: net fund flows over 1W/1M/3M/1Y.
3. **Insider activity** — Net buying vs. selling over last 12 months (dollar amount if available), notable single transactions (size + price), CEO/CFO behavior specifically.
4. **Analyst view** — Consensus price target vs. current, recent rating changes (upgrades/downgrades), high and low targets (spread = confidence).
5. **Near-term catalysts** — Next earnings date, sector-relevant macro prints (CPI, Fed meetings), industry events within 30–60 days.

See **§ Research Sources** below for which sites to search for each signal type, with example query phrasings.

**Output of Phase 1:** A signal table per candidate, then an **Entry Confidence Score (0–100%)** per candidate using the rubric in **§ Entry Confidence Rubric** below. This score is the bubble-up mechanism — high-confidence names get prioritized in Phase 2.

### Phase 2: Fundamental decision matrix (on screened survivors)

Take the top 3–5 candidates per realm by entry confidence and score each on the 5-criterion fundamental matrix:

1. **Purity of Exposure** (1–5): Does the thesis directly drive this name?
2. **Backlog / Demand Signal** (1–5): Hard contracted demand visible in financials?
3. **Margin Trajectory** (1–5): Can they capture the bottleneck premium?
4. **Valuation Discipline** (1–5): Already priced for perfection, or room to run?
5. **Catalyst Proximity** (1–5): What pays in 6–12 months vs. waiting years?

For physical-commodity ETFs (e.g., bullion trackers), criteria 2 and 3 don't apply — score on the 3 applicable criteria (15 max instead of 25).

See **§ Fundamental Matrix Rubric** below for scoring guidance, anchoring examples, and edge cases.

**Output of Phase 2:** A scored matrix per realm. The highest combined fundamental + entry-confidence score becomes the ETF pick or single-name pick for that realm.

### Phase 3: Dual-track pick synthesis

For each realm, select **one ETF and one single name.** This is non-negotiable structure — even if a basket option is weak, the deliverable explicitly uses the dual-track framing.

- **ETF pick:** Highest fundamental score among ETF candidates, with entry confidence as the tiebreaker.
- **Single-name pick:** Highest fundamental score among single-name candidates, with entry confidence as the tiebreaker.
- **Suggested pairing ratio:** Inversely weighted by entry-confidence gap. If both names score 65%+, suggest balanced (50/50). If one is meaningfully better (15+ point gap), tilt toward the higher-confidence pick (60/40 or 70/30).
- **Note when the ETF is weak:** If no ETF in a realm scores above 17/25, flag this explicitly and propose pairing two single names instead. This is honest analysis — don't force a weak basket pick just for structural completeness.

### Phase 4: Build the article

Use the structure in **§ Output Template** below. The deliverable is a polished markdown file written to the current working directory, named `investment-research-<theme>-<YYYY-MM-DD>.md` (replace spaces in `<theme>` with hyphens). Report the path back to the user when complete.

If the user later wants a `.docx`, they can run `pandoc <file>.md -o <file>.docx`.

---

## Important behaviors

**Be wary of crowded trades.** If the candidates are all up 50%+ year-over-year, say so explicitly in the meta-observation. The user deserves to know they're paying for a thesis that the smart money already moved on.

**Insider selling is information, not a verdict.** Executives diversify, exercise options, fund lifestyles — but $100M+ of net selling at a single name over 12 months is meaningful and should be flagged. Quantify it. Don't editorialize beyond what the numbers say.

**Distinguish ETF expense ratios.** For commodity trackers especially, the 20–30 bps gap between competing ETFs (e.g., SIVR 0.30% vs. SLV 0.50%) compounds on multi-year holds. Always state the expense ratio in the ETF pick rationale.

**Be honest when an entry is bad.** A 30% RED confidence score with an explicit "do not chase" is more valuable than a softened recommendation. If the analyst consensus target is below the current price, say so — that's a rare signal worth flagging.

**Never invent specific numbers.** If a search doesn't return precise data (e.g., exact institutional ownership %), say "approximately" or "not disclosed" rather than fabricating. Confidence scores are subjective synthesis — but underlying data points (RSI, price, % from high) must be real.

**Stay non-advisory.** Include a disclaimer at the top of the TL;DR and at the bottom of the document. Never use language like "you should buy" — frame as "entry conditions are constructive" or "best risk-adjusted setup."

**Catalyst calendar matters.** If a candidate has earnings within a week, that's a binary catalyst that should defer sizing decisions. Surface this prominently in the entry read.

**Use current data.** Today's market data is essential — never rely on training data for prices, RSI, institutional flows, or earnings dates. Always search for current values. When formulating queries, use the current month and year; stale queries return stale results.

---

## § Entry Confidence Rubric

This is the "bubble-up" mechanism that screens candidates before fundamental scoring. It synthesizes time-sensitive signals into a single score (0–100%) representing how attractive the entry looks *today*.

### Component weights

Each component contributes up to 20 points. Total range is 0–100.

| Component | Weight | What you're measuring |
|---|---|---|
| Technical setup | 20 | Is the chart constructive or extended? |
| Institutional flow | 20 | Smart money accumulating or distributing? |
| Insider activity | 20 | What are the executives doing? |
| Analyst targets | 20 | Room to run, or already past consensus? |
| Catalyst proximity | 20 | Near-term events that could move the name? |

### Scoring per component

**Technical setup (0–20)**
- **18–20:** Pulled back 20–40% from recent high, RSI neutral (40–55), longer-term MAs intact, finding support. *Classic "wait for the pullback" entry has arrived.*
- **14–17:** Either consolidating after a run (RSI mid-50s, mixed MAs) or in a strong uptrend with reasonable RSI (under 65). Constructive but not screaming.
- **10–13:** Trading near 52-week highs with RSI 60–70. Trend intact but you're paying up. Momentum risk both directions.
- **5–9:** RSI 70+, parabolic move, no consolidation. *Overbought; chasing.*
- **0–4:** Breaking down through major support, RSI <30 in a downtrend (catching a falling knife), or technical structure has cracked.

**Institutional flow (0–20)**
- **18–20:** Accelerating accumulation. Top holders increasing positions. For ETFs: AUM growth rate increasing month-over-month.
- **14–17:** Stable, high institutional ownership (70%+) with mild QoQ increases. For ETFs: steady positive flows.
- **10–13:** Neutral — institutional ownership holding flat. No strong signal.
- **5–9:** Net institutional distribution over multiple quarters. For ETFs: persistent outflows.
- **0–4:** Heavy distribution, top holders trimming aggressively, or — for ETFs — accelerating outflows.

**Insider activity (0–20)**
- **18–20:** Net insider buying over the last 12 months, especially CEO-level. *Rare and bullish.*
- **14–17:** Roughly balanced or no notable activity. Some option exercises but not material selling.
- **10–13:** Modest net selling that could plausibly be diversification (<$5M for a mid-cap; scale to size).
- **5–9:** Significant net selling ($10M–$100M depending on company size), CEO selling material chunks of their holding.
- **0–4:** $100M+ of net insider selling at all-time highs, CEO repeatedly selling, or pattern of executives exiting. *Red flag.*

For ETFs: insider activity doesn't apply. Reallocate that 20 points to institutional flow (flow becomes 40 of the available 100).

**Analyst targets (0–20)**
- **18–20:** Consensus target 15%+ above current, recent upgrades, narrowing spread (high agreement). Multiple firms raising targets.
- **14–17:** Consensus target 5–15% above current, stable or rising.
- **10–13:** Consensus target within ±5% of current. Stock has caught up to analyst expectations.
- **5–9:** Consensus target *below* current price. Some analysts cutting targets. Wide spread (disagreement).
- **0–4:** Consensus meaningfully below current, multiple downgrades, high/low target spread wider than 50% of current price.

**Catalyst proximity (0–20)**
- **18–20:** Multiple identifiable positive catalysts within 30–90 days (earnings + sector macro print + industry event), with the setup positioned to benefit.
- **14–17:** One clear near-term catalyst that could drive the name higher (e.g., upcoming earnings with low bar, sector ETF rebalancing).
- **10–13:** No specific catalyst within 30 days but macro setup is supportive.
- **5–9:** Binary risk event within 7 days (earnings with high expectations) — defer sizing decisions.
- **0–4:** Negative catalyst pending (regulatory action, refinancing wall, dividend cut risk).

### Color thresholds

- **65–100: GREEN** — Constructive entry. Build the position at current levels.
- **50–64: YELLOW** — Proceed with caution. Smaller position or wait for specific signal.
- **0–49: RED** — Do not chase. Wait for better entry.

### Sanity checks

If your score ends up in the 70s+ but the stock has tripled in the last 12 months, reconsider — momentum exhaustion is real risk. Conversely, if your score is low but the underlying thesis is strong, that may be a "great business, bad price" pattern — note it for re-evaluation later.

---

## § Fundamental Matrix Rubric

Applied only to candidates that bubble up from Phase 1. Five criteria, 1–5 each, 25 max.

**Criterion 1: Purity of Exposure** — How directly does the thesis drive this name's revenue and earnings?
- **5:** Pure-play. 80%+ of revenue tied to the thesis.
- **4:** Heavy exposure but not exclusive. 50–80% of revenue.
- **3:** Significant but diversified exposure. 25–50% of revenue.
- **2:** Tangential exposure. Thesis matters at the margin but isn't the main driver.
- **1:** Token exposure. Marketing-driven, not financial.

**Criterion 2: Backlog / Demand Signal** — Hard contracted demand visible in the financials.
- **5:** Multi-year backlog, sold out through forward periods, orders accelerating QoQ.
- **4:** Record backlog, orders growing meaningfully YoY (20%+).
- **3:** Healthy demand but not a backlog-driven business; revenue visibility 1–2 quarters out.
- **2:** Demand uncertain or lumpy. Revenue more dependent on price than volume.
- **1:** Declining demand or no contracted visibility.

For commodity ETFs (physical bullion): this criterion doesn't apply. Mark "n/a" and score on 4 criteria (max 20).

**Criterion 3: Margin Trajectory** — Can the company capture pricing premium as the thesis plays out?
- **5:** Structural margin expansion underway. Pricing power evident in recent quarters. Operating leverage.
- **4:** Margins expanding YoY. Some pricing power.
- **3:** Stable margins. Neither expansion nor compression.
- **2:** Mild margin pressure. Input cost inflation outpacing pricing.
- **1:** Significant margin compression. Operating losses or rapidly declining gross margins.

For commodity ETFs: this criterion doesn't apply.

**Criterion 4: Valuation Discipline** — Where is the stock relative to its history and peers?
- **5:** Trading at a discount to peers and historical median multiples. Margin of safety present.
- **4:** Fair value. P/E or EV/EBITDA roughly in line with growth.
- **3:** Slightly elevated but defensible. Premium for quality.
- **2:** Stretched. Trading at 1.5–2× historical median. Priced for continued execution.
- **1:** Bubble-like. 2×+ historical multiples. Any disappointment is severely punished.

**Criterion 5: Catalyst Proximity** — What happens in the next 6–12 months that could re-rate the stock?
- **5:** Multiple identifiable catalysts within 6 months.
- **4:** One major catalyst expected within 6 months.
- **3:** Slow-burn thesis. Catalysts exist but timing uncertain.
- **2:** Long-duration thesis with no near-term catalysts. Pays off in years, not months.
- **1:** No clear catalysts. Story stock waiting for something to happen.

### Anchoring examples

- **Pure-play silver miner during a silver bull run:** Purity 5, Backlog 3 (mining isn't backlog-driven), Margin 4 (operational leverage), Valuation 3, Catalyst 4. **Total: 19/25.**
- **Industrial gas oligopolist during AI buildout:** Purity 3 (AI is one of many customers), Backlog 4 (long-term supply contracts), Margin 5 (durable pricing power), Valuation 2 (premium to peers), Catalyst 3. **Total: 17/25.**
- **Physical silver ETF:** Purity 5, Backlog n/a, Margin n/a, Valuation 5 (no equity premium), Catalyst 5 (CPI/Fed sensitive). **Total: 15/15.**
- **Highly extended single name in a hot sector:** Purity 5, Backlog 5, Margin 4, Valuation 2, Catalyst 5. **Total: 21/25** — but pair with poor entry confidence (likely 50% or below) and the result is "great business, wait for pullback."

### Combining the two layers

- **High fundamental + High entry:** Build the position now. Ideal.
- **High fundamental + Low entry:** Watch list. Set price alerts at better entry zones.
- **Low fundamental + High entry:** Probably noise. The market is rallying a mediocre name temporarily.
- **Low fundamental + Low entry:** Skip entirely.

For dual-track pick selection in Phase 3, weight roughly 60/40 fundamental/entry. A 22/25 fundamental with 50% entry can still be a defensible pick — note "wait for pullback" in the suggested action. A 17/25 fundamental with 75% entry probably means there's a better pick you haven't found.

### Common scoring mistakes to avoid

- **Confusing thesis intensity with purity.** A company can be loudly marketed as an "AI play" without 50% of revenue from AI. Use financials, not press releases.
- **Treating recent stock performance as a fundamental signal.** Up 100% in a year tells you about sentiment, not backlog quality.
- **Forgetting ETFs need their own purity check.** An "AI ETF" holding 30% Apple and Microsoft is not pure-play. Read the holdings.
- **Letting valuation score do all the work.** A cheap stock is often cheap for a reason. Pair valuation with the other four criteria.
- **Ignoring the "what breaks the thesis" question.** Thesis fragility belongs in your scoring — likely as a Catalyst Proximity haircut or as a caveat in the article.

---

## § Research Sources

Search philosophy: run searches in parallel; use the current year/month in queries; be specific about the data point (e.g., "AAPL RSI moving average [current month] 2026", not "AAPL technical analysis"); if a site returns stale data, try another source.

### Technical state
- `investing.com/equities/<ticker>-technical` — daily/weekly RSI, MACD, MA composite signals, pivot points
- `tradingview.com/symbols/<exchange>-<ticker>/technicals/` — oscillator and MA breakdowns
- `stockinvest.us/stock/<ticker>` — plain-English trend characterization, S/R levels
- `barchart.com/stocks/quotes/<ticker>/technical-analysis`
- `stockanalysis.com/stocks/<ticker>/`
- `finance.yahoo.com/quote/<ticker>/`

Example queries:
- `[TICKER] stock technical analysis RSI moving average [current month year]`
- `[TICKER] stock price 52-week high consolidation [current year]`
- `[TICKER] support resistance levels chart analysis`

Extract: current price + day range; 52-week high/low and % from high; 14-day RSI; MA20/50/100/200 alignment; one-sentence trend characterization.

### Institutional flow
- `marketbeat.com/stocks/<exchange>/<ticker>/institutional-ownership/` — 13F summary
- `gurufocus.com/stock/<ticker>/ownership` — historical institutional trend
- `tipranks.com/stocks/<ticker>` — hedge fund / institutional sentiment
- `tradingkey.com/markets/stocks/<exchange>-<ticker>/stock-analysis` — institutional score with QoQ changes
- For ETFs: `etfdb.com/etf/<ticker>/` — net fund flows
- For ETFs: official issuer pages (defianceetfs.com, ishares.com, etc.) — AUM, recent activity

Example queries:
- `[TICKER] institutional ownership 13F filings [current year]`
- `[TICKER] hedge funds buying selling latest quarter`
- `[ETF TICKER] fund flows AUM [current month year]`

Extract: total institutional ownership %; direction last quarter; notable single-firm changes (Vanguard, BlackRock, named active managers); for ETFs, net flows over 1W/1M/3M/1Y windows — *acceleration* is a stronger signal than absolute level.

### Insider activity
- `simplywall.st/stocks/us/<sector>/<exchange>-<ticker>/<company>` — net insider activity with dollar amounts
- `gurufocus.com/stock/<ticker>/ownership` — insider ownership history
- `marketbeat.com/stocks/<exchange>/<ticker>/insider-trades/` — Form 4 filings
- `openinsider.com` — real-time Form 4 aggregation

Example queries:
- `[TICKER] insider trading buying selling last 12 months [current year]`
- `[TICKER] CEO Form 4 filings stock sales`
- `[TICKER] executives selling shares [current year]`

Extract: net buy/sell dollar amount over 12 months; largest single transactions (size + price + who); CEO specifically — separate from board members. Note: insiders selling at all-time highs is common (diversification, option exercises); magnitude matters more than direction.

### Analyst view
- `marketbeat.com/stocks/<exchange>/<ticker>/forecast/`
- `stockanalysis.com/stocks/<ticker>/forecast/`
- `tipranks.com/stocks/<ticker>` — Smart Score and analyst consensus
- `wallstreetzen.com/stocks/us/<exchange>/<ticker>/stock-forecast`
- `simplywall.st/stocks/us/<sector>/<exchange>-<ticker>` — includes fair value estimates

Example queries:
- `[TICKER] analyst price target consensus [current year]`
- `[TICKER] Wall Street rating upgrade downgrade [current month year]`
- `[TICKER] forecast 12-month price target`

Extract: consensus target + % upside/downside vs. current; number of analysts; high/low spread (wide spread = disagreement = lower confidence); recent upgrades/downgrades within last 30 days. **Red flag:** consensus target *below* current price — rare and meaningful; flag it prominently.

### Near-term catalysts
- `finance.yahoo.com/quote/<ticker>/` — next earnings date
- `investing.com/equities/<ticker>` — upcoming earnings + dividend dates
- `benzinga.com/calendars/earnings` — earnings calendar
- Macro: `investing.com/economic-calendar/` or `tradingeconomics.com/calendar`
- Sector events: company IR pages, industry trade press

Example queries:
- `[TICKER] next earnings date [current year]`
- `[SECTOR] upcoming catalysts [current and next month year]`
- `[TICKER] investor day product launch announcement`

Extract: next earnings date (within 7 days = binary catalyst); any relevant macro print within 30 days (CPI, Fed, OPEC, etc.); industry conferences or company-specific events.

### ETF-specific considerations

- Skip insider activity (ETFs don't have insiders).
- Fund flows replace institutional ownership as the primary flow signal.
- Expense ratio matters disproportionately for commodity trackers — often the deciding factor (e.g., SIVR 0.30% vs. SLV 0.50%).
- AUM growth rate is the key adoption signal — newer thematic ETFs going from $100M to $500M in months are accelerating; mature ETFs with flat AUM are not.
- Always read the top holdings list. An "AI infrastructure" ETF holding regulated utilities is misnamed.

### Edge cases

- **Multiple listings:** Use the U.S. listing for U.S.-focused analysis. Note when material activity happens on the other exchange.
- **Recent IPO or spin-off:** Limited historical data. Flag this in the entry read.
- **Stale data:** If searches return data older than 30 days, try alternative sources. If multiple are stale, flag — the ticker may be illiquid or under-followed.
- **Conflicting technical signals:** Different platforms occasionally disagree. Report the disagreement rather than picking one — "signals mixed across platforms" is a real finding.
- **No analyst coverage:** Small caps and new ETFs may have no targets. Note explicitly — absence of coverage is itself information.

---

## § Output Template

The deliverable is a markdown file (`investment-research-<theme>-<YYYY-MM-DD>.md`) written to the current working directory. Length: 8–15 printed pages typical. The TL;DR should be scannable in under 30 seconds — a reader should be able to identify the picks and their entry confidence from the first section alone.

Use color/emphasis conventions for the GREEN/YELLOW/RED entry-confidence labels:
- GREEN: bold + leading emoji ✅ or a `> GREEN` blockquote tag
- YELLOW: bold + leading emoji ⚠️ or a `> YELLOW` blockquote tag
- RED: bold + leading emoji ⛔ or a `> RED` blockquote tag

(Only use emojis here — they communicate the color band cleanly in markdown. Don't sprinkle emojis elsewhere.)

### Section 1: Title block

Four lines:

```
> MARKET ANALYSIS | [THEME] | [VERSION OR DATE IDENTIFIER]

# [Headline of the research]

*[One-sentence description of the analytical approach]*

Published [DATE]  |  Technicals as of market close [DATE]
```

### Section 2: TL;DR with entry confidence

The most important section. A reader should be able to identify the picks and their entry quality from this section alone.

Open with one short paragraph framing the dual-track approach. Then:

*Confidence framing note (italic):* one sentence noting that confidence scores blend technicals, flows, insider activity, valuation, and catalysts — and are not statistical probabilities.

**The TL;DR table.** Five columns:

| Realm | Type | Ticker | Entry Conf. | One-Line Read |

Each realm gets two rows: one for the ETF pick, one for the single-name pick. Add a third row if a defensive complement is included.

In the **Entry Conf.** cell, label like `70% ✅ GREEN`, `58% ⚠️ YELLOW`, or `32% ⛔ RED`.

In the **One-Line Read** cell, write a 12–20 word characterization combining current state and action. Examples:
- "Off 29% from Feb peak. Cleanest macro proxy; cheapest expense ratio (0.30%). Watch CPI catalyst."
- "Best business, worst price. Insiders dumped ~$100M last year. Wait for pullback to $980–1000."
- "Do not chase. Q1 loss, overbought RSI, analyst targets BELOW current price."

**Ranked best-entry-today list** (right below the table). Brief intro sentence followed by bullets ranked by entry confidence, formatted as:

`[TICKER] (XX%) — [12–15 word characterization]`

End the TL;DR with a one-paragraph disclaimer in italic.

### Section 3: The thesis

Two to four paragraphs explaining the underlying investment thesis driving the picks. If a priming article exists, cite it. If not, derive the thesis from current market structure.

Cover:
- The setup (what the thesis claims will happen)
- Why now (macro tailwinds or sector inflection)
- The "kicker" (the strongest argument for the thesis)

Write like a senior analyst briefing a portfolio manager, not academic prose.

### Section 4: Methodology

Two clearly labeled subsections:

**Layer 1: Fundamental Decision Matrix.** Lead paragraph explaining the 25-point scoring (or 15-point for commodity ETFs). Bullet the five criteria with one-line definitions.

**Layer 2: Entry Confidence Read.** Lead paragraph explaining the 0–100% synthesis. Bullet the five components. End with one sentence on color thresholds (65+ GREEN, 50–64 YELLOW, <50 RED).

### Section 5: Per-realm deep dive

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

### Section 6: Cross-realm summary

Two paragraphs synthesizing patterns across realms. What does the analysis collectively reveal? Where are the strongest and weakest entries?

**Final Picks at a Glance** — Summary table:

| Realm | ETF Pick | Single Pick | Entry Conf. | Suggested Action |

The **Suggested Action** column is critical — one concrete instruction per row:
- "Build SIVR now (60–70%). Defer AG sizing until after May 12 earnings."
- "Build LIN now (70%). Hold CC slot at 30%; defer purchase until $22–24."

**Position Sizing Across the Realms** — One to two paragraphs on whether equal-dollar allocation makes sense or whether thesis-weighted allocation is more honest. Address correlation between the realms.

**Two Patterns Worth Flagging** — Two bolded callouts on cross-cutting observations. Keep them sharp; this is where you say what most other research won't.

### Section 7: What breaks the thesis

A short bear-case stress test. Open with one sentence framing this as honest risk disclosure. Then three bulleted scenarios with bolded leads:

- **Scenario name:** One to two sentences explaining how this scenario would damage the thesis and which picks would be hit first.

Common scenarios: Fed/macro pivot; demand-side disappointment (capex slowdown, end-customer pullback); sentiment shift (multiple compression even with fundamentals intact); regulatory action; geopolitical disruption.

### Section 8: Honest meta-observation

One to two paragraphs. This is where you say the thing that's true but uncomfortable. Common version: "These are already crowded trades. [Names] are up [%] in [period]. The framing implies another leg up, but you're not buying at consensus-skeptical levels — you're paying for a thesis the smart money already moved on."

Close with a one-paragraph statement of why the dual-track structure helps hedge this exact risk.

### Section 9: Disclaimer

At the very end, in italic, separated by a horizontal rule:

> *This document is analytical research, not financial advice. It applies a structured framework — fundamental decision matrix plus technical entry confidence overlay — to identify candidate vehicles for expressing the underlying thesis. All scoring is subjective and based on publicly available information as of [DATE]. Confidence scores synthesize technical signals, institutional flows, insider activity, valuation, and catalyst proximity; they are not statistical probabilities of success. Past performance does not predict future results. Conduct your own due diligence and consult a licensed financial advisor before making investment decisions. The author holds no positions in any securities mentioned at the time of writing.*

### General writing principles

- **Lead with the conclusion.** Every section header should be readable as a standalone sentence summarizing what follows.
- **Use active voice.** "Insiders sold $100M" not "$100M was sold by insiders."
- **Quantify everything.** Replace "significant" with the actual number.
- **Avoid hedging.** "It might be worth considering" is weak. "Build the position now" or "Wait for $22–24" is strong.
- **Keep paragraphs tight.** Max 4–5 sentences; break if longer.
- **End sections crisply.** No "in conclusion" — just stop when the section's job is done.

### What to skip

- Boilerplate "about the author" sections
- General market commentary unrelated to the picks
- Repeating the "not financial advice" disclaimer in every section (top + bottom only)
- Footnotes or extensive citations — link to sources naturally in prose if needed

This is a decision-support document, not a compliance-review research report. Optimize for actionability.

---

## After writing the file

1. Report the absolute path of the file you wrote.
2. Mention: "If you want a `.docx` version, run: `pandoc <path>.md -o <path>.docx`."
3. Do not open or render it for the user — they'll review on their own.
