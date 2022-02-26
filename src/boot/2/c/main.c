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
  _get_drive_info(drive, &type, &cylinders, &sectors, &heads);

  plog(INFO_STREAM,
       "Drive %hhu:\r\n        Type: 0x%s%hhX\r\n        Cylinders: %hu\r\n    "
       "    Heads: "
       "%hu\r\n        Sectors: %hu\r\n",
       drive, type < 0x10 ? "0" : "", type, cylinders, heads, sectors);

  return 0;
}
