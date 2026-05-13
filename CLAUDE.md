# claude-tools

Personal Claude Code commands and skills repo. Commands live in `.claude/commands/`; skills in `.claude/skills/`.

## Commit & push rules

- Never commit to `main` — branch, then PR.
- One commit per push (pre-push hook enforces). Squash with `git rebase -i HEAD~N` if needed.
- Don't bypass hooks (`--no-verify`).
- Don't auto-commit without user approval.
- No Claude / AI / LLM attribution in commit messages or PR descriptions. Applies to all variants: `Co-Authored-By: Claude` trailers, `🤖 Generated with Claude Code` footers, emoji-prefixed AI mentions, or any reference naming Claude, Anthropic, Claude Code, or any AI/LLM as an author, co-author, contributor, or generator.
- Commit message subjects use Conventional Commits: `type(scope): summary`. Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `ci`, `build`, `style`, `perf`. Example: `feat(scanner): add markdown image exfil pattern`.

## Adding a command

`.claude/commands/kebab-case-name.md` with frontmatter:

```markdown
---
description: One-sentence description shown in the slash-command picker
argument-hint: [optional hint, e.g. "sector, theme, or thesis"]
---
```

Add or update a Commands table in `README.md`.

## Adding a skill

`.claude/skills/kebab-case-name/SKILL.md` with frontmatter:

```markdown
---
name: kebab-case-name
description: One-sentence description
---
```

Supporting files in `.claude/skills/kebab-case-name/references/`. Update the **Skills** table in `README.md`.

## Conventions

- File and directory names: `kebab-case`.
- Command filename matches slash invocation: `foo-bar.md` → `/foo-bar`.

## Security & tests

A pre-commit scanner blocks injection patterns in Claude content under `.claude/` plus the root `CLAUDE.md`; Betterleaks scans for secrets. See `scripts/scan-injection.py` for the pattern list and `scripts/tests/` for the test suite. Run tests manually with `scripts/tests/run-all.sh`. If a legitimate case trips the scanner, update the pattern AND add a regression test — never bypass.

## Summary instructions

When summarizing this conversation, preserve:
- Commands or skills added/modified/removed
- README table changes
- Branch name + PR status if a change is in flight
- New scanner patterns or test additions
