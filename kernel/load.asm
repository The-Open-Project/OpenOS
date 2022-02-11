[bits 32]

section .text

extern kmain
global entry

entry:
    call kmain
    cli
    hlt

