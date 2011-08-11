.PHONY : clean install busybox kexec-tools kernel

kernel: ../conf/linux
	# Copy config
	cp ../conf/linux linux/.config
	# Patch with pramfs
	cd pramfs && patch -p1 < ../0001-Add-missing-function.patch
	cd pramfs && ./patch-ker.sh ../linux
	# compile
	make -C linux bzImage
	make -C linux modules

busybox: ../conf/busybox
	cp ../conf/busybox busybox/.config
	make -C busybox

kexec-tools:
	cd kexec-tools && ./bootstrap
	cd kexec-tools && LDFLAGS=-static ./configure
	make -C kexec-tools

install:
	# Kernel and modules
	cp linux/arch/x86_64/boot/bzImage ../vmlinuz
	mkdir -p ../initramfs/lib/modules
	make -C linux modules_install INSTALL_MOD_PATH=../../initramfs
	# BusyBox
	make -C busybox install
	# Kexe
	mkdir -p ../initramfs/sbin
	cp kexec-tools/build/sbin/* ../initramfs/sbin

clean:
	make -C busybox clean
	make -C linux clean
	make -C kexec-tools clean
