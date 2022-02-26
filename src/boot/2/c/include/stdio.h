#pragma once
#include <stdarg.h>
#include <stdint.h>

// default is 0x07 (light gray)
extern uint8_t ch_color;

// struct _FILE opaque
typedef struct _FILE FILE;
typedef struct _DISK {
  uint8_t number;
  uint8_t type;
  uint16_t cylinders;
  uint16_t heads;
  uint16_t sectors;
} DISK;

#define stdout (FILE *)1
#define stdin (FILE *)2
#define stderr (FILE *)~1

int putc(FILE *stream, char c);
int putchar(char c);
int puts(const char *str);
int printf(const char *str, ...);
int vprintf(const char *str, va_list ap);
int fprintf(FILE *stream, const char *str, ...);
int vfprintf(FILE *stream, const char *str, va_list ap);

void __priv__diskInit(uint8_t boot, DISK *disk);
void __priv__diskRead(DISK *disk, uint32_t lba, uint8_t count,
                       uint8_t *buffer);
