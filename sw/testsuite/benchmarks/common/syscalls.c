// See LICENSE for license details.

#include <stdint.h>
#include <string.h>
#include <stdarg.h>
#include <stdio.h>
#include <limits.h>
#include "util.h"


void setStats(int enable)
{
//  syscall(SYS_stats, enable, 0, 0);
}

void printstr(const char* s)
{
//  syscall(SYS_write, 1, (long)s, strlen(s));
}
