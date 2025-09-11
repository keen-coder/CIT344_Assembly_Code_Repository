; Author:   Daniel Yoas, Ph.D.
; Purpose:  Create a menu and print out the menu item.
; Date:     09/06/2022

section .data
; Static declarations are saved to disk and initialized at process start

NL EQU   0x0A

Input       db 0
Finished    db 0

Menu        db "What would you like to do?", 0x0A
            db "1) Say '"
M1          db "Hello"
M1Len       EQU   $-M1
            db "'", 0x0A
            db "2) Say '"
M2          db "It's Warm"
M2Len       EQU   $-M2
            db "'", NL
            db "3) Say '"
M3          db "Lunch Time"
M3Len       EQU   $-M3
            db "'", NL
            db "4) Exit Program"
NewLine     db NL, NL
NewLineLen  EQU   $-NewLine
            db 0x00
MenuLen     EQU   $-Menu

section .bss
; Undefined varibles until process execution go here

section .text
global _start
_start:

Next:
   mov   rax, 1
   mov   rdi, 1
   mov   rsi, Menu
   mov   rdx, MenuLen
   syscall

   mov   rax, 0
   mov   rdi, 0
   mov   rsi, Input
   mov   rdx, 1
   syscall

   cmp   byte [Input], 0x0A
   je    Exit

Menu1:
   cmp   byte [Input], '1'
   jne   Menu2
   mov   rsi, M1
   mov   rdx, M1Len
   jmp   PrintSelection

Menu2:
   cmp   byte [Input], '2' ; If I'm here it isn't a 1.
   jne   Menu3
   mov   rsi, M2
   mov   rdx, M2Len
   jmp   PrintSelection

Menu3:
   cmp   byte [Input], '3' ; If I'm here it isn't a 1 or a 2.
   jne   Menu4
   mov   rsi, M3
   mov   rdx, M3Len
   jmp   PrintSelection

Menu4:
   cmp   byte [Input], '4' ; Exit if the person selects it.
   je    SetFinished

   cmp   byte [Input], NL ; Exit if they only give me a NL.
   je    SetFinished
   jmp   ClearKeyboardBuffer

SetFinished:
   mov   byte [Finished], 1
   jmp   ClearKeyboardBuffer

PrintSelection:
   mov   rax, 1
   mov   rdi, 1
   syscall

   mov   rax, 1
   mov   rdi, 1
   mov   rsi, NewLine
   mov   rdx, 1
   syscall

ClearKeyboardBuffer:
   mov   rax, 0
   mov   rdi, 0
   mov   rsi, Input
   mov   rdx, 1
   syscall        ; Grab the next character in the keyboard.

   ; Once the NL is pulled the keyboard buffer is empty.
   cmp   byte [Input], NL  ; Thow out everything until a newline.
   jne   ClearKeyboardBuffer

   cmp   byte [Finished], 1
   jne   Next     ; If Finished is still 0 repeat the menu.

Exit:
   mov   rax, 60
   mov   rdi, 0
   syscall