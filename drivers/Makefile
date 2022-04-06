CC_CMD = @echo "CC $@"
MAKE_CMD = @echo "MAKE $@"

CC = i386-elf-gcc
GDB ?= i386-elf-gdb

all: screen.o keyboard.o

screen.o: screen.c screen.h
	@$(CC_CMD)
	@$(CC) $(CFLAGS) -ffreestanding -c screen.c -o screen.o

keyboard.o: keyboard.c keyboard.h
	@$(CC_CMD)
	@$(CC) $(CFLAGS) -ffreestanding -c keyboard.c -o keyboard.o

clean:
	@rm keyboard.o screen.o
