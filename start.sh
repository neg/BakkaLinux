#!/bin/bash
macstr=("`printf '00:AD:BE:EF:%02X:%02X\n' $((RANDOM%256)) $((RANDOM%256))`")
LOCATION="."
KERNEL="vmlinuz"
DISK="rootfs.ext2"
				
qemu-system-x86_64 -kernel $LOCATION/$KERNEL \
-boot c \
-m 512 \
-append "root=/dev/sda rw panic=1 console=ttyS0, 115200" \
-localtime \
-no-reboot \
-name Megatron \
-net nic,vlan=0,model=e1000,macaddr=$macstr \
-net tap,script=./qemu-ifup,downscript=./qemu-ifdown \
-nographic \
-hda $LOCATION/$DISK

#-net user,net=192.168.2.0/24 \

