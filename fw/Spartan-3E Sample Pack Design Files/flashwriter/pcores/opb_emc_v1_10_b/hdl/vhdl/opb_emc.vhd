-------------------------------------------------------------------------------
-- $Id: opb_emc.vhd,v 1.2 2003/04/01 20:30:47 anitas Exp $
-------------------------------------------------------------------------------
-- opb_emc.vhd - Entity
-------------------------------------------------------------------------------
--
--  ***************************************************************************
--  **  Copyright(C) 2003 by Xilinx, Inc. All rights reserved.               **
--  **                                                                       **
--  **  This text contains proprietary, confidential                         **
--  **  information of Xilinx, Inc. , is distributed by                      **
--  **  under license from Xilinx, Inc., and may be used,                    **
--  **  copied and/or disclosed only pursuant to the terms                   **
--  **  of a valid license agreement with Xilinx, Inc.                       **
--  **                                                                       **
--  **  Unmodified source code is guaranteed to place and route,             **
--  **  function and run at speed according to the datasheet                 **
--  **  specification. Source code is provided "as-is", with no              **
--  **  obligation on the part of Xilinx to provide support.                 **
--  **                                                                       **
--  **  Xilinx Hotline support of source code IP shall only include          **
--  **  standard level Xilinx Hotline support, and will only address         **
--  **  issues and questions related to the standard released Netlist        **
--  **  version of the core (and thus indirectly, the original core source). **
--  **                                                                       **
--  **  The Xilinx Support Hotline does not have access to source            **
--  **  code and therefore cannot answer specific questions related          **
--  **  to source HDL. The Xilinx Support Hotline will only be able          **
--  **  to confirm the problem in the Netlist version of the core.           **
--  **                                                                       **
--  **  This copyright and support notice must be retained as part           **
--  **  of this text at all times.                                           **
--  ***************************************************************************
--
-------------------------------------------------------------------------------
-- Filename:        opb_emc.vhd
-- Version:         v1.10b
-- Description:     This is the top-level design file for the OPB External
--                  Memory Controller. 
--
-- VHDL-Standard:   VHDL'93
-------------------------------------------------------------------------------
-- Structure:
--
--              opb_emc.vhd
--                  -- opb_ipif.vhd
--                  -- emc.vhd
--                      -- addr_counter_mux.vhd
--                      -- data_path.vhd
--                      -- io_registers.vhd
--                      -- mem_state_machine.vhd
--                      -- select_param.vhd
--                      -- wait_states.vhd
-------------------------------------------------------------------------------
-- Author:      DAB
-- History:
--  DAB      04-30-2002      -- First version
--  JAM      10-10-2002      -- Added functions to modify ARD arrays
--
--  ALS            11-28-2002
-- ^^^^^^
--  Version 1.10a created to include bus width/mem data width matching.
-- ~~~~~~
--  ALS            03-19-03
-- ^^^^^^
--  Version 1.10b created to include generics for positive edge/negative edge
--  io registers.
-- ~~~~~~~
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x"
--      reset signals:                          "rst", "rst_n"
--      generics:                               "C_*"
--      user defined types:                     "*_TYPE"
--      state machine next state:               "*_ns"
--      state machine current state:            "*_cs"
--      combinatorial signals:                  "*_cmb"
--      pipelined or register delay signals:    "*_d#"
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce"
--      internal version of output port         "*_i"
--      device pins:                            "*_pin"
--      ports:                                  - Names begin with Uppercase
--      processes:                              "*_PROCESS"
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_misc.all;
--
-- library unsigned is used for overloading of "=" which allows integer to
-- be compared to std_logic_vector
use ieee.std_logic_unsigned.all;

library Unisim;
use Unisim.all;

library proc_common_v1_00_b;
use proc_common_v1_00_b.proc_common_pkg.all;
use proc_common_v1_00_b.family.all;
use proc_common_v1_00_b.all;

library ipif_common_v1_00_a;
use ipif_common_v1_00_a.ipif_pkg.all;
use ipif_common_v1_00_a.all;


library opb_ipif_v2_00_a;
use opb_ipif_v2_00_a.all;



library emc_common_v1_10_b;
use emc_common_v1_10_b.all;

