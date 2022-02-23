BOOTLOADERDIR := boot/
KERNELDIR := kernel/

.PHONY: all clean

all:
	make -C $(BOOTLOADERDIR)
	make -C $(KERNELDIR)

clean:
	make -C $(BOOTLOADERDIR) clean
	make -C $(KERNELDIR) clean
