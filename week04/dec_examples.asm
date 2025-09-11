; Keenan Knaur, CIT-344
; This file shows examples of how to use the 'dec' instruction.

; NOTE: Based on examples from Ed Jorgensen's Book "x86-64 Assembly Language
; Programming with Ubuntu"

; Compile -> Link -> Execute Commands
; assembler command:    yasm -felf64 -gdwarf2 dec_examples.asm -l dec_examples.lst
; linker command:       ld -g -o dec_examples dec_examples.o
; execute command:      ./dec_examples

section .data ;=================================================================

; Constants for program exit
EXIT_SUCCESS   equ   0    ; successful program execution
SYS_exit       equ   60   ; call code for termination

; Variables defined for examples
bNum  db 42
wNum  dw 4321
dNum  dd 42000
qNum  dq 42000000
;================================================================================

; section .bss omitted

section .text ;=================================================================

global _start

_start:
   ; EXAMPLE 01: dec Instruction examples---------------------------------------
   ; rax = rax - 1
   dec   rax
   
   ; bNum = bNum - 1
   dec   byte [bNum]
   
   ; wNum = wNum - 1
   dec   word [wNum]
   
   ; dNum = dNum - 1
   dec   dword [dNum]
   
   ; qNum = qNum - 1
   dec   qword [qNum]
   ;----------------------------------------------------------------------------

exit:
   mov   rax, SYS_exit
   mov   rdi, EXIT_SUCCESS
   syscall
;===============================================================================