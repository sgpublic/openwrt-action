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
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-ssl-nginx/Makefile

# 删除 uhttpd
sed -i 's/+uhttpd-mod-ubus//g' feeds/luci/collections/luci/Makefile
sed -i 's/+uhttpd//g' feeds/luci/collections/luci/Makefile

# 更新 GoLang
rm -r feeds/packages/lang/golang
if [ -d "/mnt/core/home/Document/OpenWrt/packages/lang/golang" ]; then
  cp -a /mnt/core/home/Document/OpenWrt/packages/lang/golang feeds/packages/lang
else
  svn export https://github.com/openwrt/packages/trunk/lang/golang feeds/packages/lang/golang
fi
