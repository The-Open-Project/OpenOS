#include <logging.h>

static unsigned long x_coord = 0;
static unsigned long y_coord = 2;
static unsigned char *const VIDEO_MEMORY = (unsigned char *const)0xB8000;

#define GETPOS() ((y_coord * 80) + x_coord)
#define INCPOS()         \
  do                     \
  {                      \
    if (++x_coord >= 80) \
    {                    \
      x_coord = 0;       \
      ++y_coord;         \
    }                    \
  } while (0)

static void __putchar(const char c, unsigned char color)
{
  unsigned long pos = GETPOS();

  *(VIDEO_MEMORY + pos++) = c;
  *(VIDEO_MEMORY + pos++) = color;

  INCPOS();
}

static void __putstr(const char *str, unsigned char color)
{
  for (int i = 0; str[i] != '\0'; i++)
    __putchar(str[i], color);
}

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
  unsigned char colorinfo = 0x09; // red on black
  unsigned char colordbg = 0x0A;  // red on black

  if (stream == ERROR_STREAM)
  {
    __putchar('[', color);
    __putstr("ERROR", colorerr);
    __putstr("] ", color);
  }
  else if (stream == INFO_STREAM)
  {
    __putchar('[', color);
    __putstr("INFO", colorinfo);
    __putstr("] ", color);
  }
  else if (stream == DEBUG_STREAM)
  {
    __putchar('[', color);
    __putstr("DEBUG", colordbg);
    __putstr("] ", color);
  }

  __putstr(fmt, 0x0F);
}
