# and don't touch the rest unless you know what you're doing.
CROSS_COMPILE ?= /opt/gcc-riscv/bin/riscv64-unknown-elf-

CC =		$(CROSS_COMPILE)gcc
LD =		$(CROSS_COMPILE)ld
OBJDUMP =	$(CROSS_COMPILE)objdump
OBJCOPY =	$(CROSS_COMPILE)objcopy
SIZE =		$(CROSS_COMPILE)size

CFLAGS = -g -m32 -msoft-float -march=RV32I -O2 -I. -I../common
OBJS = crt0.o irq.o boot.o ../common/uart.o
LDS = boot.ld
OUTPUT=uart-bootloader

$(OUTPUT): $(LDS) $(OBJS)
	${CC} -g -m32 -msoft-float  -march=RV32I -o $(OUTPUT).elf -nostartfiles $(OBJS)  -lm -T $(LDS)
	${OBJCOPY} -O binary $(OUTPUT).elf $(OUTPUT).bin
	${OBJDUMP} -D $(OUTPUT).elf > disasm.S
	$(SIZE) $(OUTPUT).elf
	../genraminit $(OUTPUT).bin 512 0 0 > uart-bootloader.ram
#	../genraminit $(OUTPUT).bin 512 63488 15872 >> uart-bootloader.ram

clean:
	rm -f $(OUTPUT).elf $(OUTPUT).bin $(OBJS)

%.o:	%.S
	${CC} -c -m32 $^ -o $@