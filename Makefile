.PHONY: test
test:
	bash -c 'qemu-system-s390x -nographic -kernel linux-*/arch/s390/boot/bzImage -append "$$(<cmdline)"'

init: init.c
	s390x-linux-gnu-gcc $^ -static -o $@

acmeserv.image: init
	echo $^ | cpio -H newc -o -R root:root | gzip -9 > $@

acmeserv.kernel: linux-*/arch/s390/boot/bzImage
	cp $^ $@
