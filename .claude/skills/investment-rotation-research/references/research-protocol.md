# Research Protocol

The sub-agent reads this file at startup. It describes the inversion, the four workflow phases, the two scoring rubrics, and the research sources used in Phase 1. Ground every claim in live data — never rely on training-data memory for prices, RSI, institutional flows, or earnings dates. Use the current month and year in queries; stale queries return stale results.

## The core inversion

A naive workflow goes: thesis → candidate picks → validate with technicals. This workflow inverts that:

1. **Screen for entry quality first** across the candidate universe — technicals, institutional flows, insider activity, valuation gaps. Names with strong setups bubble to the top *before* fundamental scoring begins.
2. **Then apply the fundamental decision matrix** to the screened survivors. This prevents the failure mode of identifying a "great business" that is a terrible buy at current prices.
3. **Then synthesize the dual-track picks** (ETF + single name per realm) with explicit entry guidance.

The reason for this ordering: fundamental analysis is path-independent (a company's moat is roughly the same Tuesday as Wednesday), but entry quality is highly time-sensitive (an RSI of 75 today might be 50 next month after a pullback). Starting with time-sensitive signals ensures the picks surfaced are *actionable now*, not just theoretically attractive.

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

Use the structure in [report-template.md](report-template.md). The deliverable is a polished markdown file written to the exact output path passed in by the parent session. Report the path back in the return summary when complete.

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
- **10–13:** Modest net selling that could plausibly be diversification (<\$5M for a mid-cap; scale to size).
- **5–9:** Significant net selling (\$10M–\$100M depending on company size), CEO selling material chunks of their holding.
- **0–4:** \$100M+ of net insider selling at all-time highs, CEO repeatedly selling, or pattern of executives exiting. *Red flag.*

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

If the score lands in the 70s+ but the stock has tripled in the last 12 months, reconsider — momentum exhaustion is real risk. Conversely, if the score is low but the underlying thesis is strong, that may be a "great business, bad price" pattern — note it for re-evaluation later.

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

For commodity ETFs: this criterion doesn't apply. (Combined with criterion 2: bullion trackers score on 3 criteria, 15 max.)

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

For dual-track pick selection in Phase 3, weight roughly 60/40 fundamental/entry. A 22/25 fundamental with 50% entry can still be a defensible pick — note "wait for pullback" in the suggested action. A 17/25 fundamental with 75% entry probably means there's a better pick that hasn't surfaced yet.

### Common scoring mistakes to avoid

- **Confusing thesis intensity with purity.** A company can be loudly marketed as an "AI play" without 50% of revenue from AI. Use financials, not press releases.
- **Treating recent stock performance as a fundamental signal.** Up 100% in a year tells you about sentiment, not backlog quality.
- **Forgetting ETFs need their own purity check.** An "AI ETF" holding 30% Apple and Microsoft is not pure-play. Read the holdings.
- **Letting valuation score do all the work.** A cheap stock is often cheap for a reason. Pair valuation with the other four criteria.
- **Ignoring the "what breaks the thesis" question.** Thesis fragility belongs in scoring — likely as a Catalyst Proximity haircut or as a caveat in the article.

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
- AUM growth rate is the key adoption signal — newer thematic ETFs going from \$100M to \$500M in months are accelerating; mature ETFs with flat AUM are not.
- Read the top holdings list. An "AI infrastructure" ETF holding regulated utilities is misnamed.

### Edge cases

- **Multiple listings:** Use the U.S. listing for U.S.-focused analysis. Note when material activity happens on the other exchange.
- **Recent IPO or spin-off:** Limited historical data. Flag this in the entry read.
- **Stale data:** If searches return data older than 30 days, try alternative sources. If multiple are stale, flag — the ticker may be illiquid or under-followed.
- **Conflicting technical signals:** Different platforms occasionally disagree. Report the disagreement rather than picking one — "signals mixed across platforms" is a real finding.
- **No analyst coverage:** Small caps and new ETFs may have no targets. Note explicitly — absence of coverage is itself information.
