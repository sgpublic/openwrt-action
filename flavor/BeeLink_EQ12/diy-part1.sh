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

. $COMMON_DIY_P1

##    添加你的自定义包    ##

# 添加软件源 sundaqiang/openwrt-packages
git_clone https://github.com/sundaqiang/openwrt-packages.git package/sundaqiang
# 添加软件源 nikkinikki-org/OpenWrt-nikki
git_clone https://github.com/nikkinikki-org/OpenWrt-nikki.git package/nikki

if [ "$USE_LOCAL_PACKAGES" == "y" ]; then
  # 本地拉取依赖
  rm -rf package/sgpublic && mkdir -p package/sgpublic
  cp -r /mnt/documents/OpenWrt/openwrt-packages/* package/sgpublic
else
  # 添加软件源 sgpublic/openwrt-packages
  git_clone https://github.com/sgpublic/openwrt-packages.git package/sgpublic
fi


# 拉取最新 GoLang
git_clone https://github.com/sbwml/packages_lang_golang ./custom-feeds/packages-sbwml/lang/golang 24.x
# 更新 v2ray-geodata
git_clone https://github.com/sbwml/v2ray-geodata ./custom-feeds/packages-sbwml/net/v2ray-geodata
# 拉取源 luci-app-zerotier
git_clone https://github.com/immortalwrt/luci ./custom-feeds/luci-immortalwrt $IMMORTALWRT_BRANCH
# 拉取源 luci-app-socat
git_clone https://github.com/Lienol/openwrt-package ./custom-feeds/luci-Lienol


# 拉取主题 luci-theme-argon
git_clone https://github.com/jerrykuku/luci-theme-argon.git package/jerrykuku/luci-theme-argon
# 拉取插件 luci-app-argon-config
git_clone https://github.com/jerrykuku/luci-app-argon-config.git package/jerrykuku/luci-app-argon-config
# 拉取插件 luci-app-mosdns
git_clone https://github.com/sbwml/luci-app-mosdns package/sbwml-mosdns
# 拉取插件 luci-app-taskplan
git_clone https://github.com/sirpdboy/luci-app-taskplan package/sirpdboy-taskplan
# 拉取插件 luci-app-ddns-go
git_clone https://github.com/sirpdboy/luci-app-ddns-go package/sirpdboy-ddns-go
# 拉取插件 luci-app-eqosplus
git_clone https://github.com/sirpdboy/luci-app-eqosplus package/sirpdboy/luci-app-eqosplus
