# -------------------------------------------------------------------------------------------
#
# Legal notice:    All rights strictly reserved. Reproduction or issue to third parties in
#                  any form whatever is not permitted without written authority from the
#                  proprietors.
#
# -------------------------------------------------------------------------------------------
#
# File name:       $Id: do_test.tcl,v 1.1 2007/03/08 13:09:59 lra Exp $
#
# Classification:
# FHL:             Company confidential (intern)
# SekrL:           Unclassified
#
# Coding rules:    N/A
#
# Description:     Regression test simulation script.
#
#                  Can also be used to run the same simulation inside the ModelSim GUI.
#                  To do this, run the script with -guimode as the first argument.
#
# Known errors:    None
#
# To do:           See TODO comments in code, if any.
#
# -------------------------------------------------------------------------------------------
#
# Revision history:
#
# $Log: do_test.tcl,v $
# Revision 1.1  2007/03/08 13:09:59  lra
# File added to CVS
#
# -------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------
# Define general parameters
# -------------------------------------------------------------------------------------------

# Define the name of this script for recursive calls
set scriptName "do_test.tcl"

# List source files to be compiled
set fileList {

   ../../source/ir_decoder.vhd
   ir_decoder_tb.vhd
}

# Define top level entity to be simulated
set topLevel ir_decoder_tb

# -------------------------------------------------------------------------------------------
# Define GUI mode specific parameters
# -------------------------------------------------------------------------------------------

# Define signals, if any, to be viewed in the wave window.
set wavePatterns {
   "/*"
}

# Define non-default radices, if any, to be used in the wave window.
set waveRadices {
}

# Define GUI simulator invocation string
set vsimGui "vsim -t 1ps $topLevel"

# After sourcing the script from ModelSim for the first time, these commands can be used
# to recompile.
proc rr {} {
   global scriptName
   uplevel #0 do $scriptName -modelsim_invoked
}

proc q {} {
   quit -force
}

# -------------------------------------------------------------------------------------------
# Define regression test specific parameters
# -------------------------------------------------------------------------------------------

# Define simulator command line invocation string
# NOTE: Simulation will stop at any assertion of severity 'error' or above.
set vsimCmdLine "vsim -c -t 1ps -do \"set BreakOnAssertion 2; run -all; quit -f\" $topLevel"

# Runs regression tests on submodules, if any
proc subModulesTest {} {
}

# -------------------------------------------------------------------------------------------
# Perform the actual work
# -------------------------------------------------------------------------------------------
if { $argc > 0 && [lindex $argv 0] == "-guimode" } {

   # ----------------------------------------------------------------------------------------
   # Script called with the -guimode switch
   # ----------------------------------------------------------------------------------------

   # Start ModelSim in GUI mode and call this script again with the -modelsim_invoked switch
   exec modelsim -do "do $scriptName -modelsim_invoked"

} elseif { [info exists 1] && $1 == "-modelsim_invoked" } {

   # IMPORTANT NOTE: Must use $1, $2 etc to retrieve arguments to a script run from inside
   #                 ModelSim. $argc, $argv will return the arguments to ModelSim...

   # ----------------------------------------------------------------------------------------
   # Script invoked with the -modelsim switch
   # Run simulation from inside the ModelSim GUI
   # ----------------------------------------------------------------------------------------

   # Prefer a fixed point font for the transcript
   set PrefMain(font) {Courier 10 roman normal}

   # Create work library if necessary
   vlib work

   # Compile files
   foreach file $fileList {
      vcom $file
   }

   # Load the simulation
   eval $vsimGui

   # Default waveform radix
   radix -hexadecimal

   # Setup waveforms
   if [llength $wavePatterns] {

      noview wave

      foreach pattern $wavePatterns {
         add wave $pattern
      }

      configure wave -signalnamewidth 1

      foreach {radix signals} $waveRadices {
         foreach signal $signals {
            property wave -radix $radix $signal
         }
      }
   }

   # Run the simulation

   # NOTE: This allows all signals of the design to be watched in the wave window after
   #       simulation. May require impossible amounts of memory if design is large or
   #       simulation runs for a long time.
   add log -r *

   run -all

   wave zoomfull

   # Print some useful info
   puts {
Script commands are:

rr = Recompile everything
q  = Quit without confirmation

   }

} else {

   # ----------------------------------------------------------------------------------------
   # Run regression test simulation from the command line
   # ----------------------------------------------------------------------------------------

   # Run regression test on submodules
   subModulesTest

   # Create work library if necessary
   exec vlib work

   # Compile files
   foreach file $fileList {
      exec vcom $file
   }

   # Run the simulation
   set msg [eval "exec $vsimCmdLine"]
   
   # Search for errors in simulator output
   set msg_err\
   [lsearch -regexp [split $msg \n] "^# \[\x2A\]\[\x2A\] (Fatal|Failure|Error):.*$"]

   if {$msg_err != -1} {
      puts \
"\n========================================================================\
\nREGRESSION TEST SIMULATION OF $topLevel FAILED\
\n========================================================================\
\n\n$msg\
\n\n========================================================================"
      exit 1
   } else {
      puts "Regression test simulation of $topLevel completed successfully."
   }
}
