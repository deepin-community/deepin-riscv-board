#!/usr/bin/env bash

set -euo pipefail

qemu_setup() {
    apt install -y qemu binfmt-support qemu-user-static curl wget
    update-binfmts --display
}

qemu_setup
