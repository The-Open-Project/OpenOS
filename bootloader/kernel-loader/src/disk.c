#include <stdint.h>
#include <priv/asmdecls.h>
#include <priv/sharedfat.h>

struct _DISK
{
    uint8_t id;
    uint16_t cylinders;
    uint16_t heads;
    uint16_t sectors;
};

bool diskinit(DISK *disk, uint8_t drive)
{
        
}
void lbatochs(DISK *disk, uint32_t lba, uint16_t *cylinder, uint16_t *head, uint16_t *sector);
int readsectors(DISK *disk, uint32_t lba, uint8_t sectors, uint8_t *buffer);
int resetdisk(DISK *disk);
int readdiskparams(uint8_t drive, uint8_t *drivetype, uint16_t *cylinders, uint16_t *heads, uint16_t *sectors);
