#pragma once
#include <stdint.h>
#include <stdarg.h>

// default is 0x07 (light gray)
extern uint8_t ch_color;

// struct _FILE opaque
typedef struct _FILE FILE;

#define stdout (FILE*)1
#define stdin (FILE*)2
#define stderr (FILE*)~1

int putc(FILE * stream, char c);
int putchar(char c);
int puts(const char *str);
int printf(const char *str, ...);
int vprintf(const char *str, va_list ap);
int fprintf(FILE *stream, const char *str, ...);
int vfprintf(FILE *stream, const char *str, va_list ap);
