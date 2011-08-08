.PHONY : clean install busybox kexec-tools kernel

kernel: linux
	cp ../conf/linux linux/.config
	make -C linux bzImage
	make -C linux modules

busybox:
	cp ../conf/busybox busybox/.config
	make -C busybox

kexec-tools:
	cd kexec-tools && ./bootstrap
	cd kexec-tools && LDFLAGS=-static ./configure
	make -C kexec-tools

install:
	make -C busybox install
	mkdir -p ../initramfs/sbin
	cp kexec-tools/build/sbin/* ../initramfs/sbin
	cp linux/arch/x86_64/boot/bzImage ../vmlinuz

clean:
	make -C busybox clean
	make -C linux clean
	make -C kexec-tools clean
