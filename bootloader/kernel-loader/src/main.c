#define _BAREBONES_C_ 1
#define _BAREMETAL_ 1

#include <stdio.h>

_extern int bootmain(void)
{
    puts("Hello world!");

    return 0;
}
