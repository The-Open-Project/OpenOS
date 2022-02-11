CC16=ia16-elf-gcc
CXX16=ia16-elf-g++
LD16=ia16-elf-ld
ASM=nasm

SOURCEDIR=src/
BINDIR=../../bin/
LOADFILES=$(wildcard *.asm)
LOADOBJFILES=$(patsubst %.asm,$(BINDIR)%.asm.ssboot.o,$(LOADFILES))
SOURCEFILES=$(wildcard $(SOURCEDIR)*.c)
HEADERFILES=$(wildcard $(SOURCEDIR)*.h)
STDDEF_H=$(SOURCEDIR)stddef.h
OBJFILES=$(subst $(SOURCEDIR),$(BINDIR),$(SOURCEFILES:.c=.c.ssboot.o))
IMAGEFILE=xloader

CFLAGS16=-Wall -Wextra -std=c11 -ffreestanding -include"$(STDDEF_H)"
CXXFLAGS16=-Wall -Wextra -std=c++11 -ffreestanding -include"$(STDDEF_H)"
LDFLAGS16=-Ttext=0x1000 --oformat binary -e entry
ASMFLAGS=-f elf

.PHONY: all build clean

all:
	@echo Building second-stage bootloader...
	make build
	@echo Done.

build: $(BINDIR)$(IMAGEFILE)

clean:
	@echo Cleaning...
	rm -rf $(BINDIR)$(IMAGEFILE) $(OBJFILES) $(LOADOBJFILES)
	@echo Done.

$(BINDIR)$(IMAGEFILE): $(LOADOBJFILES) $(OBJFILES) 
	@echo Linking...
	$(LD16) -o $@ $^ $(LDFLAGS16)

$(BINDIR)%.c.ssboot.o: $(SOURCEDIR)%.c
	@echo Compiling $<...
	$(CC16) $(CFLAGS16) -c -o $@ $<

$(BINDIR)%.asm.ssboot.o: %.asm
	@echo Assembling $<...
	$(ASM) $(ASMFLAGS) -o $@ $<

