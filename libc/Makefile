CC_CMD = @echo "CC $@"
MAKE_CMD = @echo "MAKE $@"

all: mem.o string.o

mem.o: mem.c mem.h
	@$(CC_CMD)
	$(Q)$(CC) $(CFLAGS) -ffreestanding -c mem.c -o mem.o

string.o: string.c string.h
	@$(CC_CMD)
	$(Q)$(CC) $(CFLAGS) -ffreestanding -c string.c -o string.o

clean:
	$(Q)rm -f *.o
