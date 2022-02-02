VERSION = 1
PATCHLEVEL = 0
SUBLEVEL = 2
EXTRAVERSION = -rc1

C_SOURCES = $(wildcard kernel/*.c drivers/*.c cpu/*.c libc/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h cpu/*.h libc/*.h)
# Nice syntax for file extension replacement
OBJ = ${C_SOURCES:.c=.o} 

DOC_NAMES := latexpdf html

# Change this if your cross-compiler is somewhere else
CC = i386-elf-gcc
GDB = gdb
# -g: Use debugging symbols in gcc
CFLAGS = -g

# First rule is run by default
os-image.bin: boot/boot.o kernel.o ${OBJ}
	# $(CC) -T linker.ld -o os-image.bin -ffreestanding -O2 -nostdlib cpu/idt.o cpu/interrupt.o cpu/isr.o cpu/ports.o cpu/timer.o boot/boot.o kernel/util.o drivers/keyboard.o drivers/screen.o kernel.o -lgcc
	$(CC) -T linker.ld -o os-image.bin -ffreestanding -O2 -nostdlib $(OBJ) boot/boot.o -lgcc -fomit-frame-pointer

os-image-debug.bin: boot/boot.bin kernel.bin
	cat $^ > os-image-debug.bin

kernel.bin: boot/kernel_entry.o ${OBJ}
	i386-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

# '--oformat binary' deletes all symbols as a collateral, so we don't need
# to 'strip' them manually on this case
# kernel.bin: boot/kernel_entry.o ${OBJ}
# 	i386-elf-ld -o $@ -T linker.ld $^ --oformat binary

# cpu/interrupt.o: cpu/interrupt.asm
# 	nasm $< -f elf -o $@

boot/boot.o: boot/boot.s
	i386-elf-as boot/boot.s -o boot/boot.o

kernel.o: kernel/kernel.c $(OBJ)
	$(CC) -c kernel/kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

# Used for debugging purposes
kernel.elf: boot/kernel_entry.o ${OBJ}
	i386-elf-ld -o $@ -Ttext 0x1000 $^ 

run: os-image.bin
	qemu-system-i386 -s -kernel os-image.bin

# Open the connection to qemu and load our kernel-object file with symbols
debug: os-image-debug.bin kernel.elf
	qemu-system-i386 -s -fda os-image-debug.bin &
	${GDB} -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

# Generic rules for wildcards
# To make an object, always compile from its .c
%.o: %.c ${HEADERS}
	${CC} ${CFLAGS} -ffreestanding -c $< -o $@

%.o: %.asm
	nasm $< -f elf -o $@

%.bin: %.asm
	nasm $< -f bin -o $@

$(DOC_NAMES):
	$(MAKE) -C Documentation $@

clean:
	rm -rf *.bin *.dis *.o os-image.bin *.elf *.iso
	rm -rf kernel/*.o boot/*.bin drivers/*.o boot/*.o cpu/*.o libc/*.o
	$(MAKE) -C Documentation clean
