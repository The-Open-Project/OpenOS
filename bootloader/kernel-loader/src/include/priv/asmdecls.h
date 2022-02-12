#pragma once
#include "DO-NOT-TOUCH"
#include "../stdint.h"

_extern uint16_t reset_disk(uint8_t disk);
_extern uint16_t read_disk_params(uint8_t drive, uint8_t *drivetype, uint16_t *cylinders, uint16_t *heads, uint16_t *sectors);
_extern uint16_t read_disk_sectors(uint8_t drive, uint16_t cylinder, uint16_t head, uint16_t sector, uint8_t *buffer); 
_extern int print_char(char c);
