; Keenan Knaur
; Assembly program to print a string.

section .data ;==========================================================================
; Variables/Constants with known values go here.
; This data will be stored within the program and on the hard drive.

; Constats used throughout the program
LF			 	EQU 0x0A 	; 10 in decimal
NULL		 	EQU 0x00 	; 0 in decimal

SYS_write	 	EQU 1		; Call code for the SYS_write system call
STDOUT		 	EQU 1		; Code to indicate the standard outout (console)

SYS_exit	 	EQU 60		; Call code for the SYS_exit system call
EXIT_SUCCESS	EQU 0		; 0 Code for successful termination (any other value means
							; some error occured which caused the exit.
; Variables definition
msg:			db	"Hello World", LF, NULL
msglen:			EQU	$-msg	; $ represents the current memory address for the code
							; Example: subtracting msg from $ gives you the number of bytes
							; between msg and $ (essentially the size)
;========================================================================================

section .bss
; Undefined varibles until process execution go here

;========================================================================================

section .text
global _start
_start:

print:	; 'print' is a label, you can jump to labels from other parts of the code
	mov	rax, SYS_exit
	mov	rdi, STDOUT
	mov	rsi, msg
	mov	rdx, msglen
	syscall

exit:	; exit label
	mov	rax, SYS_exit
	mov	rdi, 0
	syscall

