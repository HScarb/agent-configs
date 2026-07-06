# agent-configs

Scarb 的 agent skills 库。所有能力统一以 [Agent Skills](https://agentskills.io) 格式存放在 `skills/` 目录下，可作为插件安装到 Claude Code、Codex、Cursor，或通过 `npx` 直接复制到任意 agent 的 skills 目录。

## Skills

| Skill | 用途 |
|-------|------|
| [feature-designer](skills/feature-designer/SKILL.md) | 生成高信息密度、可直接实施的特性设计文档 |
| [project-blueprint](skills/project-blueprint/SKILL.md) | 分析源码生成项目关键文档（概览/架构/技术栈/API/部署） |
| [source-analyst](skills/source-analyst/SKILL.md) | 将函数业务逻辑转换为 PlantUML 活动图，辅助源码理解 |
| [intranet-browser](skills/intranet-browser/SKILL.md) | 在公司内网 Windows 机器上用 agent-browser 可靠访问内网页面 |

## 安装

### Claude Code（插件）

```
/plugin marketplace add HScarb/agent-configs
/plugin install agent-configs@agent-configs
```

### npx（复制到 skills 目录，适用于任意 agent）

```bash
# 自动检测本机已有的 ~/.claude / ~/.codex / ~/.cursor 并全部安装
npx github:HScarb/agent-configs

# 只安装到指定 agent
npx github:HScarb/agent-configs --agent claude

# 只安装个别 skill
npx github:HScarb/agent-configs feature-designer source-analyst

# 安装到当前项目（./.claude/skills 等）而非用户目录
npx github:HScarb/agent-configs --project

# 查看可用 skill
npx github:HScarb/agent-configs --list
```

也兼容 [skills CLI](https://github.com/vercel-labs/skills)：`npx skills add HScarb/agent-configs`。

### Codex / Cursor（插件）

仓库根目录提供 `.codex-plugin/plugin.json` 与 `.cursor-plugin/plugin.json` 清单（`skills` 字段指向 `./skills/`），可按各自插件机制安装；或直接使用上面的 `npx` 方式复制到 `~/.codex/skills`、`~/.cursor/skills`。

## 目录结构

```
agent-configs/
├── .claude-plugin/     # Claude Code 插件清单 + marketplace
├── .codex-plugin/      # Codex 插件清单
├── .cursor-plugin/     # Cursor 插件清单
├── bin/install.js      # npx 安装脚本
├── package.json
└── skills/             # 全部 skill（每个子目录一个 SKILL.md）
    └── <skill-name>/
        ├── SKILL.md
        └── references/ # 可选的模板与重型参考
```

## License

MIT
