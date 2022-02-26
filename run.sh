#!/bin/sh
set -e

DISK_IMAGE="bin/openos-0.0.1a.img"

make
qemu-system-i386 -fda "$DISK_IMAGE" -m 128
