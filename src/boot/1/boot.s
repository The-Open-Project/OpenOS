[ORG 0x7C00]
[BITS 16]

%define ENDL 13, 10

;
; FAT12 header
; 
    jmp short start
    nop

oem_name:               db 'MSWIN4.1'           ; 8 bytes
bytes_per_sector:       dw 512
sectors_per_cluster:    db 1
reserved_sectors:       dw 1
fat_count:              db 2
dir_entries_count:      dw 224
total_sectors:          dw 2880                 ; 2880 * 512 = 1.44MB
media_descriptor_type:  db 0xF0                 ; F0 = 3.5" floppy disk
sectors_per_fat:        dw 9                    ; 9 sectors/fat
sectors_per_track:      dw 18
heads:                  dw 2
hidden_sectors:         dd 0
large_sector_count:     dd 0

; extended boot record
drive_number:           db 0                    ; 0x00 floppy, 0x80 hdd, useless
winnt_flags:            db 0                    ; reserved
signature:              db 0x28
volume_id:              dd 0x4A3B2C1D   ; serial number, value doesn't matter
volume_label:           db 'NO NAME    '        ; 11 bytes, padded with spaces
system_id:              db 'FAT12   '           ; 8 bytes

;
; Code goes here
;

start:
    ; setup data segments
    xor ax, ax           ; can't set ds/es directly
    mov ds, ax
    mov es, ax
    
    ; setup stack
    mov ss, ax
    mov sp, 0x7C00

    ; some BIOSes might start us at 07C0:0000 instead of 0000:7C00, make sure we are in the
    ; expected location
    push es
    push word .rl
    retf

    .rl:
        mov al, 0x03
        mov ah, 0
        int 0x10

        ; read something from floppy disk
        ; BIOS should set DL to drive number
        mov [drive_number], dl

        ; show loading message
        mov si, BOOTING_MSG
        call puts

        ; read drive parameters (sectors per track and head count)
        push es
        mov ah, 08h
        int 13h
        jc generic_error
        pop es

        and cl, 0x3F                    ; remove top 2 bits
        xor ch, ch
        mov [sectors_per_track], cx     ; sector count

        inc dh
        mov [heads], dh                 ; head count

        ; compute LBA of root directory = reserved + fats * sectors_per_fat
        ; note: this section can be hardcoded
        mov ax, [sectors_per_fat]
        mov bl, [fat_count]
        xor bh, bh
        mul bx                              ; ax = (fats * sectors_per_fat)
        add ax, [reserved_sectors]          ; ax = LBA of root directory
        push ax

        ; compute size of root directory = (32 * number_of_entries) / bytes_per_sector
        mov ax, [dir_entries_count]
        shl ax, 5                           ; ax *= 32
        xor dx, dx                          ; dx = 0
        div word [bytes_per_sector]         ; number of sectors we need to read

        test dx, dx                         ; if dx != 0, add 1
        jz .root_dir_after
        inc ax                              ; division remainder != 0, add 1
                                            ; this means we have a sector only partially filled with entries
    .root_dir_after:

        ; read root directory
        mov cl, al                          ; cl = number of sectors to read = size of root directory
        pop ax                              ; ax = LBA of root directory
        mov dl, [drive_number]              ; dl = drive number (we saved it previously)
        mov bx, buffer                      ; es:bx = buffer
        call disk_read

        ; search for XLOADER
        xor bx, bx
        mov di, buffer

    .search_second_stage:
        mov si, BOOTLOADER_FILE
        mov cx, 11                          ; compare up to 11 characters
        push di
        repe cmpsb
        pop di
        je .found_second_stage

        add di, 32
        inc bx
        cmp bx, [dir_entries_count]
        jl .search_second_stage

        ; second_stage not found
        jmp no_bootloader_error

    .found_second_stage:

        ; di should have the address to the entry
        mov ax, [di + 26]                   ; first logical cluster field (offset 26)
        mov [stage2_cluster], ax

        ; load FAT from disk into memory
        mov ax, [reserved_sectors]
        mov bx, buffer
        mov cl, [sectors_per_fat]
        mov dl, [drive_number]
        call disk_read

        ; read second_stage and process FAT chain
        mov bx, STAGE2_LOAD_SEGMENT
        mov es, bx
        mov bx, STAGE2_LOAD_OFFSET

    .load_second_stage_loop:
        
        ; Read next cluster
        mov ax, [stage2_cluster]
        
        add ax, 31                          ; first cluster = (stage2_cluster - 2) * sectors_per_cluster + start_sector
                                            ; start sector = reserved + fats + root directory size = 1 + 18 + 134 = 33
        mov cl, 1
        mov dl, [drive_number]
        call disk_read

        add bx, [bytes_per_sector]

        ; compute location of next cluster
        mov ax, [stage2_cluster]
        mov cx, 3
        mul cx
        mov cx, 2
        div cx                              ; ax = index of entry in FAT, dx = cluster mod 2

        mov si, buffer
        add si, ax
        mov ax, [ds:si]                     ; read entry from FAT table at index ax

        or dx, dx
        jz .even

    .odd:
        shr ax, 4
        jmp .next_cluster_after

    .even:
        and ax, 0x0FFF

    .next_cluster_after:
        cmp ax, 0x0FF8                      ; end of chain
        jae .read_finish

        mov [stage2_cluster], ax
        jmp .load_second_stage_loop

    .read_finish:
        
        ; jump to our second_stage
        mov dl, [drive_number]          ; boot device in dl

        mov ax, STAGE2_LOAD_SEGMENT         ; set segment registers
        mov ds, ax
        mov es, ax

        jmp STAGE2_LOAD_SEGMENT:STAGE2_LOAD_OFFSET

        jmp halt


    ;
    ; Error handlers
    ;

