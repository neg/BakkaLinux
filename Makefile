.PHONY : all clean

all: vmlinuz initramfs.cpio.gz

initramfs.cpio.gz: initramfs.cpio
	gzip -f initramfs.cpio

initramfs.cpio:
	make -C src busybox
	rm -fr initramfs
	mkdir -p initramfs/{bin,dev,etc,mnt,proc,tmp,sys}
	make -C src install
	cp -r root/* initramfs
	cd initramfs && find . | cpio -H newc -o > ../initramfs.cpio

vmlinuz:
	make -C src kernel

clean:
	make -C src clean
	rm -f vmlinuz
	rm -f initramfs.cpio.gz
	rm -fr initramfs
