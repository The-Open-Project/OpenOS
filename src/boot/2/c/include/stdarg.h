#pragma once

typedef unsigned char *va_list;
#define va_start(ap, v) ((ap) = (va_list)&(v) + sizeof(v))
#define va_arg(ap, t) (*(t *)(((ap) += sizeof(t)) - sizeof(t)))
#define va_copy(d, s) ((d) = (s))
#define va_end(ap) ((ap) = (va_list)0)
