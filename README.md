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
