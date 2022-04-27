#include "../cpu/isr.h"
#include "../drivers/colors.h"
#include "../drivers/screen.h"
#include "kernel.h"
#include "../libc/string.h"
#include "kernelversion.h"

/* kmain - Kernel main function
 * This function is called from the bootloader
 and is the startup function for the kernel
 */
void kmain() {
	isr_install();
	kernelLogPrint("Initialized ISR\n", "info");
	irq_install();
	kernelLogPrint("Initialized IRQ\n", "info");
	/* kprint_at("FUCK OFF", word_center_screen_center("FUCK OFF"), MAX_ROWS / 2, RED_ON_BLACK); */
	/* kprint_at("-Yuval", word_center_screen_center("-Yuval"), MAX_ROWS / 2 + 1, 0x02); */
	/* clear_screen(); */
	kernelLogPrint("This is wOS Version ", "info");
	kprint(FULLVERSION, GRAY_ON_BLACK);
	kprint("\n", WHITE_ON_BLACK);
	kprint("Welcome to ", WHITE_ON_BLACK);
	kprint("wOS", GREEN_ON_BLACK);
	kprint(".\n", WHITE_ON_BLACK);
	/* printLicense(license); */
	kprint("Use 'HELP' or 'USAGE' to see a list of commands.\n"
        "Use 'HALT', 'EXIT' or 'END' to halt the CPU.", WHITE_ON_BLACK);
	prompt("\n", "wOS>");
}

/* printLogBuffer - Print log buffer
 * Print all messages in the log buffer provided
   in the `log` argument
 * 
 * void printLogBuffer(char *log)
 */
void printLogBuffer(char **log) {
	for ( int i = 0; i <= sizeof *log / sizeof(log[0]); i++ ) {
		kprint(log[i], WHITE_ON_BLACK);
	}
}

/* prompt - Display a prompt
 * Display a shell prompt provided in the `prompt`
   argument with a prefix provided in the `prefix`
   argument
 *
 * void prompt(char *prefix, char *prompt)
 */
void prompt(char *prefix, char *prompt) {
	kprint(prefix, WHITE_ON_BLACK);
	kprint(prompt, WHITE_ON_BLACK);
}

/* credits - Print basic maintainer credits
 * This function isn't called directly anymore.
 * It is called from pressing "CTRL".
 *
 * `caller` is used for fixing certain bugs with
   the prompt not showing. We are planning to add
   more options and usages for this argument.
 *
 * void credits(char *caller)
 */
void credits(char *caller) {
	if (strcmp(caller, "keyboard") == 0) {
		kprint("\nCREDITS\n\n", WHITE_ON_BLACK);
		kprint("Uri Arev - Maintainer\n", WHITE_ON_BLACK);
		kprint("Yuval Maya - Maintainer\n", WHITE_ON_BLACK);
		kprint("Eytam P. - Contributor/Release names\n", WHITE_ON_BLACK);
		prompt("", "wOS>");
	}
}

/* __foff - Internal
 * Don't ask.
 */
static void __foff() {
	kprint("FUCK OFF\n", RED_ON_BLACK);
	kprint("-Yuval", GREEN_ON_BLACK);
}

/* kernelLogPrint - Print log messages.
 * Print log messages with colors to the console
   (see TESTCOLORS)
 *
 * This will print the `string` argument's value
   prefixed with the debug level matching the `level`
   argument
 *
 * void kernelLogPrint(char *string, char *level)
 */
void kernelLogPrint(char *string, char *level) {
	if (strcmp(level, "info") == 0) {
		kprint("[INFO] ", GRAY_ON_BLACK);
		kprint(string, GRAY_ON_BLACK);
	} else if (strcmp(level, "warn") == 0) {
		kprint("[WARN] ", YELLOW_ON_BLACK);
		kprint(string, WHITE_ON_BLACK);
	} else if (strcmp(level, "error") == 0) {
		kprint("[ERR] ", RED_ON_BLACK);
		kprint(string, WHITE_ON_BLACK);
	} else if (strcmp(level, "success") == 0) {
		kprint("[SUCCESS] ", GREEN_ON_BLACK);
		kprint(string, WHITE_ON_BLACK);
	}
}

