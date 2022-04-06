VERSION = 1
PATCHLEVEL = 2
SUBLEVEL = 0
EXTRAVERSION =
NAME = honk

CC_CMD = @echo "CC $@"
MAKE_CMD = @echo "MAKE $@"

C_SOURCES = $(wildcard kernel/*.c)
HEADERS = $(wildcard kernel/*.h)
# OBJ = $(C_SOURCES:.c=.o cpu/*.o)
OBJ = $(C_SOURCES:.c=.o cpu/ports.o cpu/isr.o cpu/idt.o cpu/timer.o cpu/interrupt.o drivers/screen.o drivers/keyboard.o libc/mem.o libc/string.o)
SUBDIRS := cpu drivers libc

DOC_NAMES := latexpdf html

CC = i386-elf-gcc
GDB ?= i386-elf-gdb

MAKEFLAGS += -rR --no-print-directory
CFLAGS ?= -g -m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector -nostartfiles -nodefaultlibs \
		 -Wall -Wextra

ifeq ($(OS), Windows_NT)
@echo "Don't build this on Windows."
@false
else
UNAME_S = $(shell uname -s)
endif
ifeq ($(UNAME_S), Darwin)
OS = macOS
else
OS = Not Detected
endif

all: options cpu drivers libc os-image.bin

options:
	@scripts/logo.sh
	@echo "Building wOS Kernel version $(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION) ($(NAME))"
	@echo "OS 		: $(OS)"
	@echo "CC		: $(CC)"
	@echo "CFLAGS  	: $(CFLAGS)"
	@echo "gdb		: $(GDB)"
	@echo "C_SOURCE 	: $(C_SOURCES)"
	@echo "HEADERS		: $(HEADERS)"
	@echo "MAKEFLAGS	: $(MAKEFLAGS)"

os-image.bin: boot/boot.o $(OBJ)
	@$(CC_CMD)
	@$(CC) -T linker.ld -o os-image.bin -ffreestanding -O2 -nostdlib $^

os-image-debug.bin: boot/boot.bin kernel.bin $(OBJ)
	@cat $^ > os-image-debug.bin

kernel.bin: boot/kernel_entry.o $(OBJ) cpu/interrupt.o
	@i386-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

# '--oformat binary' deletes all symbols as a collateral, so we don't need
# to 'strip' them manually on this case
# kernel.bin: boot/kernel_entry.o ${OBJ}
# 	i386-elf-ld -o $@ -T linker.ld $^ --oformat binary

# cpu/interrupt.o: cpu/interrupt.asm
# 	nasm $< -f elf -o $@

boot/boot.o: boot/boot.s
	@i386-elf-as boot/boot.s -o boot/boot.o

kernel.o: kernel/kernel.c $(OBJ) cpu/interrupt.o
	@$(CC_CMD)
	@$(CC) -c cpu/interrupt.o kernel/kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall $(OBJ) -Wextra

# Used for debugging purposes
kernel.elf: ${OBJ}
	@i386-elf-ld -o $@ -Ttext 0x1000 $^

run: os-image.bin
	@qemu-system-i386 -kernel os-image.bin

debug: os-image-debug.bin kernel.elf
	@qemu-system-i386 -s -fda os-image-debug.bin &
	@$(GDB) -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

%.o: %.c $(HEADERS)
	@$(CC_CMD)
	@$(CC) $(CFLAGS) -ffreestanding -c $< -o $@

%.o: %.asm
	@nasm $< -f elf -o $@

%.bin: %.asm
	@nasm $< -f bin -o $@

# cpu:
# 	@$(MAKE_CMD)
# 	@$(MAKE) -C cpu

# drivers:
# 	@$(MAKE_CMD)
# 	@$(MAKE) -C drivers

# libc:
# 	@echo got to libc
# 	@$(MAKE_CMD)
# 	@$(MAKE) -C libc

$(DOC_NAMES):
	@$(MAKE) -C Documentation $@

iso: os-image.bin
	@cp os-image.bin isodir/boot
	@grub-mkrescue -o wOS.iso isodir/

$(SUBDIRS):
	@$(MAKE) -C $@

clean:
	@rm -rf *.bin *.dis *.o os-image.bin *.elf *.iso
	@rm -rf kernel/*.o boot/*.bin boot/*.o
	@$(MAKE) -C Documentation clean
	@$(MAKE) -C cpu clean
	@$(MAKE) -C drivers clean
	@$(MAKE) -C libc clean


.PHONY: cpu drivers $(SUBDIRS)
