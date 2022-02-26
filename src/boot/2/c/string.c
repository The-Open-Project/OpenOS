#include "include/string.h"

void *memset(void *ptr, int c, size_t len) {
  for (int i = 0; i < len; i++) {
    ((int *)ptr)[i] = c;
  }

  return ptr;
}

char *strupr(char *ptr) {
  for (int i = 0; ptr[i] != '\0'; i++) {
    if (ptr[i] >= 'a' && ptr[i] <= 'z')
      ptr[i] -= 20;
  }

  return ptr;
}