-------------------------------------------------------------------------------
-- Definition of Generics:
--  C_NUM_BANKS_MEM                 --  Number of memory banks
--  C_INCLUDE_NEGEDGE_IOREGS        --  include negative edge IO registers
--  C_BASEADDR                      --  Base address for EMC control registers
--  C_HIGHADDR                      --  High address for EMC control registers
--  C_MEM(0:7)_BASEADDR             --  Memory bank (0:7) base address
--  C_MEM(0:7)_HIGHADDR             --  Memory bank (0:7) high address
--  C_MEM(0:7)_WIDTH                --  Memory bank (0:7) data width
--  C_MAX_MEM_WIDTH                 --  Maximum data width of all memory banks
--  C_INCLUDE_DATAWIDTH_MATCHING_(0:7)  --  Support data width matching for
--                                          memory bank (0:7) 
--  C_SYNCH_MEM_(0:7)               --  Memory bank (0:7) type
--  C_SYNCH_PIPEDELAY_(0:7)         --  Memory bank (0:7) synchronous pipe delay
--  C_RD_ADDR_TO_OUT_SLOW_PS_(0:7)  --  Slow Time that output en goes low.
--                                         Non-page reads.
--  C_WR_ADDR_TO_OUT_SLOW_PS_(0:7)  --  Slow Time that write en goes low.
--                                         Applies to all writes.
--  C_WR_MIN_PULSE_WIDTH_PS_(0:7)   --  Minimum time that write en goes low.
--                                         Applies to all writes.
--  C_RD_ADDR_TO_OUT_FAST_PS_(0:7)  --  Fast Time that output en goes low.
--                                         Non-page reads
--  C_WR_ADDR_TO_OUT_FAST_PS_(0:7)  --  Fast Time that write enable goes low.
--                                         Applies to all writes.
--  C_RD_RECOVERY_BEFORE_WRITE_PS_(0:7) --  Time of delay inserted before write en
--                                          goes low if previous access was read
--  C_WR_RECOVERY_BEFORE_READ_PS_(0:7)  --  Time of delay inserted before output en
--                                          goes low if previous access was write
--  C_OPB_DWIDTH                    --  OPB Data Bus Width
--  C_OPB_AWIDTH                    --  OPB Address Width
--  C_OPB_CLK_PERIOD_PS             --  OPB clock period to calculate wait
--                                         state pulse widths.
--  C_DEV_BLK_ID                    --  device block id to be read from MIR
--  C_DEV_MIR_ENABLE                --  include Module ID Register (MIR)
--
-- Definition of Ports:
-- OPB Interface
--  OPB_Clk                         -- OPB clock                                               
--  OPB_Rst                         -- OPB Reset                                               
--  OPB_ABus                        -- OPB address bus                                             
--  OPB_DBus                        -- OPB data bus                                                   
--  OPB_select                      -- OPB select                                    
--  OPB_RNW                         -- OPB read not write                                           
--  OPB_seqAddr                     -- OPB sequential address                              
--  OPB_BE                          -- OPB byte enables                                              
--  Sln_DBus                        -- Slave read bus                                         
--  Sln_xferAck                     -- Slave transfer acknowledge                            
--  Sln_errAck                      -- Slave error acknowledge
--  Sln_toutSup                     -- Slave timeout suppress
--  Sln_retry                       -- Slave retry
--
-- Memory Signals
--  Mem_A                           -- Memory address inputs
--  Mem_DQ_I                        -- Memory Input Data Bus
--  Mem_DQ_O                        -- Memory Output Data Bus
--  Mem_DQ_T                        -- Memory Data Output Enable
--  Mem_CEN                         -- Memory Chip Select
--  Mem_OEN                         -- Memory Output Enable
--  Mem_WEN                         -- Memory Write Enable
--  Mem_QWEN                        -- Memory Qualified Write Enable
--  Mem_BEN                         -- Memory Byte Enables
--  Mem_RPN                         -- Memory Reset/Power Down
--  Mem_CE                          -- Memory chip enable
--  Mem_ADV_LDN                     -- Memory counter advance/load (=0)
--  Mem_LBON                        -- Memory linear/interleaved burst order (=0)
--  Mem_CKEN                        -- Memory clock enable (=0)
--  Mem_RNW                         -- Memory read not write
-------------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Entity section
-----------------------------------------------------------------------------
entity opb_emc is
   -- Generics to be set by user
  generic (
    C_NUM_BANKS_MEM                   : integer range 1 to 8 := 2;
    C_INCLUDE_NEGEDGE_IOREGS          : integer := 0;
    C_BASEADDR                        : std_logic_vector := X"FFFF_FFFF";
    C_HIGHADDR                        : std_logic_vector := X"0000_0000";
    C_MEM0_BASEADDR                   : std_logic_vector := X"FFFF_FFFF";
    C_MEM0_HIGHADDR                   : std_logic_vector := X"0000_0000";
    C_MEM1_BASEADDR                   : std_logic_vector := X"FFFF_FFFF";
    C_MEM1_HIGHADDR                   : std_logic_vector := X"0000_0000";
    C_MEM2_BASEADDR                   : std_logic_vector := X"FFFF_FFFF";
    C_MEM2_HIGHADDR                   : std_logic_vector := X"0000_0000";
    C_MEM3_BASEADDR                   : std_logic_vector := X"FFFF_FFFF";
    C_MEM3_HIGHADDR                   : std_logic_vector := X"0000_0000";
    C_MEM4_BASEADDR                   : std_logic_vector := X"FFFF_FFFF";
    C_MEM4_HIGHADDR                   : std_logic_vector := X"0000_0000";
    C_MEM5_BASEADDR                   : std_logic_vector := X"FFFF_FFFF";
    C_MEM5_HIGHADDR                   : std_logic_vector := X"0000_0000";
    C_MEM6_BASEADDR                   : std_logic_vector := X"FFFF_FFFF";
    C_MEM6_HIGHADDR                   : std_logic_vector := X"0000_0000";
    C_MEM7_BASEADDR                   : std_logic_vector := X"FFFF_FFFF";
    C_MEM7_HIGHADDR                   : std_logic_vector := X"0000_0000";
    
    C_MEM0_WIDTH                      : integer := 32;
    C_MEM1_WIDTH                      : integer := 32;
    C_MEM2_WIDTH                      : integer := 32;
    C_MEM3_WIDTH                      : integer := 32;
    C_MEM4_WIDTH                      : integer := 32;
    C_MEM5_WIDTH                      : integer := 32;
    C_MEM6_WIDTH                      : integer := 32;
    C_MEM7_WIDTH                      : integer := 32;
    C_MAX_MEM_WIDTH                   : integer := 32;
    
    C_INCLUDE_DATAWIDTH_MATCHING_0    : integer := 1; 
    C_INCLUDE_DATAWIDTH_MATCHING_1    : integer := 1; 
    C_INCLUDE_DATAWIDTH_MATCHING_2    : integer := 1; 
    C_INCLUDE_DATAWIDTH_MATCHING_3    : integer := 1; 
    C_INCLUDE_DATAWIDTH_MATCHING_4    : integer := 1; 
    C_INCLUDE_DATAWIDTH_MATCHING_5    : integer := 1; 
    C_INCLUDE_DATAWIDTH_MATCHING_6    : integer := 1; 
    C_INCLUDE_DATAWIDTH_MATCHING_7    : integer := 1; 

    -- Memory read and write access times for all memory banks

    C_SYNCH_MEM_0                     : integer := 0;
    C_SYNCH_PIPEDELAY_0               : integer := 2;
    C_READ_ADDR_TO_OUT_SLOW_PS_0      : integer := 0;
    C_WRITE_ADDR_TO_OUT_SLOW_PS_0     : integer := 0;
    C_WRITE_MIN_PULSE_WIDTH_PS_0      : integer := 0;
    C_READ_ADDR_TO_OUT_FAST_PS_0      : integer := 0;
    C_WRITE_ADDR_TO_OUT_FAST_PS_0     : integer := 0;
    C_READ_RECOVERY_BEFORE_WRITE_PS_0 : integer := 0;
    C_WRITE_RECOVERY_BEFORE_READ_PS_0 : integer := 0;

    C_SYNCH_MEM_1                     : integer := 0;
    C_SYNCH_PIPEDELAY_1               : integer := 2;
    C_READ_ADDR_TO_OUT_SLOW_PS_1      : integer := 0;
    C_WRITE_ADDR_TO_OUT_SLOW_PS_1     : integer := 0;
    C_WRITE_MIN_PULSE_WIDTH_PS_1      : integer := 0;
    C_READ_ADDR_TO_OUT_FAST_PS_1      : integer := 0;
    C_WRITE_ADDR_TO_OUT_FAST_PS_1     : integer := 0;
    C_READ_RECOVERY_BEFORE_WRITE_PS_1 : integer := 0;
    C_WRITE_RECOVERY_BEFORE_READ_PS_1 : integer := 0;

    C_SYNCH_MEM_2                     : integer := 0;
    C_SYNCH_PIPEDELAY_2               : integer := 2;
    C_READ_ADDR_TO_OUT_SLOW_PS_2      : integer := 0;
    C_WRITE_ADDR_TO_OUT_SLOW_PS_2     : integer := 0;
    C_WRITE_MIN_PULSE_WIDTH_PS_2      : integer := 0;
    C_READ_ADDR_TO_OUT_FAST_PS_2      : integer := 0;
    C_WRITE_ADDR_TO_OUT_FAST_PS_2     : integer := 0;
    C_READ_RECOVERY_BEFORE_WRITE_PS_2 : integer := 0;
    C_WRITE_RECOVERY_BEFORE_READ_PS_2 : integer := 0;

    C_SYNCH_MEM_3                     : integer := 0;
    C_SYNCH_PIPEDELAY_3               : integer := 2;
    C_READ_ADDR_TO_OUT_SLOW_PS_3      : integer := 0;
    C_WRITE_ADDR_TO_OUT_SLOW_PS_3     : integer := 0;
    C_WRITE_MIN_PULSE_WIDTH_PS_3      : integer := 0;
    C_READ_ADDR_TO_OUT_FAST_PS_3      : integer := 0;
    C_WRITE_ADDR_TO_OUT_FAST_PS_3     : integer := 0;
    C_READ_RECOVERY_BEFORE_WRITE_PS_3 : integer := 0;
    C_WRITE_RECOVERY_BEFORE_READ_PS_3 : integer := 0;

    C_SYNCH_MEM_4                     : integer := 0;
    C_SYNCH_PIPEDELAY_4               : integer := 2;
    C_READ_ADDR_TO_OUT_SLOW_PS_4      : integer := 0;
    C_WRITE_ADDR_TO_OUT_SLOW_PS_4     : integer := 0;
    C_WRITE_MIN_PULSE_WIDTH_PS_4      : integer := 0;
    C_READ_ADDR_TO_OUT_FAST_PS_4      : integer := 0;
    C_WRITE_ADDR_TO_OUT_FAST_PS_4     : integer := 0;
    C_READ_RECOVERY_BEFORE_WRITE_PS_4 : integer := 0;
    C_WRITE_RECOVERY_BEFORE_READ_PS_4 : integer := 0;

    C_SYNCH_MEM_5                     : integer := 0;
    C_SYNCH_PIPEDELAY_5               : integer := 2;
    C_READ_ADDR_TO_OUT_SLOW_PS_5      : integer := 0;
    C_WRITE_ADDR_TO_OUT_SLOW_PS_5     : integer := 0;
    C_WRITE_MIN_PULSE_WIDTH_PS_5      : integer := 0;
    C_READ_ADDR_TO_OUT_FAST_PS_5      : integer := 0;
    C_WRITE_ADDR_TO_OUT_FAST_PS_5     : integer := 0;
    C_READ_RECOVERY_BEFORE_WRITE_PS_5 : integer := 0;
    C_WRITE_RECOVERY_BEFORE_READ_PS_5 : integer := 0;

    C_SYNCH_MEM_6                     : integer := 0;
    C_SYNCH_PIPEDELAY_6               : integer := 2;
    C_READ_ADDR_TO_OUT_SLOW_PS_6      : integer := 0;
    C_WRITE_ADDR_TO_OUT_SLOW_PS_6     : integer := 0;
    C_WRITE_MIN_PULSE_WIDTH_PS_6      : integer := 0;
    C_READ_ADDR_TO_OUT_FAST_PS_6      : integer := 0;
    C_WRITE_ADDR_TO_OUT_FAST_PS_6     : integer := 0;
    C_READ_RECOVERY_BEFORE_WRITE_PS_6 : integer := 0;
    C_WRITE_RECOVERY_BEFORE_READ_PS_6 : integer := 0;

    C_SYNCH_MEM_7                     : integer := 0;
    C_SYNCH_PIPEDELAY_7               : integer := 2;
    C_READ_ADDR_TO_OUT_SLOW_PS_7      : integer := 0;
    C_WRITE_ADDR_TO_OUT_SLOW_PS_7     : integer := 0;
    C_WRITE_MIN_PULSE_WIDTH_PS_7      : integer := 0;
    C_READ_ADDR_TO_OUT_FAST_PS_7      : integer := 0;
    C_WRITE_ADDR_TO_OUT_FAST_PS_7     : integer := 0;
    C_READ_RECOVERY_BEFORE_WRITE_PS_7 : integer := 0;
    C_WRITE_RECOVERY_BEFORE_READ_PS_7 : integer := 0;

    --Generics set for IPIF
    C_OPB_DWIDTH                      : integer := 32;
    C_OPB_AWIDTH                      : integer := 32;
    C_OPB_CLK_PERIOD_PS               : integer := 10000;
    C_DEV_BLK_ID                      : INTEGER := 1;
    
    C_DEV_MIR_ENABLE                  : INTEGER := 1
        );


  port
      (
       -- System Port Declarations ********************************************

       OPB_Clk         :   in std_logic;
       OPB_Rst         :   in std_logic;

       -- OPB Port Declarations ***********************************************
        OPB_ABus       : in std_logic_vector(0 to C_OPB_AWIDTH - 1 );
        OPB_DBus       : in std_logic_vector(0 to C_OPB_DWIDTH - 1 );
        Sln_DBus       : out std_logic_vector(0 to C_OPB_DWIDTH - 1 );
        OPB_select     : in std_logic := '0';
        OPB_RNW        : in std_logic := '0';
        OPB_seqAddr    : in std_logic := '0';
        OPB_BE         : in std_logic_vector(0 to C_OPB_DWIDTH/8 - 1 );
        Sln_xferAck    : out std_logic;
        Sln_errAck     : out std_logic;
        Sln_toutSup    : out std_logic;
        Sln_retry      : out std_logic;


       -- Memory signals 

       Mem_A                  : out   std_logic_vector(0 to C_OPB_AWIDTH-1);
       Mem_DQ_I               : in    std_logic_vector(0 to C_MAX_MEM_WIDTH-1);
       Mem_DQ_O               : out   std_logic_vector(0 to C_MAX_MEM_WIDTH-1);
       Mem_DQ_T               : out   std_logic_vector(0 to C_MAX_MEM_WIDTH-1);
       Mem_CEN                : out   std_logic_vector(0 to C_NUM_BANKS_MEM-1);
       Mem_OEN                : out   std_logic_vector(0 to C_NUM_BANKS_MEM-1);
       Mem_WEN                : out   std_logic;
       Mem_QWEN               : out   std_logic_vector(0 to C_MAX_MEM_WIDTH/8-1); --Qualified WE
       Mem_BEN                : out   std_logic_vector(0 to C_MAX_MEM_WIDTH/8-1);
       Mem_RPN                : out   std_logic;
       Mem_CE                 : out   std_logic_vector(0 to C_NUM_BANKS_MEM-1);
       Mem_ADV_LDN            : out   std_logic;
       Mem_LBON               : out   std_logic;
       Mem_CKEN               : out   std_logic;
       Mem_RNW                : out   std_logic
      );
      
end opb_emc;
-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
architecture implementation of opb_emc is

-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------
-- Function get_effective_mem_width sets the memory width to the bus width if
-- datawidth matching is included for that memory bank
function get_effective_mem_width(include_data_matching  : integer range 0 to 1;
                                 mem_width              : integer range 1 to 64;
                                 bus_width              : integer range 1 to 64)
                                 return integer is
    variable effective_mem_width : integer range 1 to 64;
begin
    if include_data_matching = 1 then
        effective_mem_width := bus_width;
    else
        effective_mem_width := mem_width;
    end if;
    return effective_mem_width;
end function get_effective_mem_width;

-------------------------------------------------------------------------------
-- Constant Declarations
-------------------------------------------------------------------------------
       constant OPB_DWIDTH          :  INTEGER := C_OPB_DWIDTH;
       constant OPB_AWIDTH          :  INTEGER := C_OPB_AWIDTH;
       constant IPIF_AWIDTH         :  INTEGER := C_OPB_AWIDTH;
       constant IPIF_DWIDTH         :  INTEGER := C_OPB_DWIDTH;
       constant INCLUDE_BURST       :  INTEGER := 0; -- burst not supported
       constant DEV_MAX_BURST_SIZE  :  INTEGER := 0;
-------------------------------------------------------------------------------
-- Constants used to calculate the offsets for the BASEADDR'S and HIGHADDR'S 
-- for the EMC Registers and IPIF Registers
-- These are the maximum values as noted in the Specification
-------------------------------------------------------------------------------
       constant BASEADDR            : std_logic_vector := C_BASEADDR;
                -- Base Address for the EMC Registers
       constant EMC_BASEADDR        : std_logic_vector := BASEADDR;
                -- High Address for the EMC Registers + "FF"
       constant EMC_HIGHADDR        : std_logic_vector := BASEADDR or X"0000_00FF";
                -- Base Address for the IPIF Registers beginning at next valid address
       constant IPIF_BASEADDR       : std_logic_vector := BASEADDR or X"0000_0100";
                -- High Address for the IPIF Registers + "FF"
       constant IPIF_HIGHADDR       : std_logic_vector := BASEADDR or X"0000_01FF";

