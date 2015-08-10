#include "board.h"
#include "uart.h"

#define GPIO_CODR 0x0
#define GPIO_SODR 0x4

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
}

extern void coremark_main();
main()
{
    uart_init_hw();

//    coremark_main();

//    for(;;);


    for(;;)
    {
//	volatile int t = rdtime();
//        puts("Hello, world!\n\r");
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
