#!/usr/bin/env bash

set -euo pipefail

rootfs_setup() {
    pushd rootfs
      mount -t proc proc proc
      mount -B /dev dev/
      mount --make-rslave dev
      mount -B /sys sys/
      mount --make-rslave sys
      mount --bind /run run
      mount --make-rslave run

      test -L dev/shm && rm dev/shm && mkdir dev/shm
      mount --types tmpfs --options nosuid,nodev,noexec shm dev/shm
      chmod 1777 dev/shm
      
      cp --dereference /etc/resolv.conf etc/
      cat ../${base_path}/fstab | sudo tee -a etc/fstab
    popd
}

rootfs_setup
