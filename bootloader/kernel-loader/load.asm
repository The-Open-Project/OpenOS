[bits 16]

section .text

extern bootmain
global entry

entry:
    mov sp, 0x1000
    mov bp, sp

    call bootmain

    cli
    hlt

