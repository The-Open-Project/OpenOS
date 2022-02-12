#pragma once
// stddef.h for 16-bit x86
// pointer size is 16 bits

#define NULL ((void *)0)
#define offsetof(type, member) ((size_t)(&((type *)0)->member))

typedef signed short int ptrdiff_t;
typedef unsigned long int size_t;
typedef signed long int ssize_t;

/* OS-specific extensions */
#define alignto(align, num) ((align) == 0 ? (num) : ((num) % (align)) == 0 ? (num) : (num) + (align) - ((num) % (align)))
#ifdef __cplusplus
#define _extern extern "C"
#else
#define _extern extern
#endif


