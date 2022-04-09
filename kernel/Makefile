CC_CMD = @echo "CC $@"
MAKE_CMD = @echo "MAKE $@"

CC = i386-elf-gcc
GDB ?= i386-elf-gdb

# OBJ = $(C_SOURCES:.c=.o cpu/*.o) OBJ = $(C_SOURCES:.c=.o cpu/ports.o cpu/isr.o cpu/idt.o cpu/timer.o cpu/interrupt.o drivers/screen.o drivers/keyboard.o libc/mem.o libc/string.o)

all: kernel.o

kernel.o: kernel.c kernel.h
	@$(CC_CMD)
	$(Q)$(CC) -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

clean:
	$(Q)rm -f *.o