-------------------------------------------------------------------------------
-- Necessary for SLV64_ARRAY_TYPE (64 bits wide) and everything else 32-bit
-------------------------------------------------------------------------------
       constant ZEROES              :  std_logic_vector := X"00000000";
-------------------------------------------------------------------------------
-- Constants necessary for IPIF arrays
-------------------------------------------------------------------------------
       constant IPIF_RST_OFFSET     :  std_logic_vector := X"00000040";
       constant IPIF_RST_BASEADDR   :  std_logic_vector := IPIF_BASEADDR or
                                                            IPIF_RST_OFFSET;

       Constant MCCR                : integer := 120;
       Constant MEM0                : integer := 121;
       Constant MEM1                : integer := 122;
       Constant MEM2                : integer := 123;
       Constant MEM3                : integer := 124;
       Constant MEM4                : integer := 125;
       Constant MEM5                : integer := 126;
       Constant MEM6                : integer := 127;
       Constant MEM7                : integer := 128;

-------------------------------------------------------------------------------
-- Create constant arrays for IPIF
-- Note that functions are used to correctly populate array entries
-------------------------------------------------------------------------------
       constant ARD_ID_ARRAY_IN : INTEGER_ARRAY_TYPE :=
               (
                MCCR,     -- Memory Control Register (MCCR)
                MEM0,     -- Memory Bank 0
                MEM1,     -- Memory Bank 1
                MEM2,     -- Memory Bank 2
                MEM3,     -- Memory Bank 3
                MEM4,     -- Memory Bank 4
                MEM5,     -- Memory Bank 5
                MEM6,     -- Memory Bank 6
                MEM7,     -- Memory Bank 7
                IPIF_RST         -- IPIF Reset

               );

        constant ARD_ADDR_RANGE_ARRAY_IN  : SLV64_ARRAY_TYPE :=
               (
                ZEROES & EMC_BASEADDR,       -- MCCR Base Address := X"2000_0000"
                ZEROES & EMC_HIGHADDR,       -- MCCR High Address := X"2FFF_FFFF"
                ZEROES & C_MEM0_BASEADDR,    -- Memory Bank 0     := X"3000_0000"
                ZEROES & C_MEM0_HIGHADDR,    -- Memory Bank 0     := X"3FFF_FFFF"
                ZEROES & C_MEM1_BASEADDR,    -- Memory Bank 1     := X"4000_0000"
                ZEROES & C_MEM1_HIGHADDR,    -- Memory Bank 1     := X"4FFF_FFFF"
                ZEROES & C_MEM2_BASEADDR,    -- Memory Bank 2     := X"5000_0000"
                ZEROES & C_MEM2_HIGHADDR,    -- Memory Bank 2     := X"5FFF_FFFF"
                ZEROES & C_MEM3_BASEADDR,    -- Memory Bank 3     := X"6000_0000"
                ZEROES & C_MEM3_HIGHADDR,    -- Memory Bank 3     := X"6FFF_FFFF"
                ZEROES & C_MEM4_BASEADDR,    -- Memory Bank 4     := X"7000_0000"
                ZEROES & C_MEM4_HIGHADDR,    -- Memory Bank 4     := X"7FFF_FFFF"
                ZEROES & C_MEM5_BASEADDR,    -- Memory Bank 5     := X"8000_0000"
                ZEROES & C_MEM5_HIGHADDR,    -- Memory Bank 5     := X"8FFF_FFFF"
                ZEROES & C_MEM6_BASEADDR,    -- Memory Bank 6     := X"9000_0000"
                ZEROES & C_MEM6_HIGHADDR,    -- Memory Bank 6     := X"9FFF_FFFF"
                ZEROES & C_MEM7_BASEADDR,    -- Memory Bank 7     := X"A000_0000"
                ZEROES & C_MEM7_HIGHADDR,    -- Memory Bank 7     := X"AFFF_FFFF"
                ZEROES & IPIF_RST_BASEADDR,  -- IPIF Reset base address
                ZEROES & IPIF_HIGHADDR       -- IPIF Reset high address
               );

        constant ARD_DWIDTH_ARRAY_IN     : INTEGER_ARRAY_TYPE :=
               (
                32,    --  MCCR data width
                get_effective_mem_width(C_INCLUDE_DATAWIDTH_MATCHING_0, C_MEM0_WIDTH, C_OPB_DWIDTH),
                get_effective_mem_width(C_INCLUDE_DATAWIDTH_MATCHING_1, C_MEM1_WIDTH, C_OPB_DWIDTH),
                get_effective_mem_width(C_INCLUDE_DATAWIDTH_MATCHING_2, C_MEM2_WIDTH, C_OPB_DWIDTH),
                get_effective_mem_width(C_INCLUDE_DATAWIDTH_MATCHING_3, C_MEM3_WIDTH, C_OPB_DWIDTH),
                get_effective_mem_width(C_INCLUDE_DATAWIDTH_MATCHING_4, C_MEM4_WIDTH, C_OPB_DWIDTH),
                get_effective_mem_width(C_INCLUDE_DATAWIDTH_MATCHING_5, C_MEM5_WIDTH, C_OPB_DWIDTH),
                get_effective_mem_width(C_INCLUDE_DATAWIDTH_MATCHING_6, C_MEM6_WIDTH, C_OPB_DWIDTH),
                get_effective_mem_width(C_INCLUDE_DATAWIDTH_MATCHING_7, C_MEM7_WIDTH, C_OPB_DWIDTH),
                32     --  IPIF Reset data width
               );

       constant ARD_NUM_CE_ARRAY_IN   : INTEGER_ARRAY_TYPE :=
               (
                8,     -- MCCR CE number
                1,     -- Memory Bank 0 CE number
                1,     -- Memory Bank 1 CE number
                1,     -- Memory Bank 2 CE number
                1,     -- Memory Bank 3 CE number
                1,     -- Memory Bank 4 CE number
                1,     -- Memory Bank 5 CE number
                1,     -- Memory Bank 6 CE number
                1,     -- Memory Bank 7 CE number
                1      -- IPIF Reset CE number
               );

-- functions to correctly populate the arrays
function Get_ARD_ADDR_RANGE_ARRAY return SLV64_ARRAY_TYPE is
  variable ARD_ADDR_RANGE_ARRAY_V : SLV64_ARRAY_TYPE(0 to 19);
