# Argument Flags

Parse `$ARGUMENTS` for any of the following. Ask the user only for missing required fields.

## Required

- **Ticker** (first positional argument, e.g. `UUUU`, `NVDA`)
- **Output directory** — accept via `--output=<path>` or ask interactively

## Optional flags

| Flag | Values | Default |
| --- | --- | --- |
| `--horizon=` | `swing` (2–10 days) / `position` (1–3 months) / `long` (6–24 months) | `position` |
| `--position=` | `none` / `starter` / `full` / `oversized` | `none` |
| `--cost=` | Single number (e.g. `15`) or range (e.g. `18-24`) | (skip) |
| `--risk=` | `conservative` / `moderate` / `aggressive` | `moderate` |
| `--peers=` | Comma-separated tickers (e.g. `CCJ,UEC,DNN`) | auto-detect |
| `--sections=` | `full` / `summary` / `technicals` / `fundamentals` | `full` |
| `--sector=` | `yes` / `no` (include sector context sidebar) | `yes` |
| `--output=` | Directory path; supports `~` expansion | (ask) |

## Examples

```
/equity-analysis UUUU
/equity-analysis UUUU --output=~/research/equities/
/equity-analysis NVDA --horizon=long --risk=conservative
/equity-analysis TSLA --position=full --cost=180-220 --horizon=position
/equity-analysis PLTR --peers=AI,SNOW,DDOG --sections=summary
/equity-analysis CCJ --horizon=swing --sector=no
```
