-- $Id: opb_emc_wrap.vhd,v 1.1 2003/03/27 20:31:19 anitas Exp $

-- opb_emc_wrap.vhd
--   Generated by wrapgen, v1.01f Mar 26,2003 17:12:59

library ieee;
library opb_emc_v1_10_b;

use ieee.std_logic_1164.all;
use opb_emc_v1_10_b.all;

-------------------------------------------------------------------------------
-- entity
-------------------------------------------------------------------------------

entity opb_emc_wrap is
  generic
  (
    C_NUM_BANKS_MEM                   : integer range 1 to 8 := 2;
    C_INCLUDE_NEGEDGE_IOREGS          : integer              := 0;
    C_BASEADDR                        : std_logic_vector     := X"FFFF_FFFF";
    C_HIGHADDR                        : std_logic_vector     := X"0000_0000";
    C_MEM0_BASEADDR                   : std_logic_vector     := X"FFFF_FFFF";
    C_MEM0_HIGHADDR                   : std_logic_vector     := X"0000_0000";
    C_MEM1_BASEADDR                   : std_logic_vector     := X"FFFF_FFFF";
    C_MEM1_HIGHADDR                   : std_logic_vector     := X"0000_0000";
    C_MEM2_BASEADDR                   : std_logic_vector     := X"FFFF_FFFF";
    C_MEM2_HIGHADDR                   : std_logic_vector     := X"0000_0000";
    C_MEM3_BASEADDR                   : std_logic_vector     := X"FFFF_FFFF";
    C_MEM3_HIGHADDR                   : std_logic_vector     := X"0000_0000";
    C_MEM4_BASEADDR                   : std_logic_vector     := X"FFFF_FFFF";
    C_MEM4_HIGHADDR                   : std_logic_vector     := X"0000_0000";
    C_MEM5_BASEADDR                   : std_logic_vector     := X"FFFF_FFFF";
    C_MEM5_HIGHADDR                   : std_logic_vector     := X"0000_0000";
    C_MEM6_BASEADDR                   : std_logic_vector     := X"FFFF_FFFF";
    C_MEM6_HIGHADDR                   : std_logic_vector     := X"0000_0000";
    C_MEM7_BASEADDR                   : std_logic_vector     := X"FFFF_FFFF";
    C_MEM7_HIGHADDR                   : std_logic_vector     := X"0000_0000";
    C_MEM0_WIDTH                      : integer              := 32;
    C_MEM1_WIDTH                      : integer              := 32;
    C_MEM2_WIDTH                      : integer              := 32;
    C_MEM3_WIDTH                      : integer              := 32;
    C_MEM4_WIDTH                      : integer              := 32;
    C_MEM5_WIDTH                      : integer              := 32;
    C_MEM6_WIDTH                      : integer              := 32;
    C_MEM7_WIDTH                      : integer              := 32;
    C_MAX_MEM_WIDTH                   : integer              := 32;
    C_INCLUDE_DATAWIDTH_MATCHING_0    : integer              := 1;
    C_INCLUDE_DATAWIDTH_MATCHING_1    : integer              := 1;
    C_INCLUDE_DATAWIDTH_MATCHING_2    : integer              := 1;
    C_INCLUDE_DATAWIDTH_MATCHING_3    : integer              := 1;
    C_INCLUDE_DATAWIDTH_MATCHING_4    : integer              := 1;
    C_INCLUDE_DATAWIDTH_MATCHING_5    : integer              := 1;
    C_INCLUDE_DATAWIDTH_MATCHING_6    : integer              := 1;
    C_INCLUDE_DATAWIDTH_MATCHING_7    : integer              := 1;
    C_SYNCH_MEM_0                     : integer              := 0;
    C_SYNCH_PIPEDELAY_0               : integer              := 2;
    C_READ_ADDR_TO_OUT_SLOW_PS_0      : integer              := 0;
    C_WRITE_ADDR_TO_OUT_SLOW_PS_0     : integer              := 0;
    C_WRITE_MIN_PULSE_WIDTH_PS_0      : integer              := 0;
    C_READ_ADDR_TO_OUT_FAST_PS_0      : integer              := 0;
    C_WRITE_ADDR_TO_OUT_FAST_PS_0     : integer              := 0;
    C_READ_RECOVERY_BEFORE_WRITE_PS_0 : integer              := 0;
    C_WRITE_RECOVERY_BEFORE_READ_PS_0 : integer              := 0;
    C_SYNCH_MEM_1                     : integer              := 0;
    C_SYNCH_PIPEDELAY_1               : integer              := 2;
    C_READ_ADDR_TO_OUT_SLOW_PS_1      : integer              := 0;
    C_WRITE_ADDR_TO_OUT_SLOW_PS_1     : integer              := 0;
    C_WRITE_MIN_PULSE_WIDTH_PS_1      : integer              := 0;
    C_READ_ADDR_TO_OUT_FAST_PS_1      : integer              := 0;
    C_WRITE_ADDR_TO_OUT_FAST_PS_1     : integer              := 0;
    C_READ_RECOVERY_BEFORE_WRITE_PS_1 : integer              := 0;
    C_WRITE_RECOVERY_BEFORE_READ_PS_1 : integer              := 0;
    C_SYNCH_MEM_2                     : integer              := 0;
    C_SYNCH_PIPEDELAY_2               : integer              := 2;
    C_READ_ADDR_TO_OUT_SLOW_PS_2      : integer              := 0;
    C_WRITE_ADDR_TO_OUT_SLOW_PS_2     : integer              := 0;
    C_WRITE_MIN_PULSE_WIDTH_PS_2      : integer              := 0;
    C_READ_ADDR_TO_OUT_FAST_PS_2      : integer              := 0;
    C_WRITE_ADDR_TO_OUT_FAST_PS_2     : integer              := 0;
    C_READ_RECOVERY_BEFORE_WRITE_PS_2 : integer              := 0;
    C_WRITE_RECOVERY_BEFORE_READ_PS_2 : integer              := 0;
    C_SYNCH_MEM_3                     : integer              := 0;
    C_SYNCH_PIPEDELAY_3               : integer              := 2;
    C_READ_ADDR_TO_OUT_SLOW_PS_3      : integer              := 0;
    C_WRITE_ADDR_TO_OUT_SLOW_PS_3     : integer              := 0;
    C_WRITE_MIN_PULSE_WIDTH_PS_3      : integer              := 0;
    C_READ_ADDR_TO_OUT_FAST_PS_3      : integer              := 0;
    C_WRITE_ADDR_TO_OUT_FAST_PS_3     : integer              := 0;
    C_READ_RECOVERY_BEFORE_WRITE_PS_3 : integer              := 0;
    C_WRITE_RECOVERY_BEFORE_READ_PS_3 : integer              := 0;
    C_SYNCH_MEM_4                     : integer              := 0;
    C_SYNCH_PIPEDELAY_4               : integer              := 2;
    C_READ_ADDR_TO_OUT_SLOW_PS_4      : integer              := 0;
    C_WRITE_ADDR_TO_OUT_SLOW_PS_4     : integer              := 0;
    C_WRITE_MIN_PULSE_WIDTH_PS_4      : integer              := 0;
    C_READ_ADDR_TO_OUT_FAST_PS_4      : integer              := 0;
    C_WRITE_ADDR_TO_OUT_FAST_PS_4     : integer              := 0;
    C_READ_RECOVERY_BEFORE_WRITE_PS_4 : integer              := 0;
    C_WRITE_RECOVERY_BEFORE_READ_PS_4 : integer              := 0;
    C_SYNCH_MEM_5                     : integer              := 0;
    C_SYNCH_PIPEDELAY_5               : integer              := 2;
    C_READ_ADDR_TO_OUT_SLOW_PS_5      : integer              := 0;
    C_WRITE_ADDR_TO_OUT_SLOW_PS_5     : integer              := 0;
    C_WRITE_MIN_PULSE_WIDTH_PS_5      : integer              := 0;
    C_READ_ADDR_TO_OUT_FAST_PS_5      : integer              := 0;
    C_WRITE_ADDR_TO_OUT_FAST_PS_5     : integer              := 0;
    C_READ_RECOVERY_BEFORE_WRITE_PS_5 : integer              := 0;
    C_WRITE_RECOVERY_BEFORE_READ_PS_5 : integer              := 0;
    C_SYNCH_MEM_6                     : integer              := 0;
    C_SYNCH_PIPEDELAY_6               : integer              := 2;
    C_READ_ADDR_TO_OUT_SLOW_PS_6      : integer              := 0;
    C_WRITE_ADDR_TO_OUT_SLOW_PS_6     : integer              := 0;
    C_WRITE_MIN_PULSE_WIDTH_PS_6      : integer              := 0;
    C_READ_ADDR_TO_OUT_FAST_PS_6      : integer              := 0;
    C_WRITE_ADDR_TO_OUT_FAST_PS_6     : integer              := 0;
    C_READ_RECOVERY_BEFORE_WRITE_PS_6 : integer              := 0;
    C_WRITE_RECOVERY_BEFORE_READ_PS_6 : integer              := 0;
    C_SYNCH_MEM_7                     : integer              := 0;
    C_SYNCH_PIPEDELAY_7               : integer              := 2;
    C_READ_ADDR_TO_OUT_SLOW_PS_7      : integer              := 0;
    C_WRITE_ADDR_TO_OUT_SLOW_PS_7     : integer              := 0;
    C_WRITE_MIN_PULSE_WIDTH_PS_7      : integer              := 0;
    C_READ_ADDR_TO_OUT_FAST_PS_7      : integer              := 0;
    C_WRITE_ADDR_TO_OUT_FAST_PS_7     : integer              := 0;
    C_READ_RECOVERY_BEFORE_WRITE_PS_7 : integer              := 0;
    C_WRITE_RECOVERY_BEFORE_READ_PS_7 : integer              := 0;
    C_OPB_DWIDTH                      : integer              := 32;
    C_OPB_AWIDTH                      : integer              := 32;
    C_OPB_CLK_PERIOD_PS               : integer              := 10000;
    C_DEV_BLK_ID                      : INTEGER              := 1;
    C_DEV_MIR_ENABLE                  : INTEGER              := 1
  );
  port
  (
    OPB_Clk     : in  std_logic;
    OPB_Rst     : in  std_logic;
    OPB_ABus    : in  std_logic_vector(0 to C_OPB_AWIDTH - 1 );
    OPB_DBus    : in  std_logic_vector(0 to C_OPB_DWIDTH - 1 );
    Sln_DBus    : out std_logic_vector(0 to C_OPB_DWIDTH - 1 );
    OPB_select  : in  std_logic                                  := '0';
    OPB_RNW     : in  std_logic                                  := '0';
    OPB_seqAddr : in  std_logic                                  := '0';
    OPB_BE      : in  std_logic_vector(0 to C_OPB_DWIDTH/8 - 1 );
    Sln_xferAck : out std_logic;
    Sln_errAck  : out std_logic;
    Sln_toutSup : out std_logic;
    Sln_retry   : out std_logic;
    Mem_A       : out std_logic_vector(0 to C_OPB_AWIDTH-1);
    Mem_DQ_I    : in  std_logic_vector(0 to C_MAX_MEM_WIDTH-1);
    Mem_DQ_O    : out std_logic_vector(0 to C_MAX_MEM_WIDTH-1);
    Mem_DQ_T    : out std_logic_vector(0 to C_MAX_MEM_WIDTH-1);
    Mem_CEN     : out std_logic_vector(0 to C_NUM_BANKS_MEM-1);
    Mem_OEN     : out std_logic_vector(0 to C_NUM_BANKS_MEM-1);
    Mem_WEN     : out std_logic;
    Mem_QWEN    : out std_logic_vector(0 to C_MAX_MEM_WIDTH/8-1);
    Mem_BEN     : out std_logic_vector(0 to C_MAX_MEM_WIDTH/8-1);
    Mem_RPN     : out std_logic;
    Mem_CE      : out std_logic_vector(0 to C_NUM_BANKS_MEM-1);
    Mem_ADV_LDN : out std_logic;
    Mem_LBON    : out std_logic;
    Mem_CKEN    : out std_logic;
    Mem_RNW     : out std_logic
  );
