# DO NOT EXECUTE THIS SCRIPT DIRECTLY!!

#!/bin/bash
set -e

##    自定义配置    ##
FLAVOR_DIR="/mnt/openwrt-action/flavor"
FLAVOR=""
FLAVOR_BASE_DIR=""
PATCH_FILES="patches"
DIY_P1_SH="diy-part1.sh"
COMMON_DIY_P1="/mnt/openwrt-action/script/$DIY_P1_SH"
DIY_P2_SH="diy-part2.sh"
COMMON_DIY_P2="/mnt/openwrt-action/script/$DIY_P2_SH"
THREAD=$(nproc)
OUTPUT_DIR="outputs"

export USE_LOCAL_PACKAGES=${USE_LOCAL_PACKAGES:-y}
##    自定义配置    ##






declare -a _STEP_STACK=(
  Select_Build_Flavor
  Clone_Source_Code
  Load_Custom_Feeds
  Update_Feeds
  Install_Feeds
  Load_Custom_Configuration
  Download_Package
  Copy_Patch_Files
  Compile_The_Firmware
  Organize_Files
  Upload_Firmware_To_Release
)

runing() {
  echo -e "\e[1;33m  runing:\e[0m \e[1;34m$1\e[0m"
}

execute() {
  runing "$1"
  $1
}

comfirm() {
  echo -e "\e[1;36m  $1: \e[0m\c"
}

main() {
  export PATH=$(echo "$PATH" | tr ':' '\n' | grep -v '^/mnt/c/' | paste -sd:)^C

  if [ -d '/var/cache/openwrt' ]; then
    comfirm "Do you want to use build cache? If you select No, it will be deleted. (Y/n)"
    read _need
    if [[ "$_need" =~ ^[nN]$ ]]; then
      execute "rm -rf /var/cache/openwrt/build_dir"
      execute "rm -rf /var/cache/openwrt/staging_dir"
      execute "rm -rf /var/cache/openwrt/binary"
    fi
  fi

  execute "mkdir -p /var/cache/openwrt"

  for _element in ${_STEP_STACK[@]}; do
    $_element
  done
}

_STEP_CURRENT=0
print_step() {
  _STEP_CURRENT=$((_STEP_CURRENT+1))
  echo -e "\e[1;32m  Step $_STEP_CURRENT (${#_STEP_STACK[@]} total): $1\e[0m"
}

Select_Build_Flavor() {
  print_step 'Select build flavor'
  # 选择要使用的风味
  FLAVOR=$(find $FLAVOR_DIR -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | fzf \
      --prompt "Select the build flavor you want:")
  FLAVOR_BASE_DIR=$FLAVOR_DIR/$FLAVOR
  OUTPUT_DIR=$FLAVOR_BASE_DIR/$OUTPUT_DIR
  DIY_P1_SH=$FLAVOR_BASE_DIR/$DIY_P1_SH
  DIY_P2_SH=$FLAVOR_BASE_DIR/$DIY_P2_SH
  PATCH_FILES=$FLAVOR_BASE_DIR/$PATCH_FILES
  echo "using $FLAVOR_BASE_DIR"
  execute "mkdir -p $FLAVOR"
  execute "cd $FLAVOR"
}

Clone_Source_Code() {
  print_step 'Clone source code'
  execute "rm -rf openwrt"
  . $FLAVOR_BASE_DIR/openwrt-detail.sh

  if [ -d 'openwrt.bak' ]; then
    comfirm "Do you want to use git cache? If you select No, ite will be deleted. (Y/n)"
    read _need
    if [[ "$_need" =~ ^[nN]$ ]]; then
      execute "rm -rf ./openwrt.bak"
    fi
  fi

  if [ ! -d 'openwrt.bak' ]; then
    execute "git clone -b $REPO_BRANCH $REPO_URL openwrt.bak --depth=1"
    execute "cd openwrt.bak"
    execute "mkdir -p /var/cache/openwrt/staging_dir"
    if [ ! -d "staging_dir" ]; then
      execute "ln -s /var/cache/openwrt/staging_dir ./"
    fi
    execute "mkdir -p /var/cache/openwrt/build_dir"
    if [ ! -d "build_dir" ]; then
      execute "ln -s /var/cache/openwrt/build_dir ./"
    fi
  else
    execute "cd openwrt.bak"
    execute "git pull origin $REPO_BRANCH"
  fi
}

Load_Custom_Feeds() {
  print_step 'Load custom feeds'
  export COMMON_DIY_P1=$COMMON_DIY_P1
  execute "bash $DIY_P1_SH"
  export -n COMMON_DIY_P1
}

Update_Feeds() {
  print_step 'Update feeds'
  execute "./scripts/feeds update -a"
  execute "cp -r ../openwrt.bak ../openwrt"
  execute "cd ../openwrt"
  export COMMON_DIY_P2=$COMMON_DIY_P2
  execute "bash $DIY_P2_SH"
  export -n COMMON_DIY_P2
}

Install_Feeds() {
  print_step 'Install feeds'
  execute "./scripts/feeds update -i"
  execute "./scripts/feeds install -a"
}

replace_environment_value() {
  while IFS= read -r line; do
      echo "$line" | envsubst
  done
}

Load_Custom_Configuration() {
  print_step 'Load custom configuration'
  # 填充 config 中使用的环境变量
  replace_environment_value < "$FLAVOR_BASE_DIR/origin.config" > "$FLAVOR_BASE_DIR/origin.config.replaced"
  execute "cp $FLAVOR_BASE_DIR/origin.config.replaced ./.config"
}

Download_Package() {
  print_step 'Download package'
  comfirm "Do you need to change the config file? (y/N)"
  read _need
  if [[ "$_need" =~ ^[yY]$ ]]; then
    runing "make menuconfig -j$THREAD"
    make menuconfig -j$THREAD || make menuconfig V=s
  else
    runing "make defconfig -j$THREAD"
    make defconfig -j$THREAD || make defconfig V=s
  fi
  mkdir -p $OUTPUT_DIR
  execute "cp ./.config $OUTPUT_DIR"
  runing "make download -j2"
  make download -j$THREAD
  execute "rm -rf /var/cache/openwrt/download/go-mod-cache"
  runing "find /var/cache/openwrt/download -size -1024c -exec ls -l {} \;"
  find /var/cache/openwrt/download -size -1024c -exec ls -l {} \;
  runing "find /var/cache/openwrt/download -size -1024c -exec rm -f {} \;"
  find /var/cache/openwrt/download -size -1024c -exec rm -f {} \;
}

Copy_Patch_Files() {
  print_step 'Copy patch files'
  shopt -s nullglob
  files=($PATCH_FILES/*)
  if [ ${#files[@]} -gt 0 ]; then
    execute "cp -r $PATCH_FILES/* ./"
  else
    echo "No patch files, skip."
  fi
}

Compile_The_Firmware() {
  print_step 'Compile the firmware'
  execute "rm -rf /var/cache/openwrt/binary/targets"
  runing "make -j$THREAD || make V=s"
  make -j$THREAD || make V=s
}

Organize_Files() {
  print_step 'Organize files'
  mkdir -p $OUTPUT_DIR
  execute "rm -rf /var/cache/openwrt/binary/targets/*/*/packages"
}

Upload_Firmware_To_Release() {
  print_step 'Upload firmware to release'
  execute "rm -rf $OUTPUT_DIR/bin/"
  runing "mkdir -p $OUTPUT_DIR/bin"
  mkdir -p $OUTPUT_DIR/bin
  execute "cp -r /var/cache/openwrt/binary/targets/*/*/* $OUTPUT_DIR/bin/"
}

main
