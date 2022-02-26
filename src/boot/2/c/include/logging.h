#pragma once

#include "stdio.h"
#include <stdarg.h>
#include <stddef.h>

typedef char **stream_t;
static const stream_t ERROR_STREAM = (const stream_t)-1;
static const stream_t INFO_STREAM = (const stream_t)0;
static const stream_t DEBUG_STREAM = (const stream_t)1;

void plog(stream_t stream, const char *fmt, ...);
void vplog(stream_t stream, const char *fmt, va_list args);
void putstr(const char *str);

static void panic(const char *fmt, ...) {
  va_list args;
  va_start(args, fmt);
  plog(ERROR_STREAM, "A panic occurred. Reason: ");
  vprintf(fmt, args);
  printf("\r\nAborting.\r\n");
  va_end(args);

  while (1) {
    asm volatile("cli; hlt");
  }
}

static void printBuf(const char *buf, size_t len) {
  for (size_t i = 0; i < len; i++) {
    printf("%s%x", i == 0 ? "0" : "", buf[i]);
  }
}
