#include <stdint.h>

void rv_test_pass(int num)
{
    pp_printf("Test passed\n");
}

void rv_test_fail(int num)
{
    pp_printf("Test %d failed\n", num);
}