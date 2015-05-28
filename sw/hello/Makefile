# and don't touch the rest unless you know what you're doing.
CROSS_COMPILE ?= /opt/gcc-riscv/bin/riscv64-unknown-elf-

CC =		$(CROSS_COMPILE)gcc
LD =		$(CROSS_COMPILE)ld
OBJDUMP =	$(CROSS_COMPILE)objdump
OBJCOPY =	$(CROSS_COMPILE)objcopy
SIZE =		$(CROSS_COMPILE)size

CFLAGS = -g -m32 -msoft-float -march=RV32I  -I. -I../common
OBJS = ../common/crt0.o main.o ../common/uart.o
LDS = ../common/ram2.ld
OUTPUT=hello

$(OUTPUT): $(LDS) $(OBJS)
	${CC} -g -m32 -msoft-float  -march=RV32I -o $(OUTPUT).elf -nostartfiles $(OBJS)  -lm -T $(LDS)
	${OBJCOPY} -O binary $(OUTPUT).elf $(OUTPUT).bin
	${OBJDUMP} -D $(OUTPUT).elf > disasm.S
#	../genraminit $(OUTPUT).bin 1024 0 0 > uart-bootloader.ram
	$(SIZE) $(OUTPUT).elf

clean:
	rm -f $(OUTPUT).elf $(OUTPUT).bin $(OBJS)

%.o:	%.S
	${CC} -c -m32 $^ -o $@