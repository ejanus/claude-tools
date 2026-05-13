# Arguments

Parse `$ARGUMENTS` for the realm/theme string and any flags below. Ask the user only for missing required fields.

## Required

- **Realm / theme** — free-text positional argument (e.g. `silver`, `AI infrastructure`, `power and electrification`). May be empty if the user invokes the skill bare; in that case Phase 1 elicits it.
- **Output directory** — accept via `--output=<path>` or ask interactively.

## Optional flags

| Flag | Values | Default |
| --- | --- | --- |
| `--output=` | Directory path; supports `~` expansion | (ask, default `~/research/rotations/`) |
| `--thesis=` | Quoted free text describing a priming view or article | (included in the one-question prompt when the realm is vague; otherwise derive from current market structure) |

## The one-question rule

If the realm is empty or vague, ask **one** focused clarifying question that covers realm(s) AND any priming thesis. Do not split this into multiple questions. Example phrasing:

> "Which sector or theme should this cover (e.g. silver, AI infrastructure, power), and is there a priming thesis or article driving the request — or should I derive the thesis from current market structure?"

A single combined prompt preserves momentum. Tolerance for question-asking here is one, not three.

## Theme-slug derivation

For the output filename, normalize the user's realm/theme string into a slug:

1. Lowercase
2. Replace spaces and `/` with `-`
3. Strip remaining punctuation (`'`, `,`, `.`, `&`, etc.)
4. Collapse repeated hyphens
5. Trim leading and trailing hyphens

Examples:

| Realm string | Slug |
| --- | --- |
| `silver` | `silver` |
| `AI infrastructure` | `ai-infrastructure` |
| `Power & Electrification` | `power-electrification` |
| `oil/gas` | `oil-gas` |
| `Silver, power, chemicals` | `silver-power-chemicals` |

## Examples

```
/investment-rotation-research silver
/investment-rotation-research silver --output=~/research/rotations/
/investment-rotation-research "AI infrastructure" --thesis="Goldman Apr 2026 capex acceleration call"
/investment-rotation-research
```

The bare form triggers the single combined elicitation question. The quoted-multi-word form is supported by `$ARGUMENTS` and resolves to a single realm string.
