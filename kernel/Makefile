CC32=i386-elf-gcc
CXX32=i386-elf-g++
LD32=i386-elf-ld
ASM=nasm

BINDIR=../bin/
SOURCEDIR=src/
ASMSOURCEFILES=$(wildcard *.asm)
SOURCEFILES=$(wildcard $(SOURCEDIR)*.c)
ASMOBJFILES=$(patsubst %.asm,$(BINDIR)%.asm.kernel.o,$(ASMSOURCEFILES))
OBJFILES=$(subst $(SOURCEDIR),$(BINDIR),$(SOURCEFILES:.c=.c.kernel.o))
STDDEF_H=$(SOURCEDIR)stddef.h
KERNELFILE=ooxk

CFLAGS32=-m32 -fno-PIC -Wall -Wextra -std=c11 -ffreestanding -include"$(STDDEF_H)"
CXXFLAGS32=-m32 -Wall -fno-pic -Wextra -std=c++11 -ffreestanding -include"$(STDDEF_H)"
LDFLAGS32=--oformat binary -e entry
ASMFLAGS=-f elf

.PHONY: all build clean

all:
	@echo Building kernel...
	make build
	@echo Done.

build: $(BINDIR)$(KERNELFILE)

clean:
	@echo Cleaning...
	rm -f $(OBJFILES) $(ASMOBJFILES) $(BINDIR)$(KERNELFILE)
	@echo Done.

$(BINDIR)$(KERNELFILE): $(ASMOBJFILES) $(OBJFILES) 
	@echo Linking...
	$(LD32) -o $@ $^ $(LDFLAGS32) 
	
$(BINDIR)%.asm.kernel.o: %.asm
	@echo Assembling $<...
	$(ASM) $(ASMFLAGS) -o $@ $<

$(BINDIR)%.c.kernel.o: $(SOURCEDIR)%.c
	@echo Compiling $<...
	$(CXX32) $(CXXFLAGS32) -c -o $@ $<