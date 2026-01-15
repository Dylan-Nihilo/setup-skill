# 推荐规则配置

基于 `claude_code_datasource.json` 的推荐规则。

## 数据源

主数据源：`claude_code_datasource.json`
- Skills: skillsmp.com (52,000+)
- MCP: registry.modelcontextprotocol.io
- 官方文档: code.claude.com

## 项目类型检测

| 检测文件 | 项目类型 | 推荐分类 |
|---------|---------|---------|
| `package.json` | JavaScript/TypeScript | Frontend, Full Stack |
| `requirements.txt` | Python | Data & AI, Backend |
| `go.mod` | Go | Backend, DevOps |
| `Cargo.toml` | Rust | Backend, System |
| `pom.xml` | Java | Backend, Enterprise |
| `Gemfile` | Ruby | Backend, Web |
| `.csproj` | C#/.NET | Backend, Enterprise |

## Skills 分类

| 分类 | 数量 | 适用场景 |
|-----|------|---------|
| Tools | 17,448 | 开发工具、自动化 |
| Development | 15,805 | 应用开发、框架 |
| Data & AI | 10,431 | 数据处理、机器学习 |
| DevOps | 8,529 | CI/CD、部署 |
| Testing & Security | 6,249 | 测试、安全 |
| Documentation | 4,501 | 文档、知识库 |

## MCP 热门分类

- Web Search & Crawling
- Database Access
- File Management
- Git & Version Control
- Cloud Services
- Data Analysis
