#include "keyboard.h"
#include "../cpu/ports.h"
#include "../cpu/isr.h"
#include "screen.h"
#include "../libc/string.h"
#include "../libc/function.h"
#include "../kernel/kernel.h"

#define BACKSPACE 0x0E
#define LCTRL 0x1D
#define LALT 0x38
#define ENTER 0x1C

static char key_buffer[256];

#define SC_MAX 57
const char *sc_name[] = { "ERROR", "Esc", "1", "2", "3", "4", "5", "6", 
    "7", "8", "9", "0", "-", "=", "Backspace", "Tab", "Q", "W", "E", 
        "R", "T", "Y", "U", "I", "O", "P", "[", "]", "Enter", "Lctrl", 
        "A", "S", "D", "F", "G", "H", "J", "K", "L", ";", "'", "`", 
        "LShift", "\\", "Z", "X", "C", "V", "B", "N", "M", ",", ".", 
        "/", "RShift", "Keypad *", "LAlt", "Spacebar"};
const char sc_ascii[] = { '?', '?', '1', '2', '3', '4', '5', '6',     
    '7', '8', '9', '0', '-', '=', '?', '?', 'Q', 'W', 'E', 'R', 'T', 'Y', 
        'U', 'I', 'O', 'P', '[', ']', '?', '?', 'A', 'S', 'D', 'F', 'G', 
        'H', 'J', 'K', 'L', ';', '\'', '`', '?', '\\', 'Z', 'X', 'C', 'V', 
        'B', 'N', 'M', ',', '.', '/', '?', '?', '?', ' '};

static void keyboard_callback(registers_t regs) {
	/* The PIC leaves us the scancode in port 0x60 */
	u8 scancode = port_byte_in(0x60);
	if (scancode > SC_MAX) return;
	if (scancode == BACKSPACE) {
		backspace(key_buffer);
		kprint_backspace();
	} else if (scancode == ENTER) {
		kprint("\n", WHITE_ON_BLACK);
		user_input(key_buffer, "wOS>");
		key_buffer[0] = '\0';
	} else if (scancode == LCTRL) { // Not the best idea
		kprint("\n", WHITE_ON_BLACK);
		kernelLogPrint("Halting CPU\n", "info");
		asm volatile("hlt");
	} else if (scancode == LALT) {
		credits("keyboard");
	} else {
		char letter = sc_ascii[(int)scancode];
		char str[2] = {letter, '\0'};
		append(key_buffer, letter);
		kprint(str, WHITE_ON_BLACK);
	}
	UNUSED(regs);
}

void init_keyboard() {
   register_interrupt_handler(IRQ1, keyboard_callback); 
}
