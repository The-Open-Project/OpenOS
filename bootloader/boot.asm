[bits 16]
[org 0x7C00]

jmp short entry 
nop

; BIOS parameter block
oem_id:                         db 'MSWIN4.1'
bytes_per_sector:               dw 512
sectors_per_cluster:            db 1
reserved_sectors:               dw 11
number_of_fats:                 db 2
root_entries:                   dw 224
total_sectors:                  dw 2880
media_descriptor:               db 0xF0
sectors_per_fat:                dw 9
sectors_per_track:              dw 18
number_of_heads:                dw 2
hidden_sectors:                 dd 0
large_sector_count:             dd 0

; Extended boot record
physical_drive_number:          db 0
winnt_flags:                    db 0
signature:                      db 0x28
serial_number:                  dd 0x4A3B2C1D
volume_label:                   db 'NO NAME    '
system_id:                      db 'FAT12   '

; Boot code
entry:
    KERNEL_LOADER_LOCATION equ 0x1000

    mov [physical_drive_number], dl                 
                         
    xor ax, ax                          
    mov es, ax
    mov ds, ax
    mov bp, 0x7C00
    mov sp, bp

    mov si, STARTUP_MESSAGE
    call print_string

    mov bx, KERNEL_LOADER_LOCATION
    mov dh, 50

    mov ah, 0x02     ; BIOS read from disk routine

    mov al, dh       ; dh is the number of segments we want to read

    mov ch, 0x00     ; track / cylinder number 0
    mov dh, 0x00     ; head 0
    mov cl, 0x02     ; start reading from sector 2 (after boot sector)
    
    mov dl, [physical_drive_number]
    int 0x13     ; read from disk interrupt

    jc disk_error     ; jump to error if Carry Flag HIGH
    
    cmp ah, 0     ; AH contains the status. If it's 0, it's alright
    jne disk_error

    mov si, SUCCESS_MESSAGE
    call print_string

    jmp KERNEL_LOADER_LOCATION

    jmp halt_cpu

halt_cpu:
    cli
    hlt

; Labels

; string in si
print_string:
    .loop:
        lodsb ; load next byte from string si into al

        or al, al ; if al is 0, we're done
        jz .end

        call print_char ; print the character
        
        jmp .loop

    .end:

    ret

; char in al
print_char:
    mov ah, 0x0E

    int 0x10    

    ret

read_disk:
    push ax
    push bx
    push cx
    push dx
    push di

    push cx
    call conv_lba_to_chs
    pop ax
    
    mov ah, 02h
    mov di, 3

    .begin:
        pusha
        stc

        int 13h
        jnc .end

        popa
        
        pusha
        mov ah, 0
        stc
        int 13h
        jc disk_error

        popa

        dec di
        test di, di
        jnz .begin

    .end:
        popa

        pop di
        pop dx
        pop cx
        pop bx
        pop ax

    ret

conv_lba_to_chs:
    ; cylinder = (lba / (heads * sectors))
    ; head = (lba / sectors) % heads
    ; sector = lba % sectors

    ; cylinder
    push ax
    push dx

    xor dx, dx
    div word [sectors_per_track]

    inc dx
    mov cx, dx

    xor dx, dx
    div word [number_of_heads]

    mov dh, dl
    mov ch, al
    shl ah, 6
    or cl, ah

    pop ax
    mov dl, al
    pop ax

    ret

disk_error:
    mov bx, FAILED_TO_READ_DISK_MESSAGE
    call print_string

    jmp halt_cpu

STARTUP_MESSAGE:                db 'Startup sequence'           , 13, 10, 0
FAILED_TO_READ_DISK_MESSAGE:    db 'Failed to read the disk.'   , 13, 10, 0
SUCCESS_MESSAGE:                db 'File loaded.'               , 13, 10, 0

; Boot partition signature
times 510-($-$$) db 0 ; fill remainder of sector with zeros
dw 0xAA55 ; signature
