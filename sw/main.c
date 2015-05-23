char dupa[64];

const char *hello="Hello, world";

volatile int *TX_REG = 0x100000;
main()
{
    char *s = hello;
    while(*s) { *TX_REG = *s++; }
    for(;;);
}