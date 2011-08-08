.PHONY : bakka source

bakka: initramfs.igz vmlinuz

vmlinuz:
	make -C src kernel

initramfs.igz: vmlinuz
	make -C src busybox
	make -C src kexec-tools
	mkdir -p initramfs/{bin,sbin,etc,proc,sys,kexec}
	make -C src install
	cp -r root/* initramfs
	cp vmlinuz initramfs/kexec
	cd initramfs && find . | cpio -H newc -o > ../initramfs.cpio
	rm -fr initramfs
	gzip initramfs.cpio

clean:
	make -C src clean
	rm -f initramfs.cpio.gz
	rm -f vmlinuz
