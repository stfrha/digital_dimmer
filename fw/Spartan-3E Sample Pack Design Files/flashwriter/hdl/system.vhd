-------------------------------------------------------------------------------
-- system.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity system is
  port (
    sys_clk_pin : in std_logic;
    sys_rst_pin : in std_logic;
    SRAM_512Kx8_FLASH_2Mx8_Mem_A : out std_logic_vector(10 to 31);
    SRAM_512Kx8_FLASH_2Mx8_Mem_DQ : inout std_logic_vector(0 to 7);
    SRAM_512Kx8_FLASH_2Mx8_Mem_CEN : out std_logic_vector(0 to 0);
    SRAM_512Kx8_FLASH_2Mx8_Mem_WEN : out std_logic;
    SRAM_512Kx8_FLASH_2Mx8_Mem_BEN : out std_logic;
    SRAM_512Kx8_FLASH_2Mx8_Mem_OEN : out std_logic
  );
end system;

architecture STRUCTURE of system is

  attribute box_type : STRING;

  component microblaze_0_wrapper is
    port (
      CLK : in std_logic;
      RESET : in std_logic;
      INTERRUPT : in std_logic;
      DEBUG_RST : in std_logic;
      EXT_BRK : in std_logic;
      EXT_NM_BRK : in std_logic;
      DBG_STOP : in std_logic;
      INSTR : in std_logic_vector(0 to 31);
      I_ADDRTAG : out std_logic_vector(0 to 3);
      IREADY : in std_logic;
      IWAIT : in std_logic;
      INSTR_ADDR : out std_logic_vector(0 to 31);
      IFETCH : out std_logic;
      I_AS : out std_logic;
      DATA_READ : in std_logic_vector(0 to 31);
      DREADY : in std_logic;
      DWAIT : in std_logic;
      DATA_WRITE : out std_logic_vector(0 to 31);
      DATA_ADDR : out std_logic_vector(0 to 31);
      D_ADDRTAG : out std_logic_vector(0 to 3);
      D_AS : out std_logic;
      READ_STROBE : out std_logic;
      WRITE_STROBE : out std_logic;
      BYTE_ENABLE : out std_logic_vector(0 to 3);
      DM_ABUS : out std_logic_vector(0 to 31);
      DM_BE : out std_logic_vector(0 to 3);
      DM_BUSLOCK : out std_logic;
      DM_DBUS : out std_logic_vector(0 to 31);
      DM_REQUEST : out std_logic;
      DM_RNW : out std_logic;
      DM_SELECT : out std_logic;
      DM_SEQADDR : out std_logic;
      DOPB_DBUS : in std_logic_vector(0 to 31);
      DOPB_ERRACK : in std_logic;
      DOPB_MGRANT : in std_logic;
      DOPB_RETRY : in std_logic;
      DOPB_TIMEOUT : in std_logic;
      DOPB_XFERACK : in std_logic;
      IM_ABUS : out std_logic_vector(0 to 31);
      IM_BE : out std_logic_vector(0 to 3);
      IM_BUSLOCK : out std_logic;
      IM_DBUS : out std_logic_vector(0 to 31);
      IM_REQUEST : out std_logic;
      IM_RNW : out std_logic;
      IM_SELECT : out std_logic;
      IM_SEQADDR : out std_logic;
      IOPB_DBUS : in std_logic_vector(0 to 31);
      IOPB_ERRACK : in std_logic;
      IOPB_MGRANT : in std_logic;
      IOPB_RETRY : in std_logic;
      IOPB_TIMEOUT : in std_logic;
      IOPB_XFERACK : in std_logic;
      DBG_CLK : in std_logic;
      DBG_TDI : in std_logic;
      DBG_TDO : out std_logic;
      DBG_REG_EN : in std_logic_vector(0 to 4);
      DBG_CAPTURE : in std_logic;
      DBG_UPDATE : in std_logic;
      VALID_INSTR : out std_logic;
      PC_EX : out std_logic_vector(0 to 31);
      REG_WRITE : out std_logic;
      REG_ADDR : out std_logic_vector(0 to 4);
      MSR_REG : out std_logic_vector(0 to 9);
      NEW_REG_VALUE : out std_logic_vector(0 to 31);
      PIPE_RUNNING : out std_logic;
      INTERRUPT_TAKEN : out std_logic;
      JUMP_TAKEN : out std_logic;
      PREFETCH_ADDR : out std_logic_vector(0 to 3);
      MB_Halted : out std_logic;
      Trace_Branch_Instr : out std_logic;
      Trace_Delay_Slot : out std_logic;
      Trace_Data_Address : out std_logic_vector(0 to 31);
      Trace_AS : out std_logic;
      Trace_Data_Read : out std_logic;
      Trace_Data_Write : out std_logic;
      Trace_DCache_Req : out std_logic;
      Trace_DCache_Hit : out std_logic;
      Trace_ICache_Req : out std_logic;
      Trace_ICache_Hit : out std_logic;
      Trace_Instr_EX : out std_logic_vector(0 to 31);
      FSL0_S_CLK : out std_logic;
      FSL0_S_READ : out std_logic;
      FSL0_S_DATA : in std_logic_vector(0 to 31);
      FSL0_S_CONTROL : in std_logic;
      FSL0_S_EXISTS : in std_logic;
      FSL0_M_CLK : out std_logic;
      FSL0_M_WRITE : out std_logic;
      FSL0_M_DATA : out std_logic_vector(0 to 31);
      FSL0_M_CONTROL : out std_logic;
      FSL0_M_FULL : in std_logic;
      FSL1_S_CLK : out std_logic;
      FSL1_S_READ : out std_logic;
      FSL1_S_DATA : in std_logic_vector(0 to 31);
      FSL1_S_CONTROL : in std_logic;
      FSL1_S_EXISTS : in std_logic;
      FSL1_M_CLK : out std_logic;
      FSL1_M_WRITE : out std_logic;
      FSL1_M_DATA : out std_logic_vector(0 to 31);
      FSL1_M_CONTROL : out std_logic;
      FSL1_M_FULL : in std_logic;
      FSL2_S_CLK : out std_logic;
      FSL2_S_READ : out std_logic;
      FSL2_S_DATA : in std_logic_vector(0 to 31);
      FSL2_S_CONTROL : in std_logic;
      FSL2_S_EXISTS : in std_logic;
      FSL2_M_CLK : out std_logic;
      FSL2_M_WRITE : out std_logic;
      FSL2_M_DATA : out std_logic_vector(0 to 31);
      FSL2_M_CONTROL : out std_logic;
      FSL2_M_FULL : in std_logic;
      FSL3_S_CLK : out std_logic;
      FSL3_S_READ : out std_logic;
      FSL3_S_DATA : in std_logic_vector(0 to 31);
      FSL3_S_CONTROL : in std_logic;
      FSL3_S_EXISTS : in std_logic;
      FSL3_M_CLK : out std_logic;
      FSL3_M_WRITE : out std_logic;
      FSL3_M_DATA : out std_logic_vector(0 to 31);
      FSL3_M_CONTROL : out std_logic;
      FSL3_M_FULL : in std_logic;
      FSL4_S_CLK : out std_logic;
      FSL4_S_READ : out std_logic;
      FSL4_S_DATA : in std_logic_vector(0 to 31);
      FSL4_S_CONTROL : in std_logic;
      FSL4_S_EXISTS : in std_logic;
      FSL4_M_CLK : out std_logic;
      FSL4_M_WRITE : out std_logic;
      FSL4_M_DATA : out std_logic_vector(0 to 31);
      FSL4_M_CONTROL : out std_logic;
      FSL4_M_FULL : in std_logic;
      FSL5_S_CLK : out std_logic;
      FSL5_S_READ : out std_logic;
      FSL5_S_DATA : in std_logic_vector(0 to 31);
      FSL5_S_CONTROL : in std_logic;
      FSL5_S_EXISTS : in std_logic;
      FSL5_M_CLK : out std_logic;
      FSL5_M_WRITE : out std_logic;
      FSL5_M_DATA : out std_logic_vector(0 to 31);
      FSL5_M_CONTROL : out std_logic;
      FSL5_M_FULL : in std_logic;
      FSL6_S_CLK : out std_logic;
      FSL6_S_READ : out std_logic;
      FSL6_S_DATA : in std_logic_vector(0 to 31);
      FSL6_S_CONTROL : in std_logic;
      FSL6_S_EXISTS : in std_logic;
      FSL6_M_CLK : out std_logic;
      FSL6_M_WRITE : out std_logic;
      FSL6_M_DATA : out std_logic_vector(0 to 31);
      FSL6_M_CONTROL : out std_logic;
      FSL6_M_FULL : in std_logic;
      FSL7_S_CLK : out std_logic;
      FSL7_S_READ : out std_logic;
      FSL7_S_DATA : in std_logic_vector(0 to 31);
      FSL7_S_CONTROL : in std_logic;
      FSL7_S_EXISTS : in std_logic;
      FSL7_M_CLK : out std_logic;
      FSL7_M_WRITE : out std_logic;
      FSL7_M_DATA : out std_logic_vector(0 to 31);
      FSL7_M_CONTROL : out std_logic;
      FSL7_M_FULL : in std_logic;
      ICACHE_FSL_IN_CLK : out std_logic;
      ICACHE_FSL_IN_READ : out std_logic;
      ICACHE_FSL_IN_DATA : in std_logic_vector(0 to 31);
      ICACHE_FSL_IN_CONTROL : in std_logic;
      ICACHE_FSL_IN_EXISTS : in std_logic;
      ICACHE_FSL_OUT_CLK : out std_logic;
      ICACHE_FSL_OUT_WRITE : out std_logic;
      ICACHE_FSL_OUT_DATA : out std_logic_vector(0 to 31);
      ICACHE_FSL_OUT_CONTROL : out std_logic;
      ICACHE_FSL_OUT_FULL : in std_logic;
      DCACHE_FSL_IN_CLK : out std_logic;
      DCACHE_FSL_IN_READ : out std_logic;
      DCACHE_FSL_IN_DATA : in std_logic_vector(0 to 31);
      DCACHE_FSL_IN_CONTROL : in std_logic;
      DCACHE_FSL_IN_EXISTS : in std_logic;
      DCACHE_FSL_OUT_CLK : out std_logic;
      DCACHE_FSL_OUT_WRITE : out std_logic;
      DCACHE_FSL_OUT_DATA : out std_logic_vector(0 to 31);
      DCACHE_FSL_OUT_CONTROL : out std_logic;
      DCACHE_FSL_OUT_FULL : in std_logic
    );
  end component;

  attribute box_type of microblaze_0_wrapper: component is "black_box";

  component mb_opb_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : out std_logic;
      SYS_Rst : in std_logic;
      Debug_SYS_Rst : in std_logic;
      WDT_Rst : in std_logic;
      M_ABus : in std_logic_vector(0 to 63);
      M_BE : in std_logic_vector(0 to 7);
      M_beXfer : in std_logic_vector(0 to 1);
      M_busLock : in std_logic_vector(0 to 1);
      M_DBus : in std_logic_vector(0 to 63);
      M_DBusEn : in std_logic_vector(0 to 1);
      M_DBusEn32_63 : in std_logic_vector(0 to 1);
      M_dwXfer : in std_logic_vector(0 to 1);
      M_fwXfer : in std_logic_vector(0 to 1);
      M_hwXfer : in std_logic_vector(0 to 1);
      M_request : in std_logic_vector(0 to 1);
      M_RNW : in std_logic_vector(0 to 1);
      M_select : in std_logic_vector(0 to 1);
      M_seqAddr : in std_logic_vector(0 to 1);
      Sl_beAck : in std_logic_vector(0 to 2);
      Sl_DBus : in std_logic_vector(0 to 95);
      Sl_DBusEn : in std_logic_vector(0 to 2);
      Sl_DBusEn32_63 : in std_logic_vector(0 to 2);
      Sl_errAck : in std_logic_vector(0 to 2);
      Sl_dwAck : in std_logic_vector(0 to 2);
      Sl_fwAck : in std_logic_vector(0 to 2);
      Sl_hwAck : in std_logic_vector(0 to 2);
      Sl_retry : in std_logic_vector(0 to 2);
      Sl_toutSup : in std_logic_vector(0 to 2);
      Sl_xferAck : in std_logic_vector(0 to 2);
      OPB_MRequest : out std_logic_vector(0 to 1);
      OPB_ABus : out std_logic_vector(0 to 31);
      OPB_BE : out std_logic_vector(0 to 3);
      OPB_beXfer : out std_logic;
      OPB_beAck : out std_logic;
      OPB_busLock : out std_logic;
      OPB_rdDBus : out std_logic_vector(0 to 31);
      OPB_wrDBus : out std_logic_vector(0 to 31);
      OPB_DBus : out std_logic_vector(0 to 31);
      OPB_errAck : out std_logic;
      OPB_dwAck : out std_logic;
      OPB_dwXfer : out std_logic;
      OPB_fwAck : out std_logic;
      OPB_fwXfer : out std_logic;
      OPB_hwAck : out std_logic;
      OPB_hwXfer : out std_logic;
      OPB_MGrant : out std_logic_vector(0 to 1);
      OPB_pendReq : out std_logic_vector(0 to 1);
      OPB_retry : out std_logic;
      OPB_RNW : out std_logic;
      OPB_select : out std_logic;
      OPB_seqAddr : out std_logic;
      OPB_timeout : out std_logic;
      OPB_toutSup : out std_logic;
      OPB_xferAck : out std_logic
    );
  end component;

  attribute box_type of mb_opb_wrapper: component is "black_box";

  component debug_module_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Interrupt : out std_logic;
      Debug_SYS_Rst : out std_logic;
      Debug_Rst : out std_logic;
      Ext_BRK : out std_logic;
      Ext_NM_BRK : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      OPB_DBus : in std_logic_vector(0 to 31);
      MDM_DBus : out std_logic_vector(0 to 31);
      MDM_errAck : out std_logic;
      MDM_retry : out std_logic;
      MDM_toutSup : out std_logic;
      MDM_xferAck : out std_logic;
      Dbg_Clk_0 : out std_logic;
      Dbg_TDI_0 : out std_logic;
      Dbg_TDO_0 : in std_logic;
      Dbg_Reg_En_0 : out std_logic_vector(0 to 4);
      Dbg_Capture_0 : out std_logic;
      Dbg_Update_0 : out std_logic;
      Dbg_Clk_1 : out std_logic;
      Dbg_TDI_1 : out std_logic;
      Dbg_TDO_1 : in std_logic;
      Dbg_Reg_En_1 : out std_logic_vector(0 to 4);
      Dbg_Capture_1 : out std_logic;
      Dbg_Update_1 : out std_logic;
      Dbg_Clk_2 : out std_logic;
      Dbg_TDI_2 : out std_logic;
      Dbg_TDO_2 : in std_logic;
      Dbg_Reg_En_2 : out std_logic_vector(0 to 4);
      Dbg_Capture_2 : out std_logic;
      Dbg_Update_2 : out std_logic;
      Dbg_Clk_3 : out std_logic;
      Dbg_TDI_3 : out std_logic;
      Dbg_TDO_3 : in std_logic;
      Dbg_Reg_En_3 : out std_logic_vector(0 to 4);
      Dbg_Capture_3 : out std_logic;
      Dbg_Update_3 : out std_logic;
      Dbg_Clk_4 : out std_logic;
      Dbg_TDI_4 : out std_logic;
      Dbg_TDO_4 : in std_logic;
      Dbg_Reg_En_4 : out std_logic_vector(0 to 4);
      Dbg_Capture_4 : out std_logic;
      Dbg_Update_4 : out std_logic;
      Dbg_Clk_5 : out std_logic;
      Dbg_TDI_5 : out std_logic;
      Dbg_TDO_5 : in std_logic;
      Dbg_Reg_En_5 : out std_logic_vector(0 to 4);
      Dbg_Capture_5 : out std_logic;
      Dbg_Update_5 : out std_logic;
      Dbg_Clk_6 : out std_logic;
      Dbg_TDI_6 : out std_logic;
      Dbg_TDO_6 : in std_logic;
      Dbg_Reg_En_6 : out std_logic_vector(0 to 4);
      Dbg_Capture_6 : out std_logic;
      Dbg_Update_6 : out std_logic;
      Dbg_Clk_7 : out std_logic;
      Dbg_TDI_7 : out std_logic;
      Dbg_TDO_7 : in std_logic;
      Dbg_Reg_En_7 : out std_logic_vector(0 to 4);
      Dbg_Capture_7 : out std_logic;
      Dbg_Update_7 : out std_logic;
      bscan_tdi : out std_logic;
      bscan_reset : out std_logic;
      bscan_shift : out std_logic;
      bscan_update : out std_logic;
      bscan_capture : out std_logic;
      bscan_sel1 : out std_logic;
      bscan_drck1 : out std_logic;
      bscan_tdo1 : in std_logic;
      FSL0_S_CLK : out std_logic;
      FSL0_S_READ : out std_logic;
      FSL0_S_DATA : in std_logic_vector(0 to 31);
      FSL0_S_CONTROL : in std_logic;
      FSL0_S_EXISTS : in std_logic;
      FSL0_M_CLK : out std_logic;
      FSL0_M_WRITE : out std_logic;
      FSL0_M_DATA : out std_logic_vector(0 to 31);
      FSL0_M_CONTROL : out std_logic;
      FSL0_M_FULL : in std_logic
    );
  end component;

  attribute box_type of debug_module_wrapper: component is "black_box";

  component lmb_bram_wrapper is
    port (
      BRAM_Rst_A : in std_logic;
      BRAM_Clk_A : in std_logic;
      BRAM_EN_A : in std_logic;
      BRAM_WEN_A : in std_logic_vector(0 to 3);
      BRAM_Addr_A : in std_logic_vector(0 to 31);
      BRAM_Din_A : out std_logic_vector(0 to 31);
      BRAM_Dout_A : in std_logic_vector(0 to 31);
      BRAM_Rst_B : in std_logic;
      BRAM_Clk_B : in std_logic;
      BRAM_EN_B : in std_logic;
      BRAM_WEN_B : in std_logic_vector(0 to 3);
      BRAM_Addr_B : in std_logic_vector(0 to 31);
      BRAM_Din_B : out std_logic_vector(0 to 31);
      BRAM_Dout_B : in std_logic_vector(0 to 31)
    );
  end component;

  attribute box_type of lmb_bram_wrapper: component is "black_box";

  component sram_512kx8_flash_2mx8_wrapper is
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
  end component;

  attribute box_type of sram_512kx8_flash_2mx8_wrapper: component is "black_box";

  component sram_512kx8_flash_2mx8_util_bus_split_0_wrapper is
    port (
      Sig : in std_logic_vector(0 to 31);
      Out1 : out std_logic_vector(10 to 31);
      Out2 : out std_logic_vector(32 downto 31)
    );
  end component;

  attribute box_type of sram_512kx8_flash_2mx8_util_bus_split_0_wrapper: component is "black_box";

  component opb_bram_if_cntlr_0_wrapper is
    port (
      opb_clk : in std_logic;
      opb_rst : in std_logic;
      opb_abus : in std_logic_vector(0 to 31);
      opb_dbus : in std_logic_vector(0 to 31);
      sln_dbus : out std_logic_vector(0 to 31);
      opb_select : in std_logic;
      opb_rnw : in std_logic;
      opb_seqaddr : in std_logic;
      opb_be : in std_logic_vector(0 to 3);
      sln_xferack : out std_logic;
      sln_errack : out std_logic;
      sln_toutsup : out std_logic;
      sln_retry : out std_logic;
      bram_rst : out std_logic;
      bram_clk : out std_logic;
      bram_en : out std_logic;
      bram_wen : out std_logic_vector(0 to 3);
      bram_addr : out std_logic_vector(0 to 31);
      bram_din : in std_logic_vector(0 to 31);
      bram_dout : out std_logic_vector(0 to 31)
    );
  end component;

  attribute box_type of opb_bram_if_cntlr_0_wrapper: component is "black_box";

  component BUFGP is
    port (
      I : in std_logic;
      O : out std_logic
    );
  end component;

  component IBUF is
    port (
      I : in std_logic;
      O : out std_logic
    );
  end component;

  component OBUF is
    port (
      I : in std_logic;
      O : out std_logic
    );
  end component;

  component IOBUF is
    port (
      I : in std_logic;
      IO : inout std_logic;
      O : out std_logic;
      T : in std_logic
    );
  end component;

  -- Internal signals

  signal DBG_CAPTURE_s : std_logic;
  signal DBG_CLK_s : std_logic;
  signal DBG_REG_EN_s : std_logic_vector(0 to 4);
  signal DBG_TDI_s : std_logic;
  signal DBG_TDO_s : std_logic;
  signal DBG_UPDATE_s : std_logic;
  signal Debug_Rst : std_logic;
  signal Ext_BRK : std_logic;
  signal Ext_NM_BRK : std_logic;
  signal SRAM_512Kx8_FLASH_2Mx8_Mem_A_OBUF : std_logic_vector(10 to 31);
  signal SRAM_512Kx8_FLASH_2Mx8_Mem_A_split : std_logic_vector(0 to 31);
  signal SRAM_512Kx8_FLASH_2Mx8_Mem_CEN_OBUF : std_logic_vector(0 to 0);
  signal SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_I : std_logic_vector(0 to 7);
  signal SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_O : std_logic_vector(0 to 7);
  signal SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_T : std_logic_vector(0 to 7);
  signal SRAM_512Kx8_FLASH_2Mx8_Mem_OEN_OBUF : std_logic_vector(0 to 0);
  signal SRAM_512Kx8_FLASH_2Mx8_Mem_WEN_OBUF : std_logic;
  signal conn1_BRAM_Addr : std_logic_vector(0 to 31);
  signal conn1_BRAM_Clk : std_logic;
  signal conn1_BRAM_Din : std_logic_vector(0 to 31);
  signal conn1_BRAM_Dout : std_logic_vector(0 to 31);
  signal conn1_BRAM_EN : std_logic;
  signal conn1_BRAM_Rst : std_logic;
  signal conn1_BRAM_WEN : std_logic_vector(0 to 3);
  signal mb_opb_Debug_SYS_Rst : std_logic;
  signal mb_opb_M_ABus : std_logic_vector(0 to 63);
  signal mb_opb_M_BE : std_logic_vector(0 to 7);
  signal mb_opb_M_DBus : std_logic_vector(0 to 63);
  signal mb_opb_M_RNW : std_logic_vector(0 to 1);
  signal mb_opb_M_busLock : std_logic_vector(0 to 1);
  signal mb_opb_M_request : std_logic_vector(0 to 1);
  signal mb_opb_M_select : std_logic_vector(0 to 1);
  signal mb_opb_M_seqAddr : std_logic_vector(0 to 1);
  signal mb_opb_OPB_ABus : std_logic_vector(0 to 31);
  signal mb_opb_OPB_BE : std_logic_vector(0 to 3);
  signal mb_opb_OPB_DBus : std_logic_vector(0 to 31);
  signal mb_opb_OPB_MGrant : std_logic_vector(0 to 1);
  signal mb_opb_OPB_RNW : std_logic;
  signal mb_opb_OPB_Rst : std_logic;
  signal mb_opb_OPB_errAck : std_logic;
  signal mb_opb_OPB_retry : std_logic;
  signal mb_opb_OPB_select : std_logic;
  signal mb_opb_OPB_seqAddr : std_logic;
  signal mb_opb_OPB_timeout : std_logic;
  signal mb_opb_OPB_xferAck : std_logic;
  signal mb_opb_Sl_DBus : std_logic_vector(0 to 95);
  signal mb_opb_Sl_errAck : std_logic_vector(0 to 2);
  signal mb_opb_Sl_retry : std_logic_vector(0 to 2);
  signal mb_opb_Sl_toutSup : std_logic_vector(0 to 2);
  signal mb_opb_Sl_xferAck : std_logic_vector(0 to 2);
  signal net_gnd0 : std_logic;
  signal net_gnd2 : std_logic_vector(0 to 1);
  signal net_gnd3 : std_logic_vector(0 to 2);
  signal net_gnd32 : std_logic_vector(0 to 31);
  signal net_gnd4 : std_logic_vector(0 to 3);
  signal net_vcc2 : std_logic_vector(0 to 1);
  signal net_vcc3 : std_logic_vector(0 to 2);
  signal sys_clk_s : std_logic;
  signal sys_rst_s : std_logic;

begin

  -- Internal assignments

  net_gnd0 <= '0';
  net_gnd2(0 to 1) <= B"00";
  net_gnd3(0 to 2) <= B"000";
  net_gnd32(0 to 31) <= B"00000000000000000000000000000000";
  net_gnd4(0 to 3) <= B"0000";
  net_vcc2(0 to 1) <= B"11";
  net_vcc3(0 to 2) <= B"111";

  microblaze_0 : microblaze_0_wrapper
    port map (
      CLK => sys_clk_s,
      RESET => mb_opb_OPB_Rst,
      INTERRUPT => net_gnd0,
      DEBUG_RST => Debug_Rst,
      EXT_BRK => Ext_BRK,
      EXT_NM_BRK => Ext_NM_BRK,
      DBG_STOP => net_gnd0,
      INSTR => net_gnd32,
      I_ADDRTAG => open,
      IREADY => net_gnd0,
      IWAIT => net_gnd0,
      INSTR_ADDR => open,
      IFETCH => open,
      I_AS => open,
      DATA_READ => net_gnd32,
      DREADY => net_gnd0,
      DWAIT => net_gnd0,
      DATA_WRITE => open,
      DATA_ADDR => open,
      D_ADDRTAG => open,
      D_AS => open,
      READ_STROBE => open,
      WRITE_STROBE => open,
      BYTE_ENABLE => open,
      DM_ABUS => mb_opb_M_ABus(0 to 31),
      DM_BE => mb_opb_M_BE(0 to 3),
      DM_BUSLOCK => mb_opb_M_busLock(0),
      DM_DBUS => mb_opb_M_DBus(0 to 31),
      DM_REQUEST => mb_opb_M_request(0),
      DM_RNW => mb_opb_M_RNW(0),
      DM_SELECT => mb_opb_M_select(0),
      DM_SEQADDR => mb_opb_M_seqAddr(0),
      DOPB_DBUS => mb_opb_OPB_DBus,
      DOPB_ERRACK => mb_opb_OPB_errAck,
      DOPB_MGRANT => mb_opb_OPB_MGrant(0),
      DOPB_RETRY => mb_opb_OPB_retry,
      DOPB_TIMEOUT => mb_opb_OPB_timeout,
      DOPB_XFERACK => mb_opb_OPB_xferAck,
      IM_ABUS => mb_opb_M_ABus(32 to 63),
      IM_BE => mb_opb_M_BE(4 to 7),
      IM_BUSLOCK => mb_opb_M_busLock(1),
      IM_DBUS => mb_opb_M_DBus(32 to 63),
      IM_REQUEST => mb_opb_M_request(1),
      IM_RNW => mb_opb_M_RNW(1),
      IM_SELECT => mb_opb_M_select(1),
      IM_SEQADDR => mb_opb_M_seqAddr(1),
      IOPB_DBUS => mb_opb_OPB_DBus,
      IOPB_ERRACK => mb_opb_OPB_errAck,
      IOPB_MGRANT => mb_opb_OPB_MGrant(1),
      IOPB_RETRY => mb_opb_OPB_retry,
      IOPB_TIMEOUT => mb_opb_OPB_timeout,
      IOPB_XFERACK => mb_opb_OPB_xferAck,
      DBG_CLK => DBG_CLK_s,
      DBG_TDI => DBG_TDI_s,
      DBG_TDO => DBG_TDO_s,
      DBG_REG_EN => DBG_REG_EN_s,
      DBG_CAPTURE => DBG_CAPTURE_s,
      DBG_UPDATE => DBG_UPDATE_s,
      VALID_INSTR => open,
      PC_EX => open,
      REG_WRITE => open,
      REG_ADDR => open,
      MSR_REG => open,
      NEW_REG_VALUE => open,
      PIPE_RUNNING => open,
      INTERRUPT_TAKEN => open,
      JUMP_TAKEN => open,
      PREFETCH_ADDR => open,
      MB_Halted => open,
      Trace_Branch_Instr => open,
      Trace_Delay_Slot => open,
      Trace_Data_Address => open,
      Trace_AS => open,
      Trace_Data_Read => open,
      Trace_Data_Write => open,
      Trace_DCache_Req => open,
      Trace_DCache_Hit => open,
      Trace_ICache_Req => open,
      Trace_ICache_Hit => open,
      Trace_Instr_EX => open,
      FSL0_S_CLK => open,
      FSL0_S_READ => open,
      FSL0_S_DATA => net_gnd32,
      FSL0_S_CONTROL => net_gnd0,
      FSL0_S_EXISTS => net_gnd0,
      FSL0_M_CLK => open,
      FSL0_M_WRITE => open,
      FSL0_M_DATA => open,
      FSL0_M_CONTROL => open,
      FSL0_M_FULL => net_gnd0,
      FSL1_S_CLK => open,
      FSL1_S_READ => open,
      FSL1_S_DATA => net_gnd32,
      FSL1_S_CONTROL => net_gnd0,
      FSL1_S_EXISTS => net_gnd0,
      FSL1_M_CLK => open,
      FSL1_M_WRITE => open,
      FSL1_M_DATA => open,
      FSL1_M_CONTROL => open,
      FSL1_M_FULL => net_gnd0,
      FSL2_S_CLK => open,
      FSL2_S_READ => open,
      FSL2_S_DATA => net_gnd32,
      FSL2_S_CONTROL => net_gnd0,
      FSL2_S_EXISTS => net_gnd0,
      FSL2_M_CLK => open,
      FSL2_M_WRITE => open,
      FSL2_M_DATA => open,
      FSL2_M_CONTROL => open,
      FSL2_M_FULL => net_gnd0,
      FSL3_S_CLK => open,
      FSL3_S_READ => open,
      FSL3_S_DATA => net_gnd32,
      FSL3_S_CONTROL => net_gnd0,
      FSL3_S_EXISTS => net_gnd0,
      FSL3_M_CLK => open,
      FSL3_M_WRITE => open,
      FSL3_M_DATA => open,
      FSL3_M_CONTROL => open,
      FSL3_M_FULL => net_gnd0,
      FSL4_S_CLK => open,
      FSL4_S_READ => open,
      FSL4_S_DATA => net_gnd32,
      FSL4_S_CONTROL => net_gnd0,
      FSL4_S_EXISTS => net_gnd0,
      FSL4_M_CLK => open,
      FSL4_M_WRITE => open,
      FSL4_M_DATA => open,
      FSL4_M_CONTROL => open,
      FSL4_M_FULL => net_gnd0,
      FSL5_S_CLK => open,
      FSL5_S_READ => open,
      FSL5_S_DATA => net_gnd32,
      FSL5_S_CONTROL => net_gnd0,
      FSL5_S_EXISTS => net_gnd0,
      FSL5_M_CLK => open,
      FSL5_M_WRITE => open,
      FSL5_M_DATA => open,
      FSL5_M_CONTROL => open,
      FSL5_M_FULL => net_gnd0,
      FSL6_S_CLK => open,
      FSL6_S_READ => open,
      FSL6_S_DATA => net_gnd32,
      FSL6_S_CONTROL => net_gnd0,
      FSL6_S_EXISTS => net_gnd0,
      FSL6_M_CLK => open,
      FSL6_M_WRITE => open,
      FSL6_M_DATA => open,
      FSL6_M_CONTROL => open,
      FSL6_M_FULL => net_gnd0,
      FSL7_S_CLK => open,
      FSL7_S_READ => open,
      FSL7_S_DATA => net_gnd32,
      FSL7_S_CONTROL => net_gnd0,
      FSL7_S_EXISTS => net_gnd0,
      FSL7_M_CLK => open,
      FSL7_M_WRITE => open,
      FSL7_M_DATA => open,
      FSL7_M_CONTROL => open,
      FSL7_M_FULL => net_gnd0,
      ICACHE_FSL_IN_CLK => open,
      ICACHE_FSL_IN_READ => open,
      ICACHE_FSL_IN_DATA => net_gnd32,
      ICACHE_FSL_IN_CONTROL => net_gnd0,
      ICACHE_FSL_IN_EXISTS => net_gnd0,
      ICACHE_FSL_OUT_CLK => open,
      ICACHE_FSL_OUT_WRITE => open,
      ICACHE_FSL_OUT_DATA => open,
      ICACHE_FSL_OUT_CONTROL => open,
      ICACHE_FSL_OUT_FULL => net_gnd0,
      DCACHE_FSL_IN_CLK => open,
      DCACHE_FSL_IN_READ => open,
      DCACHE_FSL_IN_DATA => net_gnd32,
      DCACHE_FSL_IN_CONTROL => net_gnd0,
      DCACHE_FSL_IN_EXISTS => net_gnd0,
      DCACHE_FSL_OUT_CLK => open,
      DCACHE_FSL_OUT_WRITE => open,
      DCACHE_FSL_OUT_DATA => open,
      DCACHE_FSL_OUT_CONTROL => open,
      DCACHE_FSL_OUT_FULL => net_gnd0
    );

  mb_opb : mb_opb_wrapper
    port map (
      OPB_Clk => sys_clk_s,
      OPB_Rst => mb_opb_OPB_Rst,
      SYS_Rst => sys_rst_s,
      Debug_SYS_Rst => mb_opb_Debug_SYS_Rst,
      WDT_Rst => net_gnd0,
      M_ABus => mb_opb_M_ABus,
      M_BE => mb_opb_M_BE,
      M_beXfer => net_gnd2,
      M_busLock => mb_opb_M_busLock,
      M_DBus => mb_opb_M_DBus,
      M_DBusEn => net_gnd2,
      M_DBusEn32_63 => net_vcc2,
      M_dwXfer => net_gnd2,
      M_fwXfer => net_gnd2,
      M_hwXfer => net_gnd2,
      M_request => mb_opb_M_request,
      M_RNW => mb_opb_M_RNW,
      M_select => mb_opb_M_select,
      M_seqAddr => mb_opb_M_seqAddr,
      Sl_beAck => net_gnd3,
      Sl_DBus => mb_opb_Sl_DBus,
      Sl_DBusEn => net_vcc3,
      Sl_DBusEn32_63 => net_vcc3,
      Sl_errAck => mb_opb_Sl_errAck,
      Sl_dwAck => net_gnd3,
      Sl_fwAck => net_gnd3,
      Sl_hwAck => net_gnd3,
      Sl_retry => mb_opb_Sl_retry,
      Sl_toutSup => mb_opb_Sl_toutSup,
      Sl_xferAck => mb_opb_Sl_xferAck,
      OPB_MRequest => open,
      OPB_ABus => mb_opb_OPB_ABus,
      OPB_BE => mb_opb_OPB_BE,
      OPB_beXfer => open,
      OPB_beAck => open,
      OPB_busLock => open,
      OPB_rdDBus => open,
      OPB_wrDBus => open,
      OPB_DBus => mb_opb_OPB_DBus,
      OPB_errAck => mb_opb_OPB_errAck,
      OPB_dwAck => open,
      OPB_dwXfer => open,
      OPB_fwAck => open,
      OPB_fwXfer => open,
      OPB_hwAck => open,
      OPB_hwXfer => open,
      OPB_MGrant => mb_opb_OPB_MGrant,
      OPB_pendReq => open,
      OPB_retry => mb_opb_OPB_retry,
      OPB_RNW => mb_opb_OPB_RNW,
      OPB_select => mb_opb_OPB_select,
      OPB_seqAddr => mb_opb_OPB_seqAddr,
      OPB_timeout => mb_opb_OPB_timeout,
      OPB_toutSup => open,
      OPB_xferAck => mb_opb_OPB_xferAck
    );

  debug_module : debug_module_wrapper
    port map (
      OPB_Clk => sys_clk_s,
      OPB_Rst => mb_opb_OPB_Rst,
      Interrupt => open,
      Debug_SYS_Rst => mb_opb_Debug_SYS_Rst,
      Debug_Rst => Debug_Rst,
      Ext_BRK => Ext_BRK,
      Ext_NM_BRK => Ext_NM_BRK,
      OPB_ABus => mb_opb_OPB_ABus,
      OPB_BE => mb_opb_OPB_BE,
      OPB_RNW => mb_opb_OPB_RNW,
      OPB_select => mb_opb_OPB_select,
      OPB_seqAddr => mb_opb_OPB_seqAddr,
      OPB_DBus => mb_opb_OPB_DBus,
      MDM_DBus => mb_opb_Sl_DBus(0 to 31),
      MDM_errAck => mb_opb_Sl_errAck(0),
      MDM_retry => mb_opb_Sl_retry(0),
      MDM_toutSup => mb_opb_Sl_toutSup(0),
      MDM_xferAck => mb_opb_Sl_xferAck(0),
      Dbg_Clk_0 => DBG_CLK_s,
      Dbg_TDI_0 => DBG_TDI_s,
      Dbg_TDO_0 => DBG_TDO_s,
      Dbg_Reg_En_0 => DBG_REG_EN_s,
      Dbg_Capture_0 => DBG_CAPTURE_s,
      Dbg_Update_0 => DBG_UPDATE_s,
      Dbg_Clk_1 => open,
      Dbg_TDI_1 => open,
      Dbg_TDO_1 => net_gnd0,
      Dbg_Reg_En_1 => open,
      Dbg_Capture_1 => open,
      Dbg_Update_1 => open,
      Dbg_Clk_2 => open,
      Dbg_TDI_2 => open,
      Dbg_TDO_2 => net_gnd0,
      Dbg_Reg_En_2 => open,
      Dbg_Capture_2 => open,
      Dbg_Update_2 => open,
      Dbg_Clk_3 => open,
      Dbg_TDI_3 => open,
      Dbg_TDO_3 => net_gnd0,
      Dbg_Reg_En_3 => open,
      Dbg_Capture_3 => open,
      Dbg_Update_3 => open,
      Dbg_Clk_4 => open,
      Dbg_TDI_4 => open,
      Dbg_TDO_4 => net_gnd0,
      Dbg_Reg_En_4 => open,
      Dbg_Capture_4 => open,
      Dbg_Update_4 => open,
      Dbg_Clk_5 => open,
      Dbg_TDI_5 => open,
      Dbg_TDO_5 => net_gnd0,
      Dbg_Reg_En_5 => open,
      Dbg_Capture_5 => open,
      Dbg_Update_5 => open,
      Dbg_Clk_6 => open,
      Dbg_TDI_6 => open,
      Dbg_TDO_6 => net_gnd0,
      Dbg_Reg_En_6 => open,
      Dbg_Capture_6 => open,
      Dbg_Update_6 => open,
      Dbg_Clk_7 => open,
      Dbg_TDI_7 => open,
      Dbg_TDO_7 => net_gnd0,
      Dbg_Reg_En_7 => open,
      Dbg_Capture_7 => open,
      Dbg_Update_7 => open,
      bscan_tdi => open,
      bscan_reset => open,
      bscan_shift => open,
      bscan_update => open,
      bscan_capture => open,
      bscan_sel1 => open,
      bscan_drck1 => open,
      bscan_tdo1 => net_gnd0,
      FSL0_S_CLK => open,
      FSL0_S_READ => open,
      FSL0_S_DATA => net_gnd32,
      FSL0_S_CONTROL => net_gnd0,
      FSL0_S_EXISTS => net_gnd0,
      FSL0_M_CLK => open,
      FSL0_M_WRITE => open,
      FSL0_M_DATA => open,
      FSL0_M_CONTROL => open,
      FSL0_M_FULL => net_gnd0
    );

  lmb_bram : lmb_bram_wrapper
    port map (
      BRAM_Rst_A => conn1_BRAM_Rst,
      BRAM_Clk_A => conn1_BRAM_Clk,
      BRAM_EN_A => conn1_BRAM_EN,
      BRAM_WEN_A => conn1_BRAM_WEN,
      BRAM_Addr_A => conn1_BRAM_Addr,
      BRAM_Din_A => conn1_BRAM_Din,
      BRAM_Dout_A => conn1_BRAM_Dout,
      BRAM_Rst_B => net_gnd0,
      BRAM_Clk_B => net_gnd0,
      BRAM_EN_B => net_gnd0,
      BRAM_WEN_B => net_gnd4,
      BRAM_Addr_B => net_gnd32,
      BRAM_Din_B => open,
      BRAM_Dout_B => net_gnd32
    );

  sram_512kx8_flash_2mx8 : sram_512kx8_flash_2mx8_wrapper
    port map (
      OPB_Clk => sys_clk_s,
      OPB_Rst => mb_opb_OPB_Rst,
      OPB_ABus => mb_opb_OPB_ABus,
      OPB_DBus => mb_opb_OPB_DBus,
      Sln_DBus => mb_opb_Sl_DBus(32 to 63),
      OPB_select => mb_opb_OPB_select,
      OPB_RNW => mb_opb_OPB_RNW,
      OPB_seqAddr => mb_opb_OPB_seqAddr,
      OPB_BE => mb_opb_OPB_BE,
      Sln_xferAck => mb_opb_Sl_xferAck(1),
      Sln_errAck => mb_opb_Sl_errAck(1),
      Sln_toutSup => mb_opb_Sl_toutSup(1),
      Sln_retry => mb_opb_Sl_retry(1),
      Mem_A => SRAM_512Kx8_FLASH_2Mx8_Mem_A_split,
      Mem_CEN => SRAM_512Kx8_FLASH_2Mx8_Mem_CEN_OBUF(0 to 0),
      Mem_OEN => SRAM_512Kx8_FLASH_2Mx8_Mem_OEN_OBUF(0 to 0),
      Mem_WEN => SRAM_512Kx8_FLASH_2Mx8_Mem_WEN_OBUF,
      Mem_QWEN => open,
      Mem_BEN => open,
      Mem_RPN => open,
      Mem_CE => open,
      Mem_ADV_LDN => open,
      Mem_LBON => open,
      Mem_CKEN => open,
      Mem_RNW => open,
      Mem_DQ_I => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_I,
      Mem_DQ_O => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_O,
      Mem_DQ_T => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_T
    );

  sram_512kx8_flash_2mx8_util_bus_split_0 : sram_512kx8_flash_2mx8_util_bus_split_0_wrapper
    port map (
      Sig => SRAM_512Kx8_FLASH_2Mx8_Mem_A_split,
      Out1 => SRAM_512Kx8_FLASH_2Mx8_Mem_A_OBUF,
      Out2 => open
    );

  opb_bram_if_cntlr_0 : opb_bram_if_cntlr_0_wrapper
    port map (
      opb_clk => sys_clk_s,
      opb_rst => mb_opb_OPB_Rst,
      opb_abus => mb_opb_OPB_ABus,
      opb_dbus => mb_opb_OPB_DBus,
      sln_dbus => mb_opb_Sl_DBus(64 to 95),
      opb_select => mb_opb_OPB_select,
      opb_rnw => mb_opb_OPB_RNW,
      opb_seqaddr => mb_opb_OPB_seqAddr,
      opb_be => mb_opb_OPB_BE,
      sln_xferack => mb_opb_Sl_xferAck(2),
      sln_errack => mb_opb_Sl_errAck(2),
      sln_toutsup => mb_opb_Sl_toutSup(2),
      sln_retry => mb_opb_Sl_retry(2),
      bram_rst => conn1_BRAM_Rst,
      bram_clk => conn1_BRAM_Clk,
      bram_en => conn1_BRAM_EN,
      bram_wen => conn1_BRAM_WEN,
      bram_addr => conn1_BRAM_Addr,
      bram_din => conn1_BRAM_Din,
      bram_dout => conn1_BRAM_Dout
    );

  bufgp_0 : BUFGP
    port map (
      I => sys_clk_pin,
      O => sys_clk_s
    );

  ibuf_1 : IBUF
    port map (
      I => sys_rst_pin,
      O => sys_rst_s
    );

  obuf_2 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_A_OBUF(10),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_A(10)
    );

  obuf_3 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_A_OBUF(11),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_A(11)
    );

  obuf_4 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_A_OBUF(12),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_A(12)
    );

  obuf_5 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_A_OBUF(13),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_A(13)
    );

  obuf_6 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_A_OBUF(14),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_A(14)
    );

  obuf_7 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_A_OBUF(15),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_A(15)
    );

  obuf_8 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_A_OBUF(16),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_A(16)
    );

  obuf_9 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_A_OBUF(17),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_A(17)
    );

  obuf_10 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_A_OBUF(18),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_A(18)
    );

  obuf_11 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_A_OBUF(19),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_A(19)
    );

  obuf_12 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_A_OBUF(20),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_A(20)
    );

  obuf_13 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_A_OBUF(21),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_A(21)
    );

  obuf_14 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_A_OBUF(22),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_A(22)
    );

  obuf_15 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_A_OBUF(23),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_A(23)
    );

  obuf_16 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_A_OBUF(24),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_A(24)
    );

  obuf_17 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_A_OBUF(25),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_A(25)
    );

  obuf_18 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_A_OBUF(26),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_A(26)
    );

  obuf_19 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_A_OBUF(27),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_A(27)
    );

  obuf_20 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_A_OBUF(28),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_A(28)
    );

  obuf_21 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_A_OBUF(29),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_A(29)
    );

  obuf_22 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_A_OBUF(30),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_A(30)
    );

  obuf_23 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_A_OBUF(31),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_A(31)
    );

  iobuf_24 : IOBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_O(0),
      IO => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ(0),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_I(0),
      T => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_T(0)
    );

  iobuf_25 : IOBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_O(1),
      IO => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ(1),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_I(1),
      T => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_T(1)
    );

  iobuf_26 : IOBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_O(2),
      IO => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ(2),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_I(2),
      T => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_T(2)
    );

  iobuf_27 : IOBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_O(3),
      IO => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ(3),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_I(3),
      T => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_T(3)
    );

  iobuf_28 : IOBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_O(4),
      IO => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ(4),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_I(4),
      T => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_T(4)
    );

  iobuf_29 : IOBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_O(5),
      IO => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ(5),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_I(5),
      T => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_T(5)
    );

  iobuf_30 : IOBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_O(6),
      IO => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ(6),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_I(6),
      T => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_T(6)
    );

  iobuf_31 : IOBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_O(7),
      IO => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ(7),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_I(7),
      T => SRAM_512Kx8_FLASH_2Mx8_Mem_DQ_int_T(7)
    );

  obuf_32 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_CEN_OBUF(0),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_CEN(0)
    );

  obuf_33 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_WEN_OBUF,
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_WEN
    );

  obuf_34 : OBUF
    port map (
      I => net_gnd0,
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_BEN
    );

  obuf_35 : OBUF
    port map (
      I => SRAM_512Kx8_FLASH_2Mx8_Mem_OEN_OBUF(0),
      O => SRAM_512Kx8_FLASH_2Mx8_Mem_OEN
    );

end architecture STRUCTURE;

