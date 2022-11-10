#!/usr/bin/env bash

set -euo pipefail

update_rootfs() {
    if [ x"${SKIP_INSTALL_PACKAGE}" = x"yes" ]; then
      exit 0
    fi
    pushd rootfs
      echo "deb [trusted=yes] ${DEEPIN_REPO} beige main" > etc/apt/sources.list
      chroot . /bin/bash -c "source /etc/profile && apt update && apt install -y systemd initramfs-tools systemd-sysv nano sudo network-manager iproute2"
      chroot . /bin/bash -c "source /etc/profile && systemctl enable NetworkManager"
      chroot . /bin/bash -c "source /etc/profile && echo root:Riscv2022# | chpasswd"
      chroot . /bin/bash -c "source /etc/profile && echo deepin-riscv > /etc/hostname"
      chroot . /bin/bash -c "source /etc/profile && echo 'deepin-riscv 127.0.0.1' > /etc/hosts"
      ls -al boot/
    popd
}