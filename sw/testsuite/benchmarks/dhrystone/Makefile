# and don't touch the rest unless you know what you're doing.
CROSS_COMPILE ?= /opt/gcc-riscv/bin/riscv64-unknown-elf-

CC =		$(CROSS_COMPILE)gcc
LD =		$(CROSS_COMPILE)ld
OBJDUMP =	$(CROSS_COMPILE)objdump
OBJCOPY =	$(CROSS_COMPILE)objcopy
SIZE =		$(CROSS_COMPILE)size

CFLAGS = -m32 -DSIM -I../common -march=RV32IM -O2
OBJS = dhrystone.o dhrystone_main.o ../../../common/crt0.o ../../../common/irq.o  ../../../common/uart.o ../../../common/printf.o ../../../common/vsprintf-xint.o ../common/syscalls.o
LDS = ../../../common/ram2.ld
OUTPUT=dhrystone

$(OUTPUT): $(LDS) $(OBJS)
	${CC} -m32 -o $(OUTPUT).elf -nostartfiles $(OBJS)  -T $(LDS) ../../../common/_emulate.o -lc
	${OBJCOPY} -O binary $(OUTPUT).elf $(OUTPUT).bin
	${OBJDUMP} -D $(OUTPUT).elf > disasm.S
	$(SIZE) $(OUTPUT).elf
#	../genramvhd -p wrc_simulation_firmware $(OUTPUT).bin >  wrc_simulation_firmware_pkg.vhd
	../../../genraminit $(OUTPUT).bin 16384 > $(OUTPUT).ram

clean:
	rm -f $(OUTPUT).elf $(OUTPUT).bin $(OBJS)

%.o:	%.S
	${CC} -c -m32 $^ -o $@