#!/bin/bash

# 脚本：将当前目录下的配置文件软链接到用户目录
# 用法：./scripts/link-configs.sh

set -e

# 获取脚本所在目录的父目录（即项目根目录）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# 用户目录
USER_HOME="$HOME"

echo "Source directory: $SCRIPT_DIR"
echo "Target directory: $USER_HOME"
echo ""

# 需要处理的配置目录列表
CONFIG_DIRS=(".claude" ".gemini" ".roo")

# 遍历每个配置目录
for config_dir in "${CONFIG_DIRS[@]}"; do
    src_dir="$SCRIPT_DIR/$config_dir"

    # 如果源目录不存在，跳过
    if [ ! -d "$src_dir" ]; then
        echo "Skip: $src_dir (not found)"
        continue
    fi

    echo "Processing: $config_dir"

    # 递归查找所有文件
    find "$src_dir" -type f | while read -r src_file; do
        # 计算相对路径
        rel_path="${src_file#$SCRIPT_DIR/}"
        # 目标文件路径
        target_file="$USER_HOME/$rel_path"
        # 目标文件所在目录
        target_dir="$(dirname "$target_file")"

        # 确保目标目录存在
        if [ ! -d "$target_dir" ]; then
            echo "  Creating directory: $target_dir"
            mkdir -p "$target_dir"
        fi

        # 如果目标已存在（文件或链接），先删除
        if [ -e "$target_file" ] || [ -L "$target_file" ]; then
            echo "  Removing existing: $target_file"
            rm -f "$target_file"
        fi

        # 创建软链接
        echo "  Linking: $rel_path"
        ln -s "$src_file" "$target_file"
    done
done

echo ""
echo "Done! All config files have been linked."
