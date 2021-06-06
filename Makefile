compile-boot:
	nasm src/boot/boot.asm -f bin -o boot.bin
run:
	qemu-system-x86_64 boot.bin
start:
	make compile-boot run
