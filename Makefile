.PHONY: test

ABS_ROOT_DIR := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))/

test: acmeserv.kernel acmeserv.image acmeserv.cmdline
	bash -c 'qemu-system-s390x -nographic -kernel acmeserv.kernel -append "$$(<acmeserv.cmdline)" -initrd acmeserv.image'

init: $(wildcard *.go)
	GOARCH=s390x go build -o $@

acmeserv.image: init
	ls -d iucv $^ | cpio -v -H newc -o -R root:root | gzip -9 > $@

linux:
	wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.8.3.tar.xz
	tar -xvf linux-5.8.3.tar.xz
	mv linux-5.8.3 linux
	rm linux/net/iucv/af_iucv.c
	ln -sf ../../../iucv/af_iucv.c linux/net/iucv/af_iucv.c

acmeserv.kernel: linux linux.config iucv/af_iucv.c
	make -C linux/ ARCH=s390 CROSS_COMPILE=s390x-linux-gnu- KCONFIG_CONFIG=$(ABS_ROOT_DIR)/linux.config -j$(shell nproc)
	cp linux/arch/s390/boot/bzImage $@

# Unused, due to error:
# [    1.762486] module af_iucv: relocation error for symbol  (r_type 5, value 0xffffffe080126256)
iucv/af_iucv.ko: iucv/af_iucv.c
	$(MAKE) -C "linux" \
		CROSS_COMPILE=s390x-linux-gnu- \
		ARCH=s390 \
		M=$(ABS_ROOT_DIR)/iucv \
		modules
