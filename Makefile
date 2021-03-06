VERSION = 1
PATCHLEVEL = 5
SUBLEVEL = 1
EXTRAVERSION =
NAME = 7inch
FULLVERSION = 1.5.1 (7inch)

$(if $(filter __%, $(MAKECMDGOALS)), \
	$(error targets prefixed with '__' are only for internal use))

CC_CMD = @echo "CC $@"
MAKE_CMD = @echo "MAKE $@"

C_SOURCES = $(wildcard kernel/*.c)
HEADERS = $(wildcard kernel/*.h)
# OBJ = $(C_SOURCES:.c=.o cpu/*.o)
OBJ = $(C_SOURCES:.c=.o cpu/ports.o cpu/isr.o cpu/idt.o cpu/timer.o cpu/interrupt.o drivers/screen.o drivers/keyboard.o libc/mem.o libc/string.o)
SUBDIRS := cpu drivers libc kernel

DOC_NAMES := latexpdf html

ifeq ($(origin CC),default)
CC = i686-elf-gcc
endif
GDB ?= i686-elf-gdb
ifeq ($(origin AS),default)
AS = i686-elf-as
endif
ifeq ($(origin LD),default)
LD = i686-elf-ld
endif

MAKEFLAGS += -rR --no-builtin-variables
CFLAGS ?= -g -m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector -nostartfiles -nodefaultlibs \
		 -Wall -Wextra

ifeq ($(OS),Windows_NT)
$(error Don't build this on Windows.)
endif

# Straight up copied from linux/Makefile
ifeq ("$(origin V)", "command line")
	VERBOSE = $(V)
endif
ifndef VERBOSE
	VERBOSE = 0
endif

ifeq ($(VERBOSE),1)
	quiet =
	Q =
else
	quiet=quiet_
	Q = @
	MAKEFLAGS += --no-print-directory
endif

ifneq ($(findstring s,$(filter-out --%,$(MAKEFLAGS))),)
	quiet=silent_
	VERBOSE = 0
endif

ifeq ("$(origin HEXD)", "command line")
	HEXD=$(HEXD)
endif
ifndef HEXD
	HEXD=0
endif

ifeq ($(HEXD),1)
	HEXDUMP=hexdump
else
	HEXDUMP=
endif

export quiet Q VERBOSE CC CFLAGS AS LD

PHONY += __all
__all: options $(SUBDIRS) os-image.bin

PHONY += help
help:
	@echo "Cleaning targets:"
	@echo "  clean           - Remove most generated files"
	@echo "  patchclean      - Remove all patches left"
	@echo ""
	@echo "Modules:"
	@echo "You should generally not compile modules individually."
	@echo "  drivers         - Compile all files in drivers/"
	@echo "  cpu             - Compile all files in cpu/"
	@echo "  libc            - Compile all files in libc/"
	@echo "  kernel          - Compile kernel"
	@echo "Options:"
	@echo "  make V=(0/1)    - Verbosity level (default 0, don't show commands)"
	@echo "Documentation targets:"
	@echo "  html            - Build the html docs (Documentation/build/html/index.html)"
	@echo "Patch targets:"
	@echo "  patchclean      - Remove all patches left"
	@echo "  createpatches 1=<commit1> 2=<commit2> - Create patches from commits"

PHONY += options
options:
	$(Q)scripts/make/logo.sh @echo "Building wOS Kernel version $(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION) ($(NAME))"
	@echo "CC		: $(CC)"
	@echo "AS 		: $(AS)"
	@echo "LD 		: $(LD)"
	@echo "GDB 		: $(GDB)"
	@echo "CFLAGS  	: $(CFLAGS)"
	@echo "gdb		: $(GDB)"
	@echo "C_SOURCE 	: $(C_SOURCES)"
	@echo "HEADERS		: $(HEADERS)"
	@echo "MAKEFLAGS	: $(MAKEFLAGS)"

os-image.bin: boot/boot.o $(OBJ)
	@$(CC_CMD)
	$(Q)$(CC) -T linker.ld -o os-image.bin -ffreestanding -O2 -nostdlib $^
	$(Q)if [ ! -z $(HEXDUMP) ]; then \
		$(HEXDUMP) $@; \
	fi


os-image-debug.bin: boot/boot.bin kernel.bin $(OBJ)
	$(Q)cat $^ > os-image-debug.bin

kernel.bin: boot/kernel_entry.o $(OBJ) cpu/interrupt.o
	$(Q)$(LD) -o $@ -Ttext 0x1000 $^ --oformat binary

# '--oformat binary' deletes all symbols as a collateral, so we don't need
# to 'strip' them manually on this case
# kernel.bin: boot/kernel_entry.o ${OBJ}
# 	$(LD) -o $@ -T linker.ld $^ --oformat binary

# cpu/interrupt.o: cpu/interrupt.asm
# 	nasm $< -f elf -o $@

boot/boot.o: boot/boot.s
	$(Q)$(AS) boot/boot.s -o boot/boot.o

# kernel.o: kernel/kernel.c $(OBJ) cpu/interrupt.o
# 	@$(CC_CMD)
# 	@$(CC) -c cpu/interrupt.o kernel/kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall $(OBJ) -Wextra

# Used for debugging purposes
kernel.elf: ${OBJ}
	$(Q)$(LD) -o $@ -Ttext 0x1000 $^

PHONY += run
run: os-image.bin
	$(Q)qemu-system-i386 -kernel os-image.bin

PHONY += debug
debug: os-image-debug.bin kernel.elf
	$(Q)qemu-system-i386 -s -fda os-image-debug.bin &
	$(Q)$(GDB) -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

%.o: %.c $(HEADERS)
	@$(CC_CMD)
	$(Q)$(CC) $(CFLAGS) -ffreestanding -c $< -o $@

%.o: %.asm
	$(Q)nasm $< -f elf -o $@

%.bin: %.asm
	$(Q)nasm $< -f bin -o $@

$(DOC_NAMES):
	$(Q)$(MAKE) -C Documentation $@

PHONY += iso
iso: os-image.bin
	$(Q)cp os-image.bin isodir/boot
	$(Q)grub-mkrescue -o wOS.iso isodir/

PHONY += $(SUBDIRS)
$(SUBDIRS):
	$(Q)$(MAKE) -C $@

PHONY += clean
clean:
	$(Q)rm -rf *.bin *.dis *.o *.elf *.iso
	$(Q)rm -rf boot/*.bin boot/*.o
	$(Q)$(MAKE) -C Documentation clean
	$(Q)$(MAKE) -C cpu clean
	$(Q)$(MAKE) -C drivers clean
	$(Q)$(MAKE) -C libc clean
	$(Q)$(MAKE) -C kernel clean

PHONY += createpatches
createpatches: patchclean
	$(Q)git format-patch -o patch/ -n --cover-letter $(1)..$(2)

PHONY += patchclean
patchclean:
	$(Q)rm -rf patch/*


.PHONY: $(PHONY)
