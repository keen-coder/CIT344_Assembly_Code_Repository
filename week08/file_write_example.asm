; Keenan Knaur, CIT-344


; NOTE: Based on examples from Ed Jorgensen's Book "x86-64 Assembly Language
; Programming with Ubuntu"


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

O_RDONLY       equ   000000q     ; file access mode flag for read only open
O_WRONLY       equ   000001q     ; file access mode flag for write only open
O_RDWR         equ   000002q     ; file access mode flag for read / write open

; Contants for File close
SYS_close      equ   3

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
BUFFER_SIZE    equ   255

; Variables
fileName       db    "output.txt", NULL
fileDesc       dq    0
fileCharsRead  dq    0

textToWrite    db    "hello world! writing to my first file in assembly!", LF, NULL
textToWriteLen equ   $-textToWrite-1

; Status Messages
writeDone      db    "Write Completed.", LF, NULL
writeDoneLen   equ   $-writeDone

errMsgOpen     db    "Error opening the file.", LF, NULL
errMsgOpenLen  equ   $-errMsgOpen

errMsgWrite     db   "Error writing to file.", LF, NULL
errMsgWriteLen  equ  $-errMsgWrite
;===============================================================================

section .text ;=================================================================

global _start

_start:

openInputFile:
   ; Instructions to open a file or create it if not already created
   mov   rax, SYS_creat
   mov   rdi, fileName
   mov   rsi, S_IRUSR | S_IWUSR  ; | is the OR operator, you can | values together for the flags
   syscall

   cmp   rax, 0   
   jl    errorOnOpen

   mov qword [fileDesc], rax     ; save the file descriptor


writeToFile:
   mov   rax, SYS_write
   mov   rdi, qword [fileDesc]
   mov   rsi, textToWrite
   mov   rdx, textToWriteLen
   syscall
   
   cmp   rax, 0
   jl    errorOnWrite

closeFile:
   mov   rax, SYS_close
   mov   rdi, qword [fileDesc]
   syscall
   
printSuccess:
   mov  rax, SYS_write
   mov  rdi, STDOUT
   mov  rsi, writeDone
   mov  rdx, writeDoneLen
   syscall
   
   jmp  exit
  
errorOnOpen:
   ; print the error message and exit   
   mov  rax, SYS_write
   mov  rdi, STDOUT
   mov  rsi, errMsgOpen
   mov  rdx, errMsgOpenLen
   syscall
   
   jmp exit

errorOnWrite:
   ; print the error message and exit   
   mov  rax, SYS_write
   mov  rdi, STDOUT
   mov  rsi, errMsgWrite
   mov  rdx, errMsgWriteLen
   syscall
   
   jmp exit

exit:
   mov   rax, SYS_exit
   mov   rdi, EXIT_SUCCESS
   syscall
;===============================================================================