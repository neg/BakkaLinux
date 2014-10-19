.PHONY: all clean

all: vmlinuz initramfs.cpio.gz

initramfs.cpio.gz: initramfs.cpio
	gzip -f initramfs.cpio

initramfs.cpio: busybox/busybox
	rm -fr initramfs
	mkdir -p initramfs/bin initramfs/dev initramfs/etc initramfs/mnt \
		initramfs/proc initramfs/tmp initramfs/sys initramfs/root
	make -C src install
	$(MAKE) -C busybox install
	cp -r root/* initramfs
	cd initramfs && ln -s sbin/init init
	cd initramfs && find . | cpio --owner 0:0 -H newc -o > ../initramfs.cpio

vmlinuz:
	make -C src linux

busybox/busybox: busybox/.config
	$(MAKE) -C busybox
busybox/.config:
	$(MAKE) -C busybox defconfig
	sed -i 's|CONFIG_PREFIX=".*"|CONFIG_PREFIX="../initramfs"|' busybox/.config

clean:
	make -C src clean
	make -C busybox clean
	rm -f vmlinuz
	rm -f System.map
	rm -f initramfs.cpio.gz
	rm -fr initramfs
