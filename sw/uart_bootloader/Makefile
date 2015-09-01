# and don't touch the rest unless you know what you're doing.
CROSS_COMPILE ?= /opt/gcc-riscv/bin/riscv64-unknown-elf-

CC =		$(CROSS_COMPILE)gcc
LD =		$(CROSS_COMPILE)ld
OBJDUMP =	$(CROSS_COMPILE)objdump
OBJCOPY =	$(CROSS_COMPILE)objcopy
SIZE =		$(CROSS_COMPILE)size

SYN_DIR=../../syn/spec
SYN_TOP_LEVEL=spec_top

CFLAGS = -g -O2 -m32 -msoft-float -march=RV32I -I. -I../common -ffunction-sections -fdata-sections
OBJS = crt0.o  boot.o ../common/uart.o ../common/emulate.o ../common/irq.o
LDS = boot.ld
OUTPUT=uart-bootloader

$(OUTPUT): $(LDS) $(OBJS)
	${CC} -g  -m32 -Wl,--gc-sections -march=RV32I -o $(OUTPUT).elf -nostartfiles $(OBJS)  -lm -T $(LDS)
	${OBJCOPY} -O binary $(OUTPUT).elf $(OUTPUT).bin
	${OBJDUMP} -D $(OUTPUT).elf > disasm.S
	$(SIZE) $(OUTPUT).elf
	../genraminit $(OUTPUT).bin 512 0 0 > $(OUTPUT).ram
	../genmeminit $(OUTPUT).bin 512 0 0 > $(OUTPUT).mem
#	../genraminit $(OUTPUT).bin 512 63488 15872 >> uart-bootloader.ram

clean:
	rm -f $(OUTPUT).elf $(OUTPUT).bin $(OBJS)

bitstream: $(OUTPUT)
	data2mem -o b $(SYN_TOP_LEVEL)_$(OUTPUT).bit -bt $(SYN_DIR)/$(SYN_TOP_LEVEL).bit -bm $(SYN_DIR)/$(SYN_TOP_LEVEL)_bd.bmm -bd $(OUTPUT).mem tag urv_iram
#	data2mem -bx 1 -bt $(SYN_DIR)/$(SYN_TOP_LEVEL).bit -bm $(SYN_DIR)/$(SYN_TOP_LEVEL)_bd.bmm -bd $(OUTPUT).mem tag urv_iram
	

%.o:	%.S
	${CC} -c -m32 $^ -o $@