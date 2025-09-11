; Keenan Knaur, CIT-344
; This file shows examples of how to use the 'cmp', 'je', and 'jne' instructions.

; Compile -> Link -> Execute Commands
; assembler command:    yasm -felf64 -gdwarf2 cmp_je_jne.asm -l cmp_je_jne.lst
; linker command:       ld -g -o cmp_je_jne cmp_je_jne.o
; execute command:      ./cmp_je_jne

section .data ;=================================================================

; Constants for program exit
EXIT_SUCCESS   equ   0    ; successful program execution
SYS_exit       equ   60   ; call code for termination

; Constants for output
STDOUT         equ   1  ; The standard output code (1 is for the console)
SYS_write      equ   1  ; Call code for the write system service

; String Constants
LF    equ   10
NULL  equ   0

; Variables defined for examples
strEqual       db    "The values are equal.", NULL, LF
strEqualLen    dq    $-strEqual

strNotEqual    db    "The values are NOT equal.", NULL, LF
strNotEqualLen dq    $-strNotEqual

bNum1    db    7
bNum2    db    42

;================================================================================

; section .bss omitted

section .text ;=================================================================

global _start

_start:
 
example1:   
   mov   al, byte [bNum1]
   cmp   al, 7
   je    equal1
   jne   notEqual1

equal1:
   mov      rax, SYS_write
   mov      rdi, STDOUT
   mov      rsi, strEqual
   mov      rdx, qword [strEqualLen]
   syscall
   
   jmp example2

notEqual1:
   mov      rax, SYS_write
   mov      rdi, STDOUT
   mov      rsi, strNotEqual
   mov      rdx, qword [strNotEqualLen]
   syscall
   
   jmp example2

example2:   
   mov   al, byte [bNum2]
   cmp   al, 7
   je    equal2
   jne   notEqual2

equal2:
   mov      rax, SYS_write
   mov      rdi, STDOUT
   mov      rsi, strEqual
   mov      rdx, qword [strEqualLen]
   syscall
   
   jmp exit

notEqual2:
   mov      rax, SYS_write
   mov      rdi, STDOUT
   mov      rsi, strNotEqual
   mov      rdx, qword [strNotEqualLen]
   syscall
   
   jmp exit

exit:
   mov   rax, SYS_exit
   mov   rdi, EXIT_SUCCESS
   syscall
;===============================================================================