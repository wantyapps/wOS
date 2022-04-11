CC_CMD = @echo "CC $@"
MAKE_CMD = @echo "MAKE $@"

all: idt.o isr.o ports.o timer.o

idt.o: idt.c idt.h
	@$(CC_CMD)
	$(Q)$(CC) $(CFLAGS) -ffreestanding -c idt.c -o idt.o

isr.o: isr.c isr.h
	@$(CC_CMD)
	$(Q)$(CC) $(CFLAGS) -ffreestanding -c isr.c -o isr.o

ports.o: ports.c ports.h
	@$(CC_CMD)
	$(Q)$(CC) $(CFLAGS) -ffreestanding -c ports.c -o ports.o

timer.o: timer.c timer.h
	@$(CC_CMD)
	$(Q)$(CC) $(CFLAGS) -ffreestanding -c timer.c -o timer.o

clean:
	$(Q)rm -f *.o
