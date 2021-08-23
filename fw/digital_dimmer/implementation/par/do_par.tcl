# ------------------------------------------------------------------------------------------
#
# Legal notice:   All rights strictly reserved. Reproduction or issue to third parties in
#                 any form whatever is not permitted without written authority from the
#                 proprietors.
#
# ------------------------------------------------------------------------------------------
#
# File name:      $Id: do_par.tcl,v 1.1 2007/04/19 15:45:03 frha Exp $
#
# Classification:
# FHL:            Company confidential (intern)
# SekrL:          Unclassified
#
# Coding rules:   N/A
#
# Description:    This Tcl script will place and route the input netlist.
#
#                 ¤ The input files to this script (vmx.edf, vmx.ncf, and all
#                   all fifo netlists (*.edn)) needs to be located in the same 
#                   directory as the Tcl script itself.
#
#                 ¤ In the system path enviroment variable, the path to the Xilinx
#                   directory is needed in order to run the place and route programs.
#
# Known errors:   None
#
# To do:          See TODO comments in code, if any.
#
# ------------------------------------------------------------------------------------------
#
# Revision history:
#
# $Log: do_par.tcl,v $
# Revision 1.1  2007/04/19 15:45:03  frha
# First check in of vp vmx.
#
#
# -------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------
# Include utility procedures
# -------------------------------------------------------------------------------------------
if [catch {source ../../../tools/build_utilities/util.tcl}] {
   source ../../../../tools/build_utilities/util.tcl
   set ucfDir "../../par"
} else {
   set ucfDir "."
} ;# if

# -------------------------------------------------------------------------------------------
# Define design name
# -------------------------------------------------------------------------------------------
set design digital_dimmer

# -------------------------------------------------------------------------------------------
# Define FPGA device
# -------------------------------------------------------------------------------------------
set device "xc3s100E-tQ144-4"

# -------------------------------------------------------------------------------------------
# Define FPGA configuration options for the bitgen program
# -------------------------------------------------------------------------------------------
set configOptions "
-g DebugBitstream:No
-g DonePipe:Yes
-g DriveDone:Yes
-g UnusedPin:PullUp
-g DONE_cycle:6
-g GTS_cycle:6
-g GWE_cycle:1
-g LCK_cycle:2
-g Match_cycle:2
"

# -------------------------------------------------------------------------------------------
# Begin processing
# -------------------------------------------------------------------------------------------
puts "\nPlace And Route Run"

# -------------------------------------------------------------------------------------------
# Get and store start time
# -------------------------------------------------------------------------------------------
set startTime [clock seconds]
puts [clock format $startTime -format "\nStart time: %H:%M:%S"]

# -------------------------------------------------------------------------------------------
# The commands to be used in the place and route. To see all options type the program
# name at a command promt and they will be listed, eg. "c:\ngdbuild" -> enter.
#
# The environment variable XIL_PLACE_ALLOW_LOCAL_BUFG_ROUTING must be set to be able
# to use clock inputs on non clock buffered pins.
# -------------------------------------------------------------------------------------------
set env(XIL_PLACE_ALLOW_LOCAL_BUFG_ROUTING) 1

executeCommandLine "ngdbuild -dd _ngo -p $device -uc ${ucfDir}/${design}.ucf ${design}.edf"
executeCommandLine "map -p $device -pr b -o ${design}_map.ncd ${design}.ngd ${design}.pcf"
executeCommandLine "par -w ${design}_map.ncd ${design}.ncd ${design}.pcf"
executeCommandLine "trce -e -xml ${design}.twx -o ${design}.twr ${design}.ncd ${design}.pcf"
executeCommandLine "bitgen -w $configOptions ${design}.ncd ${design}.bit ${design}.pcf"
executeCommandLine "promgen -p mcs -o ${design}.mcs -s 4096 -w -u 0 ${design}.bit"
executeCommandLine "promgen -w -p bin -c FF -o ${design}.bin -u 0 ${design}.bit"

# -------------------------------------------------------------------------------------------
# Get and store stop time
# -------------------------------------------------------------------------------------------
set stopTime [clock seconds]
puts [clock format $stopTime -format "\nStop time: %H:%M:%S"]

# -------------------------------------------------------------------------------------------
# Declare array for time information and calculate and print run time
# -------------------------------------------------------------------------------------------
array set PnRrhms {runtime 0 hours 0 minutes 0 seconds 0}
printRunTime PnRrhms $startTime $stopTime
