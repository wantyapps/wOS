#ifndef KERNEL_H
#define KERNEL_H

void user_input(char *input, char *prompt);
void printLicense(char *license[]);
void printLogBuffer(char *log);
void kernelLogPrint(char *string, char *level);
void credits(char *caller);
int wcsc(char *string);

#endif
