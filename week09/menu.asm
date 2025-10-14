section .data
; Static declarations are saved to disk and initialized at process start

NL  EQU   0x0A

Input       db 0
Finished    db 0

Menu        db "What would you like to do?", NL

M1          db "1) Say 'Hello'", NL
M1Len       EQU   $-M1
            
M2          db "2) Say 'It's Warm'", NL
M2Len       EQU   $-M2

M3          db "3) Say 'Lunch Time'", NL
M3Len       EQU   $-M3

M4          db "4) Exit Program", NL
M4Len       EQU     $-M4
        
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
   ; Print the menu
   mov   rax, 1
   mov   rdi, 1
   mov   rsi, Menu
   mov   rdx, MenuLen
   syscall

   ; Get the user input choice
   mov   rax, 0
   mov   rdi, 0
   mov   rsi, Input
   mov   rdx, 1
   syscall

   ; exit if the user presses enter without a menu choice
   cmp   byte [Input], NL
   je    Exit

Menu1:
   ; if the user doesn't enter 1, jump to menu2
   ; otherwise load the M1 and M1Len into rsi and rdx, the jump to PrintSelection
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
   ; Load the values for rax and rdi to print to the console
   ; rsi and rdx were set by the previous Menu1~4 sections.
   mov   rax, 1
   mov   rdi, 1
   syscall

   ; print 2 newline characters NewLine = NL,NL
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