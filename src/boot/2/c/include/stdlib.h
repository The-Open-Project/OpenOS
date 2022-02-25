#pragma once

char *itoa(int num, char *buf, int radix);
char *utoa(unsigned int num, char *buf, int radix);
char *ltoa(long num, char *buf, int radix);
char *lltoa(long long num, char *buf, int radix);
char *ultoa(unsigned long num, char *buf, int radix);
char *ulltoa(unsigned long long num, char *buf, int radix);
