#!/bin/sh

set -e

make
bochs -f bochsrc.bxrc -q
