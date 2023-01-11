#!/usr/bin/env bash

set -euo pipefail

update_rootfs() {
    if [ x"${SKIP_INSTALL_PACKAGE}" = x"yes" ]; then
      exit 0
    fi
    pushd rootfs
      echo "deb [trusted=yes] ${DEEPIN_REPO} beige main" > etc/apt/sources.list
      chroot . /bin/bash -c "source /etc/profile && apt update && apt install -y systemd initramfs-tools systemd-sysv nano sudo network-manager iproute2 vim deepin-terminal dcc-network-plugin"
      chroot . /bin/bash -c "source /etc/profile && systemctl enable NetworkManager"
      chroot . /bin/bash -c "source /etc/profile && echo root:Riscv2022# | chpasswd"
      chroot . /bin/bash -c "source /etc/profile && echo deepin-riscv > /etc/hostname"
      chroot . /bin/bash -c "source /etc/profile && echo 'deepin-riscv 127.0.0.1' > /etc/hosts"

      chroot . /bin/bash -c "source /etc/profile && useradd -s /bin/bash -m -G sudo deepin"
      chroot . /bin/bash -c "source /etc/profile && echo deepin:deepin | chpasswd"
      ls -al boot/
    popd
    if [ x"${base_path}" = x"sifive" ]; then
      pushd rootfs
        chroot . /bin/bash -c 'source /etc/profile && apt install -o DPkg::options::="--force-overwrite" -y linux-image-riscv64 linux-firmware'
        chroot . /bin/bash -c 'source /etc/profile && cp /usr/lib/linux-image-*-riscv64/sifive/hifive-unmatched-a00.dtb /boot'
      popd
    fi
}

update_rootfs
