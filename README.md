# claude-tools

Personal collection of Claude Code slash commands and skills — structured research workflows, productivity tools, and anything else that doesn't belong in a project repo.

## Installation

Clone the repo and run Claude Code from inside it. Commands live in `.claude/commands/`; skills in `.claude/skills/`.

```bash
git clone https://github.com/ejanus/claude-tools.git
cd claude-tools
```

### Enable pre-commit hooks

Install [pre-commit](https://pre-commit.com/#installation) for your platform, then run once from the repo root:

```bash
pre-commit install
```

Wires two stages from one install:

- **pre-commit** — scans staged Claude content files for 11 categories of prompt-injection patterns (instruction override, tool-poisoning tags, markdown image exfil, Claude-Code config-edit signals, hidden Unicode incl. the Unicode TAG block, non-Latin confusables, and more) and runs Betterleaks for secrets.
- **pre-push** — blocks pushes that include more than one commit, so every commit triggers its own CI run.

See `.pre-commit-config.yaml` for the exact scope and hook definitions, and `scripts/scan-injection.py` for the full pattern list with source citations (OWASP LLM01, recent CVEs, vendor advisories).

### Run the scanner test suite

```bash
scripts/tests/run-all.sh
```

Runs `test_scan_injection.py` (Python unittest, 50+ injection payloads with citations) and `test_check_single_commit.sh` (bash, 6 pre-push scenarios). The suite also runs automatically on any commit touching `scripts/` and on every PR in CI.

## Commands

Slash commands invoked as `/command-name` inside Claude Code.

| Command | Description |
|---|---|
| `/investment-rotation-research` | Research investment picks (ETF + single-name) for a sector/theme with dual-layer scoring and entry-timing confidence |

## Skills

Each skill lives at `.claude/skills/<name>/SKILL.md`.

| Skill | Description |
|---|---|
| `equity-analysis` | Equity research report for a publicly traded stock with scored decision matrix and action grid |

## Contributing

PRs welcome. To add a command:

1. Add `.claude/commands/your-command-name.md` with the required frontmatter (`description`, optional `argument-hint`)
2. Update the Commands table above
3. Open a PR against `main`

To add a skill:

1. Add `.claude/skills/your-skill-name/SKILL.md` with `name` and `description` frontmatter
2. Update the Skills table above
3. Open a PR against `main`

## License

MIT — see [LICENSE](LICENSE)
