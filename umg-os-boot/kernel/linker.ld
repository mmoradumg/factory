ENTRY(kernel_entry)
PHDRS { text PT_LOAD FLAGS(5); data PT_LOAD FLAGS(6); }
SECTIONS {
 . = 0x200000;
 .text : ALIGN(4096) { *(.text.entry) *(.text .text.*) } :text
 .rodata : ALIGN(4096) { *(.rodata .rodata.*) } :text
 .data : ALIGN(4096) { *(.data .data.*) } :data
 .bss (NOLOAD) : ALIGN(4096) { *(.bss .bss.*) *(COMMON) } :data
}
