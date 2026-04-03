#!/bin/bash
# Git 规范检查 Hook
# 检查 git 命令是否符合 Git 工作流规范

set -e

# 从 stdin 读取 JSON 输入
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# 如果不是 git 命令，直接通过
if [[ ! "$COMMAND" =~ ^git\  ]]; then
    exit 0
fi

# 分支命名规范：feat/*, fix/*, hotfix/*, release/*, main
BRANCH_PATTERN='^(feat|fix|hotfix|release)/.+$|^main$'

# 提交信息规范：Conventional Commits
# 格式: type(scope): description 或 type: description
COMMIT_PATTERN='^(feat|fix|docs|style|refactor|test|chore|perf|ci|build|revert)(\(.+\))?: .+'

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查分支创建/切换命令
check_branch_command() {
    local cmd="$1"

    # 检查 git checkout -b 或 git switch -c 命令
    if [[ "$cmd" =~ git\ (checkout\ -b|switch\ -c)\ ([^ ]+) ]]; then
        local branch_name="${BASH_REMATCH[2]}"

        if [[ ! "$branch_name" =~ $BRANCH_PATTERN ]]; then
            echo -e "${RED}❌ 分支名称不符合规范${NC}" >&2
            echo -e "${YELLOW}分支名称: ${branch_name}${NC}" >&2
            echo -e "${YELLOW}规范要求:${NC}" >&2
            echo -e "  - feat/*     新功能开发" >&2
            echo -e "  - fix/*      Bug 修复" >&2
            echo -e "  - hotfix/*   紧急修复" >&2
            echo -e "  - release/*  发布分支" >&2
            echo -e "  - main       主分支" >&2
            echo "" >&2
            echo -e "${GREEN}建议:${NC}" >&2
            echo -e "  git checkout -b feat/your-feature-name" >&2
            return 1
        fi
    fi

    # 检查 git branch <name> 命令（排除 -a, -r, -l 等选项）
    if [[ "$cmd" =~ ^git\ branch\ ([^-\ ].+)$ ]]; then
        local branch_name="${BASH_REMATCH[1]}"
        # 去除前后空格
        branch_name=$(echo "$branch_name" | xargs)

        if [[ -n "$branch_name" && ! "$branch_name" =~ $BRANCH_PATTERN ]]; then
            echo -e "${RED}❌ 分支名称不符合规范${NC}" >&2
            echo -e "${YELLOW}分支名称: ${branch_name}${NC}" >&2
            echo -e "${YELLOW}规范要求:${NC}" >&2
            echo -e "  - feat/*     新功能开发" >&2
            echo -e "  - fix/*      Bug 修复" >&2
            echo -e "  - hotfix/*   紧急修复" >&2
            echo -e "  - release/*  发布分支" >&2
            echo -e "  - main       主分支" >&2
            echo "" >&2
            echo -e "${GREEN}建议:${NC}" >&2
            echo -e "  git branch feat/your-feature-name" >&2
            return 1
        fi
    fi
    return 0
}

