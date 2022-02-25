[BITS 32]

[section .entry]

[extern kmain]
[global _start]

_start:
    cli

    mov ax, ds
    mov ss, ax
    
    mov sp, 0x1000
    mov bp, sp

    sti

    call kmain

    cli
    hlt

    ret
