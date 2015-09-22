# and don't touch the rest unless you know what you're doing.
CROSS_COMPILE ?= /opt/gcc-riscv/bin/riscv64-unknown-elf-

CC =		$(CROSS_COMPILE)gcc
LD =		$(CROSS_COMPILE)ld
OBJDUMP =	$(CROSS_COMPILE)objdump
OBJCOPY =	$(CROSS_COMPILE)objcopy
SIZE =		$(CROSS_COMPILE)size

CFLAGS = -m32 -DSIM -I../common -march=RV32I -O2
OBJS = test.o ../common/crt0.o ../common/irq.o ../common/emulate.o ../common/uart.o ../common/printf.o ../common/vsprintf-xint.o
LDS = ../common/ram2.ld
OUTPUT=test1

$(OUTPUT): $(LDS) $(OBJS)
	${CC} -m32 -o $(OUTPUT).elf -nostartfiles $(OBJS)  -T $(LDS)
	${OBJCOPY} -O binary $(OUTPUT).elf $(OUTPUT).bin
	${OBJDUMP} -D $(OUTPUT).elf > disasm.S
	$(SIZE) $(OUTPUT).elf
#	../genramvhd -p wrc_simulation_firmware $(OUTPUT).bin >  wrc_simulation_firmware_pkg.vhd
	../genraminit $(OUTPUT).bin 1000 > $(OUTPUT).ram

clean:
	rm -f $(OUTPUT).elf $(OUTPUT).bin $(OBJS)

%.o:	%.S
	${CC} -c -m32 $^ -o $@