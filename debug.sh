#!/bin/sh

set -e

make
bochs -f bochsrc.txt -q
