#!/bin/bash

# console - setup seriel console
# memmap  - reserve 20M of memore 50M in to be used by pramfs

qemu-kvm \
    -nographic \
    -m 100 \
    -append 'console=ttyS0,115200 memmap=20M$0x3200000' \
    -initrd initramfs-seed.cpio.gz \
    -kernel vmlinuz
