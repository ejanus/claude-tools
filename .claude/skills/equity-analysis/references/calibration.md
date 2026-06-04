# Calibration

Standing instructions for the sub-agent on how to write the report.

## Formatting

- Tables for everything quantitative; prose only where prose adds reasoning
- Bold the most important numbers and levels
- Use `[Data as of: ...]` tags on sections with mixed-freshness inputs
- Color emojis (🟢🟡🔴⚪) only in scored matrices; nowhere else
- No headers shallower than `###` inside sections
- No filler caveats — every caveat must add information
- All price levels are specific numbers, never hedged with "around"
- All scores are integers between -5 and +5

### Markdown rendering rules

These are non-negotiable — many renderers (the Claude Code preview pane, GitHub with math extensions, several IDEs) will mangle output that violates them.

- **Escape every dollar sign in prices as `\$`** — write `\$21.50`, `\$19.99–\$21.97`, `\$5.24B`. Paired raw `$...$` on the same line is parsed as KaTeX/MathJax inline math and renders as italic math glyphs, eating the surrounding text.
- Table separator rows use space-padded pipes: `| --- | --- |`, matching the data-row style. Do not use the compact form (`|---|---|`) — markdownlint MD060 flags the mismatch and some renderers tighten the column widths inconsistently.
- Leave a blank line above and below every heading, list, and table (markdownlint MD022 / MD032).
- No trailing punctuation in headings, especially `:`. If you want a lead-in label, put it as a **bold-prefixed** sentence on the line below the heading instead.
- **Link every ticker to its Yahoo Finance quote page.** Render each ticker symbol as `[TICKER](https://finance.yahoo.com/quote/TICKER)` — e.g. `[TSLA](https://finance.yahoo.com/quote/TSLA)`. Yahoo is the default review destination: most popular, free, no login, and one URL pattern covers both stocks and ETFs.
  - Use the bare, uppercase ticker with no exchange suffix. For share-class or special symbols use Yahoo's convention (dash, not dot): `BRK-B`, not `BRK.B`.
  - Link tickers in their **anchor locations** — the primary ticker in the H1 header `({Exchange}: [TICKER](...))`, every ticker cell in the Peer Comparison table, and composite call-out lines (`[TICKER](...) lands at {score} → ...`). Don't link every prose mention; anchors keep the report clickable without link spam.
  - The link wraps only the symbol text — keep the `Exchange:` label, prices (`\$...`), and scores as plain text outside it.

## Tone

- **Be honest about uncertainty.** If data is genuinely ambiguous, score 0 and say so. Do not manufacture directional views to seem decisive.
- **Disagree with consensus when warranted.** Surface tensions between insider activity, analyst ratings, and price action.
- **Avoid hedging language for its own sake.** "Markets are uncertain" is not analysis. "Iran headline risk could compress the war-premium 10–15% across the sector in 30 days" is analysis.
- **Be willing to recommend "wait" or "no action."** Not every report needs to recommend a trade.
- **Treat the reader as competent.** Don't over-explain standard indicators.

## Analytical pitfalls to avoid

- **Don't use stale prices.** Search for the current quote before writing the header.
- **Don't pretend openinsider data exists if the search fails.** Note the absence and proceed.
- **Don't let one analyst's PT dominate the valuation section.** Spread is information.
- **Don't write the bull case stronger than the bear case (or vice versa) for stylistic reasons.** Both must be the strongest honest version.
- **Don't recommend shorting low-float, high-short-interest, retail-heavy names.** Squeeze risk typically dominates the thesis.
- **Don't issue confident swing-trade calls for a long-horizon request, or vice versa.** Match recommendation to horizon.
- **Don't fabricate data when a source returns nothing.** Say "data unavailable" explicitly.
- **Don't smooth over CEO transitions, board churn, or governance changes.** These belong in the insider section as yellow flags.
