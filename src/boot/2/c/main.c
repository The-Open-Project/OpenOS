#define _BAREMETAL_ 1

#include <conio.h>
#include <logging.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

static uint8_t *_randomMem = (uint8_t *)0x100000;

extern int _cstart(uint8_t drive) {
  plog(INFO_STREAM, "Successfully loaded second-stage bootloader\r\n");

  DISK disk;
  __priv__diskInit(drive, &disk);
  __priv__diskRead(&disk, 0, 1, _randomMem);

  printBuf(_randomMem, 512);

  return 0;
}
