*** readme.txt ***
Spartan-3E Sample Pack Flashwriter

------------------------------------------------------------------------------------
----	Revision History (files)								  ----	
------------------------------------------------------------------------------------
Rev	Date			User	Notes
----  ----------------- ----  ------------------------------------------------------
v1.0 	Nov. 4, 2005 	sus	Initial release 	

------------------------------------------------------------------------------------
----	Quick Description										  ----	
------------------------------------------------------------------------------------

The application note provides an easy to use reference design and instructions on 
how to program the Intel StrataFlash on the Spartan-3E Sample Pack board.  The 
methodology uses a custom flash writer designed for a MicroBlaze system using the 
Embedded Development Kit.  This demonstrates an easy and low-cost method to 
configure parallel NOR flash connected to an FPGA.

The design files are provided as an Embedded Development Kit (EDK) project.

------------------------------------------------------------------------------------
----	Reference documents									  ----	
------------------------------------------------------------------------------------

Spartan-3E Sample Pack board User's Guide.

------------------------------------------------------------------------------------
----	Tools verified on										  ----
------------------------------------------------------------------------------------

Xilinx ISE 7.1.04i
Xilinx EDK 7.1.02i

------------------------------------------------------------------------------------
----	Target Devices										  ----
------------------------------------------------------------------------------------

The design files included can target following Xilinx architectures:
Spartan-3E XC3S100E-TQ144

------------------------------------------------------------------------------------
----	How to use this ref design?								  ----
------------------------------------------------------------------------------------

- Open the project 'system.xmp' in Xilinx Platform Studio (EDK)
- Within a text editor verify that the 'flash_params.tcl' file has the correct file
	to download and correct offset.  The 'flash_params.tcl' file can be found in 
	the project>etc directory.  The FLASH_FILE path must include complete file 
	name path.  
	Refer to the readme.txt for the specific project that you want to run for 
	the promgen command to generate the binary (.bin) file.

The file used should be a binary file.
	For BPI-UP configuration the 
		FLASH_PROG_OFFSET = 0x0000E423
	For BPI-DN configuration
		FLASH_PROG_OFFSET = 0x000E0000

- Connect the JTAG cable to Spartan-3E Sample Pack board on JP2.

- Go to the ‘Tools’ menu and click on ‘Generate Libraries and BSP’ to generate the 
	software libraries that the flash writer utilizes.

- Go to the ‘Tools’ menu and click on ‘Download’ to download the Flashwriter 
	hardware to the Spartan-3E device on the Sample Pack board.

- Go to the ‘Tools’ menu and click on ‘Xilinx Command Shell’ to open a command 
	prompt.

- In the new Command Shell, type ‘xmd –tcl flashwriter.tcl’ to start the 
	flash writer software.

- Note that the flash writer software may take a few minutes depending on the 
	size of the file to program.  An example of the status output is shown 
	in output.txt.

- The flashwriter is complete when it says :
	"Programming completed successfully.
	 Processor started. Type "stop" to stop processor
       Flashwriter terminating..."
	 Additionally the command prompt will re-appear.

- Congratulations.  You've just re-programmed the StrataFlash with a new image.
To see the new design press toggle the power button twice.

------------------------------------------------------------------------------------
----	FILE STRUCTURE for flashwriter distribution					  ----	
------------------------------------------------------------------------------------

/ {root}
readme.txt 		--> This file
flaswriter.tcl 	--> TCL script used to execute the flashwriter
platgen.opt		--> Platgen command options file
system.mhs		--> Microprocessor Hardware Definitions file
system.mss		--> Microprocessor Software Definitions file
system.xps		--> Xilinx Platform Studio


/ sw_services 	--> Custom Flashwriter software

/pcore		--> Custom cores for Sample Pack board

/data		--> User constraints file

/etc		--> Tool command options

------------------------------------------------------------------------------------
END OF FILE README.TXT
------------------------------------------------------------------------------------





