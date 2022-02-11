ASM=nasm
BINDIR=../bin/
SOURCEFILE=boot.asm
IMAGEFILE=bootx
ASMFLAGS=-fbin

.PHONY: all build clean

all:
	@echo Building first-stage bootloader...
	make build
	@echo Done.

build: $(BINDIR)$(IMAGEFILE)

clean:
	@echo Cleaning...
	rm -rf $(BINDIR)$(IMAGEFILE) $(OBJFILES)
	@echo Done.

$(BINDIR)$(IMAGEFILE): $(SOURCEFILE)
	@echo Assembling $<...
	$(ASM) $(ASMFLAGS) -o $@ $<