begin
  ARD_ADDR_RANGE_ARRAY_V(0) := ARD_ADDR_RANGE_ARRAY_IN(0);
  ARD_ADDR_RANGE_ARRAY_V(1) := ARD_ADDR_RANGE_ARRAY_IN(1);
  for i in 0 to C_NUM_BANKS_MEM*2-1  loop
      ARD_ADDR_RANGE_ARRAY_V(i+2) := ARD_ADDR_RANGE_ARRAY_IN(i+2);
  end loop;
  if C_NUM_BANKS_MEM < 8 then
    for i in C_NUM_BANKS_MEM to 7 loop
        ARD_ADDR_RANGE_ARRAY_V(i*2+2) :=
                             ARD_ADDR_RANGE_ARRAY_IN(C_NUM_BANKS_MEM*2);
        ARD_ADDR_RANGE_ARRAY_V(i*2+3) :=
                           ARD_ADDR_RANGE_ARRAY_IN(C_NUM_BANKS_MEM*2+1);
    end loop;
  end if;
  ARD_ADDR_RANGE_ARRAY_V(ARD_ADDR_RANGE_ARRAY_IN'length-2) :=
              ARD_ADDR_RANGE_ARRAY_IN(ARD_ADDR_RANGE_ARRAY_IN'length-2);
  ARD_ADDR_RANGE_ARRAY_V(ARD_ADDR_RANGE_ARRAY_IN'length-1) :=
              ARD_ADDR_RANGE_ARRAY_IN(ARD_ADDR_RANGE_ARRAY_IN'length-1);
  return ARD_ADDR_RANGE_ARRAY_V;
end function Get_ARD_ADDR_RANGE_ARRAY;
---------------------------------------------------------------------------     
function Get_ARD_DWIDTH_ARRAY return INTEGER_ARRAY_TYPE is
  variable ARD_DWIDTH_ARRAY_V : INTEGER_ARRAY_TYPE(0 to 9);
begin
  ARD_DWIDTH_ARRAY_V(0) := ARD_DWIDTH_ARRAY_IN(0);
  for i in 1 to C_NUM_BANKS_MEM loop
      ARD_DWIDTH_ARRAY_V(i) := ARD_DWIDTH_ARRAY_IN(i);
  end loop;
  if C_NUM_BANKS_MEM < 8 then
    for i in C_NUM_BANKS_MEM+1 to 8 loop
        ARD_DWIDTH_ARRAY_V(i) := ARD_DWIDTH_ARRAY_IN(C_NUM_BANKS_MEM);
    end loop;
  end if;
  ARD_DWIDTH_ARRAY_V(ARD_DWIDTH_ARRAY_IN'length-1) :=
                      ARD_DWIDTH_ARRAY_IN(ARD_DWIDTH_ARRAY_IN'length-1);
  return ARD_DWIDTH_ARRAY_V;
end function Get_ARD_DWIDTH_ARRAY;
---------------------------------------------------------------------------         
function Get_ARD_NUM_CE_ARRAY return INTEGER_ARRAY_TYPE is
  variable ARD_NUM_CE_ARRAY_V : INTEGER_ARRAY_TYPE(0 to 9);
begin
  ARD_NUM_CE_ARRAY_V(0) := ARD_NUM_CE_ARRAY_IN(0);
  for i in 1 to C_NUM_BANKS_MEM loop
      ARD_NUM_CE_ARRAY_V(i) := ARD_NUM_CE_ARRAY_IN(i);
  end loop;
  if C_NUM_BANKS_MEM < 8 then
    for i in C_NUM_BANKS_MEM+1 to 8 loop
        ARD_NUM_CE_ARRAY_V(i) := ARD_NUM_CE_ARRAY_IN(C_NUM_BANKS_MEM);
    end loop;
  end if;
  ARD_NUM_CE_ARRAY_V(ARD_NUM_CE_ARRAY_IN'length-1) :=
                      ARD_NUM_CE_ARRAY_IN(ARD_NUM_CE_ARRAY_IN'length-1);
  return ARD_NUM_CE_ARRAY_V;
end function Get_ARD_NUM_CE_ARRAY;
---------------------------------------------------------------------------         

       -------------------------------------------------------------------------
       -- assign the constant arrays the values returned by the functions
       -------------------------------------------------------------------------     
       constant ARD_ID_ARRAY : INTEGER_ARRAY_TYPE := ARD_ID_ARRAY_IN;
       constant ARD_ADDR_RANGE_ARRAY : SLV64_ARRAY_TYPE :=
                                                      Get_ARD_ADDR_RANGE_ARRAY;
       constant ARD_DWIDTH_ARRAY : INTEGER_ARRAY_TYPE := Get_ARD_DWIDTH_ARRAY;
       constant ARD_NUM_CE_ARRAY : INTEGER_ARRAY_TYPE := Get_ARD_NUM_CE_ARRAY;
     
     

    constant IP_INTR_MODE_ARRAY   : INTEGER_ARRAY_TYPE :=
                  (
                   0, 
                   0 
                   );




 -- parse MCCR info
       constant MCCR_NAME_INDEX : integer := get_id_index(ARD_ID_ARRAY,MCCR);
       constant MCCR_CE_INDEX : integer := calc_start_ce_index(ARD_NUM_CE_ARRAY,MCCR_NAME_INDEX);

 -- parse Memory bank info
       constant MEM0_NAME_INDEX : integer := get_id_index(ARD_ID_ARRAY,MEM0);
       constant MEM1_NAME_INDEX : integer := get_id_index(ARD_ID_ARRAY,MEM1);
       constant MEM2_NAME_INDEX : integer := get_id_index(ARD_ID_ARRAY,MEM2);
       constant MEM3_NAME_INDEX : integer := get_id_index(ARD_ID_ARRAY,MEM3);
       constant MEM4_NAME_INDEX : integer := get_id_index(ARD_ID_ARRAY,MEM4);
       constant MEM5_NAME_INDEX : integer := get_id_index(ARD_ID_ARRAY,MEM5);
       constant MEM6_NAME_INDEX : integer := get_id_index(ARD_ID_ARRAY,MEM6);
       constant MEM7_NAME_INDEX : integer := get_id_index(ARD_ID_ARRAY,MEM7);


    constant INCLUDE_DEV_ISC : INTEGER := 0;
             -- 'true' specifies that the full device interrupt
             -- source controller structure will be included;
             -- 'false' specifies that only the global interrupt
             -- enable is present in the device interrupt source
             -- controller and that the only source of interrupts
             -- in the device is the IP interrupt source controller

    constant INCLUDE_DEV_PENCODER : integer := 0;
             -- 'true' will include the Device IID in the IPIF Interrupt
             -- function


    constant IP_MASTER_PRESENT : integer := 0;
             -- 'true' specifies that the IP has Bus Master capability




    constant OPB_CLK_PERIOD_PS : INTEGER := C_OPB_CLK_PERIOD_PS;
              --  The period of the OPB Bus clock in ps (10000 = 10ns)


    constant FAMILY : STRING := virtex2;
              -- Select the target architecture type
                     -- true = Virtex II, false = Virtex E

    constant CS_BUS_WIDTH        :  integer := ARD_ADDR_RANGE_ARRAY'LENGTH/2;
    constant CE_BUS_WIDTH        :  integer := calc_num_ce(ARD_NUM_CE_ARRAY);
    constant IP_NUM_INTR         :  integer := IP_INTR_MODE_ARRAY'length;
    constant ZERO_INTREVENT      :  std_logic_vector(0 to IP_NUM_INTR-1) 
                                    := (others => '0');
--------------------------------------------------------------------------------
-- Chipscope can be optioned in or out by setting this constant.
--------------------------------------------------------------------------------
  constant C_INCLUDE_CHIPSCOPE        : boolean   := FALSE;

-------------------------------------------------------------------------------
-- Signal and Type Declarations
-------------------------------------------------------------------------------

-- IPIC Used Signals

  signal IP2Bus_rdAck             : std_logic;
  signal IP2Bus_wrAck             : std_logic;
  signal IP2Bus_toutSup           : std_logic;
  signal IP2Bus_retry             : std_logic;
  signal IP2Bus_errAck            : std_logic;
  signal IP2Bus_Data              : std_logic_vector(0 to IPIF_DWIDTH - 1);
  signal Bus2IP_Addr              : std_logic_vector(0 to IPIF_AWIDTH - 1);
  signal Bus2IP_Data              : std_logic_vector(0 to IPIF_DWIDTH - 1);
  signal Bus2IP_RNW               : std_logic;
  signal Bus2IP_RdReq             : std_logic;
  signal Bus2IP_WrReq             : std_logic;
  signal Bus2IP_CS                : std_logic_vector(0 to ((ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1);
  signal Bus2IP_CE                : std_logic_vector(0 to calc_num_ce(ARD_NUM_CE_ARRAY)-1);
  signal Bus2IP_RdCE              : std_logic_vector(0 to calc_num_ce(ARD_NUM_CE_ARRAY)-1);
  signal Bus2IP_WrCE              : std_logic_vector(0 to calc_num_ce(ARD_NUM_CE_ARRAY)-1);
  signal Bus2IP_BE                : std_logic_vector(0 to (IPIF_DWIDTH / 8) - 1);
  signal Bus2IP_Burst             : std_logic;
  signal Bus2IP_Clk               : std_logic;
  signal Bus2IP_Reset             : std_logic;

  -- signals tied to zero because (others => '0' does not work)
  signal ZERO_AWIDTH              : std_logic_vector(0 to IPIF_AWIDTH - 1) := (others => '0');
  signal ZERO_DWIDTH              : std_logic_vector(0 to IPIF_DWIDTH - 1) := (others => '0');
  signal ZERO_BE                  : std_logic_vector(0 to IPIF_DWIDTH/8 - 1) := (others => '0');

  -- new signals needed!!!
  signal  memcon_cs_bus           : Std_logic_vector(0 to C_NUM_BANKS_MEM-1);
  signal  memcon_cs_bus_full      : Std_logic_vector(0 to 7);

  signal  Sln_DBus_i              : std_logic_vector(0 to C_OPB_DWIDTH -1);
  signal  Sln_xferAck_i           : std_logic;
  signal  Sln_errAck_i            : std_logic;
  signal  Sln_toutSup_i           : std_logic;

  signal  Mem_DQ_O_i              : std_logic_vector(0 to C_MAX_MEM_WIDTH -1);
  signal  Mem_DQ_T_i              : std_logic_vector(0 to C_MAX_MEM_WIDTH-1);
  signal  Mem_CEN_i               : std_logic_vector(0 to C_NUM_BANKS_MEM -1);
  signal  Mem_OEN_i               : std_logic_vector(0 to C_NUM_BANKS_MEM -1);
  signal  Mem_WEN_i               : std_logic;
  signal  Mem_QWEN_i              : std_logic_vector(0 to C_MAX_MEM_WIDTH/8 -1);
  signal  Mem_BEN_i               : std_logic_vector(0 to C_MAX_MEM_WIDTH/8 -1);
  signal  Mem_ADV_LDN_i           : std_logic;
  signal  Mem_CKEN_i              : std_logic;
  signal  Mem_CE_i                : std_logic_vector(0 to C_NUM_BANKS_MEM -1);
  signal  Mem_A_i                 : std_logic_vector(0 to C_OPB_AWIDTH -1);


-------------------------------------------------------------------------------
-- Component Declarations
-------------------------------------------------------------------------------
component opb_ipif
  generic (
    C_ARD_ID_ARRAY         : INTEGER_ARRAY_TYPE
                           := ( IPIF_RST, -- 2
                                USER_00   -- 100
                              );

    C_ARD_ADDR_RANGE_ARRAY : SLV64_ARRAY_TYPE
                           := ( x"0000_0000_6000_0040",  -- IPIF_RST
                                x"0000_0000_6000_0043",
                                --
                                x"0000_0000_6000_1100",  -- USER_00
                                x"0000_0000_6000_11FF"
                              );

    C_ARD_DWIDTH_ARRAY     : INTEGER_ARRAY_TYPE
                           := ( 32,  -- IPIF_RST
                                32   -- USER_00
                              );

    C_ARD_NUM_CE_ARRAY     : INTEGER_ARRAY_TYPE
                           := (  1,  -- IPIF_RST
                                17   -- USER_00
                              );

    C_DEV_BLK_ID : INTEGER := 1;
      --  Platform Builder Assiged Device ID number (unique
      --  for each device)

    C_DEV_MIR_ENABLE : integer := 0;
      --  Used to Enable/Disable Module ID functions

    C_DEV_BURST_ENABLE : INTEGER := 0;
      -- Burst Enable for IPIF Interface

    C_DEV_MAX_BURST_SIZE : INTEGER := 64;
      -- Maximum burst size to be supported (in bytes)

    C_INCLUDE_DEV_ISC : INTEGER := 1;
      -- 'true' specifies that the full device interrupt
      -- source controller structure will be included;
      -- 'false' specifies that only the global interrupt
      -- enable is present in the device interrupt source
      -- controller and that the only source of interrupts
      -- in the device is the IP interrupt source controller

    C_INCLUDE_DEV_PENCODER : integer := 0;
      -- 'true' will include the Device IID in the IPIF Interrupt
      -- function

    C_IP_INTR_MODE_ARRAY   : INTEGER_ARRAY_TYPE :=
                        (
                         1,  -- pass through (non-inverting)
                         2,  -- pass through (inverting)
                         3,  -- registered level (non-inverting)
                         4,  -- registered level (inverting)
                         5,  -- positive edge detect
                         6   -- negative edge detect
                        );
      -- One entry for each IP interrupt signal, with the
      -- signal type for each signal given by the value
      -- in the corresponding position. (See above.)

    C_IP_MASTER_PRESENT : integer := 0;
             -- 'true' specifies that the IP has Bus Master capability

   -----------------------------------------------------------------------------
   -- The parameters with names starting with 'C_DMA'  need only be specified if
   -- one of the address ranges is for the optional DMA[SG] controller, i.e. one
   -- range of type IPIF_DMA_SG is included in C_ARD_ID_ARRAY (see above).
   -- If DMA[SG] is included, then the number of channels and the
   -- parameterizeable properties of each Channel are specified in the arrays,
   -- below.
   -----------------------------------------------------------------------------
    C_DMA_CHAN_TYPE_ARRAY : INTEGER_ARRAY_TYPE :=       (2,
                                                         3
                                                        );
      -- One entry in the array for each channel, encoded as
      --    0 = simple DMA,  1 = simple sg,  2 = pkt tx SG,  3 = pkt rx SG

    C_DMA_LENGTH_WIDTH_ARRAY : INTEGER_ARRAY_TYPE :=    (11,
                                                         11
                                                        );
      -- One entry in the array for each channel.
      -- Gives the number of bits needed to specify the maximum DMA transfer
      -- length, in bytes, for the channel.

    C_DMA_PKT_LEN_FIFO_ADDR_ARRAY : SLV64_ARRAY_TYPE := (x"00000000_00000000",
                                                         x"00000000_00000000"
                                                        );
      -- One entry in the array for each channel.
      -- If the channel type is 0 or 1, the value should be "zero".
      -- If the channel type is 2 or 3 (packet channel),
      -- the value should give the address of the packet-length FIFO associated
      -- with the channel.

    C_DMA_PKT_STAT_FIFO_ADDR_ARRAY : SLV64_ARRAY_TYPE :=(x"00000000_00000000",
                                                         x"00000000_00000000"
                                                        );
      -- One entry in the array for each channel.
      -- If the channel type is 0 or 1, the value should be "zero".
      -- If the channel type is 2 or 3 (packet channel),
      -- the value should give the address of the packet-status FIFO associated
      -- with the channel.

    C_DMA_INTR_COALESCE_ARRAY : INTEGER_ARRAY_TYPE    :=(0,
                                                         0
                                                        );
      -- One entry in the array for each channel.
      -- If the channel type is 0 or 1, the value should be 0 for the
      -- channel.
      -- If the channel type is 2 or 3, the channel is a packet channel and
      -- the value 1 specifies that interrupt-coalescing features are
      -- to be implemented for the channel. The value 0 declines the features.


    C_DMA_ALLOW_BURST : integer := 1;
      -- 'true' allows DMA to initiate burst transfers, 'false'
      -- inhibits DMA initiated bursts

    C_DMA_PACKET_WAIT_UNIT_NS : INTEGER := 1000000;
      -- Gives the unit for timing pack-wait bounds for all channels
      -- with interrupt coalescing. (Usually left at default value.);
      -- Needs to be specified only if at least one channel is of type
      -- 2 or 3 with interrupt coalescing and there is a need
      -- to deviate from the nominal unit of 1 ms (for example
    C_OPB_AWIDTH : INTEGER := 32;
      --  width of OPB Address Bus (in bits)

    C_OPB_DWIDTH : INTEGER := 32;
      --  Width of the OPB Data Bus (in bits)

    C_OPB_CLK_PERIOD_PS : INTEGER := 10000;
      --  The period of the OPB Bus clock in ps (10000 = 10ns)

    C_IPIF_DWIDTH : INTEGER := 32;
      --  Set this equal to C_OPB_DWIDTH

    C_FAMILY : string := "virtex2"
           );
  port (
        OPB_ABus : in std_logic_vector(0 to C_OPB_AWIDTH - 1 );

        OPB_DBus : in std_logic_vector(0 to C_OPB_DWIDTH - 1 );

        Sln_DBus : out std_logic_vector(0 to C_OPB_DWIDTH - 1 );

        Mn_ABus : out std_logic_vector(0 to C_OPB_AWIDTH - 1 );

        IP2Bus_Addr : in std_logic_vector(0 to C_OPB_AWIDTH - 1 );

        Bus2IP_Addr : out std_logic_vector(0 to C_OPB_AWIDTH - 1 );

        Bus2IP_Data : out std_logic_vector(0 to C_IPIF_DWIDTH - 1 );

        Bus2IP_RNW  : out std_logic;

        Bus2IP_CS      : Out std_logic_vector(0 to CS_BUS_WIDTH-1);

        Bus2IP_CE      : out std_logic_vector(0 to CE_BUS_WIDTH-1);

        Bus2IP_RdCE    : out std_logic_vector(0 to CE_BUS_WIDTH-1);

        Bus2IP_WrCE    : out std_logic_vector(0 to CE_BUS_WIDTH-1);

        IP2Bus_Data : in std_logic_vector(0 to C_IPIF_DWIDTH - 1 );

        IP2Bus_WrAck : in std_logic;

        IP2Bus_RdAck : in std_logic;

        IP2Bus_Retry : in std_logic;

        IP2Bus_Error : in std_logic;

        IP2Bus_ToutSup : in std_logic;

        IP2DMA_RxLength_Empty : in std_logic;

        IP2DMA_RxStatus_Empty : in std_logic;

        IP2DMA_TxLength_Full : in std_logic;

        IP2DMA_TxStatus_Empty : in std_logic;

        IP2IP_Addr : in std_logic_vector(0 to C_OPB_AWIDTH - 1 );

        IP2RFIFO_Data : in std_logic_vector(0 to 31 );

        IP2RFIFO_WrMark : in std_logic;

        IP2RFIFO_WrRelease : in std_logic;

        IP2RFIFO_WrReq : in std_logic;

        IP2RFIFO_WrRestore : in std_logic;

        IP2WFIFO_RdMark : in std_logic;

        IP2WFIFO_RdRelease : in std_logic;

        IP2WFIFO_RdReq : in std_logic;

        IP2WFIFO_RdRestore : in std_logic;

        IP2Bus_MstBE : in std_logic_vector(0 to C_OPB_DWIDTH/8 - 1 );

        IP2Bus_MstWrReq : in std_logic;

        IP2Bus_MstRdReq : in std_logic;

        IP2Bus_MstBurst : in std_logic;

        IP2Bus_MstBusLock : in std_logic;

        Bus2IP_MstWrAck : out std_logic;

        Bus2IP_MstRdAck : out std_logic;

        Bus2IP_MstRetry : out std_logic;

        Bus2IP_MstError : out std_logic;

        Bus2IP_MstTimeOut : out std_logic;

        Bus2IP_MstLastAck : out std_logic;

        Bus2IP_BE : out std_logic_vector(0 to C_IPIF_DWIDTH/8 - 1 );

        Bus2IP_WrReq : out std_logic;

        Bus2IP_RdReq : out std_logic;

        Bus2IP_Burst : out std_logic;

        Mn_request : out std_logic;

        Mn_busLock : out std_logic;

        Mn_select : out std_logic;

        Mn_RNW : out std_logic;

        Mn_BE : out std_logic_vector(0 to C_OPB_DWIDTH/8 - 1 );

        Mn_seqAddr : out std_logic;

        OPB_MnGrant : in std_logic;

        OPB_xferAck : in std_logic;

        OPB_errAck : in std_logic;

        OPB_retry : in std_logic;

        OPB_timeout : in std_logic;

        Freeze : in std_logic;

        RFIFO2IP_AlmostFull : out std_logic;

        RFIFO2IP_Full : out std_logic;

        RFIFO2IP_Vacancy : out std_logic_vector(0 to 9 );

        RFIFO2IP_WrAck : out std_logic;

        OPB_select : in std_logic;

        OPB_RNW : in std_logic;

        OPB_seqAddr : in std_logic;

        OPB_BE : in std_logic_vector(0 to C_OPB_DWIDTH/8 - 1 );

        Sln_xferAck : out std_logic;

        Sln_errAck : out std_logic;

        Sln_toutSup : out std_logic;

        Sln_retry : out std_logic;

        WFIFO2IP_AlmostEmpty : out std_logic;

        WFIFO2IP_Data : out std_logic_vector(0 to 31 );

        WFIFO2IP_Empty : out std_logic;

        WFIFO2IP_Occupancy : out std_logic_vector(0 to 9 );

        WFIFO2IP_RdAck : out std_logic;

        Bus2IP_Clk : out std_logic;

        Bus2IP_DMA_Ack : out std_logic;

        Bus2IP_Freeze : out std_logic;

        Bus2IP_Reset : out std_logic;

        IP2Bus_Clk : in std_logic;

        IP2Bus_DMA_Req : in std_logic;

        IP2Bus_IntrEvent : in std_logic_vector(0 to IP_NUM_INTR - 1 );

        IP2INTC_Irpt : out std_logic;

        OPB_Clk : in std_logic;

        Reset : in std_logic

        );
end component;

component emc
  generic (
    C_NUM_BANKS_MEM                 : integer range 1 to 8 := 2;
    C_INCLUDE_NEGEDGE_IOREGS        : integer range 0 to 1 := 0;
    C_INCLUDE_BURST                 : integer range 0 to 1 := 0;
    C_IPIF_DWIDTH                   : integer := 64;
    C_IPIF_AWIDTH                   : integer := 32;
    C_MEM0_WIDTH                    : integer := 64;
    C_MEM1_WIDTH                    : integer := 64;
    C_MEM2_WIDTH                    : integer := 64;
    C_MEM3_WIDTH                    : integer := 64;
    C_MEM4_WIDTH                    : integer := 64;
    C_MEM5_WIDTH                    : integer := 64;
    C_MEM6_WIDTH                    : integer := 64;
    C_MEM7_WIDTH                    : integer := 64;
    C_MAX_MEM_WIDTH                 : integer := 64;

    C_INCLUDE_DATAWIDTH_MATCHING_0    : integer := 1; 
    C_INCLUDE_DATAWIDTH_MATCHING_1    : integer := 1; 
    C_INCLUDE_DATAWIDTH_MATCHING_2    : integer := 1; 
    C_INCLUDE_DATAWIDTH_MATCHING_3    : integer := 1; 
    C_INCLUDE_DATAWIDTH_MATCHING_4    : integer := 1; 
    C_INCLUDE_DATAWIDTH_MATCHING_5    : integer := 1; 
    C_INCLUDE_DATAWIDTH_MATCHING_6    : integer := 1; 
    C_INCLUDE_DATAWIDTH_MATCHING_7    : integer := 1; 

    -- Memory read and write access times for all memory banks
    C_BUS_CLOCK_PERIOD_PS             : integer := 40000;

    C_SYNCH_MEM_0                     : integer := 0;
    C_SYNCH_PIPEDELAY_0               : integer := 2;
    C_READ_ADDR_TO_OUT_SLOW_PS_0      : integer := 0;
    C_WRITE_ADDR_TO_OUT_SLOW_PS_0     : integer := 0;
    C_WRITE_MIN_PULSE_WIDTH_PS_0      : integer := 0;
    C_READ_ADDR_TO_OUT_FAST_PS_0      : integer := 0;
    C_WRITE_ADDR_TO_OUT_FAST_PS_0     : integer := 0;
    C_READ_RECOVERY_BEFORE_WRITE_PS_0 : integer := 0;
    C_WRITE_RECOVERY_BEFORE_READ_PS_0 : integer := 0;

    C_SYNCH_MEM_1                     : integer := 0;
    C_SYNCH_PIPEDELAY_1               : integer := 2;
    C_READ_ADDR_TO_OUT_SLOW_PS_1      : integer := 0;
    C_WRITE_ADDR_TO_OUT_SLOW_PS_1     : integer := 0;
    C_WRITE_MIN_PULSE_WIDTH_PS_1      : integer := 0;
    C_READ_ADDR_TO_OUT_FAST_PS_1      : integer := 0;
    C_WRITE_ADDR_TO_OUT_FAST_PS_1     : integer := 0;
    C_READ_RECOVERY_BEFORE_WRITE_PS_1 : integer := 0;
    C_WRITE_RECOVERY_BEFORE_READ_PS_1 : integer := 0;

    C_SYNCH_MEM_2                     : integer := 0;
    C_SYNCH_PIPEDELAY_2               : integer := 2;
    C_READ_ADDR_TO_OUT_SLOW_PS_2      : integer := 0;
    C_WRITE_ADDR_TO_OUT_SLOW_PS_2     : integer := 0;
    C_WRITE_MIN_PULSE_WIDTH_PS_2      : integer := 0;
    C_READ_ADDR_TO_OUT_FAST_PS_2      : integer := 0;
    C_WRITE_ADDR_TO_OUT_FAST_PS_2     : integer := 0;
    C_READ_RECOVERY_BEFORE_WRITE_PS_2 : integer := 0;
    C_WRITE_RECOVERY_BEFORE_READ_PS_2 : integer := 0;

    C_SYNCH_MEM_3                     : integer := 0;
    C_SYNCH_PIPEDELAY_3               : integer := 2;
    C_READ_ADDR_TO_OUT_SLOW_PS_3      : integer := 0;
    C_WRITE_ADDR_TO_OUT_SLOW_PS_3     : integer := 0;
    C_WRITE_MIN_PULSE_WIDTH_PS_3      : integer := 0;
    C_READ_ADDR_TO_OUT_FAST_PS_3      : integer := 0;
    C_WRITE_ADDR_TO_OUT_FAST_PS_3     : integer := 0;
    C_READ_RECOVERY_BEFORE_WRITE_PS_3 : integer := 0;
    C_WRITE_RECOVERY_BEFORE_READ_PS_3 : integer := 0;

    C_SYNCH_MEM_4                     : integer := 0;
    C_SYNCH_PIPEDELAY_4               : integer := 2;
    C_READ_ADDR_TO_OUT_SLOW_PS_4      : integer := 0;
    C_WRITE_ADDR_TO_OUT_SLOW_PS_4     : integer := 0;
    C_WRITE_MIN_PULSE_WIDTH_PS_4      : integer := 0;
    C_READ_ADDR_TO_OUT_FAST_PS_4      : integer := 0;
    C_WRITE_ADDR_TO_OUT_FAST_PS_4     : integer := 0;
    C_READ_RECOVERY_BEFORE_WRITE_PS_4 : integer := 0;
    C_WRITE_RECOVERY_BEFORE_READ_PS_4 : integer := 0;

    C_SYNCH_MEM_5                     : integer := 0;
    C_SYNCH_PIPEDELAY_5               : integer := 2;
    C_READ_ADDR_TO_OUT_SLOW_PS_5      : integer := 0;
    C_WRITE_ADDR_TO_OUT_SLOW_PS_5     : integer := 0;
    C_WRITE_MIN_PULSE_WIDTH_PS_5      : integer := 0;
    C_READ_ADDR_TO_OUT_FAST_PS_5      : integer := 0;
    C_WRITE_ADDR_TO_OUT_FAST_PS_5     : integer := 0;
    C_READ_RECOVERY_BEFORE_WRITE_PS_5 : integer := 0;
    C_WRITE_RECOVERY_BEFORE_READ_PS_5 : integer := 0;

    C_SYNCH_MEM_6                     : integer := 0;
    C_SYNCH_PIPEDELAY_6               : integer := 2;
    C_READ_ADDR_TO_OUT_SLOW_PS_6      : integer := 0;
    C_WRITE_ADDR_TO_OUT_SLOW_PS_6     : integer := 0;
    C_WRITE_MIN_PULSE_WIDTH_PS_6      : integer := 0;
    C_READ_ADDR_TO_OUT_FAST_PS_6      : integer := 0;
    C_WRITE_ADDR_TO_OUT_FAST_PS_6     : integer := 0;
    C_READ_RECOVERY_BEFORE_WRITE_PS_6 : integer := 0;
    C_WRITE_RECOVERY_BEFORE_READ_PS_6 : integer := 0;

    C_SYNCH_MEM_7                     : integer := 0;
    C_SYNCH_PIPEDELAY_7               : integer := 2;
    C_READ_ADDR_TO_OUT_SLOW_PS_7      : integer := 0;
    C_WRITE_ADDR_TO_OUT_SLOW_PS_7     : integer := 0;
    C_WRITE_MIN_PULSE_WIDTH_PS_7      : integer := 0;
    C_READ_ADDR_TO_OUT_FAST_PS_7      : integer := 0;
    C_WRITE_ADDR_TO_OUT_FAST_PS_7     : integer := 0;
    C_READ_RECOVERY_BEFORE_WRITE_PS_7 : integer := 0;
    C_WRITE_RECOVERY_BEFORE_READ_PS_7 : integer := 0
    );
  port (
    Bus2IP_Clk             : in  std_logic;
    Bus2IP_Reset           : in  std_logic;

    -- Bus and IPIC Interface signals
    Bus2IP_Addr            : in  std_logic_vector(0 to C_IPIF_AWIDTH-1);
    Bus2IP_BE              : in  std_logic_vector(0 to C_IPIF_DWIDTH/8-1);
    Bus2IP_Data            : in  std_logic_vector(0 to C_IPIF_DWIDTH-1);
    Bus2IP_RNW             : in  std_logic;
    Bus2IP_Burst           : in  std_logic;
    Bus2IP_WrReq           : in  std_logic;
    Bus2IP_RdReq           : in  std_logic;
    Bus2IP_Mem_CS          : in  std_logic_vector(0 to C_NUM_BANKS_MEM-1);
    Bus2IP_Reg_CS          : in  std_logic;
    Bus2IP_WrCE            : in  std_logic_vector(0 to C_NUM_BANKS_MEM-1);
    Bus2IP_RdCE            : in  std_logic_vector(0 to C_NUM_BANKS_MEM-1);

    IP2Bus_Data            : out std_logic_vector(0 to C_IPIF_DWIDTH-1);
    IP2Bus_errAck          : out std_logic;
    IP2Bus_retry           : out std_logic;
    IP2Bus_toutSup         : out std_logic;
    IP2Bus_RdAck           : out std_logic;
    IP2Bus_WrAck           : out std_logic;


    -- Memory signals
    Mem_A                  : out   std_logic_vector(0 to C_IPIF_AWIDTH-1);
    Mem_DQ_I               : in    std_logic_vector(0 to C_MAX_MEM_WIDTH-1);
    Mem_DQ_O               : out   std_logic_vector(0 to C_MAX_MEM_WIDTH-1);
    Mem_DQ_T               : out   std_logic_vector(0 to C_MAX_MEM_WIDTH-1);
    Mem_CEN                : out   std_logic_vector(0 to C_NUM_BANKS_MEM-1);
    Mem_OEN                : out   std_logic_vector(0 to C_NUM_BANKS_MEM-1);
    Mem_WEN                : out   std_logic;
    Mem_QWEN               : out   std_logic_vector(0 to C_MAX_MEM_WIDTH/8-1); --Qualified WE
    Mem_BEN                : out   std_logic_vector(0 to C_MAX_MEM_WIDTH/8-1);
    Mem_RPN                : out   std_logic;
    -- added for ZBT
    Mem_CE                 : out   std_logic_vector(0 to C_NUM_BANKS_MEM-1);
    Mem_ADV_LDN            : out   std_logic;
    Mem_LBON               : out   std_logic;
    Mem_CKEN               : out   std_logic;
    Mem_RNW                : out   std_logic
    );
  end component;

begin -- architecture IMP

Sln_DBus <= Sln_DBus_i;
Sln_xferAck <= Sln_xferAck_i;
Sln_toutSup <= Sln_toutSup_i;
Sln_errAck <= Sln_errAck_i;

Mem_A        <=  Mem_A_i  ;
Mem_DQ_O     <=  Mem_DQ_O_i ;
Mem_DQ_T     <=  Mem_DQ_T_i ;
Mem_CEN      <=  Mem_CEN_i  ;
Mem_OEN      <=  Mem_OEN_i  ;
Mem_WEN      <=  Mem_WEN_i  ;
Mem_QWEN     <=  Mem_QWEN_i ;
Mem_BEN      <=  Mem_BEN_i  ;
Mem_CE       <=  Mem_CE_i  ;
Mem_ADV_LDN  <=  Mem_ADV_LDN_i;
Mem_CKEN     <=  Mem_CKEN_i  ;


-- now build the intermediate memory CS bus of all possible memory chip selects
 memcon_cs_bus_full(0) <= Bus2IP_CS(MEM0_NAME_INDEX);
 memcon_cs_bus_full(1) <= Bus2IP_CS(MEM1_NAME_INDEX);
 memcon_cs_bus_full(2) <= Bus2IP_CS(MEM2_NAME_INDEX);
 memcon_cs_bus_full(3) <= Bus2IP_CS(MEM3_NAME_INDEX);
 memcon_cs_bus_full(4) <= Bus2IP_CS(MEM4_NAME_INDEX);
 memcon_cs_bus_full(5) <= Bus2IP_CS(MEM5_NAME_INDEX);
 memcon_cs_bus_full(6) <= Bus2IP_CS(MEM6_NAME_INDEX);
 memcon_cs_bus_full(7) <= Bus2IP_CS(MEM7_NAME_INDEX);

-- now populate the size restricted MEM_CON CS bus
COLLECT_MEM_CS : process (memcon_cs_bus_full)
  begin
    for cs_index in 0 to C_NUM_BANKS_MEM-1 loop
        memcon_cs_bus(cs_index) <=  memcon_cs_bus_full(cs_index);
    end loop;
end process COLLECT_MEM_CS;

-------------------------------------------------------------------------------
-- Component Instantiations
-------------------------------------------------------------------------------
-- State the function the component is performing with comments
-- Component instantiation names are all uppercase and are of the form:
--          <ENTITY_>I_<#|FUNC>
-- If no components are required, delete this section from the file
-------------------------------------------------------------------------------
I_OPB_IPIf: opb_ipif
  generic map(
      -- Generics to be set for ipif
      C_ARD_ID_ARRAY                 =>   ARD_ID_ARRAY       ,
      C_ARD_ADDR_RANGE_ARRAY         =>   ARD_ADDR_RANGE_ARRAY ,
      C_ARD_DWIDTH_ARRAY             =>   ARD_DWIDTH_ARRAY     ,
      C_ARD_NUM_CE_ARRAY             =>   ARD_NUM_CE_ARRAY     ,
      C_DEV_BLK_ID                   =>   C_DEV_BLK_ID           ,
      C_DEV_MIR_ENABLE               =>   C_DEV_MIR_ENABLE       ,
      C_DEV_BURST_ENABLE             =>   INCLUDE_BURST     ,
      C_DEV_MAX_BURST_SIZE           =>   DEV_MAX_BURST_SIZE   ,
      C_INCLUDE_DEV_ISC              =>   INCLUDE_DEV_ISC      ,
      C_INCLUDE_DEV_PENCODER         =>   INCLUDE_DEV_PENCODER ,
      C_IP_INTR_MODE_ARRAY           =>   IP_INTR_MODE_ARRAY ,
      C_IP_MASTER_PRESENT            =>   IP_MASTER_PRESENT    ,

      C_OPB_AWIDTH                   =>   OPB_AWIDTH       ,
      C_OPB_DWIDTH                   =>   OPB_DWIDTH       ,
      C_OPB_CLK_PERIOD_PS            =>   OPB_CLK_PERIOD_PS,
      C_IPIF_DWIDTH                  =>   IPIF_DWIDTH      ,
      C_FAMILY                       =>   FAMILY

      )
    port map (

        OPB_ABus               => OPB_ABus,
        OPB_DBus               => OPB_DBus,
        Sln_DBus               => Sln_DBus_i,
        Mn_ABus                => open,
        IP2Bus_Addr            => ZERO_AWIDTH,
        Bus2IP_Addr            => Bus2IP_Addr,
        Bus2IP_Data            => Bus2IP_Data,
        Bus2IP_RNW             => Bus2IP_RNW,
        Bus2IP_CS              => Bus2IP_CS,
        Bus2IP_CE              => Bus2IP_CE,
        Bus2IP_RdCE            => Bus2IP_RdCE,
        Bus2IP_WrCE            => Bus2IP_WrCE,
        IP2Bus_Data            => IP2Bus_Data,
        IP2Bus_WrAck           => IP2Bus_WrAck,
        IP2Bus_RdAck           => IP2Bus_RdAck,
        IP2Bus_Retry           => IP2Bus_Retry,
        IP2Bus_Error           => '0',
        IP2Bus_ToutSup         => IP2Bus_ToutSup,
        IP2DMA_RxLength_Empty  => '0',
        IP2DMA_RxStatus_Empty  => '0',
        IP2DMA_TxLength_Full   => '0',
        IP2DMA_TxStatus_Empty  => '0',
        IP2IP_Addr             => ZERO_AWIDTH,
        IP2RFIFO_Data          => ZERO_DWIDTH,
        IP2RFIFO_WrMark        => '0',
        IP2RFIFO_WrRelease     => '0',
        IP2RFIFO_WrReq         => '0',
        IP2RFIFO_WrRestore     => '0',
        IP2WFIFO_RdMark        => '0',
        IP2WFIFO_RdRelease     => '0',
        IP2WFIFO_RdReq         => '0',
        IP2WFIFO_RdRestore     => '0',
        IP2Bus_MstBE           => ZERO_BE,
        IP2Bus_MstWrReq        => '0',
        IP2Bus_MstRdReq        => '0',
        IP2Bus_MstBurst        => '0',
        IP2Bus_MstBusLock      => '0',
        Bus2IP_MstWrAck        => open,
        Bus2IP_MstRdAck        => open,
        Bus2IP_MstRetry        => open,
        Bus2IP_MstError        => open,
        Bus2IP_MstTimeOut      => open,
        Bus2IP_MstLastAck      => open,
        Bus2IP_BE              => Bus2IP_BE,
        Bus2IP_WrReq           => Bus2IP_WrReq,
        Bus2IP_RdReq           => Bus2IP_RdReq,
        Bus2IP_Burst           => Bus2IP_Burst,
        Mn_request             => open,
        Mn_busLock             => open,
        Mn_select              => open,
        Mn_RNW                 => open,
        Mn_BE                  => open,
        Mn_seqAddr             => open,
        OPB_MnGrant            => '0',
        OPB_xferAck            => '0',
        OPB_errAck             => '0',
        OPB_retry              => '0',
        OPB_timeout            => '0',
        Freeze                 => '0',
        RFIFO2IP_AlmostFull    => open,
        RFIFO2IP_Full          => open,
        RFIFO2IP_Vacancy       => open,
        RFIFO2IP_WrAck         => open,
        OPB_select             => OPB_select,
        OPB_RNW                => OPB_RNW,
        OPB_seqAddr            => OPB_seqAddr,
        OPB_BE                 => OPB_BE,
        Sln_xferAck            => Sln_xferAck_i,
        Sln_errAck             => Sln_errAck_i,
        Sln_toutSup            => Sln_toutSup_i,
        Sln_retry              => Sln_retry,
        WFIFO2IP_AlmostEmpty   => open,
        WFIFO2IP_Data          => open,
        WFIFO2IP_Empty         => open,
        WFIFO2IP_Occupancy     => open,
        WFIFO2IP_RdAck         => open,
        Bus2IP_Clk             => Bus2IP_Clk,
        Bus2IP_DMA_Ack         => open,
        Bus2IP_Freeze          => open,
        Bus2IP_Reset           => Bus2IP_Reset,
        IP2Bus_Clk             => '0',
        IP2Bus_DMA_Req         => '0',
        IP2Bus_IntrEvent       => ZERO_INTREVENT,
        IP2INTC_Irpt           => open,
        OPB_Clk                => OPB_Clk,
        Reset                  => OPB_Rst
      );

I_EMC: emc
  generic map(
       C_NUM_BANKS_MEM          =>   C_NUM_BANKS_MEM,
       C_INCLUDE_NEGEDGE_IOREGS =>   C_INCLUDE_NEGEDGE_IOREGS,
       C_INCLUDE_BURST          =>   INCLUDE_BURST,
       C_IPIF_DWIDTH            =>   OPB_DWIDTH,
       C_IPIF_AWIDTH            =>   OPB_AWIDTH,
       C_MEM0_WIDTH             =>   C_MEM0_WIDTH,
       C_MEM1_WIDTH             =>   C_MEM1_WIDTH,  
       C_MEM2_WIDTH             =>   C_MEM2_WIDTH,  
       C_MEM3_WIDTH             =>   C_MEM3_WIDTH,  
       C_MEM4_WIDTH             =>   C_MEM4_WIDTH,  
       C_MEM5_WIDTH             =>   C_MEM5_WIDTH,  
       C_MEM6_WIDTH             =>   C_MEM6_WIDTH,  
       C_MEM7_WIDTH             =>   C_MEM7_WIDTH,  
       C_MAX_MEM_WIDTH          =>   C_MAX_MEM_WIDTH,

       C_INCLUDE_DATAWIDTH_MATCHING_0   =>  C_INCLUDE_DATAWIDTH_MATCHING_0,
       C_INCLUDE_DATAWIDTH_MATCHING_1   =>  C_INCLUDE_DATAWIDTH_MATCHING_1,
       C_INCLUDE_DATAWIDTH_MATCHING_2   =>  C_INCLUDE_DATAWIDTH_MATCHING_2,
       C_INCLUDE_DATAWIDTH_MATCHING_3   =>  C_INCLUDE_DATAWIDTH_MATCHING_3,
       C_INCLUDE_DATAWIDTH_MATCHING_4   =>  C_INCLUDE_DATAWIDTH_MATCHING_4,
       C_INCLUDE_DATAWIDTH_MATCHING_5   =>  C_INCLUDE_DATAWIDTH_MATCHING_5,
       C_INCLUDE_DATAWIDTH_MATCHING_6   =>  C_INCLUDE_DATAWIDTH_MATCHING_6,
       C_INCLUDE_DATAWIDTH_MATCHING_7   =>  C_INCLUDE_DATAWIDTH_MATCHING_7,
      
       -- Memory read and write access times for all memory banks
       C_BUS_CLOCK_PERIOD_PS             =>    OPB_CLK_PERIOD_PS,

       C_SYNCH_MEM_0                     =>    C_SYNCH_MEM_0,
       C_SYNCH_PIPEDELAY_0               =>    C_SYNCH_PIPEDELAY_0,
       C_READ_ADDR_TO_OUT_SLOW_PS_0      =>    C_READ_ADDR_TO_OUT_SLOW_PS_0,
       C_WRITE_ADDR_TO_OUT_SLOW_PS_0     =>    C_WRITE_ADDR_TO_OUT_SLOW_PS_0,
       C_WRITE_MIN_PULSE_WIDTH_PS_0      =>    C_WRITE_MIN_PULSE_WIDTH_PS_0,
       C_READ_ADDR_TO_OUT_FAST_PS_0      =>    C_READ_ADDR_TO_OUT_FAST_PS_0,
       C_WRITE_ADDR_TO_OUT_FAST_PS_0     =>    C_WRITE_ADDR_TO_OUT_FAST_PS_0,
       C_READ_RECOVERY_BEFORE_WRITE_PS_0 =>    C_READ_RECOVERY_BEFORE_WRITE_PS_0,
       C_WRITE_RECOVERY_BEFORE_READ_PS_0 =>    C_WRITE_RECOVERY_BEFORE_READ_PS_0,

       C_SYNCH_MEM_1                     =>    C_SYNCH_MEM_1,
       C_SYNCH_PIPEDELAY_1               =>    C_SYNCH_PIPEDELAY_1,
       C_READ_ADDR_TO_OUT_SLOW_PS_1      =>    C_READ_ADDR_TO_OUT_SLOW_PS_1,
       C_WRITE_ADDR_TO_OUT_SLOW_PS_1     =>    C_WRITE_ADDR_TO_OUT_SLOW_PS_1,
       C_WRITE_MIN_PULSE_WIDTH_PS_1      =>    C_WRITE_MIN_PULSE_WIDTH_PS_1,
       C_READ_ADDR_TO_OUT_FAST_PS_1      =>    C_READ_ADDR_TO_OUT_FAST_PS_1,
       C_WRITE_ADDR_TO_OUT_FAST_PS_1     =>    C_WRITE_ADDR_TO_OUT_FAST_PS_1,
       C_READ_RECOVERY_BEFORE_WRITE_PS_1 =>    C_READ_RECOVERY_BEFORE_WRITE_PS_1,
       C_WRITE_RECOVERY_BEFORE_READ_PS_1 =>    C_WRITE_RECOVERY_BEFORE_READ_PS_1,

       C_SYNCH_MEM_2                     =>    C_SYNCH_MEM_2,
       C_SYNCH_PIPEDELAY_2               =>    C_SYNCH_PIPEDELAY_2,
       C_READ_ADDR_TO_OUT_SLOW_PS_2      =>    C_READ_ADDR_TO_OUT_SLOW_PS_2,
       C_WRITE_ADDR_TO_OUT_SLOW_PS_2     =>    C_WRITE_ADDR_TO_OUT_SLOW_PS_2,
       C_WRITE_MIN_PULSE_WIDTH_PS_2      =>    C_WRITE_MIN_PULSE_WIDTH_PS_2,
       C_READ_ADDR_TO_OUT_FAST_PS_2      =>    C_READ_ADDR_TO_OUT_FAST_PS_2,
       C_WRITE_ADDR_TO_OUT_FAST_PS_2     =>    C_WRITE_ADDR_TO_OUT_FAST_PS_2,
       C_READ_RECOVERY_BEFORE_WRITE_PS_2 =>    C_READ_RECOVERY_BEFORE_WRITE_PS_2,
       C_WRITE_RECOVERY_BEFORE_READ_PS_2 =>    C_WRITE_RECOVERY_BEFORE_READ_PS_2,

       C_SYNCH_MEM_3                     =>    C_SYNCH_MEM_3,
       C_SYNCH_PIPEDELAY_3               =>    C_SYNCH_PIPEDELAY_3,
       C_READ_ADDR_TO_OUT_SLOW_PS_3      =>    C_READ_ADDR_TO_OUT_SLOW_PS_3,
       C_WRITE_ADDR_TO_OUT_SLOW_PS_3     =>    C_WRITE_ADDR_TO_OUT_SLOW_PS_3,
       C_WRITE_MIN_PULSE_WIDTH_PS_3      =>    C_WRITE_MIN_PULSE_WIDTH_PS_3,
       C_READ_ADDR_TO_OUT_FAST_PS_3      =>    C_READ_ADDR_TO_OUT_FAST_PS_3,
       C_WRITE_ADDR_TO_OUT_FAST_PS_3     =>    C_WRITE_ADDR_TO_OUT_FAST_PS_3,
       C_READ_RECOVERY_BEFORE_WRITE_PS_3 =>    C_READ_RECOVERY_BEFORE_WRITE_PS_3,
       C_WRITE_RECOVERY_BEFORE_READ_PS_3 =>    C_WRITE_RECOVERY_BEFORE_READ_PS_3,

       C_SYNCH_MEM_4                     =>    C_SYNCH_MEM_4,
       C_SYNCH_PIPEDELAY_4               =>    C_SYNCH_PIPEDELAY_4,
       C_READ_ADDR_TO_OUT_SLOW_PS_4      =>    C_READ_ADDR_TO_OUT_SLOW_PS_4,
       C_WRITE_ADDR_TO_OUT_SLOW_PS_4     =>    C_WRITE_ADDR_TO_OUT_SLOW_PS_4,
       C_WRITE_MIN_PULSE_WIDTH_PS_4      =>    C_WRITE_MIN_PULSE_WIDTH_PS_4,
       C_READ_ADDR_TO_OUT_FAST_PS_4      =>    C_READ_ADDR_TO_OUT_FAST_PS_4,
       C_WRITE_ADDR_TO_OUT_FAST_PS_4     =>    C_WRITE_ADDR_TO_OUT_FAST_PS_4,
       C_READ_RECOVERY_BEFORE_WRITE_PS_4 =>    C_READ_RECOVERY_BEFORE_WRITE_PS_4,
       C_WRITE_RECOVERY_BEFORE_READ_PS_4 =>    C_WRITE_RECOVERY_BEFORE_READ_PS_4,

       C_SYNCH_MEM_5                     =>    C_SYNCH_MEM_5,
       C_SYNCH_PIPEDELAY_5               =>    C_SYNCH_PIPEDELAY_5,
       C_READ_ADDR_TO_OUT_SLOW_PS_5      =>    C_READ_ADDR_TO_OUT_SLOW_PS_5,
       C_WRITE_ADDR_TO_OUT_SLOW_PS_5     =>    C_WRITE_ADDR_TO_OUT_SLOW_PS_5,
       C_WRITE_MIN_PULSE_WIDTH_PS_5      =>    C_WRITE_MIN_PULSE_WIDTH_PS_5,
       C_READ_ADDR_TO_OUT_FAST_PS_5      =>    C_READ_ADDR_TO_OUT_FAST_PS_5,
       C_WRITE_ADDR_TO_OUT_FAST_PS_5     =>    C_WRITE_ADDR_TO_OUT_FAST_PS_5,
       C_READ_RECOVERY_BEFORE_WRITE_PS_5 =>    C_READ_RECOVERY_BEFORE_WRITE_PS_5,
       C_WRITE_RECOVERY_BEFORE_READ_PS_5 =>    C_WRITE_RECOVERY_BEFORE_READ_PS_5,

       C_SYNCH_MEM_6                     =>    C_SYNCH_MEM_6,
       C_SYNCH_PIPEDELAY_6               =>    C_SYNCH_PIPEDELAY_6,
       C_READ_ADDR_TO_OUT_SLOW_PS_6      =>    C_READ_ADDR_TO_OUT_SLOW_PS_6,
       C_WRITE_ADDR_TO_OUT_SLOW_PS_6     =>    C_WRITE_ADDR_TO_OUT_SLOW_PS_6,
       C_WRITE_MIN_PULSE_WIDTH_PS_6      =>    C_WRITE_MIN_PULSE_WIDTH_PS_6,
       C_READ_ADDR_TO_OUT_FAST_PS_6      =>    C_READ_ADDR_TO_OUT_FAST_PS_6,
       C_WRITE_ADDR_TO_OUT_FAST_PS_6     =>    C_WRITE_ADDR_TO_OUT_FAST_PS_6,
       C_READ_RECOVERY_BEFORE_WRITE_PS_6 =>    C_READ_RECOVERY_BEFORE_WRITE_PS_6,
       C_WRITE_RECOVERY_BEFORE_READ_PS_6 =>    C_WRITE_RECOVERY_BEFORE_READ_PS_6,

       C_SYNCH_MEM_7                     =>    C_SYNCH_MEM_7,
       C_SYNCH_PIPEDELAY_7               =>    C_SYNCH_PIPEDELAY_7,
       C_READ_ADDR_TO_OUT_SLOW_PS_7      =>    C_READ_ADDR_TO_OUT_SLOW_PS_7,
       C_WRITE_ADDR_TO_OUT_SLOW_PS_7     =>    C_WRITE_ADDR_TO_OUT_SLOW_PS_7,
       C_WRITE_MIN_PULSE_WIDTH_PS_7      =>    C_WRITE_MIN_PULSE_WIDTH_PS_7,
       C_READ_ADDR_TO_OUT_FAST_PS_7      =>    C_READ_ADDR_TO_OUT_FAST_PS_7,
       C_WRITE_ADDR_TO_OUT_FAST_PS_7     =>    C_WRITE_ADDR_TO_OUT_FAST_PS_7,
       C_READ_RECOVERY_BEFORE_WRITE_PS_7 =>    C_READ_RECOVERY_BEFORE_WRITE_PS_7,
       C_WRITE_RECOVERY_BEFORE_READ_PS_7 =>    C_WRITE_RECOVERY_BEFORE_READ_PS_7
       )

    port map (
       Bus2IP_Clk              => Bus2IP_Clk,
       Bus2IP_Reset            => Bus2IP_Reset,
       Bus2IP_Addr             => Bus2IP_Addr,
       Bus2IP_BE               => Bus2IP_BE,
       Bus2IP_Data             => Bus2IP_Data,
       Bus2IP_RNW              => Bus2IP_RNW,
       Bus2IP_Burst            => Bus2IP_Burst,
       Bus2IP_WrReq            => Bus2IP_WrReq,
       Bus2IP_RdReq            => Bus2IP_RdReq,
       Bus2IP_Mem_CS           => memcon_cs_bus,
       BUS2IP_Reg_CS           => Bus2IP_CS(MCCR_NAME_INDEX),
       Bus2IP_WrCE             => Bus2IP_WrCE(MCCR_CE_INDEX to (MCCR_CE_INDEX+C_NUM_BANKS_MEM)-1),
       Bus2IP_RdCE             => Bus2IP_RdCE(MCCR_CE_INDEX to (MCCR_CE_INDEX+C_NUM_BANKS_MEM)-1),
       IP2Bus_Data             => IP2Bus_Data,
       IP2Bus_errAck           => IP2Bus_errAck,
       IP2Bus_retry            => IP2Bus_retry,
       IP2Bus_toutSup          => IP2Bus_toutSup,
       IP2Bus_RdAck            => IP2Bus_RdAck,
       IP2Bus_WrAck            => IP2Bus_WrAck,
       Mem_A                   => Mem_A_i,
       Mem_DQ_I                => Mem_DQ_I,
       Mem_DQ_O                => Mem_DQ_O_i,
       Mem_DQ_T                => Mem_DQ_T_i,
       Mem_CEN                 => Mem_CEN_i,
       Mem_OEN                 => Mem_OEN_i,
       Mem_WEN                 => Mem_WEN_i,
       Mem_QWEN                => Mem_QWEN_i,
       Mem_BEN                 => Mem_BEN_i,
       Mem_RPN                 => Mem_RPN,

       -- added for ZBT
       Mem_CE                  => Mem_CE_i,
       Mem_ADV_LDN             => Mem_ADV_LDN_i,
       Mem_LBON                => Mem_LBON,
       Mem_CKEN                => Mem_CKEN_i,
       Mem_RNW                 => Mem_RNW
       );

-------------------------------------------------------------------

  MAKE_CHIPSCOPE :  if C_INCLUDE_CHIPSCOPE = true generate
-------------------------------------------------------------------
    -- this code is only included to show an example of an instantiation
    -- of chipscope 
    -- the chipscope components (ethernet_icon and opb_emc_ila) are not
    -- included 
    
    --  ILA core signal declarations
    signal control_bus           : std_logic_vector(41 downto 0);
    signal ila_data              : std_logic_vector(127 downto 0);
    signal ila_trig              : std_logic_vector(7 downto 0);

    -------------------------------------------------------------------
    --
    --  ICON core component declaration
    --
    -------------------------------------------------------------------
    component ethernet_icon
      port
      (
        CONTROL0    :   out std_logic_vector(41 downto 0)
      );
    end component;

    -------------------------------------------------------------------
    --
    --  ICON core compiler-specific attributes
    --
    -------------------------------------------------------------------
    attribute syn_black_box : boolean;
    attribute syn_black_box of ethernet_icon : component is TRUE;
    attribute syn_noprune : boolean;
    attribute syn_noprune of ethernet_icon : component is TRUE;

    -------------------------------------------------------------------
    --
    --  ILA core component declaration
    --
    -------------------------------------------------------------------
    component opb_emc_ila
      port
      (
        CONTROL     : in    std_logic_vector(41 downto 0);
        CLK         : in    std_logic;
        DATA        : in    std_logic_vector(127 downto 0);
        TRIG        : in    std_logic_vector(7 downto 0)
      );
    end component;
    component ila_64
      port
      (
        CONTROL     : in    std_logic_vector(41 downto 0);
        CLK         : in    std_logic;
        DATA        : in    std_logic_vector(63 downto 0);
        TRIG        : in    std_logic_vector(7 downto 0)
      );
    end component;

    -------------------------------------------------------------------
    --
    --  ILA core compiler-specific attributes
    --
    -------------------------------------------------------------------
    attribute syn_black_box of opb_emc_ila : component is TRUE;
    attribute syn_noprune of opb_emc_ila : component is TRUE;
    attribute syn_black_box of ila_64 : component is TRUE;
    attribute syn_noprune of ila_64 : component is TRUE;

    begin
       -------------------------------------------------------------------
       --
       --  ICON core instance
       --
       -------------------------------------------------------------------
       i_ethernet_icon : ethernet_icon
         port map
         (
           CONTROL0   => control_bus
         );

       -------------------------------------------------------------------
       --
       --  ILA core instance
       --
       -------------------------------------------------------------------
       i_emc_ila : opb_emc_ila
         port map
         (
           CONTROL => control_bus,
           CLK     => OPB_Clk,
           DATA    => ila_data,
           TRIG    => ila_trig
         );

       ila_trig(0)            <=   OPB_select;
       ila_trig(1)            <=   OPB_RNW;
       ila_trig(2)            <=   IP2Bus_rdAck;
       ila_trig(3)            <=   IP2Bus_wrAck;
       ila_trig(4)            <=   memcon_cs_bus(0);
       ila_trig(5)            <=   Bus2IP_rdReq;
       ila_trig(6)            <=   Bus2IP_wrReq;
       ila_trig(7)            <=   Sln_xferAck_i;

       ila_data(31 downto 0)    <=   IP2Bus_Data(0 to 31);
       ila_data(39 downto 32)   <=   Mem_DQ_I(0 to 7);
       ila_data(47 downto 40)   <=   Mem_DQ_O_i(0 to 7);
       ila_data(79 downto 48)   <=   Bus2IP_Data(0 to 31);
       ila_data(83 downto 80)   <=   Bus2IP_BE;
       
       ila_data(111 downto 84)  <=   OPB_ABus(4 to 31);
       ila_data(112)            <=   Mem_BEN_i(0);
       ila_data(113)            <=   Bus2IP_rdReq;
       ila_data(114)            <=   IP2Bus_rdAck;
       ila_data(115)            <=   IP2Bus_wrAck;
       ila_data(116)            <=   Mem_CEN_i(0);
       ila_data(117)            <=   Mem_OEN_i(0);
       ila_data(118)            <=   Mem_WEN_i;
       ila_data(119)            <=   Sln_xferAck_i;
       ila_data(127 downto 120) <=   Mem_A_i(24 to 31);



    end generate MAKE_CHIPSCOPE;


end implementation;