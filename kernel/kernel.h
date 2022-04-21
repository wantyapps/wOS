#ifndef KERNEL_H
#define KERNEL_H

void user_input(char *input);
void printLicense(char *license[]);
void printLogBuffer(char *log);
void kernelLogPrint(char *string, char *level);
void credits(char *caller);
void prompt(char *prefix, char *prompt);
int wcsc(char *string);

#endif
