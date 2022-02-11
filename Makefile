VERSIONNUMBER=0.0.1
DEVSTATE=a

FSBOOTLOADERDIR=bootloader/
SSBOOTLOADERDIR=$(FSBOOTLOADERDIR)kernel-loader/
KERNELDIR=kernel/
BINDIR=bin/
FSBOOTFILE=bootx
SSBOOTFILE=xloader
KERNELFILE=ooxk
IMAGEFILE=openos_$(VERSIONNUMBER)$(DEVSTATE).img

.PHONY: all image kernel ss-bootloader fs-bootloader clean force

all: fs-bootloader ss-bootloader kernel image

fs-bootloader:
	make -C $(FSBOOTLOADERDIR)

ss-bootloader:
	make -C $(SSBOOTLOADERDIR)

kernel:
	make -C $(KERNELDIR)

image: $(IMAGEFILE)

clean:
	@echo Cleaning up...
	rm -rf $(BINDIR)*
	rm -f $(IMAGEFILE)
	@echo Done.

force: ;

$(IMAGEFILE): force
	dd if=/dev/zero of=$@ bs=512 count=2880
	mkfs.vfat -F 12 $@

	dd if=$(BINDIR)$(FSBOOTFILE) of=$@ bs=512 count=1 conv=notrunc
	dd if=$(BINDIR)$(SSBOOTFILE) of=$@ bs=512 count=1 conv=notrunc seek=1

	# Copy kernel
	mcopy -i $@ $(BINDIR)$(KERNELFILE) "::/$(KERNELFILE)"
