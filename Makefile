.PHONY: test
test:
	bash -c 'qemu-system-s390x -nographic -kernel linux-*/arch/s390/boot/bzImage -append "$$(<cmdline)"'
