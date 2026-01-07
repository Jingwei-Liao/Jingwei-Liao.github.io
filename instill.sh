#!/bin/bash

# ==========================
# Run Jekyll Server Script
# ==========================

set -e

# 1. 设置 Ruby 3.1 路径（Homebrew 安装）
export PATH="/opt/homebrew/opt/ruby@3.1/bin:$PATH"

# 2. 检查 Ruby 版本
RUBY_VER=$(ruby -v | awk '{print $2}')
echo "Using Ruby version: $RUBY_VER"

if [[ "$RUBY_VER" != 3.1* ]]; then
    echo "ERROR: Ruby 3.1 is required for this project."
    exit 1
fi

# ==========================
# 启动前强制清理（关键）
# ==========================

echo "Cleaning Jekyll build & cache..."

rm -rf _site \
       .jekyll-cache \
       .sass-cache

# 如果你使用 vendor/bundle（推荐）
if [ -d "vendor/bundle" ]; then
    echo "Removing vendor/bundle..."
    rm -rf vendor/bundle
fi

# 尝试 Jekyll 自带 clean（双保险）
if command -v bundle >/dev/null 2>&1; then
    bundle exec jekyll clean || true
fi

# ==========================
# Bundler 管理
# ==========================

# 安装指定 Bundler
if ! bundle -v 2>/dev/null | grep -q "2.2.19"; then
    echo "Installing Bundler 2.2.19..."
    gem install bundler -v 2.2.19 --no-document
fi

# ==========================
# 安装依赖 & 启动
# ==========================

echo "Installing project dependencies..."
bundle install

echo "Starting Jekyll server..."
bundle exec jekyll serve \
  --livereload \
  --force_polling

# ==========================
# End of Script
# ==========================
