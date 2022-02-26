#define _BAREMETAL_ 1

#include <conio.h>
#include <logging.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

extern int _cstart(uint8_t drive) {
  plog(INFO_STREAM, "Successfully loaded second-stage bootloader\r\n");

  uint8_t type;
  uint16_t cylinders, heads, sectors;
  _get_drive_info(drive, &type, &cylinders, &heads, &sectors);

  plog(INFO_STREAM, "Drive %hhu: TYPE 0x%hhX CYL %hu, HD %hu, SEC %hu\r\n",
       type, drive, cylinders, heads, sectors);

  return 0;
}
