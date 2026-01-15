#!/bin/bash
# 项目扫描脚本 - 检测项目类型、框架和工具链
# 增强版 v2.0

PROJECT_DIR="${1:-.}"
cd "$PROJECT_DIR" || exit 1

# 初始化数组
declare -a FRAMEWORKS=()
declare -a TOOLS=()
declare -a DATABASES=()
declare -a TESTING=()
PROJECT_TYPE="unknown"

# ============================================
# 第一部分：项目类型检测
# ============================================

if [ -f "package.json" ]; then
    PROJECT_TYPE="nodejs"
elif [ -f "pyproject.toml" ] || [ -f "requirements.txt" ] || [ -f "setup.py" ]; then
    PROJECT_TYPE="python"
elif [ -f "go.mod" ]; then
    PROJECT_TYPE="go"
elif [ -f "Cargo.toml" ]; then
    PROJECT_TYPE="rust"
elif [ -f "pom.xml" ] || [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
    PROJECT_TYPE="java"
elif [ -f "Gemfile" ]; then
    PROJECT_TYPE="ruby"
elif [ -f "composer.json" ]; then
    PROJECT_TYPE="php"
elif ls *.csproj 1>/dev/null 2>&1 || ls *.sln 1>/dev/null 2>&1; then
    PROJECT_TYPE="dotnet"
elif [ -f "Package.swift" ]; then
    PROJECT_TYPE="swift"
fi

# ============================================
# 第二部分：Node.js 框架检测
# ============================================

if [ "$PROJECT_TYPE" = "nodejs" ] && [ -f "package.json" ]; then
    # 前端框架
    grep -q '"react"' package.json 2>/dev/null && FRAMEWORKS+=("react")
    grep -q '"vue"' package.json 2>/dev/null && FRAMEWORKS+=("vue")
    grep -q '"svelte"' package.json 2>/dev/null && FRAMEWORKS+=("svelte")
    grep -q '"@angular/core"' package.json 2>/dev/null && FRAMEWORKS+=("angular")
    grep -q '"solid-js"' package.json 2>/dev/null && FRAMEWORKS+=("solid")

    # 元框架
    grep -q '"next"' package.json 2>/dev/null && FRAMEWORKS+=("nextjs")
    grep -q '"nuxt"' package.json 2>/dev/null && FRAMEWORKS+=("nuxt")
    grep -q '"@remix-run"' package.json 2>/dev/null && FRAMEWORKS+=("remix")
    grep -q '"astro"' package.json 2>/dev/null && FRAMEWORKS+=("astro")

    # 后端框架
    grep -q '"express"' package.json 2>/dev/null && FRAMEWORKS+=("express")
    grep -q '"@nestjs/core"' package.json 2>/dev/null && FRAMEWORKS+=("nestjs")
    grep -q '"fastify"' package.json 2>/dev/null && FRAMEWORKS+=("fastify")
    grep -q '"koa"' package.json 2>/dev/null && FRAMEWORKS+=("koa")
    grep -q '"hono"' package.json 2>/dev/null && FRAMEWORKS+=("hono")
fi

# ============================================
# 第三部分：Python 框架检测
# ============================================

if [ "$PROJECT_TYPE" = "python" ]; then
    for f in requirements.txt pyproject.toml setup.py; do
        if [ -f "$f" ]; then
            grep -qi "django" "$f" 2>/dev/null && FRAMEWORKS+=("django")
            grep -qi "fastapi" "$f" 2>/dev/null && FRAMEWORKS+=("fastapi")
            grep -qi "flask" "$f" 2>/dev/null && FRAMEWORKS+=("flask")
            grep -qi "streamlit" "$f" 2>/dev/null && FRAMEWORKS+=("streamlit")
            grep -qi "gradio" "$f" 2>/dev/null && FRAMEWORKS+=("gradio")
        fi
    done
fi

# ============================================
# 第四部分：工具链检测
# ============================================

# TypeScript
[ -f "tsconfig.json" ] && TOOLS+=("typescript")

# 容器化
[ -f "Dockerfile" ] && TOOLS+=("docker")
[ -f "docker-compose.yml" ] || [ -f "docker-compose.yaml" ] && TOOLS+=("docker-compose")

# 构建工具 (Node.js)
if [ -f "package.json" ]; then
    grep -q '"vite"' package.json 2>/dev/null && TOOLS+=("vite")
    grep -q '"webpack"' package.json 2>/dev/null && TOOLS+=("webpack")
    grep -q '"esbuild"' package.json 2>/dev/null && TOOLS+=("esbuild")
    grep -q '"turbo"' package.json 2>/dev/null && TOOLS+=("turborepo")
    grep -q '"nx"' package.json 2>/dev/null && TOOLS+=("nx")
    grep -q '"tailwindcss"' package.json 2>/dev/null && TOOLS+=("tailwind")
fi

# Monorepo
[ -f "pnpm-workspace.yaml" ] && TOOLS+=("pnpm-workspace")
[ -f "lerna.json" ] && TOOLS+=("lerna")

# CLAUDE.md 检测
HAS_CLAUDE_MD="false"
[ -f "CLAUDE.md" ] && HAS_CLAUDE_MD="true"

# ============================================
# 第五部分：数据库/ORM 检测
# ============================================

if [ -f "package.json" ]; then
    grep -q '"prisma"' package.json 2>/dev/null && DATABASES+=("prisma")
    grep -q '"typeorm"' package.json 2>/dev/null && DATABASES+=("typeorm")
    grep -q '"sequelize"' package.json 2>/dev/null && DATABASES+=("sequelize")
    grep -q '"drizzle-orm"' package.json 2>/dev/null && DATABASES+=("drizzle")
    grep -q '"mongoose"' package.json 2>/dev/null && DATABASES+=("mongodb")
fi

if [ "$PROJECT_TYPE" = "python" ]; then
    for f in requirements.txt pyproject.toml; do
        [ -f "$f" ] && grep -qi "sqlalchemy" "$f" 2>/dev/null && DATABASES+=("sqlalchemy")
        [ -f "$f" ] && grep -qi "tortoise-orm" "$f" 2>/dev/null && DATABASES+=("tortoise")
    done
fi

# ============================================
# 第六部分：测试框架检测
# ============================================

if [ -f "package.json" ]; then
    grep -q '"jest"' package.json 2>/dev/null && TESTING+=("jest")
    grep -q '"vitest"' package.json 2>/dev/null && TESTING+=("vitest")
    grep -q '"mocha"' package.json 2>/dev/null && TESTING+=("mocha")
    grep -q '"playwright"' package.json 2>/dev/null && TESTING+=("playwright")
    grep -q '"cypress"' package.json 2>/dev/null && TESTING+=("cypress")
fi

if [ "$PROJECT_TYPE" = "python" ]; then
    for f in requirements.txt pyproject.toml; do
        [ -f "$f" ] && grep -qi "pytest" "$f" 2>/dev/null && TESTING+=("pytest")
    done
fi

# ============================================
# 第七部分：输出 JSON
# ============================================

# 数组转 JSON 格式
array_to_json() {
    local arr=("$@")
    if [ ${#arr[@]} -eq 0 ]; then
        echo "[]"
    else
        printf '["%s"' "${arr[0]}"
        for ((i=1; i<${#arr[@]}; i++)); do
            printf ', "%s"' "${arr[$i]}"
        done
        printf ']'
    fi
}

echo "{"
echo "  \"project_type\": \"$PROJECT_TYPE\","
echo "  \"frameworks\": $(array_to_json "${FRAMEWORKS[@]}"),"
echo "  \"tools\": $(array_to_json "${TOOLS[@]}"),"
echo "  \"databases\": $(array_to_json "${DATABASES[@]}"),"
echo "  \"testing\": $(array_to_json "${TESTING[@]}"),"
echo "  \"has_claude_md\": $HAS_CLAUDE_MD"
echo "}"
