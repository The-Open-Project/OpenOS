[bits 16]

section .text

global print_char
global reset_disk
global read_disk_sectors
global read_disk_params

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

; 1st param - drive number
reset_disk:
    push bp
    mov bp, sp
    
    mov ah, 0x00
	mov dl, [bp + 4] ; passed parameter, first
	int 0x13

	mov ax, 1
	sbb ax, 0

    mov sp, bp
    pop bp
    ret

; 1st param - drive number
; 2nd param - cylinder
; 3rd param - head
; 4th param - sector
; 5th param - count
; 6th param (out) - pointer to buffer
read_disk_sectors:
    push bp
    mov bp, sp

    ; save modified regs
    push bx
    push es

    ; setup args
    mov dl, [bp + 4]    ; dl - drive

    mov ch, [bp + 6]    ; ch - cylinder (lower 8 bits)
    mov cl, [bp + 7]    ; cl - cylinder to bits 6-7
    shl cl, 6

    mov dh, [bp + 8]   ; dh - head
    
    mov al, [bp + 10]    ; cl - sector to bits 0-5
    and al, 3Fh
    or cl, al

    mov al, [bp + 12]   ; al - count

    mov bx, [bp + 16]   ; es:bx - far pointer to data out
    mov es, bx
    mov bx, [bp + 14]

    ; call int13h
    mov ah, 02h
    stc
    int 13h

    ; set return value
    mov ax, 1
    sbb ax, 0           ; 1 on success, 0 on fail   

    ; restore regs
    pop es
    pop bx

    mov sp, bp
    pop bp
    ret

; 1st param - drive number
; 2nd (out) - drive type
; 3rd (out) - head number
; 4th (out) - sectors per track
; 5th (out) - cylinder number
read_disk_params:
    push bp
    mov bp, sp
    ; save regs
    push es
    push bx
    push si
    push di

    ; call int13h
    mov dl, [bp + 4]    ; dl - disk drive
    mov ah, 08h
    mov di, 0           ; es:di - 0000:0000
    mov es, di
    int 13h

    ; return
    jc .fail
    mov ax, 1

    mov si, [bp + 6]    ; drive type from bl
    mov [si], bl

    mov dl, dh
    xor dh, dh
    mov si, [bp + 10]
    mov [si], dx

    xor dx, dx
    mov dl, cl
    and dl, 0x3F
    mov si, [bp + 12]
    mov [si], dx

    xor dx, dx
    mov dl, ch          ; cylinders - lower bits in ch
    mov dh, cl          ; cylinders - upper bits in cl (6-7)
    ; shift bits 1-0 to bits 7-6
    shr dh, 6
    mov si, [bp + 8]
    mov [si], dx

    ; restore regs
    pop di
    pop si
    pop bx
    pop es

    .end:
    ; restore old call frame
    mov sp, bp
    pop bp
    ret

    .fail:
        xor ax, ax
        jmp .end

