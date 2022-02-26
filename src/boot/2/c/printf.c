#include "include/stdio.h"
#include "include/stdlib.h"
#include "include/string.h"
uint8_t ch_color = 0x07;

static unsigned long x_coord = 0;
static unsigned long y_coord = 0;
static unsigned char *const VIDEO_MEMORY = (unsigned char *const)0xB8000;

#define _TABSTOP 8

#define _GETPOS() 2 * ((y_coord * 80) + x_coord)
#define _INCPOS()                                                              \
  do {                                                                         \
    if (++x_coord >= 80) {                                                     \
      x_coord = 0;                                                             \
      ++y_coord;                                                               \
    }                                                                          \
  } while (0)

static void __putchar(const char c, unsigned char color) {
  switch (c) {
  case '\n':
    y_coord++; // use carriage return in combination with newline to get desired
               // effect
    break;
  case '\r':
    x_coord = 0;
    break;
  case '\b':
    if (x_coord > 0)
      x_coord--;
    break;
  case '\t':
    // tab stop is 8 "spaces"
    for (unsigned long i = 0; i < _TABSTOP - (x_coord % _TABSTOP); i++)
      __putchar(' ', color);
    break;
  default: {
    unsigned long pos = _GETPOS();
    VIDEO_MEMORY[pos] = c;
    VIDEO_MEMORY[pos + 1] = color;
    _INCPOS();
  } break;
  }
}

static void __putstr(const char *str, unsigned char color) {
  for (int i = 0; str[i] != '\0'; i++)
    __putchar(str[i], color);
}

int putc(FILE *stream, char c) {
  __putchar(c, ch_color);
  return 0;
}

int putchar(char c) { return putc(stdout, c); }

int puts(const char *str) {
  __putstr(str, ch_color);
  __putstr("\r\n", ch_color);
  return 0;
}

int printf(const char *str, ...) {
  va_list ap;
  va_start(ap, str);
  int ret = vprintf(str, ap);
  va_end(ap);

  return ret;
}

int vprintf(const char *str, va_list ap) { return vfprintf(stdout, str, ap); }

int fprintf(FILE *stream, const char *str, ...) {
  va_list ap;
  va_start(ap, str);
  int ret = vfprintf(stream, str, ap);
  va_end(ap);

  return ret;
}

#define PF_FMT_SPEC 1
#define PF_FMT_NORMAL 2

#define PF_LEN_SSHORT 1
#define PF_LEN_SHORT 2
#define PF_LEN_DEFAULT 3
#define PF_LEN_LONG 4
#define PF_LEN_LLONG 5

#define PF_FMT_RECEIVE_ARG(flen, ap, s, buf, base)                             \
  do {                                                                         \
    switch (flen) {                                                            \
    case PF_LEN_SSHORT:                                                        \
      itoa((s char)va_arg(ap, s int), buf, base);                              \
      break;                                                                   \
    case PF_LEN_SHORT:                                                         \
      itoa((s short)va_arg(ap, s int), buf, base);                             \
      break;                                                                   \
    case PF_LEN_DEFAULT:                                                       \
      itoa(va_arg(ap, s int), buf, base);                                      \
      break;                                                                   \
    case PF_LEN_LONG:                                                          \
      itoa(va_arg(ap, s long), buf, base);                                     \
      break;                                                                   \
    case PF_LEN_LLONG:                                                         \
      itoa(va_arg(ap, s long long), buf, base);                                \
      break;                                                                   \
    }                                                                          \
  } while (0)

#define _PUTS_NO_NL(str) __putstr(str, ch_color)

int vfprintf(FILE *stream, const char *str, va_list ap) {
  int i = 0;
  int pfs = PF_FMT_NORMAL;
  int flen = PF_LEN_DEFAULT;

  while (*str != '\0') {
    if (*str == '%') {
      pfs = PF_FMT_SPEC;
      ++str;
    }

    if (pfs == PF_FMT_SPEC) {

      switch (*str) {
      case 'h':
        if (flen == PF_LEN_DEFAULT)
          flen = PF_LEN_SHORT;
        else if (flen == PF_LEN_SHORT)
          flen = PF_LEN_SSHORT;
        ++str;
        continue;
      case 'l':
        if (flen == PF_LEN_DEFAULT)
          flen = PF_LEN_LONG;
        else if (flen == PF_LEN_SHORT)
          flen = PF_LEN_LLONG;
        ++str;
        continue;
      case '%':
        putchar('%');
        break;
      case 's':
        _PUTS_NO_NL(va_arg(ap, const char *));
        break;
      case 'i':
      case 'd': {
        char num[32];

        PF_FMT_RECEIVE_ARG(flen, ap, signed, num, 10);
        _PUTS_NO_NL(num);
      } break;

      case 'u': {
        char num[32];

        PF_FMT_RECEIVE_ARG(flen, ap, unsigned, num, 10);
        _PUTS_NO_NL(num);
      } break;

      case 'x': {
        char num[32];

        PF_FMT_RECEIVE_ARG(flen, ap, unsigned, num, 16);
        _PUTS_NO_NL(num);
      } break;

      case 'X': {
        char num[32];

        PF_FMT_RECEIVE_ARG(flen, ap, unsigned, num, 16);
        _PUTS_NO_NL(strupr(num));
      } break;

      case 'o': {
        char num[32];

        PF_FMT_RECEIVE_ARG(flen, ap, unsigned, num, 16);
        _PUTS_NO_NL(num);
      } break;

      default:
        putchar('%');
        putchar(*str);
        break;
      }
    } else {
      putchar(*str);
    }

    pfs = PF_FMT_NORMAL;
    flen = PF_LEN_DEFAULT;

    ++i;
    ++str;
  }

  return i;
}
