[BITS 32]

[section .text]

%macro _RMODE16 0
    [BITS 32]
    .swrmode:
        jmp word 0x18:.pmode ; jump to protected mode (16-bit)
    [BITS 16]
    .pmode:
        mov eax, cr0
        and al, ~1 ; clear PE bit
        mov cr0, eax

        jmp word 0x0:.rmode ; jump to real mode segment
    [BITS 16]
    .rmode:
        xor ax, ax
        mov ds, ax
        mov ss, ax

        ; enable interrupts
        sti
%endmacro

%macro _PMODE32 0
    [BITS 16]
    .swpmode:
        cli ; disable interrupts
        mov eax, cr0
        or al, 1 ; set PE bit
        mov cr0, eax

        jmp dword 0x8:.pmodeex ; jump to protected mode (32-bit)
    [BITS 32]
    .pmodeex:
        mov ax, 0x10 ; set segment registers to protected mode segment
        mov ds, ax
        mov ss, ax
%endmacro

; convert flat address to real mode segment:offset pair (16-bit)
; 1st parameter: flat address
; 2nd parameter: segment register
; 3rd parameter: 32-bit intermediate register
; 4th parameter: 16-bit lower half of 32-bit intermediate register
%macro _PMODE2RMODEPTR 4
    mov %3, %1 ; flat address -> 32-bit intermediate register
    shr %3, 4 ; 32-bit intermediate register -> 16-bit lower half of 32-bit intermediate register
    mov %2, %4 ; 16-bit lower half of 32-bit intermediate register -> segment register
    mov %3, %1 ; flat address -> 32-bit intermediate register
    and %3, 0x0F ; mask lower 4 bits of 32-bit intermediate register
%endmacro

[global _internal_memcpy]
[global _internal_memset]
[global _inb]
[global _outb]
[global _get_drive_info]
[global _reset_drive]
[global _read_drive_sectors]

; param 1 - port
_inb:
    ; clear eax and edx so we don't get garbage
    xor eax, eax
    xor edx, edx

    mov edx, [esp + 4]
    in al, dx
    ret

; param 1 - port
; param 2 - value (byte)
_outb:
    ; clear eax and edx so we don't get garbage
    xor eax, eax
    xor edx, edx

    mov edx, [esp + 4]
    mov eax, [esp + 8]

    out dx, al
    ret

; param 1 - dest
; param 2 - src
; param 3 - num bytes
_internal_memcpy:
    enter 0, 0

    push esi
    push edi

    mov esi, [ebp + 12]
    mov edi, [ebp + 8]
    mov ecx, [ebp + 16]
    cld

    rep movsb

    pop edi
    pop esi

    leave
    ret

; param 1 - dest
; param 2 - fill
; param 3 - num bytes
_internal_memset:
    enter 0, 0 ; create stack frame

    push edi

    mov eax, [ebp + 12]
    mov edi, [ebp + 8]
    mov ecx, [ebp + 16]
    cld

    rep stosd ; for ecx repetitions, store the value of eax in edi and increment edi

    pop edi

    leave ; destroy stack frame
    ret

; param 1 - drive number
; param 2 - drive type (out)
; param 3 - cylinders (out)
; param 4 - sectors (out)
; param 5 - heads (out)
_get_drive_info:
    enter 0, 0 ; make new stack frame

    push es
    push ebx
    push esi
    push edi
    ; save non-volatile registers
    _RMODE16 ; switch to real mode

    mov dl, [bp + 8] ; drive number
    mov ah, 0x08 ; get drive info function
    mov di, 0x0
    mov es, di ; es:di = 0:0
    stc ; set carry flag
    int 0x13

    ; set return value
    mov eax, 1
    sbb eax, 0 ; subtract with carry, if carry flag is set, eax will be 0
    push eax ; push because it will be modified by the _PMODE32 macro

    ; output drive info
    _PMODE2RMODEPTR [bp + 12], es, esi, si
    mov es:[si], bl

    mov bl, ch ; cylinders (upper 2 bits in cl)
    mov bh, cl ; cylinders (lower 8 bits in ch, bits 6-7 in cl)
    ; for some reason, the BIOS returns the number of cylinders with the LOWER bits in ch, and
    ; the UPPER bits in cl. (I don't know why, but it's the way it is.)

    shr bh, 6 ; shift upper 2 bits to lower 2 bits
    inc bx ; add 1 to cylinder for correct number of cylinders

    _PMODE2RMODEPTR [bp + 16], es, esi, si
    mov es:[si], bx ; lower bits in bl, upper bits in bh (10 bits)

    xor ch, ch
    and cl, 0x3F ; mask lower 6 bits

    _PMODE2RMODEPTR [bp + 20], es, esi, si
    mov es:[si], cx

    mov cl, dh ; maximum head number
    inc cx ; add 1 to head number for correct number of heads

    _PMODE2RMODEPTR [bp + 24], es, esi, si
    mov es:[si], cx

    _PMODE32 ; switch to protected mode

    pop eax ; restore eax (return value)
    ; restore non-volatile registers
    pop edi
    pop esi
    pop ebx
    pop es

    leave
    ret

; param 1 - drive number
; param 2 - cylinder
; param 3 - sector
; param 4 - head
; param 5 - num sectors
; param 6 - buffer (out)
_read_drive_sectors:
    enter 0, 0

    push ebx
    push es

    _RMODE16

    mov ah, 0x02 ; read sectors function
    mov al, [bp + 16] ; sectors shift
    and al, 0x3F ; mask lower 6 bits

    mov cl, [bp + 13] ; sector number (6 bits)
    shl cl, 6 ; shift 6 bits to the left
    or cl, al

    mov dl, [bp + 8] ; drive number
    mov dh, [bp + 20] ; head
    mov ch, [bp + 12] ; cylinder (lower 8 bits, upper 2 bits discarded)

    mov al, [bp + 24] ; count of sectors to read

    _PMODE2RMODEPTR [bp + 28], es, ebx, bx ; convert buffer address to real mode segment:offset pair
    ; es:bx is now correctly set
    stc
    int 0x13 ; call BIOS

    mov ax, 1
    sbb ax, 0 ; subtract with carry, if carry flag is set, ax will be 0
    push ax ; push because it will be modified by the _PMODE32 macro

    _PMODE32

    pop eax ; restore eax (return value)

    pop es
    pop ebx

    leave

; param 1 - drive number
_reset_drive:
    enter 0, 0

    ; save non-volatile registers
    _RMODE16

    mov dl, [bp + 8] ; drive number
    mov ah, 0x00 ; reset drive function

    int 0x13

    mov eax, 1
    sbb eax, 0 ; subtract with carry, if carry flag is set, eax will be 0
    push eax ; push because it will be modified by the _PMODE32 macro

    _PMODE32

    pop eax ; restore eax (return value)

    leave
