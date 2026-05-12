# claude-tools

Personal collection of Claude Code slash commands and skills — structured research workflows, productivity tools, and anything else that doesn't belong in a project repo.

Commands are available globally via a symlink from `~/.claude/commands/` to this repo, so they work in every project without copying files.

## Installation

### Full install (recommended)

Clone and symlink the commands directory so all commands load globally:

```bash
git clone https://github.com/ejanus/claude-tools.git ~/claude-tools
ln -s ~/claude-tools/commands ~/.claude/commands
```

If `~/.claude/commands` already exists as a directory, back it up first:

```bash
mv ~/.claude/commands ~/.claude/commands.bak
ln -s ~/claude-tools/commands ~/.claude/commands
```

### Enable pre-commit hooks

Install [pre-commit](https://pre-commit.com/#installation) for your platform, then run once from the repo root:

```bash
pre-commit install
```

Wires two stages from one install:

- **pre-commit** — scans staged Claude content files for 11 categories of prompt-injection patterns (instruction override, tool-poisoning tags, markdown image exfil, Claude-Code config-edit signals, hidden Unicode incl. the Unicode TAG block, non-Latin confusables, and more) and runs Gitleaks for secrets.
- **pre-push** — blocks pushes that include more than one commit, so every commit triggers its own CI run.

See `.pre-commit-config.yaml` for the exact scope and hook definitions, and `scripts/scan-injection.py` for the full pattern list with source citations (OWASP LLM01, recent CVEs, vendor advisories).

### Run the scanner test suite

```bash
scripts/tests/run-all.sh
```

Runs `test_scan_injection.py` (Python unittest, 50+ injection payloads with citations) and `test_check_single_commit.sh` (bash, 6 pre-push scenarios). The suite also runs automatically on any commit touching `scripts/` and on every PR in CI.

### Selective install

Copy individual files into your existing `~/.claude/commands/` directory:

```bash
cp commands/investment-rotation-research.md ~/.claude/commands/
```

## Commands

Slash commands invoked as `/command-name` inside Claude Code.

| Command | Description |
|---|---|
| `/investment-rotation-research` | Research investment picks (ETF + single-name) for a sector/theme with dual-layer scoring and entry-timing confidence |

## Skills

SKILL.md format skills installable via `npx skills add ejanus/claude-tools`.

| Skill | Description |
|---|---|
| *(coming soon)* | — |

## Contributing

PRs welcome. To add a command:

1. Add `commands/your-command-name.md` with the required frontmatter (`description`, optional `argument-hint`)
2. Update the Commands table above
3. Open a PR against `main`

To add a skill:

1. Add `skills/your-skill-name/SKILL.md` with `name` and `description` frontmatter
2. Update the Skills table above
3. Open a PR against `main`

## License

MIT — see [LICENSE](LICENSE)
