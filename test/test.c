/* #include <stdio.h> */
/* #include <string.h> */
#include "../kernel/kernel.h"

int main() {
	/* printf("Testing kernel word_center_screen_center with odd value..."); */
	if ( word_center_screen_center("odd") == 38.5 ) {
		/* printf("\033[0;32mpass\033[0m\n"); */
		;
	} else {
		/* printf("\033[0;31mfail\033[0m\nword_center_screen_center test failed. Expected value: 38.5. Got value: %d", word_center_screen_center("odd")); */
		;
	}
}
