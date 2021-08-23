--
-- Module: 	BUFG_CLKDV_SUBM 
--
-- Description: VHDL submodule 
--		DCM with CLKDV and CLK0 deskew
--
-- Device: 	Spartan-3 Family 
--
-----------------------------------------------------------------------
--
library ieee,unisim;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use unisim.vcomponents.all;

entity clock is
   port ( 
      clk_50 : in std_logic;
      clk1x  : out std_logic;
      clk_25 : out std_logic;
      lock   : out std_logic
   );
end clock;

architecture rtl of clock is

--
-- Attributes

attribute DLL_FREQUENCY_MODE : string; 
attribute DUTY_CYCLE_CORRECTION : string;
attribute CLKDV_DIVIDE : real; 
attribute STARTUP_WAIT : string; 

attribute DLL_FREQUENCY_MODE of U_DCM: label is "LOW";
attribute DUTY_CYCLE_CORRECTION of U_DCM: label is "TRUE";
attribute CLKDV_DIVIDE of U_DCM: label is 2.0;
attribute STARTUP_WAIT of U_DCM: label is "FALSE";

--		
-----------------------------------------------------------------------
--
-- Signal Declarations:
signal gnd : std_logic;
--
signal clk0_w: std_logic;
signal clk1x_w: std_logic;
signal clkdv_w: std_logic;
signal clk_div_w: std_logic;

begin

gnd <= '0';

clk1x <= clk1x_w;
clk_25 <= clk_div_w;

-- DCM Instantiation
u_dcm: dcm port map (
   clkin =>    clk_50,
   clkfb =>    clk1x_w,
   dssen =>    gnd,
   psincdec => gnd,
   psen =>     gnd,
   psclk =>    gnd,
   rst   =>    '0',
   clk0 =>     clk0_w,
   clkdv =>    clkdv_w,
   locked =>   lock
); 

-- BUFG Instantiation for CLK0
u0_bufg: bufg port map (
   i => clk0_w,
   o => clk1x_w
);

-- BUFG Instantiation for CLKDV
u1_bufg: bufg port map (
   i => clkdv_w,
   o => clk_div_w
);

end architecture rtl;

