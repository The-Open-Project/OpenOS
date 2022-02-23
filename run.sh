#!/bin/sh
set -e

DISK_IMAGE="bin/openos-0.0.1a.img"

make
qemu-system-i386 -drive format=raw,file="$DISK_IMAGE" -m 128 -s -S
