; Keenan Knaur, CIT-344
; First Program
; Shows some simple input.  

; assembler command:    yasm -felf64 -gdwarf2 simple_input.asm -l simple_input.lst
; linker command:       ld -g -o simple_input simple_input.o
; execute command:      ./simple_input

section .data ;-----------------------------------------------------------------

STDIN			equ 	0		; The standard input code (0 is for the keyboard)
SYS_read		equ		0		; Call code for the read system service
STDOUT			equ 	1	; The standard output code (1 is for the console)
SYS_write		equ		1	; Call code for the write system service
EXIT_SUCCESS   	equ   	0       ; successful program execution
SYS_exit       	equ   	60      ; call code for termination
LF				equ		10		; New Line code

inChar	db	0
;-------------------------------------------------------------------------------


; section .bss omitted

section .text
global _start
_start:
	; read the data
	mov		rax, SYS_read
	mov		rdi, STDIN
	mov		rsi, inChar		; message address
	mov		rdx, 2			; read count
	syscall

	; write the data
	mov		rax, SYS_write
	mov		rdi, STDOUT
	mov		rsi, inChar
	mov		rdx, 2
	syscall

last:
	mov   rax, SYS_exit
	mov   rdi, EXIT_SUCCESS
	syscall
