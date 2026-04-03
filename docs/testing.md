# Testing Superpowers

## 如何测试 Skills

1. 启动新的 Claude Code 会话，验证 `using-superpowers` skill 自动注入
2. 手动调用 skill 并验证输出格式
3. 检查 hook 是否正常触发（如 git-check 拦截非法 git 命令）

## 测试 Hook 脚本

```bash
# 测试 session-start hook
CLAUDE_PLUGIN_ROOT=. ./hooks/session-start

# 测试 git-check hook
echo '{"tool_input":{"command":"git push --force"}}' | bash ./hooks/git-check/git-check.sh
```
