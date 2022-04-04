#ifndef KERNEL_H
#define KERNEL_H

void user_input(char *input, char *prompt);
void usage();
void printLicense(char *license[]);
void printLogBuffer(char *log);
void kernelLogPrint(char *string, char *level);
int word_center_screen_center(char *string);
void fuckoff();

#endif
