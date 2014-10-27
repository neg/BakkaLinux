.PHONY: all clean FORCE

export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabi-

all: uImage rootfs

rootfs: busybox/busybox $(wildcard skel/*)
	rm -fr rootfs
	mkdir -p rootfs/bin rootfs/dev rootfs/etc rootfs/mnt \
		rootfs/proc rootfs/tmp rootfs/sys rootfs/root
	$(MAKE) -C busybox install CONFIG_PREFIX=../rootfs
	cp -r skel/* rootfs

uImage: linux/arch/arm/boot/zImage linux/arch/arm/boot/dts/emev2-kzm9d.dtb
	cat linux/arch/arm/boot/zImage linux/arch/arm/boot/dts/emev2-kzm9d.dtb > /tmp/uImage.tmp
	mkimage -A arm -O linux -T kernel -C none -a 0x40008000 -e 0x40008000 -n "Bakka Linux" -d /tmp/uImage.tmp $@

linux/arch/arm/boot/zImage: linux/.config FORCE
	$(MAKE) -C linux all
linux/.config:
	$(MAKE) -C linux shmobile_defconfig


busybox/busybox: busybox/.config FORCE
	$(MAKE) -C busybox
busybox/.config:
	rm -f busybox/.config
	$(MAKE) -C busybox defconfig
	sed -i "s/# CONFIG_STATIC is not set/CONFIG_STATIC=y/" busybox/.config

clean:
	$(MAKE) -C busybox clean
	$(MAKE) -C linux clean
	rm -f initramfs.cpio.gz
	rm -f uImage
	rm -fr rootfs

FORCE:
