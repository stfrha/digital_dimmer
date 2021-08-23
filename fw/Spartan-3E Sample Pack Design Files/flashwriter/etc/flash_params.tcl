set FLASH_FILE          "C:/temp/rufino/led_counter/led_counter_bpi_up.bin" ;# Image file to program the flash with
set FLASH_PROG_OFFSET   0x0000E423                 ;# Offset at which the image should be programmed within flash

set FLASH_PROG_MODE     "STREAMING"                  ;# OneShot or Streaming mode
set FLASH_BASEADDR      0x20400000                 ;# Base address of flash device
set FLASH_BUSWIDTH      8                          ;# Device bus width of all flash parts combined
set SCRATCH_BASEADDR    0x00000000                 ;# Base address of scratch memory
set XMD_CONNECT         "connect mb mdm -cable type xilinx_parallel port LPT1 -debugdevice cpunr 1" ;# Target Command to connect to XMD
set TARGET_TYPE         "MICROBLAZE"               ;# Target processor type
set PROC_INSTANCE       "microblaze_0"             ;# Processor Instance name
set FLASH_BOOT_CONFIG 	BOTTOM_BOOT_FLASH
set COMPILER_FLAGS      -mxl-soft-mul

