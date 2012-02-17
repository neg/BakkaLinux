#!/bin/bash
#make sure to enable kconfig options for ext2/ide device to work

macstr=("`printf 'DE:AD:BE:EF:%02X:%02X\n' $((RANDOM%256)) $((RANDOM%256))`")

LOCATION="."
KERNEL="vmlinuz"
DISK="rootfs.ext2"
				
vdeq qemu-system-x86_64 -kernel $LOCATION/$KERNEL \
-boot c \
-m 512 \
-append "root=/dev/sda rw panic=1 console=ttyS0, 115200" \
-localtime \
-no-reboot \
-name Megatron \
-net nic,vlan=0,model=e1000,macaddr=$macstr \
-net vde,sock=/var/run/kvm0.ctl \
-net user,net=192.168.0.0/24 \
-nographic \
-hda $LOCATION/$DISK
