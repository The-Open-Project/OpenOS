#include <logging.h>
#include "include/stdio.h"

void plog(stream_t stream, const char *fmt, ...)
{
  va_list args;
  va_start(args, fmt);
  vplog(stream, fmt, args);
  va_end(args);
}

void vplog(stream_t stream, const char *fmt, va_list args)
{
  unsigned char color = 0x07;     // gray on black
  unsigned char colorerr = 0x04;  // red on black
  unsigned char colorinfo = 0x0A; // red on black
  unsigned char colordbg = 0x09;  // red on black

  if (stream == ERROR_STREAM)
  {
    ch_color = color;
    putchar('[');

    ch_color = colorerr;
    printf("ERROR");

    ch_color = color;
    printf("] ");
  }
  else if (stream == INFO_STREAM)
  {
    ch_color = color;
    putchar('[');

    ch_color = colorinfo;
    printf("INFO");

    ch_color = color;
    printf("] ");
  }
  else if (stream == DEBUG_STREAM)
  {
    ch_color = color;
    putchar('[');

    ch_color = DEBUG_STREAM;
    printf("DEBUG");

    ch_color = color;
    printf("] ");
  }

  vprintf(fmt, args);
}
