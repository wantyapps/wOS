.set ALIGN,    1<<0
.set MEMINFO,  1<<1
.set FLAGS,    ALIGN
.set MAGIC,    0x1BADB002
.set CHECKSUM, -(MAGIC + FLAGS)
 
.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

.section .bss
.align 16
stack_bottom:
.skip 16384
stack_top:

BOOT_DRIVE:
 
.section .text
.global _start
.type _start, @function
_start:
	
	
	mov $stack_top, %esp
 
	mov %dh, 22
	mov %dl, %dl

	pusha

	push %dx

	mov %ah, 0x02
	mov %al, %dh
	mov %cl, 0x02 
		 
	mov %ch, 0x00 

	mov %dh, 0x00 
	int $0x13

	pop %dx
	cmp %al, %dh    

	popa
	ret
	call kmain
 
	cli
1:	hlt
	jmp 1b
 
.size _start, . - _start
