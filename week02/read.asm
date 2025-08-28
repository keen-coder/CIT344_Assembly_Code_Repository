; Keenan Knaur
; Simple program to read three words from the console.

section .data
LF			 	EQU 0x0A 	; 10 in decimal
NULL		 	EQU 0x00 	; 0 in decimal

SYS_write	 	EQU 1		; Call code for the SYS_write system call
STDOUT		 	EQU 1		; Code to indicate the standard outout (console)

SYS_read		EQU 0		; Call code of the SYS_read system Call
STDIN			EQU 0 		; Code to indicate the standard input (keyboard)

SYS_exit	 	EQU 60		; Call code for the SYS_exit system call
EXIT_SUCCESS	EQU 0		; 0 Code for successful termination (any other value means
							; some error occured which caused the exit.


; Static declarations are saved to disk and initialized at process start
ExitStatement:		db	"Program Completed Successfully!", LF, NULL
ExitStatementLen:	EQU	$-ExitStatement

Prompt:				db	"Please type in a word: ", NULL
PromptLen:			EQU	$-Prompt

Response:			db	"You Typed ", NULL
ResponseLen:		EQU	$-Response


Input:				db	"                ", NULL
InputLen:			EQU	$-Input
InputSize:			dq	0

section .bss
; Undefined varibles until process execution go here

section .text
global _start
_start:

	mov	rcx, 3	; Put value 3 into the RCX register

next:
	push rcx	; Push the value of the rcx register onto the top of 
				; stack memory

	mov	rax, SYS_write
	mov	rdi, STDOUT
	mov	rsi, Prompt
	mov	rdx, PromptLen
	syscall

	mov	rax, SYS_read
	mov	rdi, STDIN
	mov	rsi, Input
	mov	rdx, InputLen
	syscall
	
	mov	qword [InputSize], rax

	mov	rax, SYS_write
	mov	rdi, STDOUT
	mov	rsi, Response
	mov	rdx, ResponseLen
	syscall

	mov	rax, SYS_write
	mov	rdi, STDOUT
	mov	rsi, Input
	mov	rdx, qword [InputSize]
	syscall

	pop	rcx	 ; Pop the value at the top of the stack into rcx register
			 ; At this point it SHOULD be the value we pushed earlier
			 ; When pushing and popping to / from the stack YOU need to keep track
			 ; of what is currently at the top of the stack so you are popping the
			 ; the right data. (Very important for functions later on)
	
	dec	rcx  ; Decrement the value in the rcx register (3 to 2, 2 to 1, etc...)
	jnz	next ; Jump to the 'next'
	
exit:
	mov	rax, SYS_write
	mov	rdi, STDOUT
	mov	rsi, ExitStatement
	mov	rdx, ExitStatementLen
	syscall				; Print out an exit statement

	mov	rax, SYS_exit
	mov	rdi, EXIT_SUCCESS
	syscall				; Terminate process

