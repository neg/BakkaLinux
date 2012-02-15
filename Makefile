.PHONY : all clean

ifndef FSTYPE
FSTYPE=initramfs.cpio.gz
endif

all: vmlinuz ${FSTYPE}

initramfs.cpio.gz: initramfs.cpio
	gzip -f initramfs.cpio

initramfs.cpio:
	make -C src busybox
	rm -fr initramfs
	mkdir -p initramfs/{bin,dev,etc,mnt,proc,tmp,sys}
	make -C src install
	cp -r fs/* initramfs
	cp -r root/* initramfs
	cd initramfs && find . | cpio -H newc -o > ../initramfs.cpio

rootfs.ext2:
	make -C src busybox
	make -C src install
	mkdir -p fs
	cp -r root/* fs
	rm -rf rootfs.ext2
	./genext2fs.sh -d fs/ -D root/etc/device_table.txt rootfs.ext2

vmlinuz:
	make -C src kernel

clean:
	make -C src clean
	rm -f vmlinuz
	rm -f initramfs.cpio.gz
	rm -fr initramfs
	rm -f rootfs.ext2
