#include <math.h>
#include <stdint.h>

char dupa[64];

const char *hello="Hello, world";

volatile int *TX_REG = 0x100000;


void putc(char c)
{
    *TX_REG = c;
}

void print_hex(int x)
{
    const char *hexchars="0123456789abcdef";
    int i;

    for(i = 7; i >= 0; i--)
    {
	putc(hexchars[(x>>(4*i))&0xf]);
    }
    putc('\n');
}

int array[256];

#define SWAP(a,b) temp=(a);(a)=(b);(b)=temp;

#define INSERTION_THRESHOLD 7

// NSTACK is the required auxiliary storage.
// It must be at least 2*lg(DATA_SIZE)

#define NSTACK 50

void sort( int n, int arr[] )
{
  int i,j,k;
  int ir = n;
  int l = 1;
  int jstack = 0;
  int a, temp;

  int istack[NSTACK];

  for (;;) {

#if HOST_DEBUG
    printArray( "", n, arr );
#endif

    // Insertion sort when subarray small enough.
    if ( ir-l < INSERTION_THRESHOLD ) {

      for ( j = l+1; j <= ir; j++ ) {
        a = arr[j-1];
        for ( i = j-1; i >= l; i-- ) {
          if ( arr[i-1] <= a ) break;
          arr[i] = arr[i-1];
        }
        arr[i] = a;
      }

      if ( jstack == 0 ) break;

      // Pop stack and begin a new round of partitioning.
      ir = istack[jstack--];
      l = istack[jstack--];

    }
    else {

      // Choose median of left, center, and right elements as
      // partitioning element a. Also rearrange so that a[l-1] <= a[l] <= a[ir-].

      k = (l+ir) >> 1;
      SWAP(arr[k-1],arr[l])
      if ( arr[l-1] > arr[ir-1] ) {
        SWAP(arr[l-1],arr[ir-1])
      }
      if ( arr[l] > arr[ir-1] ) {
        SWAP(arr[l],arr[ir-1])
      }
      if ( arr[l-1] > arr[l] ) {
        SWAP(arr[l-1],arr[l])
      }

      // Initialize pointers for partitioning.
      i = l+1;
      j = ir;

      // Partitioning element.
      a = arr[l];

      for (;;) {                       // Beginning of innermost loop.
        do i++; while (arr[i-1] < a);  // Scan up to find element > a.
        do j--; while (arr[j-1] > a);  // Scan down to find element < a.
        if (j < i) break;              // Pointers crossed. Partitioning complete.
        SWAP(arr[i-1],arr[j-1]);       // Exchange elements.
      }                                // End of innermost loop.

      // Insert partitioning element.
      arr[l] = arr[j-1];
      arr[j-1] = a;
      jstack += 2;

      // Push pointers to larger subarray on stack,
      // process smaller subarray immediately.

#if HOST_DEBUG
      if ( jstack > NSTACK ) { printf("NSTACK too small in sort.\n"); exit(1); }
#endif

      if ( ir-i+1 >= j-l ) {
        istack[jstack]   = ir;
        istack[jstack-1] = i;
        ir = j-1;
      }
      else {
        istack[jstack]   = j-1;
        istack[jstack-1] = l;
        l = i;
      }
    }

  }

}

void test_sort()
{
    int i;
    const int size = 16;
    for(i=0;i<size;i++)
    {
	array[i] = 1000 - i;
	print_hex(array[i]);// = 1000-i;
    }

    putc('\n');

    sort(size, array);
    for(i=0;i<size;i++)
	print_hex(array[i]);// = 1000-i;

}

#if 0
void test_floats()
{
    float x;
    float y;    

    for(x=0.0; x <=1.0; x+=0.2)
    {
	y = cosf(x);

	print_hex(*(int*)&x);
	print_hex(*(int*)&y);
	putc('\n');
    }
	
}
#endif

#define read_csr(reg) ({ unsigned long __tmp; \
  asm volatile ("csrr %0, " #reg : "=r"(__tmp)); \
  __tmp; })

uint32_t sys_get_cycles()
{
    return read_csr (cycle);
}

volatile int irq_counter = 0;

void handle_trap()
{
    irq_counter++;
}

main()
{
    char *s = hello;
    int i;

//    test_floats();

    uint32_t start = sys_get_cycles();
    test_sort();
    uint32_t end = sys_get_cycles();

    print_hex(end - start);
    print_hex(irq_counter);

//    for(i=0;i<5;i++)
//    float y = cos(x);

//    unsigned int x = 1234;

//    unsigned int y = x >> 2;
//    print_hex(*(int*)&x);
//    y = x << 2;
//    print_hex(*(int*)&y);

    for(;;)
    {
	for(i=0;i<10000;i++) asm volatile("nop");
        print_hex(irq_counter);
    }
/*
    x = 0xfffffb2e;

    y = x >> 2;
    print_hex(*(int*)&y);
    y = x << 2;
    print_hex(*(int*)&y);

//    x+=1.0;
//    print_hex(*(int*)&x);

//    print_hex(*(int*)&y);


//    while(*s) { *TX_REG = *s++; }
*/
    for(;;);
}
