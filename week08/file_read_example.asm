; Keenan Knaur, CIT-344


; NOTE: Based on examples from Ed Jorgensen's Book "x86-64 Assembly Language
; Programming with Ubuntu"

; Compile -> Link -> Execute Commands
; assembler command:    yasm -felf64 -gdwarf2 file_read_example.asm -l file_read_example.lst
; linker command:       ld -g -o file_read_example file_read_example.o
; execute command:      ./file_read_example

section .data ;=================================================================

; Constants for program exit
EXIT_SUCCESS   equ   0    ; successful program execution
SYS_exit       equ   60   ; call code for termination

; Constants for writing
STDOUT         equ   1  ; The standard output code (1 is for the console)
SYS_write      equ   1  ; Call code for the write system service

; Constants for reading
STDIN          equ   0     ; The standard input code (0 is for the keyboard)
SYS_read       equ   0     ; Call code for the read system service

; Constants for File Open system call
SYS_open       equ   2           ; System call code 2 for file open

; NOTE: The following values are defined in Octal (base 8)
O_RDONLY       equ   000000q     ; file access mode flag for read only open
O_WRONLY       equ   000001q     ; file access mode flag for write only open
O_RDWR         equ   000002q     ; file access mode flag for read / write open

; Constants for File Open/Create system call
SYS_creat      equ   85          ; System call code 85 for file open/create

O_CREAT        equ   0x40
O_TRUNC        equ   0x200
O_APPEND       equ   0x400

S_IRUSR        equ   00400q      ; user read permission
S_IWUSR        equ   00200q      ; user write permission
S_IXUSR        equ   00100q      ; user execute permission

; Constants for strings
LF             equ   10
NULL           equ   0

; Other Constants
BUFFER_SIZE    equ   500

; Variables
fileName       db    "input.txt", NULL
fileDesc       dq    0
fileCharsRead  dq    0

; Error messages
errMsgOpen     db    "Error opening the file.", LF, NULL
errMsgOpenLen  equ    $-errMsgOpen

errMsgRead     db    "Error reading from the file.", LF, NULL
errMsgReadLen  equ    $-errMsgRead


;===============================================================================

section .bss ;==================================================================

; Buffer of bytes, each byte will hold a character value read from the file.
readBuffer resb BUFFER_SIZE   ; buffer for reading the data

section .text ;=================================================================

global _start

_start:

openInputFile:
   ; Instructions to open a file and get the file descriptor
   mov   rax, SYS_open
   mov   rdi, fileName
   mov   rsi, O_RDONLY
   syscall

   cmp   rax, 0                  ; check to see if the file was opened successfully
   jl    errorOnOpen             ; jump to the error message if error

   mov   qword [fileDesc], rax   ; save file descriptor for later if success

readFile:
   ; Instructions to read data from the file.
   mov   rax, SYS_read
   mov   rdi, qword [fileDesc]
   mov   rsi, readBuffer
   mov   rdx, BUFFER_SIZE
   syscall

   cmp   rax, 0                  ; check to see if file read was successful
   jl    errorOnRead

   ; NOTE: at this point rax holds the number of characters read


printBuffer:
   mov   qword [fileCharsRead], rax

   mov  rax, SYS_write
   mov  rdi, STDOUT
   mov  rsi, readBuffer
   mov  rdx, qword [fileCharsRead]
   syscall
   jmp exit
  
errorOnOpen:
   ; print the error message and exit   
   mov  rax, SYS_write
   mov  rdi, STDOUT
   mov  rsi, errMsgOpen
   mov  rdx, errMsgOpenLen
   syscall
   
   jmp exit

errorOnRead:
   ; print the error message and exit   
   mov  rax, SYS_write
   mov  rdi, STDOUT
   mov  rsi, errMsgRead
   mov  rdx, errMsgReadLen
   syscall
   
   jmp exit

exit:
   mov   rax, SYS_exit
   mov   rdi, EXIT_SUCCESS
   syscall
;===============================================================================