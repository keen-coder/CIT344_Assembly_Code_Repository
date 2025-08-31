; Author:	Daniel Yoas
; Program:	String Length
; Date:		9/5

LF:		EQU	0x0A
NULL:		EQU	0x00


section	.data

string:		db	"This String is Long", NULL
stringprn:	db	" ", LF, NULL

exitstr:	db	"Program finished successfully", LF, NULL
exitstrlen:	EQU	31

section	.bss


section .text
global	_start

;==============================================
;Calculate the string length and return in RAX
;Maximum length of string is used.
;==============================================
strnlen:

	pushf

	mov	rax, rdi	; Use rax to walk for length

strnlenNext:
	cmp	byte [rax], NULL ; Look for the end of the string
	je	strnlenRet

	inc	rax
	dec	rsi
	jz	strnlenRet	; Return if maximum length is found

	jmp	strnlenNext

strnlenRet:
	sub	rax, rdi	; rax = rax - rdi ; aka string length

	popf
	ret

;==============================================
;Calculate the string length and return in RAX
;
;==============================================
strlen:

	push	rcx
	pushf

	mov	rcx, 0

strlenNext:
	cmp	byte [rdi], NULL ; Look for the end of the string
	je	strlenRet

	add	rcx, 1		; inc rcx
	inc	rdi
	jmp	strlenNext

strlenRet:
	mov	rax, rcx
	popf
	pop	rcx
	ret

_start:

	mov	rdi, string	; quad strlen(char *str, int maxlen)
	;mov	rsi, 9
	call	strlen

	add	rax, 0x30
	mov	byte [stringprn], al

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, stringprn
	mov	rdx, 2
	syscall

exit:
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, exitstr
	mov	rdx, exitstrlen
	syscall

	mov	rax, 60
	mov	rdi, 0
	syscall

