; Keenan Knaur, CIT-344
; Example from x86-64 Assembly Language textbook
; This is not a fully formed example.  It only demonstrates the basics of using
; local variables.

; In this example, we have an array of 100 double word (dword, 4 bytes) elements.
; We also have 4 bytes for the count variable so in total 404 bytes are needed
; to store all of the local data. NOTE: The order in which we store the local
; data is arbitrary.

; -----------------------------------------
; Example function
global expFunc
expFunc:
	; prologue
	push rbp 		; preserve the old value of rbp
	mov rbp, rsp	; save the current stack pointer location to rbp
					; this is the beginning (base) of our stack frame
	
	sub rsp, 404 	; allocate space for local variables, 400 bytes for an array
					; and 4 bytes for a single value
	
	push rbx		; preserve register rbx
	push r12		; preserver register r12
	;---------------------------------------------------------------------------

	
	mov dword [rbp-404], 0	; Initialize count local variable to 0. Count is going
							; to be at frame pointer (rbp) minus 404

	;---------------------------------------------------------------------------
	; To increment the count variable you would do something like the following
	; again this is just an example of how to access that local variable
	inc dword[rbp-404]		; count++

	;---------------------------------------------------------------------------
	; Loop example to initialize the local array to all 0's.
	
	; sets up a tmpArr register
	lea rbx, dword [rbp-400] 	; load the address of the array starting at
								; rbp-400 into the rbx register
								; lea means (load effective address)
								; lea here is required because the following are
								; NOT VALID syntax:
								; 	mov rbx, (rbp-400)
								; 	mov rbx, rbp-400
								; DOES NOT load the address, but loads the value:
								;	mov rbx, dword[rbp-400]
								; When wanting to use the address with the frame
								; reference math...you must use the lea instruction.
	
	mov r12, 0 	; r12 will hold the current index of our array

	zeroLoop:
		mov dword [rbx+r12*4], 0 ; tmpArr[index]=0
		inc r12
		cmp r12, 100
		jl zeroLoop

	;---------------------------------------------------------------------------
	; epilogue
	pop r12			; restore the r12 register value from the stack
	pop rbx			; restore the rbx register value from the stack
	
	mov rsp, rbp 	; clear the local variable space by simply adjusting the stack pointer
					; no need to do repeated pops to clean up the stack
	
	pop rbp			; restote the value of rbp register fromt he stack
					; this is necessary if we were to be jumping back to a
					; previous function call. this would restore the base frame
					; address value for the previous function.
	
	ret				; At this point we SHOULD be back to the return address
					; on the stack so the ret instruction will pop that address
					; into the rip register and then the program will continue
					; from that return address.