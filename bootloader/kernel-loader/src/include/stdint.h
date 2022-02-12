#pragma once
// stdint.h for 16-bit x86
// ! DO NOT USE for 32-bit x86. Use <stdint.h> from C standard library instead.

typedef unsigned char uint8_t;
typedef unsigned short int uint16_t;
typedef unsigned long int uint32_t;
typedef unsigned long long int uint64_t;

typedef signed char int8_t;
typedef signed short int int16_t;
typedef signed long int int32_t;
typedef signed long long int int64_t;

typedef unsigned char uint_least8_t;
typedef unsigned short int uint_least16_t;
typedef unsigned long int uint_least32_t;
typedef unsigned long long int uint_least64_t;

typedef signed char int_least8_t;
typedef signed short int int_least16_t;
typedef signed long int int_least32_t;
typedef signed long long int int_least64_t;

typedef unsigned char uint_fast8_t;
typedef unsigned short int uint_fast16_t;
typedef unsigned long int uint_fast32_t;
typedef unsigned long long int uint_fast64_t;

typedef signed char int_fast8_t;
typedef signed short int int_fast16_t;
typedef signed long int int_fast32_t;
typedef signed long long int int_fast64_t;

typedef unsigned char uintptr_t;
typedef signed char intptr_t;
