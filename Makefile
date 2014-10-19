.PHONY: all clean

all: vmlinuz initramfs.cpio.gz

initramfs.cpio.gz: initramfs.cpio
	gzip -f initramfs.cpio

initramfs.cpio: rootfs
	cd rootfs && ln -s sbin/init init
	cd rootfs && find . | cpio --owner 0:0 -H newc -o > ../initramfs.cpio

rootfs: busybox/busybox linux/arch/x86/boot/bzImage
	rm -fr rootfs
	mkdir -p rootfs/bin rootfs/dev rootfs/etc rootfs/mnt \
		rootfs/proc rootfs/tmp rootfs/sys rootfs/root
	$(MAKE) -C busybox install
	$(MAKE) -C linux modules_install INSTALL_MOD_PATH=../../rootfs
	cp -r skel/* rootfs

vmlinuz: linux/arch/x86/boot/bzImage
	cp linux/arch/x86/boot/bzImage ../vmlinuz
System.map: linux/arch/x86/boot/bzImage
	cp linux/System.map ../
linux/arch/x86/boot/bzImage: linux/.config
	$(MAKE) -C linux bzImage
	$(MAKE) -C linux modules
linux/.config:
	$(MAKE) -C linux defconfig


busybox/busybox: busybox/.config
	$(MAKE) -C busybox
busybox/.config:
	$(MAKE) -C busybox defconfig
	sed -i 's|CONFIG_PREFIX=".*"|CONFIG_PREFIX="../rootfs"|' busybox/.config

clean:
	$(MAKE) -C busybox clean
	$(MAKE) -C linux clean
	rm -f vmlinuz
	rm -f System.map
	rm -f initramfs.cpio.gz
	rm -fr rootfs
