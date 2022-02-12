#pragma once

#include "DO-NOT-TOUCH"

#define MEM_START ((void *)(0x00001000))
#define INC_MEM(size) MEM_CURRENT += (size)
_extern void *MEM_CURRENT;