end entity opb_emc_wrap;

-------------------------------------------------------------------------------
-- architecture
-------------------------------------------------------------------------------

architecture imp of opb_emc_wrap is

  component opb_emc is
    generic
    (
      C_NUM_BANKS_MEM                   : integer range 1 to 8 := 2;
      C_INCLUDE_NEGEDGE_IOREGS          : integer              := 0;
      C_BASEADDR                        : std_logic_vector     := X"FFFF_FFFF";
      C_HIGHADDR                        : std_logic_vector     := X"0000_0000";
      C_MEM0_BASEADDR                   : std_logic_vector     := X"FFFF_FFFF";
      C_MEM0_HIGHADDR                   : std_logic_vector     := X"0000_0000";
      C_MEM1_BASEADDR                   : std_logic_vector     := X"FFFF_FFFF";
      C_MEM1_HIGHADDR                   : std_logic_vector     := X"0000_0000";
      C_MEM2_BASEADDR                   : std_logic_vector     := X"FFFF_FFFF";
      C_MEM2_HIGHADDR                   : std_logic_vector     := X"0000_0000";
      C_MEM3_BASEADDR                   : std_logic_vector     := X"FFFF_FFFF";
      C_MEM3_HIGHADDR                   : std_logic_vector     := X"0000_0000";
      C_MEM4_BASEADDR                   : std_logic_vector     := X"FFFF_FFFF";
      C_MEM4_HIGHADDR                   : std_logic_vector     := X"0000_0000";
      C_MEM5_BASEADDR                   : std_logic_vector     := X"FFFF_FFFF";
      C_MEM5_HIGHADDR                   : std_logic_vector     := X"0000_0000";
      C_MEM6_BASEADDR                   : std_logic_vector     := X"FFFF_FFFF";
      C_MEM6_HIGHADDR                   : std_logic_vector     := X"0000_0000";
      C_MEM7_BASEADDR                   : std_logic_vector     := X"FFFF_FFFF";
      C_MEM7_HIGHADDR                   : std_logic_vector     := X"0000_0000";
      C_MEM0_WIDTH                      : integer              := 32;
      C_MEM1_WIDTH                      : integer              := 32;
      C_MEM2_WIDTH                      : integer              := 32;
      C_MEM3_WIDTH                      : integer              := 32;
      C_MEM4_WIDTH                      : integer              := 32;
      C_MEM5_WIDTH                      : integer              := 32;
      C_MEM6_WIDTH                      : integer              := 32;
      C_MEM7_WIDTH                      : integer              := 32;
      C_MAX_MEM_WIDTH                   : integer              := 32;
      C_INCLUDE_DATAWIDTH_MATCHING_0    : integer              := 1;
      C_INCLUDE_DATAWIDTH_MATCHING_1    : integer              := 1;
      C_INCLUDE_DATAWIDTH_MATCHING_2    : integer              := 1;
      C_INCLUDE_DATAWIDTH_MATCHING_3    : integer              := 1;
      C_INCLUDE_DATAWIDTH_MATCHING_4    : integer              := 1;
      C_INCLUDE_DATAWIDTH_MATCHING_5    : integer              := 1;
      C_INCLUDE_DATAWIDTH_MATCHING_6    : integer              := 1;
      C_INCLUDE_DATAWIDTH_MATCHING_7    : integer              := 1;
      C_SYNCH_MEM_0                     : integer              := 0;
      C_SYNCH_PIPEDELAY_0               : integer              := 2;
      C_READ_ADDR_TO_OUT_SLOW_PS_0      : integer              := 0;
      C_WRITE_ADDR_TO_OUT_SLOW_PS_0     : integer              := 0;
      C_WRITE_MIN_PULSE_WIDTH_PS_0      : integer              := 0;
      C_READ_ADDR_TO_OUT_FAST_PS_0      : integer              := 0;
      C_WRITE_ADDR_TO_OUT_FAST_PS_0     : integer              := 0;
      C_READ_RECOVERY_BEFORE_WRITE_PS_0 : integer              := 0;
      C_WRITE_RECOVERY_BEFORE_READ_PS_0 : integer              := 0;
      C_SYNCH_MEM_1                     : integer              := 0;
      C_SYNCH_PIPEDELAY_1               : integer              := 2;
      C_READ_ADDR_TO_OUT_SLOW_PS_1      : integer              := 0;
      C_WRITE_ADDR_TO_OUT_SLOW_PS_1     : integer              := 0;
      C_WRITE_MIN_PULSE_WIDTH_PS_1      : integer              := 0;
      C_READ_ADDR_TO_OUT_FAST_PS_1      : integer              := 0;
      C_WRITE_ADDR_TO_OUT_FAST_PS_1     : integer              := 0;
      C_READ_RECOVERY_BEFORE_WRITE_PS_1 : integer              := 0;
      C_WRITE_RECOVERY_BEFORE_READ_PS_1 : integer              := 0;
      C_SYNCH_MEM_2                     : integer              := 0;
      C_SYNCH_PIPEDELAY_2               : integer              := 2;
      C_READ_ADDR_TO_OUT_SLOW_PS_2      : integer              := 0;
      C_WRITE_ADDR_TO_OUT_SLOW_PS_2     : integer              := 0;
      C_WRITE_MIN_PULSE_WIDTH_PS_2      : integer              := 0;
      C_READ_ADDR_TO_OUT_FAST_PS_2      : integer              := 0;
      C_WRITE_ADDR_TO_OUT_FAST_PS_2     : integer              := 0;
      C_READ_RECOVERY_BEFORE_WRITE_PS_2 : integer              := 0;
      C_WRITE_RECOVERY_BEFORE_READ_PS_2 : integer              := 0;
      C_SYNCH_MEM_3                     : integer              := 0;
      C_SYNCH_PIPEDELAY_3               : integer              := 2;
      C_READ_ADDR_TO_OUT_SLOW_PS_3      : integer              := 0;
      C_WRITE_ADDR_TO_OUT_SLOW_PS_3     : integer              := 0;
      C_WRITE_MIN_PULSE_WIDTH_PS_3      : integer              := 0;
      C_READ_ADDR_TO_OUT_FAST_PS_3      : integer              := 0;
      C_WRITE_ADDR_TO_OUT_FAST_PS_3     : integer              := 0;
      C_READ_RECOVERY_BEFORE_WRITE_PS_3 : integer              := 0;
      C_WRITE_RECOVERY_BEFORE_READ_PS_3 : integer              := 0;
      C_SYNCH_MEM_4                     : integer              := 0;
      C_SYNCH_PIPEDELAY_4               : integer              := 2;
      C_READ_ADDR_TO_OUT_SLOW_PS_4      : integer              := 0;
      C_WRITE_ADDR_TO_OUT_SLOW_PS_4     : integer              := 0;
      C_WRITE_MIN_PULSE_WIDTH_PS_4      : integer              := 0;
      C_READ_ADDR_TO_OUT_FAST_PS_4      : integer              := 0;
      C_WRITE_ADDR_TO_OUT_FAST_PS_4     : integer              := 0;
      C_READ_RECOVERY_BEFORE_WRITE_PS_4 : integer              := 0;
      C_WRITE_RECOVERY_BEFORE_READ_PS_4 : integer              := 0;
      C_SYNCH_MEM_5                     : integer              := 0;
      C_SYNCH_PIPEDELAY_5               : integer              := 2;
      C_READ_ADDR_TO_OUT_SLOW_PS_5      : integer              := 0;
      C_WRITE_ADDR_TO_OUT_SLOW_PS_5     : integer              := 0;
      C_WRITE_MIN_PULSE_WIDTH_PS_5      : integer              := 0;
      C_READ_ADDR_TO_OUT_FAST_PS_5      : integer              := 0;
      C_WRITE_ADDR_TO_OUT_FAST_PS_5     : integer              := 0;
      C_READ_RECOVERY_BEFORE_WRITE_PS_5 : integer              := 0;
      C_WRITE_RECOVERY_BEFORE_READ_PS_5 : integer              := 0;
      C_SYNCH_MEM_6                     : integer              := 0;
      C_SYNCH_PIPEDELAY_6               : integer              := 2;
      C_READ_ADDR_TO_OUT_SLOW_PS_6      : integer              := 0;
      C_WRITE_ADDR_TO_OUT_SLOW_PS_6     : integer              := 0;
      C_WRITE_MIN_PULSE_WIDTH_PS_6      : integer              := 0;
      C_READ_ADDR_TO_OUT_FAST_PS_6      : integer              := 0;
      C_WRITE_ADDR_TO_OUT_FAST_PS_6     : integer              := 0;
      C_READ_RECOVERY_BEFORE_WRITE_PS_6 : integer              := 0;
      C_WRITE_RECOVERY_BEFORE_READ_PS_6 : integer              := 0;
      C_SYNCH_MEM_7                     : integer              := 0;
      C_SYNCH_PIPEDELAY_7               : integer              := 2;
      C_READ_ADDR_TO_OUT_SLOW_PS_7      : integer              := 0;
      C_WRITE_ADDR_TO_OUT_SLOW_PS_7     : integer              := 0;
      C_WRITE_MIN_PULSE_WIDTH_PS_7      : integer              := 0;
      C_READ_ADDR_TO_OUT_FAST_PS_7      : integer              := 0;
      C_WRITE_ADDR_TO_OUT_FAST_PS_7     : integer              := 0;
      C_READ_RECOVERY_BEFORE_WRITE_PS_7 : integer              := 0;
      C_WRITE_RECOVERY_BEFORE_READ_PS_7 : integer              := 0;
      C_OPB_DWIDTH                      : integer              := 32;
      C_OPB_AWIDTH                      : integer              := 32;
      C_OPB_CLK_PERIOD_PS               : integer              := 10000;
      C_DEV_BLK_ID                      : INTEGER              := 1;
      C_DEV_MIR_ENABLE                  : INTEGER              := 1
    );
    port
    (
      OPB_Clk     : in  std_logic;
      OPB_Rst     : in  std_logic;
      OPB_ABus    : in  std_logic_vector(0 to C_OPB_AWIDTH - 1 );
      OPB_DBus    : in  std_logic_vector(0 to C_OPB_DWIDTH - 1 );
      Sln_DBus    : out std_logic_vector(0 to C_OPB_DWIDTH - 1 );
      OPB_select  : in  std_logic                                  := '0';
      OPB_RNW     : in  std_logic                                  := '0';
      OPB_seqAddr : in  std_logic                                  := '0';
      OPB_BE      : in  std_logic_vector(0 to C_OPB_DWIDTH/8 - 1 );
      Sln_xferAck : out std_logic;
      Sln_errAck  : out std_logic;
      Sln_toutSup : out std_logic;
      Sln_retry   : out std_logic;
      Mem_A       : out std_logic_vector(0 to C_OPB_AWIDTH-1);
      Mem_DQ_I    : in  std_logic_vector(0 to C_MAX_MEM_WIDTH-1);
      Mem_DQ_O    : out std_logic_vector(0 to C_MAX_MEM_WIDTH-1);
      Mem_DQ_T    : out std_logic_vector(0 to C_MAX_MEM_WIDTH-1);
      Mem_CEN     : out std_logic_vector(0 to C_NUM_BANKS_MEM-1);
      Mem_OEN     : out std_logic_vector(0 to C_NUM_BANKS_MEM-1);
      Mem_WEN     : out std_logic;
      Mem_QWEN    : out std_logic_vector(0 to C_MAX_MEM_WIDTH/8-1);
      Mem_BEN     : out std_logic_vector(0 to C_MAX_MEM_WIDTH/8-1);
      Mem_RPN     : out std_logic;
      Mem_CE      : out std_logic_vector(0 to C_NUM_BANKS_MEM-1);
      Mem_ADV_LDN : out std_logic;
      Mem_LBON    : out std_logic;
      Mem_CKEN    : out std_logic;
      Mem_RNW     : out std_logic
    );
  end component opb_emc;

