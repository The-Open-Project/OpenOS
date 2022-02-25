#pragma once

#include "stdarg.h"

typedef char **stream_t;
static const stream_t ERROR_STREAM = (const stream_t)-1;
static const stream_t INFO_STREAM = (const stream_t)0;
static const stream_t DEBUG_STREAM = (const stream_t)1;

void plog(stream_t stream, const char *fmt, ...);
void vplog(stream_t stream, const char *fmt, va_list args);
void putstr(const char *str);
