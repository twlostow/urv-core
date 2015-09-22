#include "board.h"
#include "uart.h"

#define GPIO_CODR 0x0
#define GPIO_SODR 0x4

#define read_csr(reg) ({ unsigned long __tmp; \
  asm volatile ("csrr %0, " #reg : "=r"(__tmp)); \
  __tmp; })

#define write_csr(reg, val) \
  asm volatile ("csrw " #reg ", %0" :: "r"(val))

void gpio_set(int pin, int value)
{
    if(value)
	*(volatile uint32_t *) ( BASE_GPIO + GPIO_SODR ) = (1<<pin);
    else
	*(volatile uint32_t *) ( BASE_GPIO + GPIO_CODR ) = (1<<pin);
}

void delay(int v)
{
    volatile int i;

    for(i=0;i<v;i++);
}

volatile int irq_count = 0;

void handle_trap()
{
    irq_count++;
    asm volatile ("li t0, 0x200\ncsrc mip, t0");
}

void enable_irqs()
{
    asm volatile ("li t0, 0x200\ncsrs mie, t0");
    asm volatile ("csrs mstatus, 0x1");
}

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

/*    for(i=0;i<100;i++)
    {
	float f = 2*3.14*(float)i / 100.0;
	int y = (int) (1000.0 *sin(f));
	pp_printf("%d %d\n", i, y);
    }*/

    pp_printf("Starting CoreMark 1.0\n");

    coremark_main(argc, argv);

    for(;;);

    enable_irqs();

    for(;;)
    {
//	volatile int t = rdtime();
        pp_printf("Hello, world [%d]!\n\r", sys_get_ticks());
	gpio_set(0, 1);
	gpio_set(1, 1);
	gpio_set(2, 1);
	gpio_set(3, 1);
        delay(1000000);
	gpio_set(0, 0);
	gpio_set(1, 0);
	gpio_set(2, 0);
	gpio_set(3, 0);
        delay(1000000);
    }
}
