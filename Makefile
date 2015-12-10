.PHONY: all clean FORCE

export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabi-

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
	rm -f initramfs.cpio.gz
	rm -f uImage
	rm -fr rootfs

FORCE:
