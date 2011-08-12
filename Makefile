.PHONY : all clean

all: vmlinuz initramfs-seed.cpio.gz

initramfs-seed.cpio.gz: initramfs-seed.cpio
	gzip -f initramfs-seed.cpio

initramfs-seed.cpio: vmlinuz initramfs.cpio.gz
	mkdir -p initramfs/seed
	cp initramfs.cpio.gz initramfs/seed
	cp vmlinuz initramfs/seed
	cd initramfs && find . | cpio -H newc -o > ../initramfs-seed.cpio

initramfs.cpio.gz: initramfs.cpio
	gzip -f initramfs.cpio

initramfs.cpio:
	make -C src busybox
	make -C src kexec-tools
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
	rm -f initramfs-seed.cpio.gz
	rm -fr initramfs
