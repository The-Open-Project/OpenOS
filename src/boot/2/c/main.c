#define _BAREMETAL_ 1

#include <stdint.h>
#include <logging.h>
#include <stdio.h>
#include <stdlib.h>

extern int _cstart(unsigned char drive)
{
  plog(INFO_STREAM, "Successfully loaded second-stage bootloader\r\n");
  return 0;
}
