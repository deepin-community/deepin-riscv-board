#!/usr/bin/env bash

set -euo pipefail

clean_rootfs() {
    pushd rootfs
      if [ x"$(cat boot/latest-config | grep CONFIG_MODULES=y)" = x"CONFIG_MODULES=y" ]; then
        chroot . /bin/bash -c 'source /etc/profile && update-initramfs -c -k all'
      else
        sed -i '/initrd/d' boot/grub.cfg
      fi
    popd

    mkdir -p kernel-output
    cp -vr rootfs/boot kernel-output
    if [ -d rootfs/lib/modules ]; then
      cp -vr rootfs/lib/modules kernel-output
    fi
    find ${OUT_DIR} -name "*.bin" -exec cp '{}' kernel-output/ \;

    tar -I zstd -cvf ${DISTURB}-kernel-${base_path}-$(date +%Y%m%d%H%M%S).tar.zst kernel-output

    rm -rf rootfs/root/*
    umount rootfs/proc rootfs/dev/shm rootfs/dev rootfs/sys rootfs/run
    umount -l rootfs
    losetup -d ${DEVICE}
    export file_name=${DISTURB}-${base_path}-$(date +%Y%m%d%H%M%S)
    mv rootfs.img ${file_name}.img
    zstd -T0 --ultra -20 $file_name.img
    split -b 800M -d -a 1 $file_name.img.zst $file_name.img.zst.
    rm $file_name.img.zst
    ls -al .
}

clean_rootfs
