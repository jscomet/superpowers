# Gemini CLI Tool Mapping

When skills reference Claude Code tools, substitute Gemini CLI equivalents:

| Claude Code | Gemini CLI |
|-------------|------------|
| `Skill` tool | `activate_skill` |
| `Read` | Native file reading |
| `Write` | Native file writing |
| `Edit` | Native file editing |
| `Bash` | Native shell execution |
| `TodoWrite` | Not available — track in conversation |
| `Task` (subagents) | Not available — work inline |

Use the `activate_skill` tool to load skills by name.
