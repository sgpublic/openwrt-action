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
# 使用最新 v2ray-geodata
rm -rf feeds/packages/net/v2ray-geodata
cp -a ./custom-feeds/packages-sbwml/net/v2ray-geodata feeds/packages/net/v2ray-geodata
