.PHONY: all clean FORCE

export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-

emev2: KCONF=shmobile_defconfig
emev2: uImage.emev2

zc706: KCONF=multi_v7_defconfig
zc706: uImage.zc706

uImage.emev2: linux/arch/arm/boot/zImage linux/arch/arm/boot/dts/emev2-kzm9d.dtb
	cat linux/arch/arm/boot/zImage linux/arch/arm/boot/dts/emev2-kzm9d.dtb > /tmp/uImage.tmp
	mkimage -A arm -O linux -T kernel -C none -a 0x40008000 -e 0x40008000 -n "Bakka Linux for emev2" -d /tmp/uImage.tmp $@

uImage.zc706: linux/arch/arm/boot/zImage linux/arch/arm/boot/dts/zynq-zc706.dtb
	cat linux/arch/arm/boot/zImage linux/arch/arm/boot/dts/zynq-zc706.dtb > /tmp/uImage.tmp
	mkimage -A arm -O linux -T kernel -C none -a 0x8000 -e 0x8000 -n "Bakka Linux for zc706" -d /tmp/uImage.tmp $@

linux/arch/arm/boot/zImage: linux/.config rootfs.cpio.gz FORCE
	$(MAKE) -C linux CONFIG_INITRAMFS_SOURCE="../rootfs.cpio.gz" all
linux/.config:
	$(MAKE) -C linux $(KCONF)

rootfs.cpio.gz: rootfs.cpio
	rm -f $@
	gzip $<
rootfs.cpio: linux/.config busybox/busybox $(wildcard skel/*)
	rm -fr rootfs rootfs.cpio
	mkdir -p \
		rootfs/bin \
		rootfs/dev \
		rootfs/etc \
		rootfs/mnt \
		rootfs/proc \
		rootfs/tmp \
		rootfs/sys \
		rootfs/root \
		rootfs/lib/modules

	$(MAKE) -C busybox install CONFIG_PREFIX=../rootfs
ifneq ($(shell grep "CONFIG_MODULES=y" linux/.config),)
	$(MAKE) -C linux modules_install INSTALL_MOD_PATH=../rootfs
endif
	cp -r skel/* rootfs
	fakeroot ./createcpio.sh

busybox/busybox: busybox/.config FORCE
	$(MAKE) -C busybox
busybox/.config:
	rm -f busybox/.config
	$(MAKE) -C busybox defconfig
	sed -i "s/# CONFIG_STATIC is not set/CONFIG_STATIC=y/" busybox/.config

clean:
	$(MAKE) -C busybox clean
	$(MAKE) -C linux clean
	rm -f uImage.*
	rm -fr rootfs
	rm -f rootfs.cpio
	rm -f rootfs.cpio.gz

FORCE:
