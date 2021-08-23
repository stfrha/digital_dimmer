-------------------------------------------------------------------------------
-- sram_512kx8_flash_2mx8_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library proc_common_v1_00_b;
use proc_common_v1_00_b.all;

library ipif_common_v1_00_a;
use ipif_common_v1_00_a.all;

library opb_ipif_v2_00_a;
use opb_ipif_v2_00_a.all;

library emc_common_v1_10_b;
use emc_common_v1_10_b.all;

library opb_emc_v1_10_b;
use opb_emc_v1_10_b.all;

entity sram_512kx8_flash_2mx8_wrapper is
  port (
    OPB_Clk : in std_logic;
    OPB_Rst : in std_logic;
    OPB_ABus : in std_logic_vector(0 to 31);
    OPB_DBus : in std_logic_vector(0 to 31);
    Sln_DBus : out std_logic_vector(0 to 31);
    OPB_select : in std_logic;
    OPB_RNW : in std_logic;
    OPB_seqAddr : in std_logic;
    OPB_BE : in std_logic_vector(0 to 3);
    Sln_xferAck : out std_logic;
    Sln_errAck : out std_logic;
    Sln_toutSup : out std_logic;
    Sln_retry : out std_logic;
    Mem_A : out std_logic_vector(0 to 31);
    Mem_CEN : out std_logic_vector(0 to 0);
    Mem_OEN : out std_logic_vector(0 to 0);
    Mem_WEN : out std_logic;
    Mem_QWEN : out std_logic_vector(0 to 0);
    Mem_BEN : out std_logic_vector(0 to 0);
    Mem_RPN : out std_logic;
    Mem_CE : out std_logic_vector(0 to 0);
    Mem_ADV_LDN : out std_logic;
    Mem_LBON : out std_logic;
    Mem_CKEN : out std_logic;
    Mem_RNW : out std_logic;
    Mem_DQ_I : in std_logic_vector(0 to 7);
    Mem_DQ_O : out std_logic_vector(0 to 7);
    Mem_DQ_T : out std_logic_vector(0 to 7)
  );
  attribute x_core_info : STRING;
  attribute x_core_info of sram_512kx8_flash_2mx8_wrapper: entity is "opb_emc_v1_10_b";

end sram_512kx8_flash_2mx8_wrapper;

architecture STRUCTURE of sram_512kx8_flash_2mx8_wrapper is

  component opb_emc is
    generic (
      C_NUM_BANKS_MEM : integer range 1 to 8;
      C_INCLUDE_NEGEDGE_IOREGS : integer range 0 to 1;
      C_BASEADDR : std_logic_vector;
      C_HIGHADDR : std_logic_vector;
      C_MEM0_BASEADDR : std_logic_vector;
      C_MEM0_HIGHADDR : std_logic_vector;
      C_MEM1_BASEADDR : std_logic_vector;
      C_MEM1_HIGHADDR : std_logic_vector;
      C_MEM2_BASEADDR : std_logic_vector;
      C_MEM2_HIGHADDR : std_logic_vector;
      C_MEM3_BASEADDR : std_logic_vector;
      C_MEM3_HIGHADDR : std_logic_vector;
      C_MEM4_BASEADDR : std_logic_vector;
      C_MEM4_HIGHADDR : std_logic_vector;
      C_MEM5_BASEADDR : std_logic_vector;
      C_MEM5_HIGHADDR : std_logic_vector;
      C_MEM6_BASEADDR : std_logic_vector;
      C_MEM6_HIGHADDR : std_logic_vector;
      C_MEM7_BASEADDR : std_logic_vector;
      C_MEM7_HIGHADDR : std_logic_vector;
      C_MEM0_WIDTH : integer;
      C_MEM1_WIDTH : integer;
      C_MEM2_WIDTH : integer;
      C_MEM3_WIDTH : integer;
      C_MEM4_WIDTH : integer;
      C_MEM5_WIDTH : integer;
      C_MEM6_WIDTH : integer;
      C_MEM7_WIDTH : integer;
      C_MAX_MEM_WIDTH : integer;
      C_INCLUDE_DATAWIDTH_MATCHING_0 : integer;
      C_INCLUDE_DATAWIDTH_MATCHING_1 : integer;
      C_INCLUDE_DATAWIDTH_MATCHING_2 : integer;
      C_INCLUDE_DATAWIDTH_MATCHING_3 : integer;
      C_INCLUDE_DATAWIDTH_MATCHING_4 : integer;
      C_INCLUDE_DATAWIDTH_MATCHING_5 : integer;
      C_INCLUDE_DATAWIDTH_MATCHING_6 : integer;
      C_INCLUDE_DATAWIDTH_MATCHING_7 : integer;
      C_SYNCH_MEM_0 : integer;
      C_SYNCH_PIPEDELAY_0 : integer;
      C_READ_ADDR_TO_OUT_SLOW_PS_0 : integer;
      C_WRITE_ADDR_TO_OUT_SLOW_PS_0 : integer;
      C_WRITE_MIN_PULSE_WIDTH_PS_0 : integer;
      C_READ_ADDR_TO_OUT_FAST_PS_0 : integer;
      C_WRITE_ADDR_TO_OUT_FAST_PS_0 : integer;
      C_READ_RECOVERY_BEFORE_WRITE_PS_0 : integer;
      C_WRITE_RECOVERY_BEFORE_READ_PS_0 : integer;
      C_SYNCH_MEM_1 : integer;
      C_SYNCH_PIPEDELAY_1 : integer;
      C_READ_ADDR_TO_OUT_SLOW_PS_1 : integer;
      C_WRITE_ADDR_TO_OUT_SLOW_PS_1 : integer;
      C_WRITE_MIN_PULSE_WIDTH_PS_1 : integer;
      C_READ_ADDR_TO_OUT_FAST_PS_1 : integer;
      C_WRITE_ADDR_TO_OUT_FAST_PS_1 : integer;
      C_READ_RECOVERY_BEFORE_WRITE_PS_1 : integer;
      C_WRITE_RECOVERY_BEFORE_READ_PS_1 : integer;
      C_SYNCH_MEM_2 : integer;
      C_SYNCH_PIPEDELAY_2 : integer;
      C_READ_ADDR_TO_OUT_SLOW_PS_2 : integer;
      C_WRITE_ADDR_TO_OUT_SLOW_PS_2 : integer;
      C_WRITE_MIN_PULSE_WIDTH_PS_2 : integer;
      C_READ_ADDR_TO_OUT_FAST_PS_2 : integer;
      C_WRITE_ADDR_TO_OUT_FAST_PS_2 : integer;
      C_READ_RECOVERY_BEFORE_WRITE_PS_2 : integer;
      C_WRITE_RECOVERY_BEFORE_READ_PS_2 : integer;
      C_SYNCH_MEM_3 : integer;
      C_SYNCH_PIPEDELAY_3 : integer;
      C_READ_ADDR_TO_OUT_SLOW_PS_3 : integer;
      C_WRITE_ADDR_TO_OUT_SLOW_PS_3 : integer;
      C_WRITE_MIN_PULSE_WIDTH_PS_3 : integer;
      C_READ_ADDR_TO_OUT_FAST_PS_3 : integer;
      C_WRITE_ADDR_TO_OUT_FAST_PS_3 : integer;
      C_READ_RECOVERY_BEFORE_WRITE_PS_3 : integer;
      C_WRITE_RECOVERY_BEFORE_READ_PS_3 : integer;
      C_SYNCH_MEM_4 : integer;
      C_SYNCH_PIPEDELAY_4 : integer;
      C_READ_ADDR_TO_OUT_SLOW_PS_4 : integer;
      C_WRITE_ADDR_TO_OUT_SLOW_PS_4 : integer;
      C_WRITE_MIN_PULSE_WIDTH_PS_4 : integer;
      C_READ_ADDR_TO_OUT_FAST_PS_4 : integer;
      C_WRITE_ADDR_TO_OUT_FAST_PS_4 : integer;
      C_READ_RECOVERY_BEFORE_WRITE_PS_4 : integer;
      C_WRITE_RECOVERY_BEFORE_READ_PS_4 : integer;
      C_SYNCH_MEM_5 : integer;
      C_SYNCH_PIPEDELAY_5 : integer;
      C_READ_ADDR_TO_OUT_SLOW_PS_5 : integer;
      C_WRITE_ADDR_TO_OUT_SLOW_PS_5 : integer;
      C_WRITE_MIN_PULSE_WIDTH_PS_5 : integer;
      C_READ_ADDR_TO_OUT_FAST_PS_5 : integer;
      C_WRITE_ADDR_TO_OUT_FAST_PS_5 : integer;
      C_READ_RECOVERY_BEFORE_WRITE_PS_5 : integer;
      C_WRITE_RECOVERY_BEFORE_READ_PS_5 : integer;
      C_SYNCH_MEM_6 : integer;
      C_SYNCH_PIPEDELAY_6 : integer;
      C_READ_ADDR_TO_OUT_SLOW_PS_6 : integer;
      C_WRITE_ADDR_TO_OUT_SLOW_PS_6 : integer;
      C_WRITE_MIN_PULSE_WIDTH_PS_6 : integer;
      C_READ_ADDR_TO_OUT_FAST_PS_6 : integer;
      C_WRITE_ADDR_TO_OUT_FAST_PS_6 : integer;
      C_READ_RECOVERY_BEFORE_WRITE_PS_6 : integer;
      C_WRITE_RECOVERY_BEFORE_READ_PS_6 : integer;
      C_SYNCH_MEM_7 : integer;
      C_SYNCH_PIPEDELAY_7 : integer;
      C_READ_ADDR_TO_OUT_SLOW_PS_7 : integer;
      C_WRITE_ADDR_TO_OUT_SLOW_PS_7 : integer;
      C_WRITE_MIN_PULSE_WIDTH_PS_7 : integer;
      C_READ_ADDR_TO_OUT_FAST_PS_7 : integer;
      C_WRITE_ADDR_TO_OUT_FAST_PS_7 : integer;
      C_READ_RECOVERY_BEFORE_WRITE_PS_7 : integer;
      C_WRITE_RECOVERY_BEFORE_READ_PS_7 : integer;
      C_OPB_DWIDTH : integer;
      C_OPB_AWIDTH : integer;
      C_OPB_CLK_PERIOD_PS : integer;
      C_DEV_BLK_ID : INTEGER;
      C_DEV_MIR_ENABLE : INTEGER
    );
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      OPB_ABus : in std_logic_vector(0 to C_OPB_AWIDTH - 1);
      OPB_DBus : in std_logic_vector(0 to C_OPB_DWIDTH - 1);
      Sln_DBus : out std_logic_vector(0 to C_OPB_DWIDTH - 1);
      OPB_select : in std_logic;
      OPB_RNW : in std_logic;
      OPB_seqAddr : in std_logic;
      OPB_BE : in std_logic_vector(0 to C_OPB_DWIDTH/8 - 1);
      Sln_xferAck : out std_logic;
      Sln_errAck : out std_logic;
      Sln_toutSup : out std_logic;
      Sln_retry : out std_logic;
      Mem_A : out std_logic_vector(0 to C_OPB_AWIDTH-1);
      Mem_CEN : out std_logic_vector(0 to C_NUM_BANKS_MEM-1);
      Mem_OEN : out std_logic_vector(0 to C_NUM_BANKS_MEM-1);
      Mem_WEN : out std_logic;
      Mem_QWEN : out std_logic_vector(0 to C_MAX_MEM_WIDTH/8-1);
      Mem_BEN : out std_logic_vector(0 to C_MAX_MEM_WIDTH/8-1);
      Mem_RPN : out std_logic;
      Mem_CE : out std_logic_vector(0 to C_NUM_BANKS_MEM-1);
      Mem_ADV_LDN : out std_logic;
      Mem_LBON : out std_logic;
      Mem_CKEN : out std_logic;
      Mem_RNW : out std_logic;
      Mem_DQ_I : in std_logic_vector(0 to C_MAX_MEM_WIDTH-1);
      Mem_DQ_O : out std_logic_vector(0 to C_MAX_MEM_WIDTH-1);
      Mem_DQ_T : out std_logic_vector(0 to C_MAX_MEM_WIDTH-1)
    );
  end component;

