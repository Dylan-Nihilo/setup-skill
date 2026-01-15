---
name: setup
description: 项目智能配置助手。扫描项目架构，推荐并自动安装最佳的 skills、plugins 和 MCP 配置。使用 /setup 命令触发。
---

# Project Setup Skill

智能分析项目结构，为 Claude Code 推荐最佳实践配置。

## 核心理念

**你（Claude）是决策者，不是执行脚本的机器。**

```
脚本 = 收集数据的工具
数据源 = 提供选项的菜单
你 = 理解、分析、决策、推荐
```

这个 skill 的本质是：你根据项目情况，从数据源中智能选择合适的配置推荐给用户。

## 执行流程

当用户调用 `/setup` 时，按以下步骤执行：

### 第一步：收集项目信息

运行扫描脚本，获取项目数据：

```bash
# 扫描当前项目
bash ~/.claude/skills/setup/scripts/scan-project.sh .

# 扫描全局已安装配置
bash ~/.claude/skills/setup/scripts/scan-global.sh
```

> 脚本位置：`scripts/scan-project.sh`, `scripts/scan-global.sh`

**脚本输出示例**：

```json
{
  "project_type": "nodejs",
  "frameworks": ["react", "nextjs"],
  "tools": ["typescript", "tailwind"],
  "databases": ["prisma"],
  "testing": ["jest"],
  "has_claude_md": false
}
```

你拿到这个 JSON 后，理解这是一个什么样的项目。

### 第二步：获取数据源（混合模式）

**采用远程 + 本地混合模式获取推荐数据。**

#### 2.1 读取本地数据源

```bash
~/.claude/skills/setup/data/datasource.json
```

本地数据源包含：
- `remote_sources` - 远程数据源地址列表
- `recommended_skills` - 本地精选 Skills
- `recommended_mcp` - 本地精选 MCP
- `recommended_plugins` - 本地精选 Plugins

#### 2.2 访问远程数据源

使用 WebFetch 访问 `remote_sources.skills` 中的仓库：

| 数据源 | URL | 类型 |
|--------|-----|------|
| anthropics/skills | github.com/anthropics/skills | 官方 |
| obra/superpowers | github.com/obra/superpowers | 社区精选 |
| travisvn/awesome-claude-skills | github.com/travisvn/awesome-claude-skills | Awesome 列表 |
| ComposioHQ/awesome-claude-skills | github.com/ComposioHQ/awesome-claude-skills | Awesome 列表 |
| K-Dense-AI/claude-scientific-skills | github.com/K-Dense-AI/claude-scientific-skills | 领域专用 |

**获取方式**：
```
WebFetch → 读取仓库 README → 提取 Skills 列表 → 理解每个 Skill 的用途
```

#### 2.3 合并数据

```
本地 recommended_skills + 远程获取的 Skills = 完整推荐池
```

> 如果网络不可用，仅使用本地数据源。

### 第三步：智能决策（核心）

**这一步由你完成，不是脚本。**

你需要：

1. **理解项目**
   - 这是什么类型的项目？
   - 用了什么技术栈？
   - 可能有什么开发需求？

2. **分析数据源**
   - 浏览 `recommended_skills` 列表
   - 阅读每个 skill 的 description 和 tags
   - 判断哪些 skills 对这个项目有价值

3. **做出推荐决策**
   - 选择 3-5 个最相关的 skills
   - 为每个推荐写出具体理由
   - 理由要结合项目实际情况

**决策参考原则**：

| 项目特征 | 推荐方向 |
|----------|----------|
| 有 React/Vue/前端框架 | frontend-design, web-artifacts-builder |
| 有 TypeScript | 类型相关的开发工具 |
| 有测试框架 | webapp-testing, playwright-skill |
| 有数据库/ORM | 数据相关 skills |
| 是 Python 项目 | Python 生态 skills |
| 需要文档处理 | docx, pdf, xlsx 等 |

### 第四步：展示推荐

向用户展示你的分析和推荐：

```markdown
## 项目分析

**项目类型**: Next.js 全栈应用
**技术栈**: React, TypeScript, Prisma, Tailwind
**测试**: Jest

## 推荐配置

### Skills 推荐

1. **frontend-design**
   推荐理由：你的项目使用 React + Tailwind，这个 skill 可以帮助生成高质量的前端界面。

2. **webapp-testing**
   推荐理由：检测到 Jest，这个 skill 提供 Playwright 测试能力，补充端到端测试。

3. **mcp-builder**
   推荐理由：作为全栈项目，可能需要集成外部 API，这个 skill 帮助构建 MCP 服务器。

### MCP 推荐

（根据项目需求推荐）

### CLAUDE.md 建议

检测到项目没有 CLAUDE.md，建议创建并添加：
- 项目结构说明
- 开发规范
- 常用命令
```

