
CC_CMD = @echo "CC $@"
MAKE_CMD = @echo "MAKE $@"

CC = i386-elf-gcc
GDB ?= i386-elf-gdb

all: mem.o string.o

mem.o: mem.c mem.h
	@$(CC_CMD)
	@$(CC) $(CFLAGS) -ffreestanding -c mem.c -o mem.o

string.o: string.c string.h
	@$(CC_CMD)
	@$(CC) $(CFLAGS) -ffreestanding -c string.c -o string.o

clean:
	@rm mem.o string.o
