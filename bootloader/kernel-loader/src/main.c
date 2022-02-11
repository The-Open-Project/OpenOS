#define _BAREBONES_CPP_ 1
#define _BAREMETAL_ 1

#include "./stdio.h"

_extern int bootmain(void)
{
    puts("Hello, baremetal world!\n");

    return 0;
}
