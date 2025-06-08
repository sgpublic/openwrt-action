#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

set -e
if [ "$1" == "--local" ]; then
  set -v
fi


##    添加你的自定义逻辑    ##

# 修改默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-nginx/Makefile

# 更新 GoLang
rm -r feeds/packages/lang/golang
git_clone https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang 24.x

# 更新v2ray-geodata
rm -r feeds/packages/net/v2ray-geodata
git_clone https://github.com/sbwml/v2ray-geodata feeds/packages/net/v2ray-geodata

# 拉取源 luci-app-zerotier
rm -r feeds/luci/application/luci-app-zerotier
git_clone https://github.com/immortalwrt/luci.git ../immortalwrt/luci $IMMORTALWRT_BRANCH
cp -a ../immortalwrt/luci/application/luci-app-zerotier feeds/luci/application/luci-app-zerotier