/* __commandNotFound - Internal - Print "command not found"
 * Used situations when a command a user types does not exist
 *
 * static void __commandNotFound(char *input)
 */
static void __commandNotFound(char *input) {
	kprint("*** ", RED_ON_BLACK);
	kprint("wOS: ", WHITE_ON_BLACK);
	kprint(input, WHITE_ON_BLACK);
	kprint(": Command not found.", WHITE_ON_BLACK);
}

/* wcsc - Deprecated
 * Yuval and Uri tried making a function to
   display messages at the center of the screen.
   They both gave up.
 *
 * wscs stands for "word-center-screen-center" (old name)
 *
 * int wscs(char *string)
 */
int wcsc(char *string) {
	if (strlen(string) % 2 == 1) {
		append(string, ' ');
	}
	return MAX_COLS / 2 - strlen(string) / 2;
}

/* __usage - Internal - Display help message
 * Used to display a simple command list for
   the `HELP` command
 *
 * static void __usage()
 */
static void __usage() {
	kprint("Usage:\n", WHITE_ON_BLACK);
	kprint("COMMAND                HELP\n", WHITE_ON_BLACK);
	kprint("END/EXIT               Halt CPU\n", WHITE_ON_BLACK);
	kprint("CLEAR                  Clear screen\n", WHITE_ON_BLACK);
	kprint("YUVAL                  Don't ask.\n", WHITE_ON_BLACK);
	kprint("COLORTEST (TESTCOLORS) Test colors\n", WHITE_ON_BLACK);
	kprint("VERSION                Show wOS Version", WHITE_ON_BLACK);
}

/* user_input - Process user input
 * Process user input/commands - Will be replaced
   soon for a nicer (non-blocky) code (maybe switch?)
 * 
 * This should not be called from the main kernel source
   code file.
 *
 * void user_input(char *input)
 */
void user_input(char *input) {
	if (strcmp(input, "") == 0) {
		prompt("", "wOS>");
	}
	if (strlen(input) > 0) {
		int j = 0;
		int ctr = 0;
		char inputWords[100][100];
		for (int i = 0; i <= (strlen(input)); i++) {
			if (input[i] == ' ' || input[i] == '\0') {
			    inputWords[ctr][j]='\0';
			    ctr++;
			    j=0;
			} else {
			    inputWords[ctr][j] = input[i];
			    j++;
			}
		}
		if (strcmp(input, "END") == 0 || strcmp(input, "EXIT") == 0 || strcmp(input, "HALT") == 0) {
			kernelLogPrint("Halting CPU\n", "info");
			asm volatile("hlt");
		} else if (strcmp(input, "CLEAR") == 0) {
			clear_screen();
		} else if (strcmp(input, "YUVAL") == 0) {
			__foff(); // Don't ask.
		} else if (strcmp(input, "HELP") == 0 || strcmp(input, "USAGE") == 0) {
			__usage();
		} else if (strcmp(input, "VERSION") == 0) {
			kernelLogPrint("This is wOS Version ", "info");
			kprint(FULLVERSION, GRAY_ON_BLACK);
		} else if (strcmp(input, "TESTCOLORS") == 0 || strcmp(input, "COLORTEST") == 0) {
			kernelLogPrint("Info test\n", "info");
			kernelLogPrint("Warn test\n", "warn");
			kernelLogPrint("Error test\n", "error");
			kernelLogPrint("Success test", "success");
		} else if (strcmp(input, "LOGO") == 0) {
			kprint("           ___  ____\n", WHITE_ON_BLACK);
			kprint("__      __/ _ \\/ ___|\n", WHITE_ON_BLACK);
			kprint("\\ \\ /\\ / / | | \\___ \\\n", WHITE_ON_BLACK);
			kprint(" \\ V  V /| |_| |___) |\n", WHITE_ON_BLACK);
			kprint("  \\_/\\_/  \\___/|____/", WHITE_ON_BLACK);
		} else if (strcmp(input, "LOG") == 0) {
			char testLog[][1000] = {"test1", "test2"};
			printLogBuffer(testLog);
		} else {
			__commandNotFound(input);
		}
		prompt("\n", "wOS>");
	}
}
