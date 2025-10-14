; Keenan Knaur, CIT-344
;-------------------------------------------------------------------------------

section .data ;-----------------------------------------------------------------

EXIT_SUCCESS   equ   0     ; successful program execution
SYS_exit       equ   60    ; call code for termination

ARR_SIZE          equ   5   
DATA_TYPE_SIZE    equ   4     ; this represents 4 bytes for the integers in the array
;-------------------------------------------------------------------------------

section .bss ;------------------------------------------------------------------

numbers        resd  5     ; create space for a 5 element 4-byte (integer) array
sum            resd  1     ; create space for a single 4-byte value 

;-------------------------------------------------------------------------------

section .text ;-----------------------------------------------------------------

global _start
_start:

   ; assign values to each position in the array
   mov   dword [ numbers + (0 * DATA_TYPE_SIZE) ], 10
   mov   dword [ numbers + (1 * DATA_TYPE_SIZE) ], 20
   mov   dword [ numbers + (2 * DATA_TYPE_SIZE) ], 30
   mov   dword [ numbers + (3 * DATA_TYPE_SIZE) ], 40
   mov   dword [ numbers + (4 * DATA_TYPE_SIZE) ], 50

   mov   rax, numbers      ; move the base address of the array into the A register
   mov   rbx, 0            ; use the B register to hold the sum
   mov   rsi, 0            ; use the RSI register for the current index

sumLoop:
   add   ebx, dword[ rax + (rsi * DATA_TYPE_SIZE) ]   ; get the next value in the array
   inc   rsi                                       ; increment the index
   cmp   rsi, ARR_SIZE                             ; see if we continue
   jl    sumLoop

   mov   dword [sum], ebx                          ; store the sum for later use

exit:
   mov   rax, SYS_exit
   mov   rdi, EXIT_SUCCESS
   syscall