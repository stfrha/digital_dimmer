# -------------------------------------------------------------------------------------------
#
# Legal notice:    All rights strictly reserved. Reproduction or issue to third parties in
#                  any form whatever is not permitted without written authority from the
#                  proprietors.
#
# -------------------------------------------------------------------------------------------
#
# File name:       $Id: util.tcl,v 1.7 2007/03/07 17:13:55 lra Exp $
#
# Classification:
# FHL:             Company confidential (intern)
# SekrL:           Unclassified
#
# Coding rules:    N/A
#
# Description:     Misc. Tcl utility procedures
#
# Known errors:    None
#
# To do:           See TODO comments in code, if any.
#
# -------------------------------------------------------------------------------------------
#
# Revision history:
#
# $Log: util.tcl,v $
# Revision 1.7  2007/03/07 17:13:55  lra
# Corrected spelling in header
#
# Revision 1.6  2007/03/02 14:52:45  lra
# Fixed insanely long log message line.
# Updated comment on printRunTime().
#
# Revision 1.5  2007/02/23 10:35:31  stfrka
# Changed printRunTime procedure in util.tcl to be able to present a build summary as in
# do_cpx.tcl. Had to change all .tcl files that used printRunTime (one argument more in new
# procedure).
#
# Revision 1.4  2007/01/23 16:28:43  lra
# Made the printUserInfo argument to waitForLicense() optional.
# Added waitForSingleLicense().
#
# Revision 1.3  2007/01/09 16:06:02  sne
# Changed back to original. The one line version has been moved to a branch "BRANCH_ECPX".
#
# Revision 1.2  2007/01/09 16:00:07  sne
# Information will only be printed on one line.
#
# Revision 1.1  2006/12/01 10:53:05  lra
# File moved to new location
#
# Revision 1.6  2006/12/01 10:37:34  lra
# Removed waitForLicenseInfo. Added printUserInfo option to waitForLicense instead.
#
# Revision 1.5  2006/11/30 19:18:39  lra
# Modified waitForLicenseInfo so that output is more meaningful
#
# Revision 1.4  2006/11/30 15:52:54  sne
# waitForLicense changed back to its original function.
# waitForLicenseInfo added with the occupied user/computer name information printouts.
#
# Revision 1.3  2006/11/28 17:16:38  sne
# User name and computer name will be displayed when synplify license is occupied.
#
# Revision 1.2  2006/09/15 15:53:56  lra
# Minor cleanup to standardise headers
#
# Revision 1.1  2006/09/15 14:44:45  lra
# File added to CVS
#
# -------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------
# Simple procedure to calculate and print elapsed run time.
# Run time is also returned via the t argument.
# startTime and stopTime should be set using the clock seconds command.
# -------------------------------------------------------------------------------------------
proc printRunTime { t startTime stopTime } {

   upvar $t rhms

   set rhms(runTime) [expr "$stopTime - $startTime"]

   set rhms(hours)   [expr "$rhms(runTime) / 3600" ];
   set rhms(minutes) [expr "($rhms(runTime) - $rhms(hours) * 3600) / 60" ]
   set rhms(seconds) [expr "($rhms(runTime) - $rhms(hours) * 3600 - $rhms(minutes) * 60)" ]

   puts "\nRun time: $rhms(hours)h $rhms(minutes)min $rhms(seconds)s"
}

# -------------------------------------------------------------------------------------------
# Simple procedure to execute a non-interactive command-line application and display its
# output on the tclsh console.
# -------------------------------------------------------------------------------------------
proc executeCommandLine { commandLine } {

   puts "\nExecuting: $commandLine\n"

   set readPipe [open "|$commandLine" r]

   while {![eof $readPipe]} { puts [gets $readPipe] }

   close $readPipe
}

# -------------------------------------------------------------------------------------------
# Simple procedure to execute a non-interactive command-line application and display its
# output on the tclsh console.
# -------------------------------------------------------------------------------------------
proc silentExecuteCommandLine { commandLine } {

   set readPipe [open "|$commandLine" r]

   while {![eof $readPipe]} { gets $readPipe }

   close $readPipe
}

