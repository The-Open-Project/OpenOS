#pragma once
// implementation of stdarg.h

typedef unsigned char *va_list;
#define va_start(list, last) ((list) = (unsigned char *)&(last) + sizeof(last))
#define va_arg(list, type) (*(type *)(((list) += sizeof(type)) - sizeof(type)))
#define va_end(list)
#define va_copy(dest, src) (*(dest) = *(src))
