.PHONY: clean install busybox kernel

NUMCPUS=`grep -c '^processor' /proc/cpuinfo`
ROOT=$(CURDIR)/../initramfs

all: kernel busybox

kernel: ../conf/linux
	# Copy config
	cp ../conf/linux linux/.config
	# Compile
	$(MAKE) -j$(NUMCPUS) -C linux bzImage
	$(MAKE) -j$(NUMCPUS) -C linux modules

busybox: ../conf/busybox
	cp ../conf/busybox busybox/.config
	$(MAKE) -C busybox

install:
	# Kernel and modules
	cp linux/arch/x86_64/boot/bzImage ../vmlinuz
	mkdir -p $(ROOT)/lib/modules
	$(MAKE) -C linux modules_install INSTALL_MOD_PATH=$(ROOT)
	# BusyBox
	$(MAKE) -C busybox install

clean:
	$(MAKE) -C busybox clean
	$(MAKE) -C linux clean
