# ------------------------------------------------------------------------------------------
#
# Legal notice:   All rights strictly reserved. Reproduction or issue to third parties in
#                 any form whatever is not permitted without written authority from the
#                 proprietors.
#
# ------------------------------------------------------------------------------------------
#
# File name:      $Id: do_synt.tcl,v 1.1 2007/04/19 15:45:03 frha Exp $
#
# Classification:
# FHL:            Company confidential (intern)
# SekrL:          Unclassified
#
# Coding rules:   N/A
#
# Description:    This Tcl script will synthesise the input vhdl code and constraints
#
#                  ¤ Input files to this script are '*.prj', '*.vhd', and '*.sdc'.
#                    '*.prj' needs to be located in the same directory as the Tcl script.
#                    '*.vhd' and '*.sdc' files are placed in the source directory
#                    specified in the '*.prj' file.
#
#                  ¤ In the system path enviroment variable, the path to the synplify
#                    directory is needed in order to run synplify_pro.exe.
#
#                  ¤ In the '*.prj' file the result file should point to the synt run
#                    directory as follows 'project -result_file "./synt_run/cpx.edf"'.
#
# Known errors:   None
#
# To do:          See TODO comments in code, if any.
#
# ------------------------------------------------------------------------------------------
#
# Revision history:
#
# $Log: do_synt.tcl,v $
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
} ;# if

# -------------------------------------------------------------------------------------------
# Define design name
# -------------------------------------------------------------------------------------------
set design digital_dimmer

# -------------------------------------------------------------------------------------------
# Begin processing
# -------------------------------------------------------------------------------------------
puts "\nSynthesis Run"

# -------------------------------------------------------------------------------------------
# Get and store start time
# -------------------------------------------------------------------------------------------
set startTime [clock seconds]
puts [clock format $startTime -format "\nStart time: %H:%M:%S"]

# -------------------------------------------------------------------------------------------
# If necessary, wait for a Synplify license.
#
# NOTE: Currently, this waiting scheme is not perfect. There is a possibility that even if a
#       license is available when waitForLicenseInfo returns, it may no longer be available when
#       synplify_pro is called. However, this situation should be rare in practice.
#
# -------------------------------------------------------------------------------------------

puts "\nWaiting to get Synplify license..."
#waitForSingleLicense 7592@KARJALA [list synplifypro] 5000 1
waitForLicense 7592@KARJALA [list synplifypro] 5000 1

# -------------------------------------------------------------------------------------------
# Start a batch run with the Synplify project
# -------------------------------------------------------------------------------------------

executeCommandLine\
"synplify_pro -batch ${design}.prj"

# -------------------------------------------------------------------------------------------
# Copy the netlist and netlist constraint file to the place and route directory
# -------------------------------------------------------------------------------------------

puts "\nCopying result files..."
file copy -force ./synt_run/${design}.edf ../par/${design}.edf
file copy -force ./synt_run/${design}.ncf ../par/${design}.ncf

# -------------------------------------------------------------------------------------------
# Get and store stop time
# -------------------------------------------------------------------------------------------
set stopTime [clock seconds]
puts [clock format $stopTime -format "\nStop time: %H:%M:%S"]

# -------------------------------------------------------------------------------------------
# Declare array for time information and calculate and print run time
# -------------------------------------------------------------------------------------------
array set Syntrhms {runtime 0 hours 0 minutes 0 seconds 0}
printRunTime Syntrhms $startTime $stopTime
