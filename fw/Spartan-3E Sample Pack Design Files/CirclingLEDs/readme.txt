*** readme.txt ***
Spartan-3E Sample Pack Circling LEDS and MultiBoot reference design

------------------------------------------------------------------------------------
----	Revision History (files)								  ----	
------------------------------------------------------------------------------------
Rev	Date			User	Notes
----  ----------------- ----  ------------------------------------------------------
v1.0 	Nov. 4, 2005 	sus	Initial release 	

------------------------------------------------------------------------------------
----	Quick Description										  ----	
------------------------------------------------------------------------------------

The reference design provides a simple circling LED design for the Spartan-3E Sample 
Pack board.  The design shows trailing LEDs circling around six LEDs on the
sample pack board.  Further, this design demonstrates the MultiBoot functionality.
The default project is configured from the StrataFlash in BPI-UP mode.  If BTN1 is
pressed then a MultiBoot event is triggered and the device will automaically 
reconfigure in BPI-DN mode.  

The design files are provided in VHDL.

------------------------------------------------------------------------------------
----	Reference documents									  ----	
------------------------------------------------------------------------------------

To learn more about Spartan-3E and MultiBoot configuration mode refer to the 
datasheet at:

http://direct.xilinx.com/bvdocs/publications/ds312.pdf

------------------------------------------------------------------------------------
----	Tools verified on										  ----
------------------------------------------------------------------------------------

Xilinx ISE 7.1.04i

------------------------------------------------------------------------------------
----	Target Devices										  ----
------------------------------------------------------------------------------------

The design files included can target following Xilinx architectures:
Spartan-3E XC3S100E-TQ144

------------------------------------------------------------------------------------
----	How to use this ref design?								  ----
------------------------------------------------------------------------------------

- Open the project 'Counter-Multi.ise' in Project Navigator. Note:  You can not have two
  instances of Project Navigator open at the same time.
- Highlight 'demowithstartup' in the 'Sources in Project' pane.  If you want to make
  changes or would like to see the HDL code then double click on 
  'Demowithstartup.vhd' in 'Sources in Project' pane. This will open the VHDL file 
  for you to modify if you wish.  Be sure to save changes if you have modified the
  file before proceeding. 
- In the 'Processes for Source' pane double click on 'Generate Programming File'
	to generate a configration file (BIT) for this project.  This will generate 
	'demowithstartup.bit' in the project directory.
	Note:  The process is complete when a green check mark is visible next to 
		 "Generate Programming File"
-  Download the Design
	1. Connect a JTAG3 cable from your PC to the JP1 header on the 
	   sample pack board and press the On/Off button (BTN2).
	2. Open iMPACT by double clicking on 'Configure Device (iMPACT)' 
	   under 'Generate Programming File'.  
	3. In the window 'Configure Devices' select 'Boundary-Scan Mode' and click
	   'Next'	
	4. In the next window 'Boundary-Scan Mode Selection' select 'Automatically
	   connect to cable and identify Boundary-Scan chain' and click on 'Finish'
	5. In the window 'Assign new configuration file' assign the bit file name 
	   'demowithstartup.bit'.
	   Note:  The warning 'iMPACT:2257...' can be safely ignored.  The startup
		    clock JtagClk has been changed to match the configuration mode.
	6. Right click on the Xilinx device graphic and select 'Program...'
	7. In the window 'Program Options' you do not need select the 'Verify' 
	   check box at this time.  Instead click 'OK'
	8. 'Programming Successful' will be displayed in a blue box if device has
	   been successfully configured.

Downloading from StrataFlash into FPGA
- To download the design to the FPGA using the Intel StrataFlash refer to the
	flashwriter project.  The flashwriter tool will require the configuration
	image in binary (BIN) format.  The default design 'circling LEDs' is stored 
	in the StrataFlash and configures in BPI-UP mode.  To convert a BIT 
	file to BIN file to configure in BPI-UP mode use the following 
	PROMGEN command:
	promgen -w -p bin -c FF -o circlingLEDs_bpi_up.bin -u 0 demowithstartup.bit

	Note:  In this case circlingLEDs_bpi_up.bin is the output binary file but can
		 be renamed to the name of the user's choice.
------------------------------------------------------------------------------------
----	FILE STRUCTURE for DiceDemo distribution						  ----	
------------------------------------------------------------------------------------

/ {root}
readme.txt 			--> This file
Counter-Multi.ise 	--> ISE project file
DemoWithStartUp.vhd	--> VHDL file for Circling LEDs and MultiBoot
pin.ucf			--> Pin location constraints for Spartan-3E Sample Pack board

------------------------------------------------------------------------------------
END OF FILE README.TXT
------------------------------------------------------------------------------------




