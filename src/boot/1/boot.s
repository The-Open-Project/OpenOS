[ORG 0x7C00]
[BITS 16]

jmp short main ; short jmp
nop

; BIOS parameter block
oem_id:                         db 'MSWIN4.1'
bytes_per_sector:               dw 512
sectors_per_cluster:            db 2
reserved_sectors:               dw 11
number_of_fats:                 db 2
root_entries:                   dw 224
total_sectors:                  dw 5760 ; 2.88 MB floppy
media_descriptor:               db 0xF0
sectors_per_fat:                dw 9
sectors_per_track:              dw 0x24
number_of_heads:                dw 0x2
hidden_sectors:                 dd 0
large_sector_count:             dd 0

; Extended boot record
physical_drive_number:          db 0x0
winnt_flags:                    db 0
signature:                      db 0x28
serial_number:                  dd 0x4A3B2C1D
volume_label:                   db 'NO NAME    '
system_id:                      db 'FAT12   '

main:
    SECOND_STAGE_SEGMENT equ 0x0000
    SECOND_STAGE_OFFSET equ 0x7E00 ; constant that evaluates to the location
                                   ; where the second-stage bootloader will be loaded

    mov [physical_drive_number], dl ; save drive number

    ; setup stack
    xor ax, ax
    mov es, ax
    mov ds, ax ; zero out ds and es

    mov sp, 0x7C00
    mov bp, sp ; set sp and bp to start of program

    mov ax, 0x03
    int 0x10

    mov si, BOOTING_MESSAGE
    call putstr

    ; reading the second-stage bootloader from disk
    mov ah, 0x02 ; function 02h of INT 13h

    mov al, 10 ; 3 sectors to read

    mov ch, 0x0 ; 0th (1st) cylinder
    mov dh, 0x0 ; 0th (1st) head
    mov cl, 0x2 ; 2nd sector (for some reason, sectors start at 1 and cylinder and head start at 0)

    ; mov es, 0 (ex is already 0)
    mov bx, SECOND_STAGE_OFFSET ; load sectors into es:bx, i.e. 0x0000:0x1000 because es is already 0
    mov dl, [physical_drive_number] ; the drive number we saved earlier

    push dx ; ! save dx for later
    int 0x13 ; call INT 13h, function 02h (read sectors from disk)
    pop dx ; pop dx for passing as parameter for second-stage bootloader

    jc .read_disk_error ; if carry flag is set, then an error occurred while reading disk

    or ah, ah ; test if ah is zero
    jne .read_disk_error ; if ah is not zero, then an error occurred

    ; we made it. we can now jump to our second-stage bootloader.
    mov si, SUCCESS_SWITCH_MESSAGE
    call putstr

    jmp SECOND_STAGE_SEGMENT:SECOND_STAGE_OFFSET

    jmp .generic_error ; if we get here, something wrong definitely happened
    jmp .halt

    .halt:
        cli
        hlt

    .generic_error:
        mov si, GENERIC_FAILED_MESSAGE
        call putstr
        jmp .press_any_key_reboot

    .read_disk_error:
        mov si, ERROR_READ_DISK_MESSAGE
        call putstr
        jmp .press_any_key_reboot

    .press_any_key_reboot:
        mov si, PRESS_ANY_KEY_MESSAGE
        call putstr
        jmp .soft_reboot

    .soft_reboot:
        call wmrbt

; variables

BOOTING_MESSAGE:            db 'Attempting to boot OpenOS...', 13, 10, 0
GENERIC_FAILED_MESSAGE:     db 'Boot sequence failed!', 13, 10, 0 ; only if error is unknown
ERROR_READ_DISK_MESSAGE:    db 'Error reading disk!', 13, 10, 0 ; if INT 13h failed
SUCCESS_SWITCH_MESSAGE:     db 'No errors. Switching to second-stage bootloader...', 13, 10, 0
PRESS_ANY_KEY_MESSAGE:      db 'Press any key to restart... ', 0

; functions

; putchar - print character to BIOS
; character in al register
putchar:
    mov ah, 0x0E
    int 0x10
    ret

; putstr - print string to BIOS
; pointer to first character of null-terminated string in si register
putstr:
    .loop:
        lodsb ; load next byte from si into the al register
        
        or al, al ; test if NUL byte
        jz .end ; if it is, exit the loop

        call putchar ; print character in al

        jmp .loop ; restart the loop

    .end:
    ret ; return

; wmrbt - soft restart
wmrbt:
    jmp 0xFFFF:0x0000 ; jump to start of BIOS

    cli
    hlt ; if that doesn't work for some reason, clear interrupt flag and halt CPU

[BITS 32]
pmodeex:
    jmp SECOND_STAGE_SEGMENT:SECOND_STAGE_OFFSET ; jump to second-stage bootloader location

times 510-($-$$) db 0 ; fill rest of file with zeros
db 0x55, 0xAA ; 0x55AA bootsector signature
