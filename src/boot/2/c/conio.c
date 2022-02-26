#include <conio.h>

static unsigned char *const VIDEO_MEMORY = (unsigned char *const)0xB8000;

void clrscr(void) {
  for (int i = 0; i < 80 * 25; i++) {
    VIDEO_MEMORY[i] = 0x00;
  }
}
