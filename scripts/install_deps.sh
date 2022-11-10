#!/usr/bin/env bash

set -euo pipefail

install_deps() {
    apt install -y gdisk dosfstools g++-12-riscv64-linux-gnu build-essential \
                        libncurses-dev gawk flex bison openssl libssl-dev \
                        dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf mkbootimg \
                        fakeroot genext2fs genisoimage libconfuse-dev mtd-utils mtools qemu-utils qemu-utils squashfs-tools \
                        device-tree-compiler rauc simg2img u-boot-tools f2fs-tools arm-trusted-firmware-tools swig
    update-alternatives --install /usr/bin/riscv64-linux-gnu-gcc riscv64-gcc /usr/bin/riscv64-linux-gnu-gcc-12 10
    update-alternatives --install /usr/bin/riscv64-linux-gnu-g++ riscv64-g++ /usr/bin/riscv64-linux-gnu-g++-12 10
}

install_deps
