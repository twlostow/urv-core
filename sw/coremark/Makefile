CROSS_COMPILE ?= /opt/gcc-riscv-5.2.0/bin/riscv64-unknown-elf-

CC =		$(CROSS_COMPILE)gcc
LD =		$(CROSS_COMPILE)ld
OBJDUMP =	$(CROSS_COMPILE)objdump
OBJCOPY =	$(CROSS_COMPILE)objcopy
SIZE =		$(CROSS_COMPILE)size

ARCH = RV32IM

CFLAGS = -g  -m32  -Os  -msoft-float -march=$(ARCH)  -I. -I../common -ffunction-sections -fdata-sections -DFLAGS_STR="\"\"" -I../coremark_v1.0/barebones -I../coremark_v1.0
OBJS = ../common/crtuser.o main.o ../common/uart.o ../common/printf.o ../common/vsprintf-xint.o \
../coremark_v1.0/core_list_join.o  ../coremark_v1.0/core_matrix.o  ../coremark_v1.0/core_state.o  ../coremark_v1.0/barebones/cvt.o \
../coremark_v1.0/core_main.o ../coremark_v1.0/barebones/core_portme.o ../coremark_v1.0/core_util.o ../coremark_v1.0/barebones/ee_printf.o ../coremark_v1.0/fmod.o

LDS = ../common/user.ld
OUTPUT=hello


$(OUTPUT): $(LDS) $(OBJS)
	${CC} -m32  -flto -Wl,--gc-sections -g  -msoft-float  -march=$(ARCH) -o $(OUTPUT).elf -nostartfiles $(OBJS)  -lm -T $(LDS) -lc
	${OBJCOPY} -O binary $(OUTPUT).elf $(OUTPUT).bin
	${OBJDUMP} -D $(OUTPUT).elf > disasm.S
	../genraminit $(OUTPUT).bin 16384 > $(OUTPUT).ram

	$(SIZE) $(OUTPUT).elf

clean:
	rm -f $(OUTPUT).elf $(OUTPUT).bin $(OBJS)

load:
	../uart-bootloader.py $(OUTPUT).bin

%.o:	%.S
	${CC} -c -m32 -march=RV32IM $^ -o $@