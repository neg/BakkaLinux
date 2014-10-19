.PHONY: all clean

all: vmlinuz initramfs.cpio.gz

initramfs.cpio.gz: initramfs.cpio
	gzip -f initramfs.cpio

initramfs.cpio: busybox/busybox linux/arch/x86/boot/bzImage
	rm -fr initramfs
	mkdir -p initramfs/bin initramfs/dev initramfs/etc initramfs/mnt \
		initramfs/proc initramfs/tmp initramfs/sys initramfs/root
	$(MAKE) -C busybox install
	$(MAKE) -C linux modules_install INSTALL_MOD_PATH=../../initramfs
	cp -r root/* initramfs
	cd initramfs && ln -s sbin/init init
	cd initramfs && find . | cpio --owner 0:0 -H newc -o > ../initramfs.cpio

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
	sed -i 's|CONFIG_PREFIX=".*"|CONFIG_PREFIX="../initramfs"|' busybox/.config

clean:
	$(MAKE) -C busybox clean
	$(MAKE) -C linux clean
	rm -f vmlinuz
	rm -f System.map
	rm -f initramfs.cpio.gz
	rm -fr initramfs
