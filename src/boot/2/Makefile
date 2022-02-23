ASM := nasm
CC := i686-elf-gcc
LD := i686-elf-ld

ASMDIR := asm/
CDIR := c/

OBJDIR := ../../../obj/
BINDIR := ../../../bin/

STDLIBDIR := /usr/lib/gcc/i686-elf/11.1.0/

INCLUDEDIR := $(CDIR)include/

ASMFLAGS := -f elf
CFLAGS := -Wall -Wextra -Wno-unused-parameter -ffreestanding -nostdlib -O0
CPPFLAGS := -I$(INCLUDEDIR)
LDFLAGS := -T script.ld -nostdlib -L$(STDLIBDIR) -Map $(OBJDIR)xloader.map

ASMSRCS = $(wildcard $(ASMDIR)*.s)
CSRCS = $(wildcard $(CDIR)*.c)

ASMOBJS = $(subst $(ASMDIR),$(OBJDIR),$(ASMSRCS:.s=.2.s.o))
COBJS = $(subst $(CDIR),$(OBJDIR),$(CSRCS:.c=.2.c.o))

DEPS := -lgcc

EXECFILE = $(BINDIR)xloader

.PHONY: all clean

all: $(EXECFILE)

clean:
	rm $(EXECFILE)
	rm $(ASMOBJS) $(COBJS)

$(EXECFILE): $(ASMOBJS) $(COBJS)
	$(LD) $(LDFLAGS) -o $@ $^ $(DEPS)

$(OBJDIR)%.2.s.o: $(ASMDIR)%.s
	$(ASM) $(ASMFLAGS) -o $@ $<

$(OBJDIR)%.2.c.o: $(CDIR)%.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<
