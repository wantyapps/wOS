[bits 32]
global _start
_start:
	[extern kmain] ; Define calling point. Must have same name as kernel.c 'main' function
	call kmain ; Calls the C function. The linker will know where it is placed in memory
	jmp $