begin  ------------------------------------------------------------------------

  OPB_EMC_I : opb_emc
    generic map
    (
      C_NUM_BANKS_MEM                   => C_NUM_BANKS_MEM,
      C_INCLUDE_NEGEDGE_IOREGS          => C_INCLUDE_NEGEDGE_IOREGS,
      C_BASEADDR                        => C_BASEADDR,
      C_HIGHADDR                        => C_HIGHADDR,
      C_MEM0_BASEADDR                   => C_MEM0_BASEADDR,
      C_MEM0_HIGHADDR                   => C_MEM0_HIGHADDR,
      C_MEM1_BASEADDR                   => C_MEM1_BASEADDR,
      C_MEM1_HIGHADDR                   => C_MEM1_HIGHADDR,
      C_MEM2_BASEADDR                   => C_MEM2_BASEADDR,
      C_MEM2_HIGHADDR                   => C_MEM2_HIGHADDR,
      C_MEM3_BASEADDR                   => C_MEM3_BASEADDR,
      C_MEM3_HIGHADDR                   => C_MEM3_HIGHADDR,
      C_MEM4_BASEADDR                   => C_MEM4_BASEADDR,
      C_MEM4_HIGHADDR                   => C_MEM4_HIGHADDR,
      C_MEM5_BASEADDR                   => C_MEM5_BASEADDR,
      C_MEM5_HIGHADDR                   => C_MEM5_HIGHADDR,
      C_MEM6_BASEADDR                   => C_MEM6_BASEADDR,
      C_MEM6_HIGHADDR                   => C_MEM6_HIGHADDR,
      C_MEM7_BASEADDR                   => C_MEM7_BASEADDR,
      C_MEM7_HIGHADDR                   => C_MEM7_HIGHADDR,
      C_MEM0_WIDTH                      => C_MEM0_WIDTH,
      C_MEM1_WIDTH                      => C_MEM1_WIDTH,
      C_MEM2_WIDTH                      => C_MEM2_WIDTH,
      C_MEM3_WIDTH                      => C_MEM3_WIDTH,
      C_MEM4_WIDTH                      => C_MEM4_WIDTH,
      C_MEM5_WIDTH                      => C_MEM5_WIDTH,
      C_MEM6_WIDTH                      => C_MEM6_WIDTH,
      C_MEM7_WIDTH                      => C_MEM7_WIDTH,
      C_MAX_MEM_WIDTH                   => C_MAX_MEM_WIDTH,
      C_INCLUDE_DATAWIDTH_MATCHING_0    => C_INCLUDE_DATAWIDTH_MATCHING_0,
      C_INCLUDE_DATAWIDTH_MATCHING_1    => C_INCLUDE_DATAWIDTH_MATCHING_1,
      C_INCLUDE_DATAWIDTH_MATCHING_2    => C_INCLUDE_DATAWIDTH_MATCHING_2,
      C_INCLUDE_DATAWIDTH_MATCHING_3    => C_INCLUDE_DATAWIDTH_MATCHING_3,
      C_INCLUDE_DATAWIDTH_MATCHING_4    => C_INCLUDE_DATAWIDTH_MATCHING_4,
      C_INCLUDE_DATAWIDTH_MATCHING_5    => C_INCLUDE_DATAWIDTH_MATCHING_5,
      C_INCLUDE_DATAWIDTH_MATCHING_6    => C_INCLUDE_DATAWIDTH_MATCHING_6,
      C_INCLUDE_DATAWIDTH_MATCHING_7    => C_INCLUDE_DATAWIDTH_MATCHING_7,
      C_SYNCH_MEM_0                     => C_SYNCH_MEM_0,
      C_SYNCH_PIPEDELAY_0               => C_SYNCH_PIPEDELAY_0,
      C_READ_ADDR_TO_OUT_SLOW_PS_0      => C_READ_ADDR_TO_OUT_SLOW_PS_0,
      C_WRITE_ADDR_TO_OUT_SLOW_PS_0     => C_WRITE_ADDR_TO_OUT_SLOW_PS_0,
      C_WRITE_MIN_PULSE_WIDTH_PS_0      => C_WRITE_MIN_PULSE_WIDTH_PS_0,
      C_READ_ADDR_TO_OUT_FAST_PS_0      => C_READ_ADDR_TO_OUT_FAST_PS_0,
      C_WRITE_ADDR_TO_OUT_FAST_PS_0     => C_WRITE_ADDR_TO_OUT_FAST_PS_0,
      C_READ_RECOVERY_BEFORE_WRITE_PS_0 => C_READ_RECOVERY_BEFORE_WRITE_PS_0,
      C_WRITE_RECOVERY_BEFORE_READ_PS_0 => C_WRITE_RECOVERY_BEFORE_READ_PS_0,
      C_SYNCH_MEM_1                     => C_SYNCH_MEM_1,
      C_SYNCH_PIPEDELAY_1               => C_SYNCH_PIPEDELAY_1,
      C_READ_ADDR_TO_OUT_SLOW_PS_1      => C_READ_ADDR_TO_OUT_SLOW_PS_1,
      C_WRITE_ADDR_TO_OUT_SLOW_PS_1     => C_WRITE_ADDR_TO_OUT_SLOW_PS_1,
      C_WRITE_MIN_PULSE_WIDTH_PS_1      => C_WRITE_MIN_PULSE_WIDTH_PS_1,
      C_READ_ADDR_TO_OUT_FAST_PS_1      => C_READ_ADDR_TO_OUT_FAST_PS_1,
      C_WRITE_ADDR_TO_OUT_FAST_PS_1     => C_WRITE_ADDR_TO_OUT_FAST_PS_1,
      C_READ_RECOVERY_BEFORE_WRITE_PS_1 => C_READ_RECOVERY_BEFORE_WRITE_PS_1,
      C_WRITE_RECOVERY_BEFORE_READ_PS_1 => C_WRITE_RECOVERY_BEFORE_READ_PS_1,
      C_SYNCH_MEM_2                     => C_SYNCH_MEM_2,
      C_SYNCH_PIPEDELAY_2               => C_SYNCH_PIPEDELAY_2,
      C_READ_ADDR_TO_OUT_SLOW_PS_2      => C_READ_ADDR_TO_OUT_SLOW_PS_2,
      C_WRITE_ADDR_TO_OUT_SLOW_PS_2     => C_WRITE_ADDR_TO_OUT_SLOW_PS_2,
      C_WRITE_MIN_PULSE_WIDTH_PS_2      => C_WRITE_MIN_PULSE_WIDTH_PS_2,
      C_READ_ADDR_TO_OUT_FAST_PS_2      => C_READ_ADDR_TO_OUT_FAST_PS_2,
      C_WRITE_ADDR_TO_OUT_FAST_PS_2     => C_WRITE_ADDR_TO_OUT_FAST_PS_2,
      C_READ_RECOVERY_BEFORE_WRITE_PS_2 => C_READ_RECOVERY_BEFORE_WRITE_PS_2,
      C_WRITE_RECOVERY_BEFORE_READ_PS_2 => C_WRITE_RECOVERY_BEFORE_READ_PS_2,
      C_SYNCH_MEM_3                     => C_SYNCH_MEM_3,
      C_SYNCH_PIPEDELAY_3               => C_SYNCH_PIPEDELAY_3,
      C_READ_ADDR_TO_OUT_SLOW_PS_3      => C_READ_ADDR_TO_OUT_SLOW_PS_3,
      C_WRITE_ADDR_TO_OUT_SLOW_PS_3     => C_WRITE_ADDR_TO_OUT_SLOW_PS_3,
      C_WRITE_MIN_PULSE_WIDTH_PS_3      => C_WRITE_MIN_PULSE_WIDTH_PS_3,
      C_READ_ADDR_TO_OUT_FAST_PS_3      => C_READ_ADDR_TO_OUT_FAST_PS_3,
      C_WRITE_ADDR_TO_OUT_FAST_PS_3     => C_WRITE_ADDR_TO_OUT_FAST_PS_3,
      C_READ_RECOVERY_BEFORE_WRITE_PS_3 => C_READ_RECOVERY_BEFORE_WRITE_PS_3,
      C_WRITE_RECOVERY_BEFORE_READ_PS_3 => C_WRITE_RECOVERY_BEFORE_READ_PS_3,
      C_SYNCH_MEM_4                     => C_SYNCH_MEM_4,
      C_SYNCH_PIPEDELAY_4               => C_SYNCH_PIPEDELAY_4,
      C_READ_ADDR_TO_OUT_SLOW_PS_4      => C_READ_ADDR_TO_OUT_SLOW_PS_4,
      C_WRITE_ADDR_TO_OUT_SLOW_PS_4     => C_WRITE_ADDR_TO_OUT_SLOW_PS_4,
      C_WRITE_MIN_PULSE_WIDTH_PS_4      => C_WRITE_MIN_PULSE_WIDTH_PS_4,
      C_READ_ADDR_TO_OUT_FAST_PS_4      => C_READ_ADDR_TO_OUT_FAST_PS_4,
      C_WRITE_ADDR_TO_OUT_FAST_PS_4     => C_WRITE_ADDR_TO_OUT_FAST_PS_4,
      C_READ_RECOVERY_BEFORE_WRITE_PS_4 => C_READ_RECOVERY_BEFORE_WRITE_PS_4,
      C_WRITE_RECOVERY_BEFORE_READ_PS_4 => C_WRITE_RECOVERY_BEFORE_READ_PS_4,
      C_SYNCH_MEM_5                     => C_SYNCH_MEM_5,
      C_SYNCH_PIPEDELAY_5               => C_SYNCH_PIPEDELAY_5,
      C_READ_ADDR_TO_OUT_SLOW_PS_5      => C_READ_ADDR_TO_OUT_SLOW_PS_5,
      C_WRITE_ADDR_TO_OUT_SLOW_PS_5     => C_WRITE_ADDR_TO_OUT_SLOW_PS_5,
      C_WRITE_MIN_PULSE_WIDTH_PS_5      => C_WRITE_MIN_PULSE_WIDTH_PS_5,
      C_READ_ADDR_TO_OUT_FAST_PS_5      => C_READ_ADDR_TO_OUT_FAST_PS_5,
      C_WRITE_ADDR_TO_OUT_FAST_PS_5     => C_WRITE_ADDR_TO_OUT_FAST_PS_5,
      C_READ_RECOVERY_BEFORE_WRITE_PS_5 => C_READ_RECOVERY_BEFORE_WRITE_PS_5,
      C_WRITE_RECOVERY_BEFORE_READ_PS_5 => C_WRITE_RECOVERY_BEFORE_READ_PS_5,
      C_SYNCH_MEM_6                     => C_SYNCH_MEM_6,
      C_SYNCH_PIPEDELAY_6               => C_SYNCH_PIPEDELAY_6,
      C_READ_ADDR_TO_OUT_SLOW_PS_6      => C_READ_ADDR_TO_OUT_SLOW_PS_6,
      C_WRITE_ADDR_TO_OUT_SLOW_PS_6     => C_WRITE_ADDR_TO_OUT_SLOW_PS_6,
      C_WRITE_MIN_PULSE_WIDTH_PS_6      => C_WRITE_MIN_PULSE_WIDTH_PS_6,
      C_READ_ADDR_TO_OUT_FAST_PS_6      => C_READ_ADDR_TO_OUT_FAST_PS_6,
      C_WRITE_ADDR_TO_OUT_FAST_PS_6     => C_WRITE_ADDR_TO_OUT_FAST_PS_6,
      C_READ_RECOVERY_BEFORE_WRITE_PS_6 => C_READ_RECOVERY_BEFORE_WRITE_PS_6,
      C_WRITE_RECOVERY_BEFORE_READ_PS_6 => C_WRITE_RECOVERY_BEFORE_READ_PS_6,
      C_SYNCH_MEM_7                     => C_SYNCH_MEM_7,
      C_SYNCH_PIPEDELAY_7               => C_SYNCH_PIPEDELAY_7,
      C_READ_ADDR_TO_OUT_SLOW_PS_7      => C_READ_ADDR_TO_OUT_SLOW_PS_7,
      C_WRITE_ADDR_TO_OUT_SLOW_PS_7     => C_WRITE_ADDR_TO_OUT_SLOW_PS_7,
      C_WRITE_MIN_PULSE_WIDTH_PS_7      => C_WRITE_MIN_PULSE_WIDTH_PS_7,
      C_READ_ADDR_TO_OUT_FAST_PS_7      => C_READ_ADDR_TO_OUT_FAST_PS_7,
      C_WRITE_ADDR_TO_OUT_FAST_PS_7     => C_WRITE_ADDR_TO_OUT_FAST_PS_7,
      C_READ_RECOVERY_BEFORE_WRITE_PS_7 => C_READ_RECOVERY_BEFORE_WRITE_PS_7,
      C_WRITE_RECOVERY_BEFORE_READ_PS_7 => C_WRITE_RECOVERY_BEFORE_READ_PS_7,
      C_OPB_DWIDTH                      => C_OPB_DWIDTH,
      C_OPB_AWIDTH                      => C_OPB_AWIDTH,
      C_OPB_CLK_PERIOD_PS               => C_OPB_CLK_PERIOD_PS,
      C_DEV_BLK_ID                      => C_DEV_BLK_ID,
      C_DEV_MIR_ENABLE                  => C_DEV_MIR_ENABLE
    )
    port map
    (
      OPB_Clk     => OPB_Clk,
      OPB_Rst     => OPB_Rst,
      OPB_ABus    => OPB_ABus,
      OPB_DBus    => OPB_DBus,
      Sln_DBus    => Sln_DBus,
      OPB_select  => OPB_select,
      OPB_RNW     => OPB_RNW,
      OPB_seqAddr => OPB_seqAddr,
      OPB_BE      => OPB_BE,
      Sln_xferAck => Sln_xferAck,
      Sln_errAck  => Sln_errAck,
      Sln_toutSup => Sln_toutSup,
      Sln_retry   => Sln_retry,
      Mem_A       => Mem_A,
      Mem_DQ_I    => Mem_DQ_I,
      Mem_DQ_O    => Mem_DQ_O,
      Mem_DQ_T    => Mem_DQ_T,
      Mem_CEN     => Mem_CEN,
      Mem_OEN     => Mem_OEN,
      Mem_WEN     => Mem_WEN,
      Mem_QWEN    => Mem_QWEN,
      Mem_BEN     => Mem_BEN,
      Mem_RPN     => Mem_RPN,
      Mem_CE      => Mem_CE,
      Mem_ADV_LDN => Mem_ADV_LDN,
      Mem_LBON    => Mem_LBON,
      Mem_CKEN    => Mem_CKEN,
      Mem_RNW     => Mem_RNW
    );

end architecture imp;

