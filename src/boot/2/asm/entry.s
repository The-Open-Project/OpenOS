[BITS 16]

section .entry

extern __bss_start
extern __end

extern _cstart ; C entry point
global _start

_start:
    cli

    mov [drive], dl

    mov ax, ds
    mov ss, ax
    
    mov sp, 0x7C00
    mov bp, sp

    call a20enable

    ; configure PMode
    lgdt [GLOBAL_DESCRIPTOR_TABLE.descriptor] ; load GDT

    mov eax, cr0 ; we can't modify cr0 directly, so we move it to eax
    or al, 1 ; set cr0 PE bit
    mov cr0, eax ; move eax back to cr0

    jmp dword 0x08:.pmodeex

    .end:

    [BITS 32]
    .pmodeex:
        ; 6 - set up segment registers
        mov ax, 0x10
        mov ds, ax
        mov ss, ax
        
        ; clear bss (uninitialized data)
        mov edi, __bss_start
        mov ecx, __end
        sub ecx, edi
        mov al, 0
        cld
        rep stosb

        xor edx, edx
        mov dl, [drive]

        push edx
        call _cstart
        pop edx

        cli
        hlt
        ret

; variables and constants 
drive:                  db 0

; structs

GLOBAL_DESCRIPTOR_TABLE:
    .null:
        dd 0
        dd 0

    .code32:
        dw 0xffff
        dw 0x0000
        db 0x0000
        db 10011010b
        db 11001111b
        db 0x0000

    .data32:
        dw 0xffff
        dw 0x0000
        db 0x0000
        db 10010010b
        db 11001111b
        db 0x0000

    .code16:
        dw 0FFFFh                   ; limit (bits 0-15) = 0xFFFFF
        dw 0                        ; base (bits 0-15) = 0x0
        db 0                        ; base (bits 16-23)
        db 10011010b                ; access (present, ring 0, code segment, executable, direction 0, readable)
        db 00001111b                ; granularity (1b pages, 16-bit pmode) + limit (bits 16-19)
        db 0                        ; base high

    .data16:
        dw 0FFFFh                   ; limit (bits 0-15) = 0xFFFFF
        dw 0                        ; base (bits 0-15) = 0x0
        db 0                        ; base (bits 16-23)
        db 10010010b                ; access (present, ring 0, data segment, executable, direction 0, writable)
        db 00001111b                ; granularity (1b pages, 16-bit pmode) + limit (bits 16-19)
        db 0
        
    .descriptor:
        dw GLOBAL_DESCRIPTOR_TABLE.descriptor - GLOBAL_DESCRIPTOR_TABLE - 1
        dd GLOBAL_DESCRIPTOR_TABLE

; functions

[BITS 16]
; enable A20 line
a20enable:
    call a20wait_in
    mov al, 0xAD
    out 0x64, al

    call a20wait_in
    mov al, 0xD0
    out 0x64, al

    call a20wait_out
    in al, 0x60
    push eax

    call a20wait_in
    mov al, 0xD1
    out 0x64, al

    call a20wait_in
    pop eax
    or al, 2
    out 0x60, al

    call a20wait_in
    mov al, 0xAE
    out 0x64, al

    call a20wait_in
    ret

[BITS 16]
a20wait_in:
    in al, 0x64
    test al, 2
    jnz a20wait_in
    
    ret

[BITS 16]
a20wait_out:
    in al, 0x64
    test al, 1
    jz a20wait_out

    ret
