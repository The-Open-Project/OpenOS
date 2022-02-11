[bits 16]

section .text

extern bootmain
global entry

entry:
    cli
    ; setup stack
    mov ax, ds
    mov ss, ax
    mov sp, 0
    mov bp, sp
    sti

    call bootmain

    cli
    hlt

