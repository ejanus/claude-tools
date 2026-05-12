# claude-tools

Personal Claude Code commands and skills repo. Commands are symlinked to `~/.claude/commands/` for global availability.

## Branch rules

- Never commit directly to `main` — always branch, then PR.

## Adding a command

Files go in `commands/` as `kebab-case-name.md` with this frontmatter:

```markdown
---
description: One-sentence description shown in the slash-command picker
argument-hint: [optional hint shown to user, e.g. "sector, theme, or thesis"]
---
```

After adding a command, update the **Commands** table in `README.md`.

## Adding a skill

Files go in `skills/kebab-case-name/SKILL.md` with this frontmatter:

```markdown
---
name: kebab-case-name
description: One-sentence description
---
```

Supporting reference files go in `skills/kebab-case-name/references/`. After adding a skill, update the **Skills** table in `README.md`.

## Naming conventions

- All file and directory names: `kebab-case`
- Command invocation matches the filename: `investment-rotation-research.md` → `/investment-rotation-research`

## Summary instructions

When summarizing this conversation, preserve:
- Which commands or skills were added, modified, or removed
- Any changes to the README tables
- Branch name and PR status if a change is in flight
