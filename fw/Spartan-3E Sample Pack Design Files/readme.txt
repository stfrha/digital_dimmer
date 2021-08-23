*** readme.txt ***
Spartan-3E Sample Pack Description and Introduction

------------------------------------------------------------------------------------
----	Revision History (files)						----	
------------------------------------------------------------------------------------
Rev	Date			User	Notes
----  ----------------- ----  ------------------------------------------------------
v1.0 	Nov. 4, 2005 	sus	Initial release 	

------------------------------------------------------------------------------------
----	Quick Description							----	
------------------------------------------------------------------------------------
Included in this project are four directories.

	- CirclingLEDs.  	This is the default design first loaded in the FPGA via 
			     	BPI-UP mode.  The LEDs circle in a clock-wise fashion.  
			     	Pressing BTN2 will trigger a MultiBoot event to reconfigure
			     	the FPGA in BPI-DOWN mode with the Dice game.	

	- DiceDemo.		This design mimics the rolling of a die normally used in a 
				dice game. The design is loaded in the FPGA via the BPI-DOWN
				mode when BTN2 pressed.	

	- LED_counter.		This design mimics a counter.  The center LED counts each 
				second.  After each 10 seconds another LED is lit until
				all LEDs are on signifying 60 seconds have elapsed.
	
	- FlashWriter.		The application note provides an easy to use reference design 
				and instructions on how to program the Intel StrataFlash on 
				the Spartan-3E Sample Pack board.  

------------------------------------------------------------------------------------
END OF FILE README.TXT
------------------------------------------------------------------------------------




