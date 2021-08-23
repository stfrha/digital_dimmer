#include "portab.h"

#ifndef _FS_FLASH_H
#define _FS_FLASH_H

/* Supported part layouts   */
#define PART_LAYOUT_UNKNOWN     0xfffff                 /* Un-determinable layout               */
#define PART_LAYOUT_08_08_1     0x08081                 /* 8-bit data bus  - Single 8-bit part  */
#define PART_LAYOUT_16_16_1     0x10101                 /* 16-bit data bus - Single 16-bit part */
#define PART_LAYOUT_16_08_2     0x10082                 /* 16-bit data bus - Two 8-bit parts    */
#define PART_LAYOUT_32_08_4     0x20084                 /* 32-bit data bus - Four 8-bit parts   */
#define PART_LAYOUT_32_16_2     0x20102                 /* 32-bit data bus - Two 16-bit parts   */
#define PART_LAYOUT_32_32_1     0x20201                 /* 32-bit data bus - Single 32-bit part */

#define PART_WIDTH_08               8
#define PART_WIDTH_16              16
#define PART_WIDTH_32              32

#define PART_WIDTH(layout)      ((layout & 0xff0) >> 4)        
#define PART_COUNT(layout)      ((layout & 0xf))        

#define MAX_ERASE_REGIONS           32

typedef struct cfi_qry_s  {
    uint8_t  qrystr[3];       
    uint16_t pri_vendor_id;
    uint16_t pri_addr;
    uint16_t alt_vendor_id;
    uint16_t alt_addr;
    uint8_t  vccmin;       
    uint8_t  vccmax;
    uint8_t  vppmin;
    uint8_t  vppmax;
    uint8_t  word_write_timeout;
    uint8_t  buffer_write_timeout;
    uint8_t  block_erase_timeout;
    uint8_t  full_erase_timeout;
    uint8_t  word_write_max_timeout;
    uint8_t  buffer_write_max_timeout;
    uint8_t  block_erase_max_timeout;
    uint8_t  full_erase_max_timeout;
    uint8_t  partsiz;       
    uint16_t interface_desc;
    uint16_t max_write_buf_siz;
    uint8_t  num_erase_regions;
    uint32_t erase_region_info[1];       
} __attribute__ ((packed)) cfi_qry_t;


struct dev_info_s;

typedef void    (*init_dev_params_t)(struct dev_info_s *);
typedef void    (*rst_dev_t      )(void);
typedef int8_t  (*erase_dev_t    )(void);
typedef int8_t  (*blk_erase_dev_t)(uint32_t);
typedef int8_t  (*prog_dev_t     )(uint32_t, uint8_t*, uint32_t);

typedef struct target_ops_s {
    init_dev_params_t   initdev;                /* Pointers to interface routines       */
    rst_dev_t           rstdev;                 /*  .  */
    erase_dev_t         erasedev;               /*  .  */
    blk_erase_dev_t     blkerasedev;            /*  .  */
    prog_dev_t          progdev;                /*  .  */
} target_ops_t;

typedef struct region_info_s {
    uint32_t  offset;
    uint32_t  nblks;
    uint32_t  blksiz;
} region_info_t;

typedef struct flash_geometry_s {
    uint32_t      tot_regions;
    uint32_t      tot_blks;
    region_info_t region[MAX_ERASE_REGIONS];
} flash_geometry_t;


typedef struct dev_info_s {
    cfi_qry_t           cfiqry;
    uint32_t            bus_width;
    uint32_t            base_addr;
    uint8_t             part_width;
    uint8_t             num_parts;
    uint8_t             addr_step;
    uint8_t             addr_shift;
    uint16_t            vend_id;
    flash_geometry_t    flgeo;
    target_ops_t        *devops;
} dev_info_t;

#endif /* _FS_FLASH_H */

volatile dev_info_t devinfo;
int main ()
{

    /* devinfo.bus_width;
    devinfo.base_addr;
    devinfo.part_width;
    devinfo.num_parts;
    devinfo.addr_step;
    devinfo.addr_shift;
    */
    devinfo.cfiqry.qrystr[0] = 0xAA;
    devinfo.cfiqry.pri_vendor_id = 0xBBCC;
    devinfo.cfiqry.interface_desc = 0xCCDD;
    devinfo.cfiqry.vccmin = 0xEE;
    devinfo.vend_id = 0x1122;
    //devinfo.flgeo;
}
