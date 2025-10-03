# Actions-OpenWrt

食用方法：

1. 安装 docker
2. 将此仓库克隆到你喜欢的目录（假设是 `/var/work/openwrt-action`）
3. 创建一个编译缓存目录（假设是 `/var/cache/openwrt`）
4. 创建一个编译工作目录（假设是 `/var/work/openwrt`），并在工作目录中创建如下脚本（命名为 `build.sh`）：

   ```shell
   #!/bin/bash -e
   
   # 仓库克隆目录
   export ACTION_WORK_ROOT=/var/work/openwrt-action
   # 你的编译缓存目录
   export OPENWRT_CACHE_DIR=/var/cache/openwrt
   # 你的编译工作目录
   export BUILD_WORK_DIR=/var/work/openwrt
   
   /var/work/openwrt-action/builder/local_builder.sh
   ```
   
   若你在 docker 中运行上述脚本，则环境变量设置的目录需为物理机中的真实目录，而非 docker 容器中映射之后的目录。
5. 执行 `build.sh`。
