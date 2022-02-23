ASM := nasm
CC := i686-elf-gcc
CXX := i686-elf-g++
LD := i686-elf-ld

ASMDIR := asm/
CDIR := c/
CXXDIR := cxx/

OBJDIR := ../../obj/
BINDIR := ../../bin/

STDLIBDIR := /usr/lib/gcc/i686-elf/11.1.0/

ASMFLAGS := -f elf
CFLAGS := -Wall -Wextra -ffreestanding -nostdlib -O0
CXXFLAGS := $(CFLAGS) -fno-rtti -fno-exceptions
CPPFLAGS :=
LDFLAGS := -T script.ld -nostdlib -L$(STDLIBDIR) -Map $(OBJDIR)xsystem.map

ASMSRCS = $(wildcard $(ASMDIR)*.s)
CSRCS = $(wildcard $(CDIR)*.c)
CXXSRCS = $(wildcard $(CXXDIR)*.cc)

ASMOBJS = $(subst $(ASMDIR),$(OBJDIR),$(ASMSRCS:.s=.kernel.s.o))
COBJS = $(subst $(CDIR),$(OBJDIR),$(CSRCS:.c=.kernel.c.o))
CXXOBJS = $(subst $(CXXDIR),$(OBJDIR),$(CXXSRCS:.cxx=.kernel.cxx.o))

DEPS := -lgcc

EXECFILE = $(BINDIR)xsystem

.PHONY: all clean

all: $(EXECFILE)

clean:
	rm $(EXECFILE)
	rm $(ASMOBJS) $(COBJS)

$(EXECFILE): $(ASMOBJS) $(COBJS)
	$(LD) $(LDFLAGS) -o $@ $^ $(DEPS)

$(OBJDIR)%.kernel.s.o: $(ASMDIR)%.s
	$(ASM) $(ASMFLAGS) -o $@ $<

$(OBJDIR)%.kernel.c.o: $(CDIR)%.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<

$(OBJDIR)%.kernel.cxx.o: $(CXXDIR)%.cxx
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -o $@ $<
