ASM := nasm

ASMFLAGS := -f bin

OBJDIR := ../../../obj/
BINDIR := ../../../bin/

ASMSRCS := boot.s

EXECFILE := $(BINDIR)bootx

.PHONY: all clean

all: $(EXECFILE)

clean:
	rm $(EXECFILE)

$(EXECFILE): $(ASMSRCS)
	$(ASM) $(ASMFLAGS) -o $@ $<
