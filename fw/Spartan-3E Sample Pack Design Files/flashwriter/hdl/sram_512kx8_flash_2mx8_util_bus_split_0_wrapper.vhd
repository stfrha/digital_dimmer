-------------------------------------------------------------------------------
-- sram_512kx8_flash_2mx8_util_bus_split_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library util_bus_split_v1_00_a;
use util_bus_split_v1_00_a.all;

entity sram_512kx8_flash_2mx8_util_bus_split_0_wrapper is
  port (
    Sig : in std_logic_vector(0 to 31);
    Out1 : out std_logic_vector(10 to 31);
    Out2 : out std_logic_vector(32 downto 31)
  );
  attribute x_core_info : STRING;
  attribute x_core_info of sram_512kx8_flash_2mx8_util_bus_split_0_wrapper: entity is "util_bus_split_v1_00_a";

end sram_512kx8_flash_2mx8_util_bus_split_0_wrapper;

architecture STRUCTURE of sram_512kx8_flash_2mx8_util_bus_split_0_wrapper is

  component util_bus_split is
    generic (
      C_SIZE_IN : integer;
      C_LEFT_POS : integer;
      C_SPLIT : integer
    );
    port (
      Sig : in std_logic_vector(0 to C_SIZE_IN-1);
      Out1 : out std_logic_vector(C_LEFT_POS to C_SPLIT-1);
      Out2 : out std_logic_vector(C_SPLIT downto C_SIZE_IN-1)
    );
  end component;

begin

  sram_512kx8_flash_2mx8_util_bus_split_0 : util_bus_split
    generic map (
      C_SIZE_IN => 32,
      C_LEFT_POS => 10,
      C_SPLIT => 32
    )
    port map (
      Sig => Sig,
      Out1 => Out1,
      Out2 => Out2
    );

end architecture STRUCTURE;