generic_error:
    mov si, GENERIC_ERR_MSG
    call puts
    jmp halt

no_bootloader_error:
    mov si, BOOTLOADER_NOT_FOUND_MSG
    call puts
    jmp halt

halt:
    cli                         ; disable interrupts, this way CPU can't get out of halt" state
    hlt


    ;
    ; Prints a string to the screen
    ; Params:
    ;   - ds:si points to string
    ;

    .loop:
        lodsb               ; loads next character in al
        or al, al           ; verify if next character is null?
        jz .done

        mov ah, 0x0E        ; call bios interrupt
        mov bh, 0           ; set page number to 0
        int 0x10

        jmp .loop

    .done:
        pop bx
        pop ax
        pop si    
        ret

; pointer to first character is in si register
puts:
    ; save registers we will modify
    push ax
    push bx

    .loop:
        lodsb
        or al, al
        jz .end

        mov ah, 0x0E
        int 0x10

        jmp .loop

    .end:

    pop bx
    pop ax
    ret

;
; Disk routines
;

;
; Converts an LBA address to a CHS address
; Parameters:
;   - ax: LBA address
; Returns:
;   - cx [bits 0-5]: sector number
;   - cx [bits 6-15]: cylinder
;   - dh: head
;

lba_to_chs:

    push ax
    push dx

    xor dx, dx                          ; dx = 0
    div word [sectors_per_track]    ; ax = LBA / SectorsPerTrack
                                        ; dx = LBA % SectorsPerTrack

    inc dx                              ; dx = (LBA % SectorsPerTrack + 1) = sector
    mov cx, dx                          ; cx = sector

    xor dx, dx                          ; dx = 0
    div word [heads]                ; ax = (LBA / SectorsPerTrack) / Heads = cylinder
                                        ; dx = (LBA / SectorsPerTrack) % Heads = head
    mov dh, dl                          ; dh = head
    mov ch, al                          ; ch = cylinder (lower 8 bits)
    shl ah, 6
    or cl, ah                           ; put upper 2 bits of cylinder in CL

    pop ax
    mov dl, al                          ; restore DL
    pop ax
    ret


;
; Reads sectors from a disk
; Parameters:
;   - ax: LBA address
;   - cl: number of sectors to read (up to 128)
;   - dl: drive number
;   - es:bx: memory address where to store read data
;
disk_read:

    pusha

    push cx                             ; temporarily save CL (number of sectors to read)
    call lba_to_chs                     ; compute CHS
    pop ax                              ; AL = number of sectors to read
    
    mov ah, 02h
    mov di, 3                           ; retry count

    .retry:
        pusha                               ; save all registers, we don't know what bios modifies
        stc                                 ; set carry flag, some BIOS'es don't set it
        int 13h                             ; carry flag cleared = success
        jnc .done                           ; jump if carry not set

        ; read failed
        popa
        call disk_reset

        dec di
        test di, di
        jnz .retry

    .fail:
        ; all attempts are exhausted
        jmp generic_error

    .done:
        popa

        popa
        ret


;
; Resets disk controller
; Parameters:
;   dl: drive number
;
disk_reset:
    pusha
    mov ah, 0
    stc
    int 13h
    jc generic_error
    popa
    ret

stage2_cluster:             dw 0

BOOTING_MSG:                db 'Booting...', ENDL, 0
GENERIC_ERR_MSG:            db 'Failed to read disk', ENDL, 0
BOOTLOADER_NOT_FOUND_MSG:   db 'Cannot find bootloader', ENDL, 0
BOOTLOADER_FILE:            db 'XLOADER    '

STAGE2_LOAD_SEGMENT         equ 0x0
STAGE2_LOAD_OFFSET          equ 0x500

    times 510-($-$$) db 0
    db 0x55, 0xAA

buffer: