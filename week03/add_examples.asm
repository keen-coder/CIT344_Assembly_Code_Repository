; Keenan Knaur, CIT-344
; This file shows examples of how to use the 'add' instruction.

; NOTE: Based on examples from Ed Jorgensen's Book "x86-64 Assembly Language
; Programming with Ubuntu"

; Compile -> Link -> Execute Commands
; assembler command:    yasm -felf64 -gdwarf2 add_examples.asm -l add_examples.lst
; linker command:       ld -g -o add_examples add_examples.o
; execute command:      ./add_examples

section .data ;=================================================================

; Constants for program exit
EXIT_SUCCESS   equ   0    ; successful program execution
SYS_exit       equ   60   ; call code for termination

; Variables defined for examples
bNum1    db    42
bNum2    db    73
bAns     db    0
wNum1    dw    4321
wNum2    dw    1234
wAns     dw    0
dNum1    dd    42000
dNum2    dd    73000
dAns     dd    0
qNum1    dq    42000000
qNum2    dq    73000000
qAns     dq    0


;================================================================================

; section .bss omitted

section .text ;=================================================================

global _start

_start:
   ; EXAMPLE 01: Addition with register, immedidate and memory------------------
   mov   al, 42           ; Move 42 into the rax register.
   
   add   al, 10           ; add 10 to the rax register, store in rax.
   
   add   al, byte [bNum2] ; add value of bNum2 to rax regster, store in rax.
   ;----------------------------------------------------------------------------

   ; EXAMPLE 02: Addition between two memory locations (variables)--------------
   ; This is a two step process, move the data into a register, perform the 
   ; addition, then put the result back into memory.

   ; bAns = bNum1 + bNum2
   mov   al, byte [bNum1]  ; move value of bNum1 into al register
   add   al, byte [bNum2]  ; add value of bNum2 to a1 register   
   mov   byte [bAns], al   ; store value of a1 register in bAns variable

   ; wAns = wNum1 + wNum2
   mov   ax, word [wNum1]
   add   ax, word [wNum2]
   mov   word [wAns], ax

   ; dAns = dNum1 + dNum2
   mov   eax, dword [dNum1]
   add   eax, dword [dNum2]
   mov   dword [dAns], eax

   ; qAns = qNum1 + qNum2
   mov   rax, qword [qNum1]
   add   rax, qword [qNum2]
   mov   qword [qAns], rax
   ;----------------------------------------------------------------------------

exit:
   mov   rax, SYS_exit
   mov   rdi, EXIT_SUCCESS
   syscall
;===============================================================================