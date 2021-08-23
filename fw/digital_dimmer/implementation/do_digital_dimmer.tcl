# ------------------------------------------------------------------------------------------
#
# Legal notice:   All rights strictly reserved. Reproduction or issue to third parties in
#                 any form whatever is not permitted without written authority from the
#                 proprietors.
#
# ------------------------------------------------------------------------------------------
#
# File name:      $Id: do_vmx.tcl,v 1.1 2007/04/19 15:45:03 frha Exp $
#
# Classification:
# FHL:            Company confidential (intern)
# SekrL:          Unclassified
#
# Coding rules:   N/A
#
# Description:    This Tcl script will build a complete FPGA from source code to bit file.
#                 It will also pars result logs to extract errors or warnings.
#
# Known errors:   None
#
# To do:          See TODO comments in code, if any.
#
# ------------------------------------------------------------------------------------------
#
# Revision history:
#
# $Log: do_vmx.tcl,v $
# Revision 1.1  2007/04/19 15:45:03  frha
# First check in of vp vmx.
#
#
# -------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------
# Current design name
# -------------------------------------------------------------------------------------------
set design digital_dimmer

# -------------------------------------------------------------------------------------------
# Save current directory to return to
# -------------------------------------------------------------------------------------------
set returnDir [pwd]

# ----------------------------------------------------------------------------------------
# Goto synt directory and execute the Tcl script
# ----------------------------------------------------------------------------------------
cd synt
source do_synt.tcl
cd ..

# ----------------------------------------------------------------------------------------
# Goto place and route directory and execute the Tcl scripts building the cores and 
# performing the place and route.
# ----------------------------------------------------------------------------------------
cd par
exec tclsh do_par.tcl > par.log
cd ..

# ----------------------------------------------------------------------------------------
# Print out errors, warnings and other problems from Synplify
# ----------------------------------------------------------------------------------------
set     search {^@W: \w* \|Cannot.*$}

set fp [open "synt/synt_run/${design}.srr" r]
while {[expr ![eof $fp]]} {
   gets $fp line
   if [regexp -all $search $line] {
      puts $line
   };# if
};# while
close $fp

# ----------------------------------------------------------------------------------------
# Print out errors, warnings and other problems from ISE
# ----------------------------------------------------------------------------------------
set     search {^ERROR:.*$}
lappend search {^WARNING:.*$}
lappend search {^INFO:Place:834 - Only a subset of IOs are locked.*$}
lappend search {^INFO:Par:62 - Your design did not meet timing.*$}

set fp [open "par/par.log" r]
while {[expr ![eof $fp]]} {
   gets $fp line
   foreach s $search {
      if [regexp -all $s $line] {
         puts $line
      };# if
   };# foreach
};# while
close $fp

# ----------------------------------------------------------------------------------------
# Print out missing LOC's from pad file
# ----------------------------------------------------------------------------------------
# |AM13      |yrdy_n      |IOB      |IO_L25N_CC_LC_8     |INPUT    |LVDCI_33   |8             |          |         |           |NONE     |         |LOCATED   |         |NO         |NONE            |
# |AK21      |sysclkx2    |IOB      |IO_L5P_GC_LC_4      |INPUT    |LVCMOS25   |4             |          |         |           |NONE     |         |          |         |NO         |NONE            |
# ----------------------------------------------------------------------------------------
set search {^\|[^\|]*\|([^ \|]+)[^\|]*\|([^\|]*\|){10,10}\s}

set fp [open "par/${design}_pad.txt" r]
while {[expr ![eof $fp]]} {
   gets $fp line
   if [regexp -all $search $line match port] {puts "Warning: Port \"$port\" should be locked in UCF file"};# if
};# while
close $fp

cd $returnDir
