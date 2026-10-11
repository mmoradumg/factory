.section .text.entry,"ax"
.global kernel_entry
.type kernel_entry,@function
kernel_entry:
    cli
    lea kernel_stack_top(%rip), %rsp
    and $-16, %rsp
    call kernel_main
1:  hlt
    jmp 1b
.section .bss.stack,"aw",@nobits
.balign 16
kernel_stack:
.skip 65536
kernel_stack_top:
