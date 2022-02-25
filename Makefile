SRCDIR := src/
TOOLSDIR := tools/
BINDIR := bin/
OBJDIR := obj/

SYSNAME := openos
VERSTRING := 0.0.1
DEVSTAGE := a

IMGFILE := $(SYSNAME)-$(VERSTRING)$(DEVSTAGE).img

FSBOOTFILE := bootx
SSBOOTFILE := xloader
KERNELFILE := xsystem

.PHONY: all system tools clean obj-check bin-check

all: system tools

system: obj-check bin-check
	make -C $(SRCDIR)

	dd if=/dev/zero of=$(BINDIR)$(IMGFILE) bs=512 count=2880

	mkfs.vfat -F 12 $(BINDIR)$(IMGFILE)

	dd if=$(BINDIR)$(FSBOOTFILE) of=$(BINDIR)$(IMGFILE) count=1 conv=notrunc

	mcopy -i $(BINDIR)$(IMGFILE) $(BINDIR)$(SSBOOTFILE) "::$(SSBOOTFILE)"
	mcopy -i $(BINDIR)$(IMGFILE) $(BINDIR)$(KERNELFILE) "::$(KERNELFILE)"

tools: obj-check bin-check
	make -C $(TOOLSDIR)

clean:
	rm -rf $(BINDIR)*
	rm -rf $(OBJDIR)*

obj-check:
	mkdir -p obj/

bin-check:
	mkdir -p bin/
