; Keenan Knaur, CIT-344
; Reads a string then prints it one character at a time.

; Compile -> Link -> Execute Commands
; assembler command:    yasm -felf64 -gdwarf2 print_char_at_time.asm -l print_char_at_time.lst
; linker command:       ld -g -o print_char_at_time print_char_at_time.o
; execute command:      ./print_char_at_time

section .data ;=================================================================

; Constants for program exit
EXIT_SUCCESS   equ   0    ; successful program execution
SYS_exit       equ   60   ; call code for termination

; Constants for output
STDOUT         equ   1  ; The standard output code (1 is for the console)
SYS_write      equ   1  ; Call code for the write system service

; Constants for input
STDIN          equ   0  ; Standard input code (0 for keyboard)
SYS_read       equ   0  ; Call code for the read system service 

; String Constants
LF    equ   10
NULL  equ   0

sPromptEnter      db    "Enter a string up to 50 chars: ", NULL
sPromptEnterLen   equ   $-sPromptEnter    ; get the length of the string using the $ trick.

strLF    db    "",LF

; initialize a variable with 50 spaces in it to reserve 50 characters 
strInput    db    "                                                  "
MAX_CHARS   equ   $-strInput

charsRead      dq    0
addrCounter    dq    0


;===============================================================================

section .text ;=================================================================

global _start

_start:

   ; instructions to print the prompt
   mov  rax, SYS_write
   mov  rdi, STDOUT
   mov  rsi, sPromptEnter
   mov  rdx, sPromptEnterLen
   syscall
 
   ; instructions to read the string
   mov   rax, SYS_read
   mov   rdi, STDIN
   mov   rsi, strInput
   mov   rdx, MAX_CHARS
   syscall

   ; Decrement rax by 1 so the number of chars read does not include the enter key press
   dec   rax

   mov   qword [charsRead], rax    ; at this point rax holds the number of chars entered
                                 ; including the enter key press.  we can save that value
                                 ; for later.

; print the string character by character
printCharLoop:

   ; print the next character
   mov  rax, SYS_write
   mov  rdi, STDOUT
   mov  rsi, strInput

   add  rsi, qWord [addrCounter] ; add the counter to the address to get to the next
                                 ; character
   mov  rdx, 1       ; only print one character at a time
   syscall

   ; print a new line character
   mov  rax, SYS_write
   mov  rdi, STDOUT
   mov  rsi, strLF
   mov  rdx, 1       ; only print one character at a time
   syscall

   inc qWord [addrCounter]
   
   ; decide if you need to keep looping or not.
   mov   rbx,  qWord [addrCounter]
   cmp   rbx,  qWord [charsRead]
   jne   printCharLoop

exit:
   mov   rax, SYS_exit
   mov   rdi, EXIT_SUCCESS
   syscall
;===============================================================================