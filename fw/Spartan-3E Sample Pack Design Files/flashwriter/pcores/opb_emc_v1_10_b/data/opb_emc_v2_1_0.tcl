###############################################################################
##
## Copyright (c) 2003 Xilinx, Inc. All Rights Reserved.
## DO NOT COPY OR MODIFY THIS FILE. 
## THE CONTENTS AND METHODOLOGY MAY CHANGE IN FUTURE RELEASES.
##
## opb_emc_v2_1_0.tcl
##
###############################################################################

## @BEGIN_CHANGELOG EDK_Gm_SP2
##
## changed common library version from emc_common_v1_10_b to emc_common_v2_00_a
##
## @END_CHANGELOG

#***--------------------------------***------------------------------------***
#
#			     IPLEVEL_DRC_PROC
#
#***--------------------------------***------------------------------------***


#
# 1. check address range
#    if C_DEV_MIR_ENABLE = 1 then C_HIGHADDR - C_BASEADDR >= 0x144
#
# 2. check C_MAX_MEM_WIDTH
#    C_MAX_MEM_WIDTH = max(C_MEMx_WIDTH)
#
proc check_iplevel_settings {mhsinst} {

    set mhs_handle [xget_handle $mhsinst "parent"]
    xload_library $mhs_handle emc_common_v2_00_a
    
    hw_emc_common_v2_00_a::check_addr_range  $mhsinst
    hw_emc_common_v2_00_a::check_max_mem_width $mhsinst

}
