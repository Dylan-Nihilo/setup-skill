# 贡献指南

感谢你对 Setup Skill 的关注！

## 贡献方式

Setup Skill 采用**远程 + 本地混合模式**，你可以选择两种贡献方式：

| 方式 | 说明 | 适合场景 |
|------|------|----------|
| 贡献远程源地址 | 添加新的 Skills 仓库地址 | 你维护了一个 Skills 仓库 |
| 贡献本地数据 | 直接添加 Skill 到本地数据源 | 单个 Skill 推荐 |

---

## 方式一：贡献远程源地址

如果你维护了一个 Skills 仓库，可以将地址添加到 `remote_sources`。

### 文件位置

```
data/datasource.json → remote_sources.skills
```

### 添加格式

```json
{
  "name": "your-username/your-repo",
  "url": "https://github.com/your-username/your-repo",
  "type": "community",
  "description": "简短描述你的仓库"
}
```

### type 类型说明

| type | 说明 |
|------|------|
| `official` | 官方仓库 |
| `community` | 社区精选 |
| `awesome-list` | Awesome 列表 |
| `domain-specific` | 领域专用 |

---

## 方式二：贡献本地数据

直接添加 Skill 到本地数据源。

### 文件位置

```
data/datasource.json → recommended_skills
```

### 添加格式

```json
{
  "name": "skill-name",
  "category": "分类",
  "description": "功能描述",
  "github_url": "https://github.com/...",
  "source": "community",
  "stars": 0,
  "tags": ["tag1", "tag2"],
  "project_types": ["react", "nodejs"]
}
```

### 字段说明

| 字段 | 必填 | 说明 |
|------|------|------|
| name | 是 | Skill 名称 |
| category | 是 | 分类（如：开发工具、文档处理） |
| description | 是 | 功能描述 |
| github_url | 是 | GitHub 地址 |
| source | 是 | 来源（anthropics/skills 或 community） |
| tags | 否 | 标签数组 |
| project_types | 否 | 适用项目类型 |

---

## 其他贡献

| 类型 | 文件 | 说明 |
|------|------|------|
| 改进扫描脚本 | `scripts/*.sh` | 支持更多项目类型/框架 |
| 改进文档 | `*.md` | 修正错误、补充说明 |
| 添加模板 | `templates/` | CLAUDE.md 模板 |

---

## 提交流程

```bash
# 1. Fork 并克隆
git clone https://github.com/YOUR_USERNAME/setup.git
cd setup

# 2. 创建分支
git checkout -b feat/add-xxx

# 3. 修改文件
vim data/datasource.json

# 4. 验证 JSON
python -m json.tool data/datasource.json > /dev/null

# 5. 提交
git add .
git commit -m "feat: add xxx"
git push origin feat/add-xxx

# 6. 创建 PR
```

---

## Commit 规范

```
feat: 新功能
fix: 修复
docs: 文档
refactor: 重构
```

---

## 联系方式

- Issues: [GitHub Issues](https://github.com/Dylan-Nihilo/setup/issues)

感谢你的贡献！
