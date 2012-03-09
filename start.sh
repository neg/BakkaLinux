#!/bin/bash

qemu-kvm \
    -m 100 \
    -display none \
    -serial stdio \
    -serial pty \
    -append 'console=ttyS0,115200 kgdboc=ttyS1,115200' \
    -initrd initramfs.cpio.gz \
    -kernel vmlinuz
