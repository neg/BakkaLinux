.PHONY : bakka

bakka:
	make -C src kernel
	make -C src busybox
	make -C src kexec-tools
	# Crate directories
	mkdir -p initramfs/{bin,dev,etc,mnt,proc,tmp}
	# Install built targets to initramfs
	make -C src install
	cp vmlinuz initramfs/kexec
	cp -r root/* initramfs
	# Create initrd
	cd initramfs && find . | cpio -H newc -o > ../initramfs.cpio
	gzip -f initramfs.cpio
	# Setup seed initrd
	mkdir -p initramfs/seed
	cp initramfs.cpio.gz initramfs/seed
	cp vmlinuz initramfs/seed
	# Create seed initrd
	cd initramfs && find . | cpio -H newc -o > ../initramfs-seed.cpio
	gzip -f initramfs-seed.cpio
	# Clean initrd creating
	rm -fr initramfs
	rm -f initramfs.cpio.gz

clean:
	make -C src clean
	rm -f initramfs-seed.cpio.gz
	rm -f vmlinuz
