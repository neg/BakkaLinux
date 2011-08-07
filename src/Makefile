.PHONY : box clean install

all: box kernel

kernel: linux
	cp ../conf/linux linux/.config
	make -C linux bzImage
	make -C linux modules

box: busybox
	cp ../conf/busybox busybox/.config
	make -C busybox
	
install: box kernel
	make -C busybox install
	cp linux/arch/x86_64/boot/bzImage ../vmlinuz

clean:
	make -C busybox clean
	make -C linux clean
