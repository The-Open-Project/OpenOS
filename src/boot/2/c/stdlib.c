#include "include/stdlib.h"

static char _hex[] =
    "zyxwvutsrqponmlkjihgfedcba9876543210123456789abcdefghijklmnopqrstuvwxyz";

char *itoa(int num, char *buf, int radix) {
  return ltoa((long)num, buf, radix);
}
char *utoa(unsigned int num, char *buf, int radix) {
  return ultoa((unsigned long)num, buf, radix);
}
char *ltoa(long num, char *buf, int radix) {
  return lltoa((long long)num, buf, radix);
}
char *lltoa(long long num, char *buf, int radix) {
  char *rc;
  char *ptr;
  char *low;
  // Check for supported base.
  if (radix < 2 || radix > 36) {
    *buf = '\0';
    return buf;
  }
  rc = ptr = buf;
  // Set '-' for negative decimals.
  if (num < 0 && radix == 10) {
    *ptr++ = '-';
  }
  // Remember where the numbers start.
  low = ptr;
  // The actual conversion.
  do {
    // Modulo is negative for negative value. This trick makes abs()
    // unnecessary.
    *ptr++ = _hex[35 + num % radix];
    num /= radix;
  } while (num);
  // Terminating the string.
  *ptr-- = '\0';
  // Invert the numbers.
  while (low < ptr) {
    char tmp = *low;
    *low++ = *ptr;
    *ptr-- = tmp;
  }
  return rc;
}
char *ultoa(unsigned long num, char *buf, int radix) {
  return ulltoa((unsigned long long)num, buf, radix);
}
char *ulltoa(unsigned long long num, char *buf, int radix) {
  char *rc;
  char *ptr;
  char *low;
  // Check for supported base.
  if (radix < 2 || radix > 36) {
    *buf = '\0';
    return buf;
  }
  rc = ptr = buf;

  // Remember where the numbers start.
  low = ptr;
  // The actual conversion.
  do {
    // Modulo is negative for negative value. This trick makes abs()
    // unnecessary.
    *ptr++ = _hex[35 + num % radix];
    num /= radix;
  } while (num);
  // Terminating the string.
  *ptr-- = '\0';
  // Invert the numbers.
  while (low < ptr) {
    char tmp = *low;
    *low++ = *ptr;
    *ptr-- = tmp;
  }
  return rc;
}
