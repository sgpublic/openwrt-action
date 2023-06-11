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

# 修改默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-nginx/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-ssl-nginx/Makefile

# 删除 uhttpd
sed -i 's/+uhttpd-mod-ubus//g' feeds/luci/collections/luci/Makefile
sed -i 's/+uhttpd//g' feeds/luci/collections/luci/Makefile

# [CTCGFW]immortalwrt
# Use it under GPLv3, please.
# --------------------------------------------------------
# Remove upx commands
makefile_file="$({ find package | grep Makefile | sed "/Makefile./d"; } 2>"/dev/null")"
for a in ${makefile_file}; do
  [ -n "$(grep "upx" "$a")" ] && sed -i "/upx/d" "$a"
done

#      r2s 限定      #
# 交换 LAN/WAN 口
sed -i 's,"eth1" "eth0","eth0" "eth1",g' target/linux/rockchip/armv8/base-files/etc/board.d/02_network
sed -i "s,'eth1' 'eth0','eth0' 'eth1',g" target/linux/rockchip/armv8/base-files/etc/board.d/02_network
# 添加 INNO_USB3
sed -i '/CONFIG_PHY_ROCKCHIP_INNO_USB3/d' target/linux/rockchip/armv8/config-*
echo 'CONFIG_PHY_ROCKCHIP_INNO_USB3=y' >> target/linux/rockchip/armv8/config-*
# 新 r8152 驱动
svn export --force https://github.com/immortalwrt/immortalwrt/trunk/package/kernel/r8152 ./package/kernel/r8152-new