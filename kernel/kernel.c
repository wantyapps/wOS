#include "../drivers/colors.h"
#include "../drivers/screen.h"
#include "kernel.h"
#include "../libc/string.h"

void main() {
	clear_screen();
	kprint("Welcome to ", WHITE_ON_BLACK);
	kprint("wOS", RED_ON_BLACK);
	kprint(".", WHITE_ON_BLACK);
	/* kprint_at("Yuval", word_center_screen_center("Yuval"), MAX_ROWS / 2, RED_ON_BLACK); */
	char *credits[] = {"CREDITS", "Created by", "Yuval M", "Uri A", "at Jan 10 2022"};
	/* char *credits[] = {"CREDITS", "Created by:", "Yuval Maya", "Uri Arev", "at Jan 10 2022"}; */
	/* kprint(credits[0], WHITE_ON_BLACK); */
	/* kprint(credits[1], WHITE_ON_BLACK); */
	/* kprint(credits[2], WHITE_ON_BLACK); */
	/* kprint(credits[3], WHITE_ON_BLACK); */
	/* kprint(credits[4], WHITE_ON_BLACK); */
	kprint_at(credits[0], word_center_screen_center(*credits[0]), MAX_ROWS / 2, WHITE_ON_BLACK);
	kprint_at(credits[1], word_center_screen_center(*credits[1]), MAX_ROWS / 2 + 1, WHITE_ON_BLACK);
	kprint_at(credits[2], word_center_screen_center(*credits[2]), MAX_ROWS / 2 + 2, WHITE_ON_BLACK);
	kprint_at(credits[3], word_center_screen_center(*credits[3]), MAX_ROWS / 2 + 3, WHITE_ON_BLACK);
	kprint_at(credits[4], word_center_screen_center(*credits[4]), MAX_ROWS / 2 + 4, WHITE_ON_BLACK);
	/* kprint_at("FUCK OFF\n", (MAX_COLS / 2) - (8 / 2), MAX_ROWS / 2 - 1, 0x04); */
	/* kprint_at("-Yuval", (MAX_COLS / 2) - (6 / 2), MAX_ROWS / 2, 0x02); */
}

int word_center_screen_center(char string) {
	if ( strlen(string) % 2 == 1 ) {
		append(string, ' ');
	}
	return MAX_COLS / 2 - strlen(string) / 2;
}
