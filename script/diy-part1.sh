#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
set -e

git_clone() {
  local repo="$1"
  local dir="$2"
  local ref="$3"

  echo "==> $repo -> $dir ${ref:+($ref)}"

  if [ -d "$dir/.git" ]; then
    echo "git repo exists, try update"
    git -C "$dir" fetch --tags origin

    if [ -n "$ref" ]; then
      if git -C "$dir" show-ref --verify --quiet "refs/remotes/origin/$ref"; then
        echo "checkout remote branch: $ref"
        git -C "$dir" checkout -B "$ref" "origin/$ref"
        git -C "$dir" reset --hard "origin/$ref"
      elif git -C "$dir" show-ref --verify --quiet "refs/tags/$ref"; then
        echo "checkout tag: $ref"
        git -C "$dir" checkout -f "tags/$ref"
      elif git -C "$dir" rev-parse --verify --quiet "$ref^{commit}" >/dev/null; then
        echo "checkout commit: $ref"
        git -C "$dir" checkout -f "$ref"
      else
        echo "error: ref not found: $ref"
        return 1
      fi
    else
      local current_branch
      current_branch=$(git -C "$dir" symbolic-ref --short -q HEAD || true)
      if [ -n "$current_branch" ] && git -C "$dir" show-ref --verify --quiet "refs/remotes/origin/$current_branch"; then
        git -C "$dir" fetch origin "$current_branch"
        git -C "$dir" reset --hard "origin/$current_branch"
      else
        echo "HEAD is detached and no ref specified, skip update"
      fi
    fi
  else
    echo "git repo not exists or invalid, try clone"
    rm -rf "$dir"

    if [ -z "$ref" ]; then
      git clone --depth=1 "$repo" "$dir"
    else
      # 先尝试按 branch/tag 浅克隆
      if git clone --depth=1 --branch "$ref" "$repo" "$dir" 2>/dev/null; then
        :
      else
        # 说明大概率是 commit id，退回普通 clone 再 checkout
        git clone "$repo" "$dir"
        git -C "$dir" fetch --tags origin
        git -C "$dir" checkout -f "$ref"
      fi
    fi
  fi
}

set -v

# 修改标准目录，若不需要注释掉即可，此代码对 action 编译没有任何影响
sed -i 's/$(TOPDIR)\/staging_dir/\/var\/cache\/openwrt\/staging_dir/g' rules.mk
mkdir -p /var/cache/openwrt/staging_dir
rm -f ./staging_dir
ln -sf /var/cache/openwrt/staging_dir ./staging_dir

sed -i 's/$(TOPDIR)\/build_dir/\/var\/cache\/openwrt\/build_dir/g' rules.mk
mkdir -p /var/cache/openwrt/build_dir
rm -f ./build_dir
ln -sf /var/cache/openwrt/build_dir ./build_dir

mkdir -p /var/cache/openwrt/binary
rm -f ./bin
ln -sf /var/cache/openwrt/binary ./bin

mkdir -p /var/cache/openwrt/download
mkdir -p /var/cache/openwrt/mirror
mkdir -p /var/cache/openwrt/ccache
mkdir -p /var/cache/openwrt/log
