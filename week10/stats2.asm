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
min   resq 1
med1   resq 1
med2   resq 1
max   resq 1
;===============================================================================


section .text ;=================================================================

global _start

_start: 

   ; calling the function
   
   ; stats2(arr, len, min, med1, med2, max, sum, ave);
   mov   rdi, arr             ; 1st arg, addr of arr
   mov   esi, dword [len]     ; 2nd arg, value of len
   mov   rdx, min             ; 3rd arg, addr of min
   mov   rcx, med1            ; 4th arg, addr of med1
   mov   r8, med2             ; 5th arg, add of med2
   mov   r9, max              ; 6th arg, add of max
   
   push  ave                  ; 8th arg, add of ave
   push  sum                  ; 7th arg, add of sum
   
   call  stats2

   add   rsp, 16              ; clear passed arguments

exit:
   mov   rax, SYS_exit
   mov   rdi, EXIT_SUCCESS
   syscall

; FUNCTION DEFINITIONS

;  stats2(arr, len, min, med1, med2, max, sum, ave):

;  Arguments:     
;     arr:  address     -> rdi, array of unsigned integers
;     len:  dword value -> esi, length of the array as an unsigned integer
;     min:  address     -> rdx, the minimum of the values
;     med1: address     -> rcx, first median value
;     med2: address     -> r8,  second median value (if exists)
;     max:  address     -> r9,  maximum value
;     sum:  address     -> stack (rbp+16), will hold the sum result
;     ave:  address     -> stack (rbp+24), will hold the average result

global stats2
stats2:
   push  rbp            ; prologue
   mov   rbp, rsp       
   push  r12

; -----
; Get min and max.
   
   ; NOTE: When call-by-reference arguments are passed on the stack, two steps 
   ;  are required to return the value.
   ;  1. Get the address from the stack.
   ;  2. Use that address to return the value.
   mov   eax, dword [rdi]  ; get the minimum
   mov   dword [rdx], eax  ; return the minimum

   mov   r12, rsi                ; get len
   dec   r12                     ; set len-1
   mov   eax, dword [rdi+r12*4]  ; get max
   mov   dword [r9], eax         ; return max

; -----
; Get medians
   mov   rax, rsi   
   mov   rdx, 0
   mov   r12, 2
   div   r12                     ; rax = length/2

   cmp   rdx, 0                  ; even or odd length?
   je    evenLength




   mov   r12d, dword [rdi+rax*4] ; get arr[len/2]
   mov   dword [rcx], r12d       ; return med1
   mov   dword [r8], r12d        ; return med2
   jmp   medDone

evenLength:
   mov   r12d, dword [rdi+rax*4] ; get arr[len/2]
   mov   dword [r8], r12d        ; return med2

   dec   rax
   mov   r12d, dword [rdi+rax*4] ; get arr[len/2-1]
   mov   dword [rcx], r12d       ; return med1

medDone:

; -----
; Find sum
   mov   r12, 0                  ; counter/index
   mov   rax, 0                  ; running sum

sumLoop:
   add   eax, dword [rdi+r12*4]  ; sum += arr[i]
   inc   r12
   cmp   r12, rsi
   jl    sumLoop

   mov   r12, qword [rbp+16]     ; get sum addr
   mov   dword [r12], eax        ; return sum

; -----
; Calculate average.
   cdq
   idiv     rsi                  ; average = sum/len
   mov      r12, qword [rbp+24]  ; get ave addr
   mov      dword [r12], eax     ; return ave

   pop      r12                  ; epilogue
   pop      rbp
   ret      






























;===============================================================================