FROM ubuntu:24.04

RUN sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list.d/ubuntu.sources

# https://openwrt.org/docs/guide-developer/toolchain/install-buildsystem#debianubuntumint
RUN apt-get update && apt-get install --no-install-suggests -y  \
    build-essential clang flex bison g++ gawk gcc-multilib g++-multilib \
    gettext git libncurses5-dev libssl-dev python3-setuptools rsync swig \
    unzip zlib1g-dev file wget qemu-utils fzf curl

RUN git config --global --add safe.directory '*'

WORKDIR /mnt/work
ENTRYPOINT ["bash", "-c"]
