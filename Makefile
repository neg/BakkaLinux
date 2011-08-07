.PHONY : bakka source

bakka: initramfs.igz vmlinuz

source: src
	make -C src

vmlinuz: src
	make -C src install

initramfs.igz: source root
	mkdir -p initramfs/{bin,sbin,etc,proc,sys}
	make -C src install
	cp -r root/* initramfs
	cd initramfs && find . | cpio -H newc -o > ../initramfs.cpio
	rm -fr initramfs
	gzip initramfs.cpio

clean:
	make -C src clean
	rm -f initramfs.cpio.gz
	rm -f vmlinuz
