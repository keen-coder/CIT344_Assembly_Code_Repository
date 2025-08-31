; Keenan Knaur, CIT-344
; First Program
; Shows some simple output.  

; assembler command:    yasm -felf64 -gdwarf2 simple_output.asm -l simple_output.lst
; linker command:       ld -g -o simple_output simple_output.o
; execute command:      ./simple_output

section .data ;-----------------------------------------------------------------

STDOUT			equ 	1	; The standard output code (1 is for the console)
SYS_write		equ		1	; Call code for the write system service
EXIT_SUCCESS   equ   0        ; successful program execution
SYS_exit       equ   60       ; call code for termination
LF					equ		10

msg		db		"Hello World!", LF
msgLength	dq		13
;-------------------------------------------------------------------------------


; section .bss omitted

section .text
global _start
_start:
	mov		rax, SYS_write
	mov		rdi, STDOUT
	mov		rsi, msg
	mov		rdx, qword [msgLength]
	syscall

last:
	mov   rax, SYS_exit
	mov   rdi, EXIT_SUCCESS
	syscall
