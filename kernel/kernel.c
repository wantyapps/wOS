#include "../cpu/isr.h"
#include "../drivers/colors.h"
#include "../drivers/screen.h"
#include "kernel.h"
#include "../libc/string.h"
#include "kernelversion.h"

void kmain() {
	isr_install();
	kernelLogPrint("Initialized ISR\n", "info");
	irq_install();
	kernelLogPrint("Initialized IRQ\n", "info");
	/* kprint_at("FUCK OFF", word_center_screen_center("FUCK OFF"), MAX_ROWS / 2, RED_ON_BLACK); */
	/* kprint_at("-Yuval", word_center_screen_center("-Yuval"), MAX_ROWS / 2 + 1, 0x02); */
	clear_screen();
	kernelLogPrint("This is wOS Version ", "info");
	kprint(FULLVERSION, WHITE_ON_BLACK);
	kprint("\n", WHITE_ON_BLACK);
	kprint("Welcome to ", WHITE_ON_BLACK);
	kprint("wOS", RED_ON_BLACK);
	kprint(".\n", WHITE_ON_BLACK);
	/* printLicense(license); */
	kprint("Type help to see a short list of commands\n"
        "Type END to halt the CPU\nwOS> ", WHITE_ON_BLACK);
}

void fuckoff() {
	kprint("FUCK OFF\n", RED_ON_BLACK);
	kprint("-Yuval", 0x02);
}

void kernelLogPrint(char *string, char *level) {
	if ( strcmp(level, "info") == 0 ) {
		kprint("[KERNEL] ", WHITE_ON_BLACK);
		kprint(string, WHITE_ON_BLACK);
	}
}

void commandNotFound(char *input) {
	kprint("*** ", RED_ON_BLACK);
	kprint("wOS: ", WHITE_ON_BLACK);
	kprint(input, WHITE_ON_BLACK);
	kprint(": Command not found.", WHITE_ON_BLACK);
}

int word_center_screen_center(char *string) {
	if ( strlen(string) % 2 == 1 ) {
		append(string, ' ');
	}
	return MAX_COLS / 2 - strlen(string) / 2;
}

void usage() {
	kprint("Usage:\n", WHITE_ON_BLACK);
	kprint("COMMAND            HELP\n", WHITE_ON_BLACK);
	kprint("END/EXIT           Halt CPU\n", WHITE_ON_BLACK);
	kprint("CLEAR              Clear screen\n", WHITE_ON_BLACK);
	kprint("YUVAL              Don't ask.\n", WHITE_ON_BLACK);
	kprint("VERSION            Show wOS Version", WHITE_ON_BLACK);
}

void user_input(char *input, char *prompt) {
	if (strcmp(input, "") == 0) {
		kprint(prompt, WHITE_ON_BLACK);
	}
	if (strlen(input) > 0) {
		int j = 0;
		int ctr = 0;
		char inputWords[100][100];
		for(int i = 0; i <= (strlen(input)); i++) {
			if(input[i] == ' ' || input[i] == '\0') {
			    inputWords[ctr][j]='\0';
			    ctr++;
			    j=0;
			} else {
			    inputWords[ctr][j]=input[i];
			    j++;
			}
		}
		if (strcmp(input, "END") == 0 || strcmp(input, "EXIT") == 0) {
			kprint("Halting CPU\n", WHITE_ON_BLACK);
			asm volatile("hlt");
		} else if (strcmp(input, "CLEAR") == 0) {
			clear_screen();
		} else if (strcmp(input, "YUVAL") == 0) {
			fuckoff(); // Don't ask.
		} else if (strcmp(input, "HELP") == 0 || strcmp(input, "USAGE") == 0) {
			usage();
		} else if (strcmp(input, "VERSION") == 0) {
			kernelLogPrint("This is wOS Version ", "info");
			kprint(FULLVERSION, WHITE_ON_BLACK);
		} else if (strcmp(input, "LOGO") == 0) {
			kprint("           ___  ____\n", WHITE_ON_BLACK);
			kprint("__      __/ _ \\/ ___|\n", WHITE_ON_BLACK);
			kprint("\\ \\ /\\ / / | | \\___ \\\n", WHITE_ON_BLACK);
			kprint(" \\ V  V /| |_| |___) |\n", WHITE_ON_BLACK);
			kprint("  \\_/\\_/  \\___/|____/", WHITE_ON_BLACK);
		} else {
			commandNotFound(input);
		}
		kprint("\nwOS>", WHITE_ON_BLACK);
	}
}
