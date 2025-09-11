; Keenan Knaur, CIT-344

; This file shows an example of how to iterate using cmp, a counter variable
; and a jump.  This program sums the odd values between 1 and 30 inclusive.

; NOTE: Based on examples from Ed Jorgensen's Book "x86-64 Assembly Language
; Programming with Ubuntu"

; Compile -> Link -> Execute Commands
; assembler command:    yasm -felf64 -gdwarf2 sum_1_to_30.asm -l sum_1_to_30.lst
; linker command:       ld -g -o sum_1_to_30 sum_1_to_30.o
; execute command:      ./sum_1_to_30

section .data ;=================================================================

; Constants for program exit
EXIT_SUCCESS   equ 	0    ; successful program execution
SYS_exit       equ  60   ; call code for termination

; Variables defined for examples
loopCounter    dq	   15 
sum            dq    0
;================================================================================

; section .bss omitted

section .text ;=================================================================

global _start

_start:

   ; EXAMPLE 01: Sum the odd values from 1 to 30 using cmp, jne, and a counter
   ; variable.------------------------------------------------------------------

   mov     rcx, qword [loopCounter]        ; loop counter
   mov     rax, 1                          ; odd integer counter

sumLoop:
   add     qword [sum], rax          ; sum current odd integer
   add     rax, 2                    ; set next odd integer
   dec     rcx                       ; decrement loop counter
   cmp     rcx, 0
   jne     sumLoop

   ;----------------------------------------------------------------------------

   ; Example 02: Do the same thing but using the loop instruction this time.

   mov qword [sum], 0           ; reset the sum variable to 0
   mov rcx, qword [loopCounter] ; loop counter
   mov rax, 1                   ; odd integer counter

sumLoop2:
   add qword [sum], rax         ; sum current odd integer
   add rax, 2                   ; set next odd integer
   loop sumLoop2

exit:
   mov   rax, SYS_exit
   mov   rdi, EXIT_SUCCESS
   syscall
;===============================================================================