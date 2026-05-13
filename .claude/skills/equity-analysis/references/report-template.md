# Report Template

The sub-agent writes a single Markdown file to the exact path passed in by the parent session (pattern: `{OUTPUT_DIR}/{TICKER}_Analysis_{YYYY-MM-DD}_{HHMMSS}.md`) using the structure below, in this order.

## Header

```
# {Company Name} ({Exchange}: {TICKER}) — Technical & Fundamental Analysis

**Date:** {today, intraday/EOD note} · **Last price:** ~\${price} · **Mkt cap:** ~\${cap} · **52-wk range:** \${low}–\${high}

**Horizon:** {swing | position | long} · **Risk profile assumed:** {conservative | moderate | aggressive}
```

## Sector Context Sidebar *(only if sector flag is yes)*

3–5 lines covering:
- Stock vs. sector performance today/this week
- Sector vs. broad market (S&P 500 / Nasdaq)
- One sentence on dominant macro driver

## TL;DR — Recommendation Matrix

Table with these exact rows:

| Position | Stance | Confidence | Notes |
| --- | --- | --- | --- |
| Existing holders (large gain) | ... | ... | ... |
| Existing holders (near cost) | ... | ... | ... |
| New buyers | ... | ... | ... |
| Adding to position | ... | ... | ... |
| Trimming | ... | ... | ... |
| Short / Bearish trade | ... | ... | ... |

If user provided `--position` and `--cost`, **bold the matching row** and add a one-line "Your scenario:" callout below.

Follow with: **Overall bias:** {Strong Bullish | Bullish | Constructive | Neutral | Cautious | Bearish | Strong Bearish}, with one-sentence justification.

## Decision Matrix — Scored Factor View

**Scoring scale:** -5 (strongest bearish) ←→ 0 (neutral) ←→ +5 (strongest bullish). Integer scores only.

### Horizon-based weights

- **Swing (2–10 days):** technicals 50%, momentum/flow 20%, catalysts 15%, sentiment 10%, fundamentals 5%
- **Position (1–3 months):** technicals 30%, fundamentals 25%, valuation 10%, insider/institutional 15%, catalysts 15%, sentiment 5%
- **Long (6–24 months):** fundamentals 40%, valuation 20%, catalysts 15%, insider/institutional 15%, technicals 10%

### Master Composite table

Columns: `#`, `Factor Bucket`, `Raw Score`, `Weight`, `Weighted`, `Confidence` (Low/Med/High), `Direction` (🟢🟡🔴⚪)

Use these exact bucket names for consistency across tickers:

1. Price action & trend structure
2. Moving averages
3. Momentum oscillators
4. Support / resistance positioning
5. Volume & flow
6. Fundamentals — balance sheet
7. Fundamentals — earnings/cash flow
8. Valuation
9. Insider activity
10. Institutional / analyst
11. Catalysts & policy tailwinds
12. Sentiment & retail flow
13. Short interest / squeeze setup
14. Options/derivatives signal *(skip row if data unavailable)*

Bottom row: **TOTAL — Composite ({horizon} horizon)**, sum of weighted scores.

### Composite legend

- +2.0 to +5.0: Strong Buy
- +0.5 to +2.0: Buy
- -0.5 to +0.5: Hold / Wait
- -2.0 to -0.5: Trim / Reduce
- -5.0 to -2.0: Sell / Avoid

End with: "{TICKER} lands at {score} → {action}".

### Detail matrices (five tables)

Each table: `Factor` | `Reading` | `Score` | `Confidence` | `Logic`

1. **Technicals** (10–12 sub-factors): long-term trend vs. 200-DMA, intermediate trend vs. 50-DMA, short-term trend vs. 20-DMA, trend direction, RSI(14), MACD, Stochastic / pivot points, volatility (ATR/Beta), volume on selloff/rally, support proximity, resistance overhead, chart pattern.

2. **Fundamentals** (10–14 sub-factors): liquidity, cash position, debt structure, revenue growth Y/Y, revenue forecast forward, GAAP profitability, adjusted EPS vs. estimate, EBITDA, margins or unit economics, operating cost trend, production/operational execution, project pipeline / growth catalysts, acquisitions/divestitures, share count growth/dilution.

