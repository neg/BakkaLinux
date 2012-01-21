#!/bin/bash

qemu-kvm \
    -nographic \
    -m 100 \
    -append 'console=ttyS0,115200' \
    -initrd initramfs.cpio.gz \
    -kernel vmlinuz
