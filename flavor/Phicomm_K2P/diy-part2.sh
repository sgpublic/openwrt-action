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
# 使用 lede 闭源驱动
rm -rf package/lede-mt
mkdir -p package/lede-mt
cp -a ./custom-feeds/lede/package/lean/mt/drivers/mt7615d package/lede-mt/mt7615d
cp -a ./custom-feeds/lede/package/lean/mt/drivers/mt_wifi package/lede-mt/mt_wifi
