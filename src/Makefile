PHONY: clean install busybox kernel

all: kernel busybox

kernel: ../conf/linux
	# Copy config
	cp ../conf/linux linux/.config
	# Compile
	$(MAKE) -C linux bzImage
	$(MAKE) -C linux modules

busybox: ../conf/busybox
	cp ../conf/busybox busybox/.config
	$(MAKE) -C busybox

install:
	# Kernel and modules
	cp linux/arch/x86_64/boot/bzImage ../vmlinuz
	mkdir -p ../initramfs/lib/modules
	mkdir -p ../fs/lib/modules
	$(MAKE) -C linux modules_install INSTALL_MOD_PATH=$(CURDIR)/../fs
	# BusyBox
	$(MAKE) -C busybox install

clean:
	$(MAKE) -C busybox clean
	$(MAKE) -C linux clean
