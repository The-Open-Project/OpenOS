#define _BAREBONES_C_ 1
#define _BAREMETAL_ 1
#include <stddef.h>
#include <stdint.h>

_extern int print_char(char c);

_extern int bootmain(uint8_t drivenum)
{
    print_char('S');    
    return 0;
}
