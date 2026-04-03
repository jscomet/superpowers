# Codex Tool Mapping

When skills reference Claude Code tools, substitute Codex equivalents:

| Claude Code | Codex |
|-------------|-------|
| `Skill` tool | Auto-discovered from `~/.codex/skills/` |
| `Read` | Native file reading |
| `Write` | Native file writing |
| `Edit` | Native file editing |
| `Bash` | Native shell execution |
| `TodoWrite` | Not available — track in conversation |
| `Task` (subagents) | Not available — work inline |

Skills are discovered via symlinks in the `~/.codex/skills/` directory.
