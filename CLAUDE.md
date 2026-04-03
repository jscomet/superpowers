# Superpowers - Claude Context

This is a personal AI-assisted development skills framework.

## Repository Structure

- `skills/` — Reusable skill definitions (each skill is a directory with `SKILL.md`)
- `agents/` — Agent role definitions (`.md` files)
- `commands/` — Custom slash commands
- `hooks/` — Lifecycle hooks (session-start, git-check)
- `docs/` — Documentation, plans, and specs
- `scripts/` — Utility scripts (version bumping)

## Adding New Skills

1. Create a new directory under `skills/` with a `SKILL.md` file
2. Add YAML frontmatter with `name` and `description`
3. Write the skill content in Markdown

```markdown
---
name: my-skill
description: When to use this skill
---

# My Skill

Instructions here...
```

## Adding New Agents

Create a `.md` file in `agents/` describing the agent's role, capabilities, and output format.

## Adding New Hooks

1. Add hook scripts in `hooks/`
2. Register them in `hooks/hooks.json` (Claude Code) and `hooks/hooks-cursor.json` (Cursor)
3. Run `scripts/bump-version.sh` if you change version numbers

## Conventions

- Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/)
- Branch naming: `feat/*`, `fix/*`, `hotfix/*`, `release/*`
- All hook scripts use LF line endings (enforced by `.gitattributes`)
