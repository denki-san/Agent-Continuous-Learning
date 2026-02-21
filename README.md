# Agent Continuous Learning

从 AI Agent 会话中自动提取、评估和保存可重用模式的系统。
参考：https://github.com/affaan-m/everything-claude-code/tree/main

## 概述

这个项目实现了一套 **持续学习机制**，让 AI Agent 能够：

1. **提取模式** — 从会话中识别有价值的问题解决模式、调试技巧和变通方案
2. **质量评估** — 使用五维评分表对提取的模式进行自评，确保质量
3. **智能存储** — 根据模式的适用范围，自动选择全局或项目级别的存储位置

## 核心功能

### 模式提取

系统会自动识别以下类型的可重用知识：

| 类型 | 描述 |
|------|------|
| 错误解决模式 | 根因分析 + 修复方案 + 可复用性评估 |
| 调试技巧 | 非显而易见的调试步骤、工具组合使用 |
| 变通方案 | 库的怪癖、API 限制、版本特定的修复方法 |
| 项目特定模式 | 约定、架构决策、集成模式 |

### 质量评估

使用五维评分表确保保存的技能质量：

| 维度 | 评估内容 |
|------|----------|
| 具体性 | 是否有充足的代码示例 |
| 可操作性 | 是否立即可执行 |
| 范围适配 | 名称、触发条件、内容是否匹配 |
| 非冗余性 | 是否提供独特的价值 |
| 覆盖度 | 是否覆盖主要场景和边界情况 |

每个维度 1-5 分，总分 25 分。所有维度必须 ≥ 3 分才能保存。

### 存储策略

- **全局存储** (`~/.claude/skills/learned/`)：可在多个项目中复用的通用模式
- **项目存储** (`.claude/skills/learned/`)：项目特定的知识和约定

## 文件结构

```
Agent-Continuous-Learning/
├── README.md           # 项目说明
├── learn-eval.md       # 核心技能定义：提取、评估、保存流程
└── .claude/
    └── skills/
        └── learned/    # 项目级学习到的技能
```

## 使用方法

在 Claude Code 中调用 `/learn-eval` 命令，系统会：

1. 回顾当前会话，寻找可提取的模式
2. 识别最有价值的洞察
3. 确定保存位置（全局 vs 项目）
4. 起草技能文件
5. 进行质量自评
6. 展示给用户确认
7. 保存到确定的位置

## 流程图

```
调用 /learn-eval
         ↓
  回顾会话 → 发现模式? → 识别类型（4种）
                            ↓
                确定存储位置（全局/项目）
                            ↓
                      起草技能文件
                            ↓
                      五维质量评估 ←──┐
                            ↓          │
                所有维度 ≥ 3? ─否─ 改进草稿
                            ↓是
                      用户确认 ─否─ 修改
                            ↓是
                      保存完成 ✓
```

## 跨平台安装方案

### 支持的 Coding Agent 平台

| 平台 | 类型 | 安装方式 | 自定义命令支持 |
|------|------|----------|----------------|
| **Claude Code** | AI 原生 CLI | Plugin + 手动复制 | ✅ `/learn-eval` |
| **Cursor** | AI 原生 IDE | `.cursorrules` + `.cursor/commands/` | ✅ 支持 |
| **Windsurf** | AI 原生 IDE | `.windsurfrules` + MCP | ✅ 支持 |
| **Zed** | AI 编辑器 | `~/.config/zed/tasks.json` | ⚠️ Task 形式 |
| **VS Code + Copilot** | 插件型 | `.github/copilot-instructions.md` | ❌ 仅 Prompt |
| **OpenCode** | AI CLI | Plugin 系统 | ✅ 完全兼容 |

### 安装方案

#### Claude Code

```bash
# 方式 1: 手动安装（推荐）
mkdir -p ~/.claude/commands
cp learn-eval.md ~/.claude/commands/

# 使用
/learn-eval
```

#### Cursor

```bash
# 创建 Cursor 配置目录
mkdir -p .cursor/commands

# 复制技能文件
cp learn-eval.md .cursor/commands/learn-eval.md

# 创建 .cursorrules（可选，用于全局规则）
echo "When user types /learn-eval, follow the workflow in .cursor/commands/learn-eval.md" >> .cursorrules
```

#### Windsurf

```bash
# 创建 .windsurfrules
cat > .windsurfrules << 'EOF'
## 自定义命令

### /learn-eval
从当前会话中提取可重用模式，评估质量后保存为技能。
详细流程见 `.windsurf/commands/learn-eval.md`
EOF

# 创建命令目录
mkdir -p .windsurf/commands
cp learn-eval.md .windsurf/commands/
```

#### Zed

```bash
# 编辑 Zed tasks 配置
# ~/.config/zed/tasks.json
{
  "learn-eval": {
    "command": "echo '从会话提取模式并评估'",
    "env": {},
    "allow_concurrent_runs": false
  }
}
```

#### VS Code + GitHub Copilot

```bash
# 创建项目级指令文件
mkdir -p .github
cat > .github/copilot-instructions.md << 'EOF'
# 持续学习指令

当用户请求提取模式时，按以下流程执行：
1. 回顾会话，识别可复用模式
2. 使用五维评分表评估质量
3. 确定保存位置（全局 vs 项目）
4. 起草技能文件并等待用户确认

详细说明见 learn-eval.md
EOF
```

#### OpenCode

```bash
# OpenCode 与 Claude Code 插件兼容
mkdir -p ~/.claude/commands
cp learn-eval.md ~/.claude/commands/
```

### 一键安装

```bash
# 克隆仓库
git clone https://github.com/denki-san/Agent-Continuous-Learning.git
cd Agent-Continuous-Learning

# 运行安装脚本（自动检测 Agent 类型）
bash install.sh
```

或指定目标平台：

```bash
bash install.sh --claude     # 安装到 Claude Code
bash install.sh --cursor     # 安装到 Cursor
bash install.sh --windsurf   # 安装到 Windsurf
```

## 设计理念

- **不提取琐碎修复** — 拼写错误、简单语法错误不值得保存
- **不提取一次性问题** — 特定 API 宕机等临时问题不保存
- **聚焦可复用性** — 只保存能在未来会话中节省时间的模式
- **保持单一职责** — 一个模式对应一个技能文件

## License

MIT
