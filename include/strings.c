#include "strings.h"

/* str_len(string)
Count characters (except '\0') in a string
and return the number
*/

int str_len(char* string) {
	int count = 0;
	for ( int i = 0; string[i] != NULL; i++) {
		count++;
	}
	return count;
}

/* is_odd(string)
Return 0 if string is odd
and 1 if string is even
*/

int is_odd(char string) {
	if( str_len(&string) % 2 == 0 ) {
		return 0;
	} else if ( str_len(&string) % 2 == 1 ) {
		return 1;
	}
}
