#include "board.h"
#include "uart.h"

uint32_t sys_get_ticks()
{
    return read_csr(0xc01);
}

extern void coremark_main(int argc, char *argv[]);

main()
{
    uart_init_hw();
    int argc = 1;
    char *argv[] = {"coremark"};

    int i;

    pp_printf("Starting CoreMark 1.0\n");

    coremark_main(argc, argv);

    for(;;);

    return 0;
}
