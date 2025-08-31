; Keenan Knaur, CIT-344
; This file shows examples of how to convert between different data types.

; NOTE: Based on examples from Ed Jorgensen's Book "x86-64 Assembly Language
; Programming with Ubuntu"

; Compile -> Link -> Execute Commands
; assembler command:    yasm -felf64 -gdwarf2 conversion_examples.asm -l conversion_examples.lst
; linker command:       ld -g -o conversion_examples conversion_examples.o
; execute command:      ./conversion_examples

section .data ;=================================================================

; Constants for program exit
EXIT_SUCCESS   equ   0    ; successful program execution
SYS_exit       equ   60   ; call code for termination

bVal db 0
bVar db 42
wVar dw 777
dVar dd 289

;===============================================================================

section .text ;=================================================================

global _start

_start:
   ; EXAMPLE 01: Narrowing Conversions------------------------------------------
   ; Demonstrates how to go from a larger size to a smaller size. Be careful
   ; when you do this.
   ; General Idea: Move the value into a register, then use a smaller register
   ; name to grab the portion you want.

   mov   rax, 50           ; move 50 into the rax register
   mov   byte [bVal], al   ; move the lower 8 bits of the rax register into bVal. 
                           ; no issues here since 50 fits in the byte range.

   mov   rax, 500          ; move 500 (0x1f4) into the rax register.
   mov   byte [bVal], al   ; move the lower 8 bits of the rax register into bVal.
                           ; the upper bits of the original value will be truncated
                           ; (cut off) when placed in the smaller location. bVal
                           ; will have the value 244 (0xf4)
   ;----------------------------------------------------------------------------

   ; EXAMPLE 02: Unsigned Conversions-------------------------------------------
   
   ; converting using the mov instruction
   mov   al, 50      ; move 50 into the al register
   mov   rbx, 0      ; move 0 into the rbx register (to set it to all 0's)
   mov   bl, al      ; move al into bl (the lower portion of the rbx register)

   ; converting using the movzx command
   movzx    cx, byte [bVar]   ; convert from unsigned byte to unsigned word
   movzx    dx, al            ; convert from unsigned byte to unsigned word
   movzx    ebx, word [wVar]  ; convert from unsigned word to unsigned dword
   movzx    rbx, cl           ; convert from unsigned byte to unsigned qword
   movzx    rbx, cx           ; convert from unsigned word to unsigned qword
   ;----------------------------------------------------------------------------   

   ; EXAMPLE 03: Signed Conversions---------------------------------------------
   movsx    cx, byte [bVar]   ; convert from signed byte to signed word
   movsx    dx, al            ; convert from signed byte to signed word
   movsx    ebx, word [wVar]  ; convert from signed word to signed dword
   movsx    ebx, cx           ; convert from signed word to signed dword
   movsxd   rbx, dword [dVar] ; convert from signed dword to signed qword
   ;----------------------------------------------------------------------------

exit:
   mov   rax, SYS_exit
   mov   rdi, EXIT_SUCCESS
   syscall
;===============================================================================