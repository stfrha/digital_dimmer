*** readme.txt ***
Spartan-3E Sample Pack Dice Demo

------------------------------------------------------------------------------------
----	Revision History (files)								  ----	
------------------------------------------------------------------------------------
Rev	Date			User	Notes
----  ----------------- ----  ------------------------------------------------------
v1.0 	Nov. 4, 2005 	sus	Initial release 	

------------------------------------------------------------------------------------
----	Quick Description										  ----	
------------------------------------------------------------------------------------

The reference design provides a simple dice demo.  When BTN1 is pressed a new number 
will be shown on the LEDs.  The default design is loaded such that the dice came is
loaded into the FPGA using BPI-DN configuration.  BPI-DN configuration occurs after
MultiBoot is triggered in the Circling LEDs demo.

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
Spartan-3E 100-TQ144

------------------------------------------------------------------------------------
----	How to use this ref design?								  ----
------------------------------------------------------------------------------------

- Open the project 'Dice.ise' in Project Navigator.  Note:  You can not have two
  instances of Project Navigator open at the same time.
- Highlight 'Dice' in the 'Sources in Project' pane.  If you want to make
  changes or would like to see the HDL code then double click on 
  'Dice.vhd' in 'Sources in Project' pane. This will open the VHDL file 
  for you to modify if you wish.  Be sure to save changes if you have modified the
  file before proceeding. 
- In the 'Processes for Source' pane double click on 'Generate Programming File'
	to generate a configration file (BIT) for this project.  This will generate 
	'dice.bit' in the project directory.
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

- To download the design to the FPGA using the Intel StrataFlash refer to the
	flashwriter project.  The flashwriter tool will require the configuration
	image in binary (BIN) format.  The default dice demo is stored in the 
	StrataFlash such that it will configure in BPI-DN mode.  To convert the BIT 
	file to BIN file that will configure in BPI-DN mode use the following command
	line PROMGEN command:
	promgen -w -p bin -c FF -o dice_bpi_down.bin -d FFFFF dice.bit

------------------------------------------------------------------------------------
----	FILE STRUCTURE for DiceDemo distribution						  ----	
------------------------------------------------------------------------------------

/ {root}
readme.txt 	--> This file
divce.ise 	--> ISE project file
dice.vhd	--> VHDL file for dice demo
dice.ucf	--> Pin location constraints for Spartan-3E Sample Pack board

------------------------------------------------------------------------------------
END OF FILE README.TXT
------------------------------------------------------------------------------------





