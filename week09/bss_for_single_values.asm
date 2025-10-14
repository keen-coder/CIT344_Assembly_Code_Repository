; Keenan Knaur, CIT-344
; First Program
; Shows how to use the .bss section to define memory locations for a single value 
; (not an array of values)

section .data ;-----------------------------------------------------------------

; Constants for program exit
EXIT_SUCCESS   equ   0    ; successful program execution
SYS_exit       equ   60   ; call code for termination

;-------------------------------------------------------------------------------

section .bss ;------------------------------------------------------------------

byteVar			resb	1	; 1 byte variable
wordVar			resw	1	; 2 byte variable	
doubleWordVar	resd	1	; 4 byte variable
quadWordVar		resq	1	; 8 byte variable

;-------------------------------------------------------------------------------

section .text ;-----------------------------------------------------------------

global _start

_start:
	mov	rax, 0xff 						; 255
	mov	rbx, 0xffff 				   ; 65535
 	mov	rcx, 0xffffffff				; 4294967295
 	mov	rdx, 0x7fffffffffffffff    ; 9223372036854775807
 
 	mov	byte [byteVar], al
 	mov	word [wordVar], bx
 	mov	dword [doubleWordVar], ecx
 	mov	qword [quadWordVar], rdx


last:
	mov   rax, SYS_exit
	mov   rdi, EXIT_SUCCESS
	syscall
;-------------------------------------------------------------------------------