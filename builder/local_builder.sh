#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"
docker build -t mhmzx/openwrt-builder .

docker run --rm -it \
  -v $ACTION_WORK_ROOT:/mnt/openwrt-action \
  -v $SGPUBLIC_PACKAGE_DIR:/mnt/openwrt-packages:ro \
  -v $OPENWRT_CACHE_DIR:/var/cache/openwrt \
  -v $BUILD_WORK_DIR:/mnt/work \
  -e USE_LOCAL_PACKAGES=${USE_LOCAL_PACKAGES:-n} \
  -u $(id -u):$(id -g) \
  mhmzx/openwrt-builder \
  /mnt/openwrt-action/builder/real_builder.sh
