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

. $COMMON_DIY_P2

##    添加你的自定义逻辑    ##

# 修改默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-nginx/Makefile

# 删除内置 frp
rm -rf feeds/packages/net/frp
# 使用最新 GoLang
rm -rf feeds/packages/lang/golang
cp -a ./custom-feeds/packages-sbwml/lang/golang feeds/packages/lang/golang
# 使用 luci-app-socat
rm -rf feeds/luci/applications/luci-app-socat
cp -a ./custom-feeds/luci-Lienol/luci-app-socat feeds/luci/applications/luci-app-socat
# 使用 luci-app-zerotier
rm -rf feeds/luci/applications/luci-app-zerotier
cp -a ./custom-feeds/luci-immortalwrt/applications/luci-app-zerotier feeds/luci/applications/luci-app-zerotier