# 检查提交信息
check_commit_command() {
    local cmd="$1"

    # 检查 git commit -m 或 --message 命令
    if [[ "$cmd" =~ git\ commit.*(-m|--message) ]]; then
        local commit_msg=""

        # 格式1: -m "message" 或 -m 'message'
        if [[ "$cmd" =~ -m[[:space:]]+\"([^\"]+)\" ]]; then
            commit_msg="${BASH_REMATCH[1]}"
        elif [[ "$cmd" =~ -m[[:space:]]+\'([^\']+)\' ]]; then
            commit_msg="${BASH_REMATCH[1]}"
        # 格式2: -m message（无引号）
        elif [[ "$cmd" =~ -m[[:space:]]+([^-\ ]+) ]]; then
            commit_msg="${BASH_REMATCH[1]}"
        # 格式3: --message="..." 或 --message='...'
        elif [[ "$cmd" =~ --message=\"([^\"]+)\" ]]; then
            commit_msg="${BASH_REMATCH[1]}"
        elif [[ "$cmd" =~ --message=\'([^\']+)\' ]]; then
            commit_msg="${BASH_REMATCH[1]}"
        # 格式4: --message=...
        elif [[ "$cmd" =~ --message=([^[:space:]]+) ]]; then
            commit_msg="${BASH_REMATCH[1]}"
        fi

        # 只取第一行（标题）
        commit_msg=$(echo "$commit_msg" | head -n1)

        if [[ -n "$commit_msg" && ! "$commit_msg" =~ $COMMIT_PATTERN ]]; then
            echo -e "${RED}❌ 提交信息不符合 Conventional Commits 规范${NC}" >&2
            echo -e "${YELLOW}提交信息: ${commit_msg}${NC}" >&2
            echo -e "${YELLOW}规范要求: type(scope): description${NC}" >&2
            echo "" >&2
            echo -e "${GREEN}允许的类型:${NC}" >&2
            echo -e "  - feat:     新功能" >&2
            echo -e "  - fix:      Bug 修复" >&2
            echo -e "  - docs:     文档更新" >&2
            echo -e "  - style:    代码格式" >&2
            echo -e "  - refactor: 重构" >&2
            echo -e "  - test:     增加测试" >&2
            echo -e "  - chore:    构建或辅助工具变动" >&2
            echo -e "  - perf:     性能优化" >&2
            echo -e "  - ci:       CI 配置变动" >&2
            echo -e "  - build:    构建系统或外部依赖变动" >&2
            echo -e "  - revert:   回退之前的 commit" >&2
            echo "" >&2
            echo -e "${GREEN}示例:${NC}" >&2
            echo -e "  git commit -m \"feat: add user authentication\"" >&2
            echo -e "  git commit -m \"fix: resolve login timeout issue\"" >&2
            echo -e "  git commit -m \"docs: update API documentation\"" >&2
            return 1
        fi
    fi
    return 0
}

# 检查危险命令
check_dangerous_commands() {
    local cmd="$1"

    # 检查 git push --force
    if [[ "$cmd" =~ git\ push.*--force ]]; then
        echo -e "${RED}❌ 禁止使用 --force 推送${NC}" >&2
        echo -e "${YELLOW}强制推送可能覆盖其他人的提交，造成代码丢失${NC}" >&2
        echo -e "${GREEN}建议使用 --force-with-lease (更安全的强制推送)${NC}" >&2
        return 1
    fi

    # 检查 git reset --hard 到远程分支
    if [[ "$cmd" =~ git\ reset\ --hard\ origin/ ]]; then
        echo -e "${RED}⚠️  警告: reset --hard 到远程分支会丢失本地提交${NC}" >&2
        echo -e "${YELLOW}请确认你是否真的想这样做${NC}" >&2
    fi

    # 检查 git push --all 或 --tags
    if [[ "$cmd" =~ git\ push.*--all ]] || [[ "$cmd" =~ git\ push.*--tags ]]; then
        echo -e "${YELLOW}⚠️  注意: 推送所有分支或标签${NC}" >&2
        echo -e "${YELLOW}请确认这是你想要的操作${NC}" >&2
    fi

    return 0
}

# 检查推送到 main 分支
check_push_to_main() {
    local cmd="$1"

    if [[ "$cmd" =~ git\ push.*origin\ main ]] || [[ "$cmd" =~ git\ push.*origin\ master ]]; then
        echo -e "${RED}❌ 禁止直接推送到 main/master 分支${NC}" >&2
        echo -e "${YELLOW}请通过 Pull/Merge Request 合并代码${NC}" >&2
        echo -e "${GREEN}建议:${NC}" >&2
        echo -e "  1. 创建功能分支: git checkout -b feat/your-feature" >&2
        echo -e "  2. 推送功能分支: git push origin feat/your-feature" >&2
        echo -e "  3. 创建 Pull/Merge Request 进行代码审查" >&2
        return 1
    fi
    return 0
}

# 执行所有检查
main() {
    if ! check_dangerous_commands "$COMMAND"; then
        exit 2
    fi

    if ! check_push_to_main "$COMMAND"; then
        exit 2
    fi

    if ! check_branch_command "$COMMAND"; then
        exit 2
    fi

    if ! check_commit_command "$COMMAND"; then
        exit 2
    fi

    exit 0
}

main
