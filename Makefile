.PHONY: test

ABS_ROOT_DIR := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))/

test: acmeserv.kernel acmeserv.image acmeserv.cmdline
	bash -c 'qemu-system-s390x -nographic -kernel acmeserv.kernel -append "$$(<acmeserv.cmdline)" -initrd acmeserv.image'

init: $(wildcard *.go)
	GOARCH=s390x go build -o $@

acmeserv.image: init
	echo $^ | cpio -H newc -o -R root:root | gzip -9 > $@

linux:
	wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.8.3.tar.xz
	tar -xvf linux-5.8.3.tar.xz
	mv linux-5.8.3 linux

acmeserv.kernel: linux linux.config
	make -C linux/ ARCH=s390 CROSS_COMPILE=s390x-linux-gnu- KCONFIG_CONFIG=$(ABS_ROOT_DIR)/linux.config -j$(shell nproc)
	cp linux/arch/s390/boot/bzImage $@
