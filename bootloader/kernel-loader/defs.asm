[bits 16]

section .text

global print_char
global print_string

; char in [bp + 6] (bp+4 is return address)
print_char:
    push bp
    mov bp, sp

    mov ah, 0x0E
    mov al, [bp + 6]
    int 0x10

    mov sp, bp
    pop bp

    xor ah, ah ; al still contains the character
    ret

; string in [bp + 6]
print_string:
    push bp
    mov bp, sp

    push bx
    push si

    xor cx, cx
    mov si, [bp + 6]

    .loop:
        
        mov bx, [si] ; first char
        mov al, bl

        cmp byte al, 0
        je .end

        call print_char
        
        inc si
        inc cx
        jmp .loop

    .end:

    pop si
    pop bx

    mov sp, bp
    pop bp

    mov ax, cx ; return number of chars printed
    ret
