#!/usr/bin/env bash

set -e

msg() {
    echo -e "\n==> $*\n"
}

err() {
    echo -e "\n==> $*" 1>&2
    exit 1
}

arch="arm64"
defconfig="vendor/lahaina-qgki_defconfig"

arch_opts="ARCH=${arch} SUBARCH=${arch}"
export ARCH=$arch
export SUBARCH=$arch
#export CROSS_COMPILE="aarch64-elf-"
export CROSS_COMPILE="aarch64-linux-android-"
export KBUILD_BUILD_USER="github"
export KBUILD_BUILD_HOST="actions"

msg "Generating defconfig..."
make O=out $arch_opts "$defconfig" || err "Invalid defconfig"

msg "Preparing build..."
make O=out $arch_opts -j"$(nproc)" prepare

msg "Building kernel..."
make O=out $arch_opts -j"$(nproc)"

msg "Zipping all build artifacts..."
cd out
zip -r9 ../out_artifacts.zip *
