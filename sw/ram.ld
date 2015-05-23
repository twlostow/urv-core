OUTPUT_FORMAT("elf32-littleriscv")
ENTRY(_start)

MEMORY
{
    ram :
 ORIGIN = 0x00000000,
 LENGTH = 65536 - 2048
    stack :
 ORIGIN = 65536 - 2048,
 LENGTH = 2048
}

SECTIONS
{
 .boot : { *(.boot) } > ram
 .text : { *(.text .text.*) } > ram =0

 _gp = .;

 .rodata : { *(.rodata .rodata.*) } > ram
 .data : {
  *(.data .data.*)
 } > ram
 .bss : {
  _fbss = .;
  *(.bss .bss.*)
  *(COMMON)
  _ebss = .;
 } > ram

 PROVIDE(_endram = ORIGIN(stack));
 PROVIDE(_fstack = ORIGIN(stack) + LENGTH(stack) - 4);
 _end = .;

}

