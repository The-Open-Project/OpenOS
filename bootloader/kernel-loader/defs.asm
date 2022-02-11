[bits 16]

section .text

global print_char

; char in [bp + 4] (bp+2 is return address)
print_char:
    push bp
    mov bp, sp

    mov ah, 0x0E
    mov al, [bp + 4]
    int 0x10

    mov sp, bp
    pop bp

    xor ah, ah ; al still contains the character
    ret
    