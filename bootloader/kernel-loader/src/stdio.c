#include <stdio.h>
#include <stdarg.h>
#include <stdbool.h>
#include <priv/memdefs.h>
#include <priv/asmdecls.h>

typedef enum _FILE_MODE
{
    read,
    writec,
    append,
    readwrite,
    readwritec,
    readappend,
    readbin,
    writecbin,
    appendbin,
    readtext,
    writectext,
    appendtext,
    readwritebin,
    readwritecbin,
    readappendbin,
    readwritetext,
    readwritectext,
    readappendtext
} FILE_MODE;

struct _FILE
{
    bool isopen;

    FILE_MODE mode;
};

FILE *fopen(const char *file, const char *mode)
{
    FILE *fp = MEM_START;
    fp->isopen = true;
    fp->mode = readwritebin;

    return fp;
}

int fclose(FILE *fp)
{
    if (fp)
    {
        if (fp->isopen)
        {
            fp->isopen = false;
            fp = NULL;

            return 0;
        }
    }

    return -1;
}

static int print_string_helper(const char *s)
{
    int ch;
    for (int i = 0; s[i] != '\0'; i++)
    {
        print_char(s[i]);
        ch++;
    }
    return ch;
}

int putc(int c, FILE *stream)
{
    print_char(c);
    return c;
}

int putchar(int c)
{
    return putc(c, stdout);
}

int puts(const char *s)
{
    print_string_helper(s);
    print_string_helper("\r\n");
    return 0;
}

int printf(const char *format, ...)
{
    // TODO: implement format string

    return fprintf(stdout, format, NULL);
}

int fprintf(FILE *stream, const char *format, ...)
{
    // ignore stream
    va_list args;
    va_start(args, format);

    int result = vfprintf(stream, format, args);

    va_end(args);
    return result;
}

int vprintf(const char *format, va_list args)
{
    return vfprintf(stdout, format, args);
}

int vfprintf(FILE *stream, const char *format, va_list args)
{
    // ignore args list for a moment and just print format string
    return print_string_helper(format);
}
