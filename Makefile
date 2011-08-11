.PHONY : bakka

bakka:
	make -C src kernel
	make -C src busybox
	make -C src kexec-tools
	# Create folders
	mkdir -p initramfs/{bin,sbin,etc,proc,sys,kexeci,mnt}
	# Install built targets to initramfs
	make -C src install
	cp vmlinuz initramfs/kexec
	cp -r root/* initramfs
	# Create initrd
	cd initramfs && find . | cpio -H newc -o > ../initramfs.cpio
	rm -fr initramfs
	gzip -f initramfs.cpio

clean:
	make -C src clean
	rm -f initramfs.cpio.gz
	rm -f vmlinuz
