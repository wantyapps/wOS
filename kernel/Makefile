CC_CMD = @echo "CC $@"
MAKE_CMD = @echo "MAKE $@"

CC = i386-elf-gcc
GDB ?= i386-elf-gdb

all: kernel.o

kernel.o: kernel.c kernel.h
	@$(CC_CMD)
	$(Q)$(CC) -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

clean:
	$(Q)rm *.o
