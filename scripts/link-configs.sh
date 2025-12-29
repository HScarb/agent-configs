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

# 需要整体链接的子目录（链接目录本身而非其中的文件）
# 格式：相对于配置目录的路径，如 "skills" 表示 .claude/skills 下的每个子目录
DIR_LINK_SUBDIRS=("skills")

# 创建软链接的辅助函数
create_link() {
    local src="$1"
    local target="$2"
    local target_dir="$(dirname "$target")"

    # 确保目标目录存在
    if [ ! -d "$target_dir" ]; then
        echo "  Creating directory: $target_dir"
        mkdir -p "$target_dir"
    fi

    # 如果目标已存在（文件、目录或链接），先删除
    if [ -e "$target" ] || [ -L "$target" ]; then
        echo "  Removing existing: $target"
        rm -rf "$target"
    fi

    # 创建软链接
    echo "  Linking: $src -> $target"
    ln -s "$src" "$target"
}

# 遍历每个配置目录
for config_dir in "${CONFIG_DIRS[@]}"; do
    src_dir="$SCRIPT_DIR/$config_dir"

    # 如果源目录不存在，跳过
    if [ ! -d "$src_dir" ]; then
        echo "Skip: $src_dir (not found)"
        continue
    fi

    echo "Processing: $config_dir"

    # 构建 find 的排除参数（排除需要整体链接的目录）
    exclude_args=()
    for subdir in "${DIR_LINK_SUBDIRS[@]}"; do
        subdir_path="$src_dir/$subdir"
        if [ -d "$subdir_path" ]; then
            # 处理需要整体链接的子目录
            echo "  Processing directory links: $config_dir/$subdir"
            for item in "$subdir_path"/*/; do
                if [ -d "$item" ]; then
                    item_name="$(basename "$item")"
                    rel_path="$config_dir/$subdir/$item_name"
                    target_path="$USER_HOME/$rel_path"
                    create_link "$item" "$target_path"
                fi
            done
            # 添加排除参数
            exclude_args+=(-path "$subdir_path" -prune -o)
        fi
    done

    # 查找并链接普通文件（排除已整体链接的目录）
    if [ ${#exclude_args[@]} -gt 0 ]; then
        find "$src_dir" "${exclude_args[@]}" -type f -print | while read -r src_file; do
            rel_path="${src_file#$SCRIPT_DIR/}"
            target_file="$USER_HOME/$rel_path"
            create_link "$src_file" "$target_file"
        done
    else
        find "$src_dir" -type f | while read -r src_file; do
            rel_path="${src_file#$SCRIPT_DIR/}"
            target_file="$USER_HOME/$rel_path"
            create_link "$src_file" "$target_file"
        done
    fi
done

echo ""
echo "Done! All config files have been linked."
