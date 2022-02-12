#include <stdint.h>
#include <stdbool.h>
#include <priv/asmdecls.h>

typedef uint8_t byte;
typedef uint16_t word;
typedef uint32_t dword;
typedef uint64_t qword;

typedef struct _FAT_TIME {
    word hour    : 5;
    word minutes : 6;
    word seconds : 5; 
} FAT_TIME;

typedef struct _FAT_DATE
{
    word hour    : 5;
    word minutes : 6;
    word seconds : 5; // multiply by two
} FAT_DATE;

enum FILE_ATTRIBUTES {
    READ_ONLY = 0x01,
    HIDDEN    = 0x02,
    SYSTEM    = 0x04,
    VOLUME_ID = 0x08,
    DIRECTORY = 0x10,
    ARCHIVE   = 0x20,
    LONG_FILE_NAME = (READ_ONLY | HIDDEN | SYSTEM | VOLUME_ID)
};

typedef struct _BOOTSECTOR {
    /* BIOS parameter block (BPB) */
    
    byte    jmp[3];
    byte    oem_id[8];
    word    bytes_per_sector;
    byte    sectors_per_cluster;
    word    reserved_sectors;
    byte    fat_count;
    word    root_entries;
    word    total_sectors;
    byte    media_descriptor;
    word    sectors_per_fat;
    word    sectors_per_track;
    word    head_count;
    dword   hidden_sectors_count;
    dword   large_sectors_count;

    /* Extended boot record */
    
    byte    drive_number;
    byte    winnt_flags;
    byte    signature;
    dword   serial_number;
    byte    volume_label[11];
    byte    system_id[8];
} __attribute__((packed)) BOOTSECTOR;

typedef struct _DIRENT {
    byte            filename[11];
    byte            attributes;
    byte            reserved;
    byte            creation_time_tenths;
    FAT_TIME        creation_time;
    FAT_DATE        creation_date;
    FAT_DATE        last_acc_date;
    word            first_cluster_high;
    FAT_TIME        last_mod_time;
    FAT_DATE        last_mod_date;
    word            first_cluster_low;
    dword           filesize;
} __attribute__((packed)) DIRECTORY_ENTRY;

