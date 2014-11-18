#!/bin/bash

base=$(dirname $(readlink -f $0))

cd $base/rootfs

ln -s sbin/init init

mkdir -p dev
mknod -m 622 dev/console c 5 1
mknod -m 622 dev/tty0 c 4 0
mknod -m 622 dev/tty1 c 4 0

find . | cpio --owner 0:0 -H newc -o > $base/rootfs.cpio