# -------------------------------------------------------------------------------------------
# Procedure to wait for a license to become available.
#
# Based on an original idea by strino.
#
# lmutil lmstat is called on $server every $interval ms, until a license for any of the
# features in $featureList becomes available.
#
# If the printUserInfo flag is true, procedure will also continuously print user information
# for each feature in $featureList while waiting.
#
# -------------------------------------------------------------------------------------------
proc waitForLicense { server featureList interval { printUserInfo false } } {

   # Regular expression for extracting feature lines in output from lmutil.
   # Example matching line:
   # Users of VBHDLW_NT:  (Total of 8 licenses issued;  Total of 1 license in use)
   set regularExpr {synplifypro.*synplctyd}

   # Regular expression for extracting user info lines in output from lmutil.
   # Example matching line:
   #     stpxan ST-W289 ST-W289 (v2004.08999) (KARJALA.saabtech.se/7592 119), start Wed 11/22 9:15
   set regularExprUserInfo {^    (\w+) (\S+).*\(.*\) \(.*\), start.*$}


   while (true) {

      set isAvailableLicense true

      # Run lmutil and store result string
      set lmutilResult [ exec lmutil lmstat -a -c $server ]

      # Split result string into separate lines
      set lineList [ split $lmutilResult \n ]

      # Search through lines for an available license
      foreach line $lineList {

      if [ regexp $regularExpr $line match ] {
         set isAvailableLicense false
         break
      }



   }
   if $isAvailableLicense {
         break;
   }

   after $interval

  }
}

# -------------------------------------------------------------------------------------------
# Procedure to wait for a license to become available.
#
# Based on an original idea by strino.
#
# Simplified version of waitForLicense() above. Checks for only a single feature, and also
# assumes that there is at most one license issued for that feature.
#
# lmutil lmstat is called on $server every $interval ms, until a license for $feature
# becomes available.
#
# If the printUserInfo flag is true, procedure will also continuously print information
# about the user holding the license while waiting.
#
# -------------------------------------------------------------------------------------------
proc waitForSingleLicense { server feature interval { printUserInfo false } } {

   # Regular expression for extracting feature lines in output from lmutil.
   # Example matching line:
   # Users of VBHDLW_NT:  (Total of 8 licenses issued;  Total of 1 license in use)
   set regularExpr\
{^Users of (\w+):  \(Total of (\d+) license[s]* issued\;  Total of (\d+) license[s]* in use\)}

   # Regular expression for extracting user info lines in output from lmutil.
   # Example matching line:
   #     stpxan ST-W289 ST-W289 (v2004.08999) (KARJALA.saabtech.se/7592 119), start Wed 11/22 9:15
   set regularExprUserInfo {^    (\w+) (\S+).*\(.*\) \(.*\), start.*$}

   set isAvailableLicense false

   while { true } {

      # Run lmutil and store result string
      catch {set lmutilResult [ exec lmutil lmstat -a -c $server ]}

      # Split result string into separate lines
      set lineList [ split $lmutilResult \n ]

      # Search through lines for an available license
      foreach line $lineList {

         if [ regexp $regularExpr $line match lineFeature issued inUse ] {

            if { $lineFeature == $feature } {

               if { $inUse < $issued } {

                  set isAvailableLicense true

                  break
               }
            }
         }
      }

      if $isAvailableLicense {
         break
      }

      # No license is available.

      if $printUserInfo {

         # Search through lines again and print user info for $feature.

         set isUserFound false

         set lineNo 0
         while { $lineNo < [llength $lineList] } {

            set line [lindex $lineList $lineNo]
            if [ regexp $regularExpr $line match lineFeature issued inUse ] {

               if { $lineFeature == $feature } {

                  incr lineNo
                  set line [lindex $lineList $lineNo]

                  while { $lineNo < [llength $lineList] &&
                          ![ regexp $regularExpr $line match lineFeature issued inUse ]} {

                     if [regexp $regularExprUserInfo $line match user computer] {
                        puts "User of feature $feature: $user on $computer"
                        set isUserFound true
                        break
                     }

                     incr lineNo
                     set line [lindex $lineList $lineNo]
                  }

                  if $isUserFound {
                     break
                  }

               } else {
                  incr lineNo
               }

            } else {
               incr lineNo
            }
         }
      }

      # Wait for a while and then try again.
      after $interval
   }
}