3. **Valuation** (7–10 sub-factors): P/S, P/E, P/B, EV/EBITDA, GF Value or other quant model, Morningstar Fair Value if available, lowest analyst PT, highest analyst PT, consensus PT, model disagreement note.

4. **Insider & Institutional** (8–10 sub-factors): most recent CEO transaction, cluster selling activity last 12 mo, insider buying activity last 12 mo, executive/board transitions, institutional ownership concentration, recent 13D/G filings, top-tier analyst coverage, sell-side coverage breadth, short interest %, days-to-cover.

5. **Catalysts & Sentiment** (8–12 sub-factors): macro/sector tailwind or headwind, policy/regulatory backdrop, government contract optionality, M&A activity, upcoming earnings date, geopolitical exposure, retail sentiment platforms, social/X chatter level, narrative theme strength, sector relative performance.

After each detail matrix, give the **sub-composite** (simple average of scores) and a one-sentence directional read.

### Peer Comparison table

Single table: TICKER vs. 3–5 peers on current price, YTD %, P/S, market cap, short interest %.

### Cross-Scenario Decision Grid

3-column table: `If you are...` | `And the next move is...` | `Then...`

Cover at minimum: Long-in-profit / Long-recent / Flat-wants-exposure / Short-considering, each crossed with: holds support / breaks support / breakout catalyst / negative catalyst.

## Price Action & Chart Structure

Prose covering:
- Current snapshot (intraday range, volume, position in 52-wk range)
- Dominant pattern (parabolic / range / breakout / breakdown / base / consolidation)
- Key levels: 3–4 support, 3–4 resistance, each with reasoning
- Moving average map: 5/20/50/200-DMA with price relative to each
- Momentum reading
- Probability-weighted scenarios for next 1–3 months (must sum to 100%)

## Fundamentals Deep Dive

Prose. Most recent quarter's beat/miss with specific numbers, balance sheet, forward consensus, project pipeline, dilution dynamics. Be skeptical of single quant models if they disagree wildly with analyst consensus — flag that disagreement as a signal itself.

## Insider Activity Analysis

Pull from openinsider.com data:
- Most recent CEO/CFO/major-officer transactions with dates, sizes, prices
- Cluster pattern over trailing 12 months (sells, buys, magnitudes)
- The *absence* of buying on weakness if relevant
- Honest interpretation: distribution-into-strength is normal; sudden coordinated selling at the highs is a yellow flag; zero insider buys on a major drawdown is a yellow flag

## Institutional Ownership & Short Interest

Top institutional holders, short interest % of float, days-to-cover, recent analyst initiations, squeeze setup quality.

## News Catalysts & Sentiment

Recent material news (paraphrased, with source citations). Retail sentiment from Stocktwits / X.com with message volume note. Active narrative themes.

## Bull / Bear Synthesis

Side-by-side bullets. Then a 2–3 sentence "Where I land" honest assessment.

## Action Framework

- **Stop loss zone** (specific price)
- **Trim zone** (specific price)
- **Add zone** (specific price or condition)
- **Position sizing recommendation**, keyed to risk tolerance and conviction:
  - Conservative + low conviction: 0–2% portfolio
  - Conservative + high conviction: 2–4%
  - Moderate + low conviction: 1–3%
  - Moderate + high conviction: 3–6%
  - Aggressive + low conviction: 2–5%
  - Aggressive + high conviction: 5–10%
  - Adjust down by 30–50% for high-beta names (beta > 1.5)

## Invalidation Triggers — What Would Change My Mind

Two columns: `Bullish flip triggers` (specific levels/events) | `Bearish flip triggers` (specific levels/events). Falsifiable conditions only.

## Falsifiable Forecast

```
> **Forecast (as of {date}):** Composite = {score}. Over the next
> {horizon timeframe}, I expect {price range} with a
> {bullish/bearish/neutral} skew. The most likely path is
> {brief description}. This forecast can be revised by
> {specific triggers}.
```

This creates accountability — future reports can grade this prediction.

## Disclaimers & Data Provenance

- List of data sources actually used (SEC, openinsider, named analyst notes, named outlets, named technical aggregators)
- Note that this is research synthesis, not investment advice
- Note the analyst is not licensed
- Note the data freshness windows
- Note that scoring is judgment-based and weights can be adjusted
