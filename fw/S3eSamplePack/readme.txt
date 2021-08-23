Version 1.0.0.0 beta (first public beta)


Getting started:
================
1) connect Sample Pack board to Cable III (or compatible) JTAG Cable
2) power it up
3) Start application

if your Parallel port is not at default address then edit pinapi.ini
before starting the application to reflect your proper LPT base address


FPGA Programming
================

Select from main menu, or right click on FPGA image or drop .BIT file

FPGA configuration startup clock is automatically fixed if needed


Flash Programming
=================

Select from main menu, or right click on Flash image,
the .BIT file is automatically fixed if startup clock was wrong
and the bit reversal and load order is auto adjusted

additional Flash functions
readback reading blocks 0 to 7 into readback.bin in application exe dir
FPGA can be forced to be configured from primary or secondary config
image stored in the flash


Tools
=====
included as demo is Frequncy meter, select Tool->Frequency Meter
to measure the clock frquency of the LTC6905 clock IC (nomimal 50MHz)



Known issues:

1) Flash programming can not be aborted
2) Auto-starts with auto-connect and auto starts boundary scan
3) help is not included or integrated
4) drag-drop only starts FPGA programing, dropping files for Flash is not supported
5) limited support for download cables and hardware
6) cable detect and error reporting troubleshooting not included
7) many other things possible
8) board health diagnostic not included
9) many more? found one, send email to bugs@xilant.com

http://www.xilant.com






