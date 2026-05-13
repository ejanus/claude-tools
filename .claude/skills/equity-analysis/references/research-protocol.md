# Research Protocol

The sub-agent reads this file at startup and follows it to ground every claim with live data. Never rely on training-data memory for prices, levels, filings, or news. Always use today's date for "today's price," "latest filings," "current news."

## Required searches (minimum)

1. `{TICKER} stock price today {current month year}` — current price, intraday range, volume
2. `{TICKER} technical analysis RSI moving averages support resistance` — pull from at least 2 of: TradingView, Investing.com, Barchart, StockInvest, SwingTradeBot
3. `{TICKER} earnings latest quarter revenue EPS guidance` — most recent quarterly report
4. `{TICKER} insider buying selling Form 4 {current year}` — and **fetch `https://openinsider.com/{TICKER}` directly** for the Form 4 ledger
5. `{TICKER} institutional ownership short interest float` — Fintel, MarketBeat, StockAnalysis
6. `{TICKER} analyst price target ratings {current month year}` — sell-side coverage
7. `{TICKER} news catalyst {current month year}` — recent material news
8. `{TICKER} stocktwits retail sentiment` — retail/social signal
9. **Sector peers**: search for at least 3 peer tickers' current performance (use `--peers` value if supplied, otherwise auto-detect)
10. **Macro context**: search for the dominant sector driver currently (e.g. "uranium stocks today", "AI semiconductor selloff")

## Data freshness

Tag every section in the report with `[Data as of: ...]` showing the most recent timestamp of the underlying inputs:
- Intraday timestamp for price
- Filing date for insider data
- Quarter-end date for fundamentals
- Article date for news

## Disagreement protocol

When sources disagree on a number, present both and note the discrepancy. Do not silently pick one. Disagreement between sources (especially between quant models and analyst consensus) is itself a signal worth surfacing.

## Copyright rules

- Paraphrase everything.
- Never quote 15 or more consecutive words from any single source.
- Never reproduce article paragraphs verbatim.
- One quote per source maximum; everything else fully paraphrased.

## Source priority

Prefer in this order:
1. SEC filings (10-Q, 10-K, 8-K, Form 4) — direct via openinsider or SEC.gov
2. Company press releases and earnings call transcripts
3. Established financial press (Bloomberg, Reuters, WSJ, CNBC, Yahoo Finance)
4. Established technical aggregators (TradingView, Investing.com, Barchart)
5. Retail signal aggregators (Stocktwits) — for sentiment only, never for fundamentals
6. Quant valuation models (GuruFocus, Morningstar) — surface but be skeptical of single outputs

## When data is missing

If openinsider returns no data, or a search yields nothing relevant for a section, **say so explicitly** in that section of the report. Do not fabricate a placeholder.
