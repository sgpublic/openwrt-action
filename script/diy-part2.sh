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
# 使用最新 GoLang
rm -rf feeds/packages/lang/golang
cp -a ./custom-feeds/packages/lang/golang feeds/packages/lang/golang
# 使用 v2ray-geodata
rm -rf feeds/packages/net/v2ray-geodata
cp -a ./custom-feeds/packages/net/v2ray-geodata feeds/packages/net/v2ray-geodata
# 使用 luci-app-zerotier
rm -rf feeds/luci/applications/luci-app-zerotier
cp -a ./custom-feeds/luci-immortalwrt/applications/luci-app-zerotier feeds/luci/applications/luci-app-zerotier
