# Calibration

Standing instructions for the sub-agent on how to write the report — tone, formatting rules, behavioral discipline, and pitfalls to avoid.

## Important behaviors

**Be wary of crowded trades.** If the candidates are all up 50%+ year-over-year, say so explicitly in the meta-observation. The user deserves to know they're paying for a thesis that the smart money already moved on.

**Insider selling is information, not a verdict.** Executives diversify, exercise options, fund lifestyles — but \$100M+ of net selling at a single name over 12 months is meaningful and should be flagged. Quantify it. Don't editorialize beyond what the numbers say.

**Distinguish ETF expense ratios.** For commodity trackers especially, the 20–30 bps gap between competing ETFs (e.g., SIVR 0.30% vs. SLV 0.50%) compounds on multi-year holds. State the expense ratio in the ETF pick rationale.

**Be honest when an entry is bad.** A 30% RED confidence score with an explicit "do not chase" is more valuable than a softened recommendation. If the analyst consensus target is below the current price, say so — that's a rare signal worth flagging.

**Never invent specific numbers.** If a search doesn't return precise data (e.g., exact institutional ownership %), say "approximately" or "not disclosed" rather than fabricating. Confidence scores are subjective synthesis — but underlying data points (RSI, price, % from high) must be real.

**Stay non-advisory.** Include a disclaimer at the top of the TL;DR and at the bottom of the document. Never use language like "you should buy" — frame as "entry conditions are constructive" or "best risk-adjusted setup."

**Catalyst calendar matters.** If a candidate has earnings within a week, that's a binary catalyst that should defer sizing decisions. Surface this prominently in the entry read.

**Use current data.** Today's market data is essential — never rely on training-data memory for prices, RSI, institutional flows, or earnings dates. Search for current values. When formulating queries, use the current month and year; stale queries return stale results.

## Markdown rendering rules

These are non-negotiable — many renderers (the Claude Code preview pane, GitHub with math extensions, several IDEs) will mangle output that violates them.

- **Escape every dollar sign in prices as `\$`** — write `\$21.50`, `\$19.99–\$21.97`, `\$5.24B`. Paired raw `$...$` on the same line is parsed as KaTeX/MathJax inline math and renders as italic math glyphs, eating the surrounding text.
- Table separator rows use space-padded pipes: `| --- | --- |`, matching the data-row style. Avoid the compact form (`|---|---|`) — markdownlint MD060 flags the mismatch and some renderers tighten the column widths inconsistently.
- Leave a blank line above and below every heading, list, and table (markdownlint MD022 / MD032).
- No trailing punctuation in headings, especially `:`. If a lead-in label is needed, put it as a **bold-prefixed** sentence on the line below the heading instead.

## Tone

- **Lead with the conclusion.** Every section header should be readable as a standalone sentence summarizing what follows.
- **Use active voice.** "Insiders sold \$100M" not "\$100M was sold by insiders."
- **Quantify everything.** Replace "significant" with the actual number.
- **Avoid hedging.** "It might be worth considering" is weak. "Build the position now" or "Wait for \$22–24" is strong.
- **Keep paragraphs tight.** Max 4–5 sentences; break if longer.
- **End sections crisply.** No "in conclusion" — just stop when the section's job is done.
- **Disagree with consensus when warranted.** Surface tensions between insider activity, analyst ratings, and price action.
- **Be willing to recommend "wait" or "no action."** Not every report needs to recommend a trade.

## Color/emphasis conventions

Use color emojis only in entry-confidence labels — they communicate the color band cleanly in markdown. Do not sprinkle emojis elsewhere.

- GREEN: bold + leading emoji ✅ or a `> GREEN` blockquote tag
- YELLOW: bold + leading emoji ⚠️ or a `> YELLOW` blockquote tag
- RED: bold + leading emoji ⛔ or a `> RED` blockquote tag

## What to skip

- Boilerplate "about the author" sections
- General market commentary unrelated to the picks
- Repeating the "not financial advice" disclaimer in every section (top + bottom only)
- Footnotes or extensive citations — link to sources naturally in prose if needed

This is a decision-support document, not a compliance-review research report. Optimize for actionability.

## Common scoring mistakes

These are the failure modes most likely to compromise the analysis. See also [research-protocol.md](research-protocol.md) "Common scoring mistakes to avoid" for the matrix-specific list.

- **Confusing thesis intensity with purity.** Marketing exposure isn't financial exposure.
- **Treating recent stock performance as a fundamental signal.** Up 100% tells you about sentiment, not backlog.
- **Forgetting ETFs need their own purity check.** Read the holdings list.
- **Letting valuation score do all the work.** A cheap stock is often cheap for a reason.
- **Ignoring the "what breaks the thesis" question.** Thesis fragility belongs in the scoring or as a caveat.
