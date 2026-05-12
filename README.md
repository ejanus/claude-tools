# claude-tools

Personal collection of Claude Code slash commands and skills.

## Structure

```
commands/   → slash commands (available globally via ~/.claude/commands symlink)
skills/     → SKILL.md format skills
```

## Installation

Clone the repo and symlink the commands directory:

```bash
git clone https://github.com/ejanus/claude-tools.git
ln -s ~/path/to/claude-tools/commands ~/.claude/commands
```

Or copy individual files from `commands/` into `~/.claude/commands/` to install selectively.

## Commands

| Command | Description |
|---|---|
| `/investment-rotation-research` | Research investment picks (ETF + single-name) for a sector/theme with dual-layer scoring and entry-timing confidence |

## Skills

*(coming soon)*

## License

MIT
