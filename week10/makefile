# Linux Filename: makefile

# Checks if the FILE variable has been set from the command-line.

ifndef FILE
$(error ERROR: FILE variable not set! USAGE: make FILE=asm_file_name)
endif

all: 
	yasm -f elf64 -g dwarf2 $(FILE).asm -l $(FILE).lst
	ld -g -o $(FILE) $(FILE).o

debug:
	ddd $(FILE)

run:
	./$(FILE)
	
clean:
	@echo
	@echo Deleting the following files:
	@ls | grep -v ".asm" | grep -v makefile
	@ls | grep -v ".asm" | grep -v makefile | xargs --no-run-if-empty rm
	@echo Files Deleted!
	@echo
