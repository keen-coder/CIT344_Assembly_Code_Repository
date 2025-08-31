; Keenan Knaur, CIT-344
; This file shows examples of how to use the 'mov' instruction.

; NOTE: Based on examples from Ed Jorgensen's Book "x86-64 Assembly Language
; Programming with Ubuntu"

; Compile -> Link -> Execute Commands
; assembler command:    yasm -felf64 -gdwarf2 mov_examples.asm -l mov_examples.lst
; linker command:       ld -g -o mov_examples mov_examples.o
; execute command:      ./mov_examples

section .data ;=================================================================

; Constants for program exit
EXIT_SUCCESS   equ   0    ; successful program execution
SYS_exit       equ   60   ; call code for termination

; Variables defined for examples
bVar db 10
dVar dd 0

dValue   dd    0
bNum     db    42
wNum     dw    5000
dNum     dd    73000
qNum     dq    73000000
bAns     db    0
wAns     dw    0
dAns     dd    0
qAns     dq    0

;================================================================================

; section .bss omitted

section .text ;=================================================================

global _start

_start:
   ; EXAMPLE 01: Simple Mov Operations------------------------------------------
   mov   byte [bVar], 42      ; immediate value -> memory
   mov   ax, 42               ; immediate value -> register
   mov   cl, byte [bVar]      ; memory -> register
   mov   dword [dVar], eax    ; register -> memory
   mov   bx, ax               ; register -> register
   ;----------------------------------------------------------------------------

   ; EXAMPLE 02: Moving Data from Memory to Memory------------------------------
   ; Note you cannot just move from variable to variable (memory to memory),
   ; you need to copy the source data into a register first and then from the
   ; register to the destination.  It is a 2 step process.
   
   ; See data section above for variable declarations

   ; We will perform the following operations in this example:
   ; dValue = 27
   ; bAns = bNum
   ; wAns = wNum
   ; dAns = dNum
   ; qAns = qNum

   ; dValue = 27
   mov   dword [dValue], 27   ; move immediate value 27 into dValue

   ; bAns = bNum
   mov   al, byte [bNum]      ; move the value from bNum into the al register
   mov   byte [bAns], al      ; move the value from al register to bAns

   ; wAns = wNum
   mov   ax, word [wNum]      ; move the value from wNum into ax register   
   mov   word [wAns], ax      ; move the value from ax register to wAns

   ; dAns = dNum
   mov   eax, dword [dNum]    ; move the value from dNum into eax register
   mov   dword [dAns], eax    ; move the value from eax register to dAns

   ; qAns = qNum
   mov   rax, qword [qNum]    ; move the value from qNum into rax register
   mov   qword [qAns], rax    ; move the value from rax register into qAns\
   ;----------------------------------------------------------------------------

   ;EXAMPLE 03: Demonstration of Note 3 on Slide 6------------------------------
   ; The following demonstrates note 3 on slide 6: "if destination operand and 
   ; source operand are both double-word size (32-bits), the upper-order portion
   ; of the quadword register is set to 0."

   ; Register table for the rax and rcx registers included for reference.
   ; +------------------------------------------------------+
   ; |   64-bits   |   32-bits   |   16-bits   |   8-bits   |
   ; +------------------------------------------------------+ 
   ; |     rax     |     eax     |     ax      |     al     | 
   ; +------------------------------------------------------+
   ; |     rcx     |     ecx     |     cx      |     cl     | 
   ; +------------------------------------------------------+

   ; assign 100 to the 32-bit eax register (lower 32 bits of rax)
   mov   eax, 100    ; eax = 0x00000064

   ; rcx's binary value is set to all 1's
   mov   rcx, -1     ; rcx = 0xffffffffffffffff

   ; instead of keeping the upper portion of 1's, all the upper 1's are replaced
   ; with 0's due to the rule of note 3
   ; so ecx = 0x00000064 instead of 0xffffffff00000064
   mov   ecx, eax    ; ecx = 0x00000064
   ;----------------------------------------------------------------------------

   ; EXAMPLE 04: Address vs Value-----------------------------------------------
   ; This example shows how to get the value of a variable vs the address of a 
   ; variable.
   mov   rax, qword [qNum]    ; move the VALUE of qNum into rax register
   mov   rax, qNum            ; move the ADDRESS of qNum into rax register
   ;----------------------------------------------------------------------------

   ; EXAMPLE 05: Using lea Instruction------------------------------------------
   ; Shows how to use the lea instruction to obtain the address of a variable;
   lea   rcx, byte [bVar]     ; move the ADDRESS of bVar into rcx register
   lea   rsi, dword [dNum]    ; move the ADDRESS of dNum into rsi register

exit:
   mov   rax, SYS_exit
   mov   rdi, EXIT_SUCCESS
   syscall
;===============================================================================