; Keenan Knaur, CIT-344
; Shows a simple use of the jmp command to jump to a label and create an infinite
; loop.

; Compile -> Link -> Execute Commands
; assembler command:    yasm -felf64 -gdwarf2 infinite_loop.asm -l infinite_loop.lst
; linker command:       ld -g -o infinite_loop infinite_loop.o
; execute command:      ./infinite_loop

section .data ;=================================================================

; Constants for program exit
EXIT_SUCCESS   equ   0    ; successful program execution
SYS_exit       equ   60   ; call code for termination

; Constants for strings
LF             equ   10       ; LineFeed / newline character
NULL           equ   0        ; NULL character, required to terminate a string.

; Constants for output
STDOUT         equ   1     ; The standard output code (1 is for the console)
SYS_write      equ   1     ; Call code for the write system service


hello    db    "hello world!", LF, NULL
helloLen dq    $-hello      ; easy way to get length of string.
                            ; $ is the current address of the program, if you
                            ; subtract the address of the string from the current
                            ; you will get its length.



;================================================================================

; section .bss omitted

section .text ;=================================================================

global _start

_start:
   
helloForever:
   
   ; print out the string
   mov      rax, SYS_write
   mov      rdi, STDOUT
   mov      rsi, hello
   mov      rdx, qword [helloLen]
   syscall

   jmp helloForever ; jump back to the helloForever label


exit:
   mov   rax, SYS_exit
   mov   rdi, EXIT_SUCCESS
   syscall
;===============================================================================