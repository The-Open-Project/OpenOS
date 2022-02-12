#pragma once
#include <stdint.h>
#include <stdbool.h>

typedef struct _DISK DISK;

_extern bool diskinit(DISK *disk, uint8_t drive);
_extern void lbatochs(DISK *disk, uint32_t lba, uint16_t *cylinder, uint16_t *head, uint16_t *sector);
_extern int readsectors(DISK *disk, uint32_t lba, uint8_t sectors, uint8_t *buffer);
_extern int resetdisk(DISK *disk);
_extern int readdiskparams(uint8_t drive, uint8_t *drivetype, uint16_t *cylinders, uint16_t *heads, uint16_t *sectors);
