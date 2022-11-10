#!/usr/bin/env bash

set -euo pipefail

machine_info() {
    uname -a
    echo $(nproc)
    lscpu
    whoami
    env
}

init() {
    # Init out folder & rootfs
    mkdir -p ${OUT_DIR}
    mkdir -p rootfs

    apt update

    # create flash image
    fallocate -l 7G rootfs.img
}

machine_info
init
