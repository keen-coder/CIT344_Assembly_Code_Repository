; Keenan Knaur, CIT-344
; This file shows examples of how to use the 'inc' instruction.

; NOTE: Based on examples from Ed Jorgensen's Book "x86-64 Assembly Language
; Programming with Ubuntu"

; Compile -> Link -> Execute Commands
; assembler command:    yasm -felf64 -gdwarf2 inc_examples.asm -l inc_examples.lst
; linker command:       ld -g -o inc_examples inc_examples.o
; execute command:      ./inc_examples

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
   ; EXAMPLE 01: inc Instruction examples---------------------------------------
   ; rax = rax + 1
   inc   rax
   
   ; bNum = bNum + 1
   inc   byte [bNum]
   
   ; wNum = wNum + 1
   inc   word [wNum]
   
   ; dNum = dNum + 1
   inc   dword [dNum]
   
   ; qNum = qNum + 1
   inc   qword [qNum]
   ;----------------------------------------------------------------------------

exit:
   mov   rax, SYS_exit
   mov   rdi, EXIT_SUCCESS
   syscall
;===============================================================================