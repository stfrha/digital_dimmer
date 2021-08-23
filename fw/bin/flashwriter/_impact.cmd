setMode -bs
setCable -port auto
identify
identifyMPM
setAttribute -position 1 -attr configFileName -value "implementation/download.bit"
program -p 1 
quit