begin

  sram_512kx8_flash_2mx8 : opb_emc
    generic map (
      C_NUM_BANKS_MEM => 1,
      C_INCLUDE_NEGEDGE_IOREGS => 0,
      C_BASEADDR => X"FFFF_FFFF",
      C_HIGHADDR => X"0000_0000",
      C_MEM0_BASEADDR => X"20400000",
      C_MEM0_HIGHADDR => X"207fffff",
      C_MEM1_BASEADDR => X"FFFF_FFFF",
      C_MEM1_HIGHADDR => X"0000_0000",
      C_MEM2_BASEADDR => X"FFFF_FFFF",
      C_MEM2_HIGHADDR => X"0000_0000",
      C_MEM3_BASEADDR => X"FFFF_FFFF",
      C_MEM3_HIGHADDR => X"0000_0000",
      C_MEM4_BASEADDR => X"FFFF_FFFF",
      C_MEM4_HIGHADDR => X"0000_0000",
      C_MEM5_BASEADDR => X"FFFF_FFFF",
      C_MEM5_HIGHADDR => X"0000_0000",
      C_MEM6_BASEADDR => X"FFFF_FFFF",
      C_MEM6_HIGHADDR => X"0000_0000",
      C_MEM7_BASEADDR => X"FFFF_FFFF",
      C_MEM7_HIGHADDR => X"0000_0000",
      C_MEM0_WIDTH => 8,
      C_MEM1_WIDTH => 32,
      C_MEM2_WIDTH => 32,
      C_MEM3_WIDTH => 32,
      C_MEM4_WIDTH => 32,
      C_MEM5_WIDTH => 32,
      C_MEM6_WIDTH => 32,
      C_MEM7_WIDTH => 32,
      C_MAX_MEM_WIDTH => 8,
      C_INCLUDE_DATAWIDTH_MATCHING_0 => 0,
      C_INCLUDE_DATAWIDTH_MATCHING_1 => 1,
      C_INCLUDE_DATAWIDTH_MATCHING_2 => 1,
      C_INCLUDE_DATAWIDTH_MATCHING_3 => 1,
      C_INCLUDE_DATAWIDTH_MATCHING_4 => 1,
      C_INCLUDE_DATAWIDTH_MATCHING_5 => 1,
      C_INCLUDE_DATAWIDTH_MATCHING_6 => 1,
      C_INCLUDE_DATAWIDTH_MATCHING_7 => 1,
      C_SYNCH_MEM_0 => 0,
      C_SYNCH_PIPEDELAY_0 => 2,
      C_READ_ADDR_TO_OUT_SLOW_PS_0 => 120000,
      C_WRITE_ADDR_TO_OUT_SLOW_PS_0 => 55000,
      C_WRITE_MIN_PULSE_WIDTH_PS_0 => 75000,
      C_READ_ADDR_TO_OUT_FAST_PS_0 => 25000,
      C_WRITE_ADDR_TO_OUT_FAST_PS_0 => 75000,
      C_READ_RECOVERY_BEFORE_WRITE_PS_0 => 15000,
      C_WRITE_RECOVERY_BEFORE_READ_PS_0 => 35000,
      C_SYNCH_MEM_1 => 0,
      C_SYNCH_PIPEDELAY_1 => 2,
      C_READ_ADDR_TO_OUT_SLOW_PS_1 => 0,
      C_WRITE_ADDR_TO_OUT_SLOW_PS_1 => 0,
      C_WRITE_MIN_PULSE_WIDTH_PS_1 => 0,
      C_READ_ADDR_TO_OUT_FAST_PS_1 => 0,
      C_WRITE_ADDR_TO_OUT_FAST_PS_1 => 0,
      C_READ_RECOVERY_BEFORE_WRITE_PS_1 => 0,
      C_WRITE_RECOVERY_BEFORE_READ_PS_1 => 0,
      C_SYNCH_MEM_2 => 0,
      C_SYNCH_PIPEDELAY_2 => 2,
      C_READ_ADDR_TO_OUT_SLOW_PS_2 => 0,
      C_WRITE_ADDR_TO_OUT_SLOW_PS_2 => 0,
      C_WRITE_MIN_PULSE_WIDTH_PS_2 => 0,
      C_READ_ADDR_TO_OUT_FAST_PS_2 => 0,
      C_WRITE_ADDR_TO_OUT_FAST_PS_2 => 0,
      C_READ_RECOVERY_BEFORE_WRITE_PS_2 => 0,
      C_WRITE_RECOVERY_BEFORE_READ_PS_2 => 0,
      C_SYNCH_MEM_3 => 0,
      C_SYNCH_PIPEDELAY_3 => 2,
      C_READ_ADDR_TO_OUT_SLOW_PS_3 => 0,
      C_WRITE_ADDR_TO_OUT_SLOW_PS_3 => 0,
      C_WRITE_MIN_PULSE_WIDTH_PS_3 => 0,
      C_READ_ADDR_TO_OUT_FAST_PS_3 => 0,
      C_WRITE_ADDR_TO_OUT_FAST_PS_3 => 0,
      C_READ_RECOVERY_BEFORE_WRITE_PS_3 => 0,
      C_WRITE_RECOVERY_BEFORE_READ_PS_3 => 0,
      C_SYNCH_MEM_4 => 0,
      C_SYNCH_PIPEDELAY_4 => 2,
      C_READ_ADDR_TO_OUT_SLOW_PS_4 => 0,
      C_WRITE_ADDR_TO_OUT_SLOW_PS_4 => 0,
      C_WRITE_MIN_PULSE_WIDTH_PS_4 => 0,
      C_READ_ADDR_TO_OUT_FAST_PS_4 => 0,
      C_WRITE_ADDR_TO_OUT_FAST_PS_4 => 0,
      C_READ_RECOVERY_BEFORE_WRITE_PS_4 => 0,
      C_WRITE_RECOVERY_BEFORE_READ_PS_4 => 0,
      C_SYNCH_MEM_5 => 0,
      C_SYNCH_PIPEDELAY_5 => 2,
      C_READ_ADDR_TO_OUT_SLOW_PS_5 => 0,
      C_WRITE_ADDR_TO_OUT_SLOW_PS_5 => 0,
      C_WRITE_MIN_PULSE_WIDTH_PS_5 => 0,
      C_READ_ADDR_TO_OUT_FAST_PS_5 => 0,
      C_WRITE_ADDR_TO_OUT_FAST_PS_5 => 0,
      C_READ_RECOVERY_BEFORE_WRITE_PS_5 => 0,
      C_WRITE_RECOVERY_BEFORE_READ_PS_5 => 0,
      C_SYNCH_MEM_6 => 0,
      C_SYNCH_PIPEDELAY_6 => 2,
      C_READ_ADDR_TO_OUT_SLOW_PS_6 => 0,
      C_WRITE_ADDR_TO_OUT_SLOW_PS_6 => 0,
      C_WRITE_MIN_PULSE_WIDTH_PS_6 => 0,
      C_READ_ADDR_TO_OUT_FAST_PS_6 => 0,
      C_WRITE_ADDR_TO_OUT_FAST_PS_6 => 0,
      C_READ_RECOVERY_BEFORE_WRITE_PS_6 => 0,
      C_WRITE_RECOVERY_BEFORE_READ_PS_6 => 0,
      C_SYNCH_MEM_7 => 0,
      C_SYNCH_PIPEDELAY_7 => 2,
      C_READ_ADDR_TO_OUT_SLOW_PS_7 => 0,
      C_WRITE_ADDR_TO_OUT_SLOW_PS_7 => 0,
      C_WRITE_MIN_PULSE_WIDTH_PS_7 => 0,
      C_READ_ADDR_TO_OUT_FAST_PS_7 => 0,
      C_WRITE_ADDR_TO_OUT_FAST_PS_7 => 0,
      C_READ_RECOVERY_BEFORE_WRITE_PS_7 => 0,
      C_WRITE_RECOVERY_BEFORE_READ_PS_7 => 0,
      C_OPB_DWIDTH => 32,
      C_OPB_AWIDTH => 32,
      C_OPB_CLK_PERIOD_PS => 20000,
      C_DEV_BLK_ID => 1,
      C_DEV_MIR_ENABLE => 1
    )
    port map (
      OPB_Clk => OPB_Clk,
      OPB_Rst => OPB_Rst,
      OPB_ABus => OPB_ABus,
      OPB_DBus => OPB_DBus,
      Sln_DBus => Sln_DBus,
      OPB_select => OPB_select,
      OPB_RNW => OPB_RNW,
      OPB_seqAddr => OPB_seqAddr,
      OPB_BE => OPB_BE,
      Sln_xferAck => Sln_xferAck,
      Sln_errAck => Sln_errAck,
      Sln_toutSup => Sln_toutSup,
      Sln_retry => Sln_retry,
      Mem_A => Mem_A,
      Mem_CEN => Mem_CEN,
      Mem_OEN => Mem_OEN,
      Mem_WEN => Mem_WEN,
      Mem_QWEN => Mem_QWEN,
      Mem_BEN => Mem_BEN,
      Mem_RPN => Mem_RPN,
      Mem_CE => Mem_CE,
      Mem_ADV_LDN => Mem_ADV_LDN,
      Mem_LBON => Mem_LBON,
      Mem_CKEN => Mem_CKEN,
      Mem_RNW => Mem_RNW,
      Mem_DQ_I => Mem_DQ_I,
      Mem_DQ_O => Mem_DQ_O,
      Mem_DQ_T => Mem_DQ_T
    );

end architecture STRUCTURE;

