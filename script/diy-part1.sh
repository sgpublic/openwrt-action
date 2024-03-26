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
if [ "$1" == "--local" ]; then
  set -v
fi

git_clone() {
  path=`pwd`
  if [ -d $2 ]; then
    cd $2
    git pull
    cd $path
  else
    mkdir -p "$2"
    git clone $1 --depth=1 $2
  fi
}

# 修改标准目录，若不需要注释掉即可，此代码对 action 编译没有任何影响
sed -i 's/$(TOPDIR)\/staging_dir/\/tmp\/openwrt\/staging_dir/g' rules.mk
mkdir -p /tmp/openwrt/staging_dir
ln -sf /tmp/openwrt/staging_dir staging_dir

sed -i 's/$(TOPDIR)\/build_dir/\/tmp\/openwrt\/build_dir/g' rules.mk
mkdir -p /tmp/openwrt/build_dir
ln -sf /tmp/openwrt/build_dir build_dir

mkdir -p /tmp/openwrt/binary
ln -sf /tmp/openwrt/binary bin

mkdir -p /tmp/openwrt/download
mkdir -p /tmp/openwrt/mirror
mkdir -p /tmp/openwrt/ccache
mkdir -p /tmp/openwrt/log

##    添加你的自定义包    ##

# 添加软件源 fw876/helloworld
# git_clone https://github.com/fw876/helloworld.git package/helloworld
# 添加软件源 sundaqiang/openwrt-packages
git_clone https://github.com/sundaqiang/openwrt-packages.git package/sundaqiang
# 添加软件源 vernesong/OpenClash
git_clone https://github.com/vernesong/OpenClash package/openclash

if [ "$1" == "--local" ]; then
  # 本地拉取依赖
  rm -rf package/sgpublic && mkdir -p package/sgpublic
  cp -r /mnt/core/home/Documents/OpenWrt/openwrt-packages/* package/sgpublic
  # rm -rf package/little-paimon && mkdir -p package/little-paimon
  # cp -r /mnt/e/Documents/OpenWrt/packages-little-paimon/* package/little-paimon
else
  # 添加软件源 sgpublic/openwrt-packages
  git_clone https://github.com/sgpublic/openwrt-packages.git package/sgpublic
  # # 添加软件源 sgpublic/packages-little-paimon
  # git_clone https://github.com/sgpublic/packages-little-paimon.git package/little-paimon
fi

# 拉取主题 luci-theme-argon
git_clone https://github.com/jerrykuku/luci-theme-argon.git package/jerrykuku/luci-theme-argon
# 拉取插件 luci-app-argon-config
git_clone https://github.com/jerrykuku/luci-app-argon-config.git package/jerrykuku/luci-app-argon-config
# 拉取插件 luci-app-mosdns 和其依赖
git_clone https://github.com/sbwml/luci-app-mosdns package/mosdns
git_clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
## 拉取插件 luci-app-frpc 和其依赖
#git_clone https://github.com/kuoruan/openwrt-frp package/kuoruan/openwrt-frp
#git_clone https://github.com/kuoruan/luci-app-frpc package/kuoruan/luci-app-frpc

