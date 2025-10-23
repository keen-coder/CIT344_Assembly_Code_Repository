; Keenan Knaur, CIT-344
; Program to show a simple function to print strings and read data from the
; console. This program does not use advanced features of functions such as:
; passing things on the stack, using local variables, having to deal with setting
; up and managing the stack frame, worrying about the rsp register, and using
; preserved registers.

section .data ;=================================================================

; Constants for sys_exit()
EXIT_SUCCESS    equ     0    ; successful program execution
SYS_EXIT        equ     60   ; call code for termination

; Constants for sys_write()
STDOUT          equ     1  ; The standard output code (1 is for the console)
SYS_WRITE       equ     1  ; Call code for the write system service

; Constants for sys_read()
STDIN           equ     0     ; The standard input code (0 is for the keyboard)
SYS_READ        equ     0     ; Call code for the read system service

; Constants for special characters
NL              equ     10
NULL            equ     0
SPACE			equ		32

str1			db		"I was wondering why the frisbee kept getting bigger and bigger, but then it hit me.", NULL
str1Len			dq		$-str1

strPrompt		db		"Enter a string: ", NULL
strPromptLen	dq		$-strPrompt

BUFFER_LEN		equ		100
charsRead		db		0

newLine			db		NL

section .bss ;==================================================================

strBuffer		resb	BUFFER_LEN

section .text ;=================================================================


global _start
_start:

	; printString(str1, str1Len)
	mov rsi, str1
	mov rdx, qword[str1Len]
	call printString

	; printNewLine()
	call printNewLine
	
	; printString(strPrompt, strPromptLen)
	mov rsi, strPrompt
	mov rdx, qword[strPromptLen]
	call printString

	; readInput(strBuffer, BUFFER_LEN)
	mov rsi, strBuffer
	mov rdx, BUFFER_LEN
	call readInput
	
	;Save the number of charsRead from the previous function call
	mov byte[charsRead], al

	; printString(strBuffer, charsRead)
	mov rsi, strBuffer
	mov dl, byte[charsRead]
	call printString

exit:
	; sys_exit()
	mov rax, SYS_EXIT
	mov rdi, EXIT_SUCCESS
	syscall

; printString(str->rsi, len->rdx) -> void
; ---------------------------------------
; Arguments:
;	str, address		->	rsi:	a string to print
;	len, qword value	->	rdx:	the length of the string

global printString
printString:
	mov rax, SYS_WRITE
	mov rdi, STDOUT
	syscall
	
	ret
	
; printNewLine() -> void
; ----------------------
; Arguments: None
; Return: None	
global printNewLine
printNewLine:
	mov rax, SYS_WRITE
	mov rdi, STDOUT
	mov rsi, newLine
	mov rdx, 1
	syscall
	
	ret

; readInput	(strBuffer->rsi, bufferLen->rdx) -> rax
; ---------------------------------------------
; Arguments:
;	strBuffer, 	address			-> rsi:		the input buffer to store the string
;	bufferLen, 	byte value		-> rdx:		the number of characters to read
;
; Returns:
;	rax:	The number of characters read.
global readInput
readInput:
	mov rax, SYS_READ
	mov rdi, STDIN
    syscall
	
	ret