### 第五步：用户确认

使用 `AskUserQuestion` 工具询问用户：

- 是否同意这些推荐？
- 是否需要调整？
- 是否立即安装？

### 第六步：执行安装

用户确认后，根据 skill 来源采用不同安装策略：

#### 6.1 本地数据源 Skills（直接安装）

如果推荐的 skill 在 `datasource.json` 中且有 `install_cmd`，**直接执行安装命令**：

```bash
# 检查 install_cmd 字段
# 如果存在，直接执行：
/plugin marketplace add anthropics/skills
/plugin marketplace add obra/superpowers
/plugin marketplace add lackeyjb/playwright-skill
# 等等...
```

**本地数据源覆盖的安装命令模式**：

| 来源 | 安装命令 |
|------|----------|
| anthropics/skills | `/plugin marketplace add anthropics/skills` |
| obra/superpowers | `/plugin marketplace add obra/superpowers` |
| K-Dense-AI | `/plugin install scientific-skills@claude-scientific-skills` |
| lackeyjb/playwright-skill | `/plugin marketplace add lackeyjb/playwright-skill` |
| ComposioHQ/* | `cp -r <skill-name> ~/.claude/skills/` |
| 独立仓库 | `cp -r <skill-name> ~/.claude/skills/` 或 `pip install <package>` |

#### 6.2 远程 Skills（搜索获取）

如果推荐的 skill **不在本地数据源中**，使用 WebSearch 搜索获取安装信息：

```
WebSearch: "claude code skill <skill-name> install github"
WebSearch: "<skill-name> claude plugin installation"
```

**搜索后处理**：
1. 从搜索结果中提取 GitHub 仓库地址
2. 获取安装命令（通常在 README 中）
3. 向用户展示安装选项：

```markdown
## 远程 Skill: <skill-name>

**来源**: <github-url>
**安装方式**:
- 方式一: `/plugin install <plugin-name>@<marketplace>`
- 方式二: `openskills install -g -y <github-url>`

是否安装？
```

#### 6.3 手动安装（备选）

如果自动安装失败或用户偏好手动：

```bash
# 从 GitHub 安装
openskills install -g -y <github-url>
cp -r ~/.agent/skills/<skill-name> ~/.claude/skills/

# 或直接克隆
git clone <github-url> ~/.claude/skills/<skill-name>
```

#### 6.4 配置 MCP

修改 `~/.claude.json` 添加 MCP server 配置

#### 6.5 创建/更新 CLAUDE.md

使用 `templates/CLAUDE.md.template` 模板，根据项目情况填充内容

### 第七步：生成报告

```markdown
## Setup 完成

✅ 已安装 Skills: frontend-design, webapp-testing
✅ 已配置 MCP: （如有）
✅ CLAUDE.md 已创建

## 下一步
- 运行 `/init` 初始化项目上下文
- 查看 CLAUDE.md 了解项目配置
```

## 重要提示

1. **你是决策者** - 不要机械地匹配关键词，要理解项目并做出合理推荐
2. **推荐要有理由** - 每个推荐都要说明为什么适合这个项目
3. **数量适度** - 推荐 3-5 个最相关的，不要推荐太多
4. **尊重用户** - 始终在安装前获得用户确认
5. **保留现有配置** - 如果已有 CLAUDE.md，合并而不是覆盖

## 数据源字段说明

`recommended_skills` 中每个 skill 的字段：

| 字段 | 说明 | 你如何使用 |
|------|------|-----------|
| name | skill 名称 | 安装时使用 |
| category | 分类 | 快速定位相关 skills |
| description | 功能描述 | **重点阅读**，判断是否适合 |
| github_url | 来源地址 | 安装时使用 |
| tags | 标签 | 辅助判断相关性 |
| project_types | 适用项目类型 | 参考，但不要机械匹配 |

## 与 /init 的关系

- `/setup` - 配置工具和环境（你推荐并安装 skills、MCP 等）
- `/init` - 初始化项目上下文（生成 CLAUDE.md 内容）

建议顺序：先 `/setup` 后 `/init`
