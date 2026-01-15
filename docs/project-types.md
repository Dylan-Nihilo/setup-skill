# 项目类型检测规则

详细的项目扫描和类型识别规则。

## 扫描步骤

### 1. 文件系统扫描

首先检查根目录下的关键文件：

```
检测顺序：
1. package.json     → Node.js 生态
2. pyproject.toml   → Python (现代)
3. requirements.txt → Python (传统)
4. go.mod           → Go
5. Cargo.toml       → Rust
6. pom.xml          → Java (Maven)
7. build.gradle     → Java (Gradle)
```

### 2. 深度分析

检测到主类型后，进一步分析：

**Node.js 项目深度分析**:
- 读取 `package.json` 的 dependencies 和 devDependencies
- 检查 `src/` 或 `app/` 目录结构
- 识别配置文件：`vite.config.*`, `next.config.*`, `nuxt.config.*`

**Python 项目深度分析**:
- 解析 `pyproject.toml` 的 dependencies
- 检查 `requirements.txt` 内容
- 识别框架特征目录

### 3. 工具链检测

| 文件/目录 | 表示工具 |
|----------|---------|
| `.eslintrc*` | ESLint |
| `prettier.config.*` | Prettier |
| `jest.config.*` | Jest |
| `vitest.config.*` | Vitest |
| `tsconfig.json` | TypeScript |
| `.github/workflows/` | GitHub Actions |
| `Dockerfile` | Docker |
