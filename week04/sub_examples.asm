; Keenan Knaur, CIT-344
; This file shows examples of how to use the 'sub' instruction.

; NOTE: Based on examples from Ed Jorgensen's Book "x86-64 Assembly Language
; Programming with Ubuntu"

; Compile -> Link -> Execute Commands
; assembler command:    yasm -felf64 -gdwarf2 sub_examples.asm -l sub_examples.lst
; linker command:       ld -g -o sub_examples sub_examples.o
; execute command:      ./sub_examples

section .data ;=================================================================

; Constants for program exit
EXIT_SUCCESS   equ   0    ; successful program execution
SYS_exit       equ   60   ; call code for termination

; Variables defined for examples
bNum1        db        73
bNum2        db        42
bAns         db        0

wNum1        dw        1234
wNum2        dw        4321
wAns         dw        0

dNum1        dd        73000
dNum2        dd        42000
dAns         dd        0

qNum1        dq        73000000
qNum2        dq        73000000
qAns         dq        0


;================================================================================

; section .bss omitted

section .text ;=================================================================

global _start

_start:
   ; EXAMPLE 01: Subtraction with register, immedidate and memory---------------
   mov   al, 100          ; Move 100 into the al register.  
   sub   al, 10           ; Subtract 10 from the al register, store in al.
   sub   al, byte [bNum2] ; Subtract value of bNum2 from al regster, store in al.
   ;----------------------------------------------------------------------------

   ; EXAMPLE 02: Subtraction between two memory locations (variables)-----------
   ; This is a two step process, move the data into a register, perform the 
   ; subtraction, then put the result back into memory.

   ; bAns = bNum1 - bNum2
   mov   al, byte [bNum1]  ; move value of bNum1 into al register
   sub   al, byte [bNum2]  ; subtract value of bNum2 from a1 register   
   mov   byte [bAns], al   ; store value of a1 register in bAns variable

   ; wAns = wNum1 - wNum2
   mov   ax, word [wNum1]
   sub   ax, word [wNum2]
   mov   word [wAns], ax

   ; dAns = dNum1 - dNum2
   mov   eax, dword [dNum1]
   sub   eax, dword [dNum2]
   mov   dword [dAns], eax

   ; qAns = qNum1 - qNum2
   mov   rax, qword [qNum1]
   sub   rax, qword [qNum2]
   mov   qword [qAns], rax
   ;----------------------------------------------------------------------------

exit:
   mov   rax, SYS_exit
   mov   rdi, EXIT_SUCCESS
   syscall
;===============================================================================