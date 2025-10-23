; Keenan Knaur, CIT-344

; Demonstrates how to use a leaf function in assembly. 

; NOTE: Based on examples from Ed Jorgensen's Book "x86-64 Assembly Language
; Programming with Ubuntu"

section .data ;=================================================================

; Constants for program exit
EXIT_SUCCESS   equ   0    ; successful program execution
SYS_exit       equ   60   ; call code for termination

arr   db 10, 20, 30, 40, 50
len   dw 5

;===============================================================================

section .bss  ;=================================================================

sum   resq 1
ave   resq 1

;===============================================================================


section .text ;=================================================================

global _start

_start: 

   ; calling the function

   ; stats1(arr, len, sum, ave);
   mov   rdi, arr             ; 1st arg, addr of arr
   mov   esi, dword [len]     ; 2nd arg, value of len
   mov   rdx, sum             ; 3rd arg, addr of sum
   mov   rcx, ave             ; 4th arg, addr of ave
   call  stats1

exit:
   mov   rax, SYS_exit
   mov   rdi, EXIT_SUCCESS
   syscall

; FUNCTION DEFINITIONS

;  stats1(arr, len, sum, ave): Simple function to find and return the sum and 
;     average of an array.

;  Arguments:     
;     arr:  address     -> rdi, array of unsigned integers
;     len:  dword value -> esi, length of the array as an unsigned integer
;     sum:  address     -> rdx, will hold the sum result
;     ave:  address     -> rcx, will hold the average result

global stats1
stats1:
   ; Note: The use of r12 here is arbitrary.  valid register could have been used.
   
   push  r12      ; prologue, r12 is a preserved register so it must be saved 
                  ; on the stack

   mov   r12, 0   ; counter / index value 
   mov   rax, 0   ; will hold the running sum

sumLoop:
   add   eax, dword [rdi+r12*4]  ; sum += arr[i]
   inc   r12
   cmp   r12, rsi
   jl    sumLoop

   mov   dword [rdx], eax          ; return sum

   cdq
   idiv  esi                      ; compute average

   mov   dword [rcx], eax         ; return ave

   pop   r12                     ; epilogue
   ret


;===============================================================================