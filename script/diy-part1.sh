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
  path=`pwd`
  echo "clone $1 to $2"
  if [ -d "$2/.git" ]; then
    echo "git repo $2 exists, try update"
    cd $2
    git pull
    cd $path
  else
    echo "git repo $2 not exists or invalid, try clone"
    rm -rf $2
    mkdir -p "$2"
    branch=
    if [ ! -z "$3" ]; then
      branch="-b $3"
    fi
    git clone $1 --depth=1 $branch $2
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
