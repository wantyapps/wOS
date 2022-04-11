CC_CMD = @echo "CC $@"
MAKE_CMD = @echo "MAKE $@"

all: kernel.o

kernel.o: kernel.c kernel.h
	@$(CC_CMD)
	$(Q)$(CC) -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

clean:
	$(Q)rm -f *.o
