#pragma once
// Partial implementation of stdio.h for 16-bit x86
#include "./stdarg.h"

typedef struct _FILE FILE; // TODO: implement FILE

// TODO: implement file descriptors
#define stdin (FILE *)1
#define stdout (FILE *)2
#define stderr (FILE *)3

_extern int putc(int c, FILE *stream); // stream is ignored
_extern int putchar(int c);
_extern int puts(const char *s);
_extern int printf(const char *format, ...);
_extern int fprintf(FILE *stream, const char *format, ...);
_extern int vprintf(const char *format, va_list args);
_extern int vfprintf(FILE *stream, const char *format, va_list args);
