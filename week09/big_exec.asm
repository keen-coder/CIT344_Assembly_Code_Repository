; Keenan Knaur, CIT-344
; First Program
; Shows how correctly using .data and .bss sections helps to reduce the executable
; size.

section .data ;-----------------------------------------------------------------

; Constants for program exit
EXIT_SUCCESS   equ   0    ; successful program execution
SYS_exit       equ   60   ; call code for termination

byteArray resb	10000000   ; defining the array here, makes the executable about 10 MB (9,775KB)
;-------------------------------------------------------------------------------

section .bss ;------------------------------------------------------------------



;-------------------------------------------------------------------------------

section .text ;-----------------------------------------------------------------

global _start

_start:
	

last:
	mov   rax, SYS_exit
	mov   rdi, EXIT_SUCCESS
	syscall
;-------------------------------------------------------------------------------