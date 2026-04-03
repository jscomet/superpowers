# superpowers

自定义 AI agent 技能框架，支持多平台集成。

## 支持的平台

| 平台 | 配置 | 状态 |
|------|------|------|
| Claude Code | `.claude-plugin/plugin.json` | 已集成 |
| Cursor | `.cursor-plugin/plugin.json` | 已集成 |
| Gemini CLI | `gemini-extension.json` + `GEMINI.md` | 已集成 |
| Codex | `.codex/INSTALL.md` | 已集成 |
| OpenCode | `.opencode/plugins/superpowers.js` | 已集成 |

## 目录结构

```
.
├── .claude-plugin/
│   ├── plugin.json                    # Claude Code 插件配置
│   └── marketplace.json               # 本地开发 marketplace
├── .codex/
│   └── INSTALL.md                     # Codex 安装说明
├── .cursor-plugin/
│   └── plugin.json                    # Cursor 插件配置
├── .github/                           # GitHub 模板（PR、Issue）
├── .opencode/
│   └── plugins/superpowers.js         # OpenCode 插件
├── agents/
│   └── code-reviewer.md               # Agent 定义
├── commands/                          # 自定义斜杠命令
├── docs/
│   ├── plans/                         # 设计计划
│   ├── superpowers/specs/             # 规范文档
│   ├── testing.md                     # 测试方法
│   ├── README.codex.md                # Codex 平台说明
│   └── README.opencode.md             # OpenCode 平台说明
├── hooks/
│   ├── hooks.json                     # Claude Code Hook 注册
│   ├── hooks-cursor.json              # Cursor Hook 注册
│   ├── run-hook.cmd                   # 跨平台 hook 包装器
│   ├── session-start                  # 会话启动（自动检测平台）
│   └── git-check/git-check.sh         # Git 规范检查（PreToolUse）
├── scripts/
│   └── bump-version.sh                # 版本同步脚本
├── skills/
│   └── using-superpowers/
│       ├── SKILL.md                   # 入口 skill
│       └── references/                # 平台工具映射参考
└── tests/                             # 集成测试
```

## 安装

### Claude Code

```bash
# 在项目的 .claude/settings.json 中添加插件路径
claude plugin add /path/to/superpowers
```

### Cursor

在 Cursor 设置中指向 `.cursor-plugin/plugin.json`。

### Gemini CLI

将 `gemini-extension.json` 和 `GEMINI.md` 复制到 Gemini 扩展目录。

### Codex / OpenCode

参见 `.codex/INSTALL.md` 和 `.opencode/INSTALL.md`。

## 扩展

| 目录 | 用途 |
|------|------|
| `agents/` | 添加 `.md` 文件定义 agent 角色 |
| `commands/` | 添加自定义斜杠命令（`.md` 文件） |
| `docs/plans/` | 设计计划 |
| `docs/superpowers/specs/` | 规范文档 |
| `hooks/` | 注册 hook 事件 |
| `skills/` | 新建目录 + `SKILL.md` 添加 skill |

## Hooks

### session-start

会话启动时自动注入 `using-superpowers` gateway skill，支持多平台自动检测。

### git-check

在 AI 调用 `Bash` 工具时自动拦截 git 命令并检查规范：

| 检查项 | 规则 |
|--------|------|
| 分支命名 | `feat/*`, `fix/*`, `hotfix/*`, `release/*`, `main` |
| 提交信息 | Conventional Commits: `type(scope): description` |
| `--force` 推送 | 禁止，建议用 `--force-with-lease` |
| 推送到 main/master | 禁止，需走 PR/MR 流程 |

## 版本管理

```bash
# 检查版本一致性
./scripts/bump-version.sh --check

# 审计未声明版本引用
./scripts/bump-version.sh --audit

# 升级版本
./scripts/bump-version.sh 0.2.0
```

## License

MIT
