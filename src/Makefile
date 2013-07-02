.PHONY: all clean install busybox linux

NUMCPUS=`grep -c '^processor' /proc/cpuinfo`

all: linux busybox

busybox: ../conf/busybox
	cp ../conf/busybox busybox/.config
	$(MAKE) -C busybox

linux: ../conf/linux
	cp ../conf/linux linux/.config
	$(MAKE) -j$(NUMCPUS) -C linux bzImage
	$(MAKE) -j$(NUMCPUS) -C linux modules

install:
	cp linux/arch/x86/boot/bzImage ../vmlinuz
	cp linux/System.map ../
	$(MAKE) -C linux modules_install INSTALL_MOD_PATH=../../initramfs
	$(MAKE) -C busybox install

clean:
	$(MAKE) -C busybox clean
	$(MAKE) -C linux clean
