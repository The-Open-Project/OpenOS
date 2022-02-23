#define _BAREMETAL_ 1
#include <logging.h>

extern int _cstart(unsigned char drive)
{
  plog(INFO_STREAM, "PMode");
  return 0;
}
