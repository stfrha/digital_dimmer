
---------------------------------------------------------------------------------------------
--
-- Legal notice:    All rights strictly reserved. Reproduction or issue to third parties in
--                  any form whatever is not permitted without written authority from the
--                  proprietors.
--
---------------------------------------------------------------------------------------------
--
-- File name:       $Id: $
--
-- Classification:
-- FHL:             Company Restricted
-- SekrL:           Unclassified
--
-- Coding rules:    IN IN117887 1.1C
--
-- Description:     
--
-- Known errors:    None
--
-- To do:           None
--
---------------------------------------------------------------------------------------------
-- Revision history:
--
-- $Log: $
--
---------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity digital_dimmer is
   port (
      clk         : in std_logic;
      reset       : in std_logic;
      
      --  IR control
      ir          : in std_logic;
      -- Dimmer control
      wave_pol    : in std_logic;
      triac       : out std_logic_vector(2 downto 0);
      
      -- LEDs
      led         : out std_logic_vector(7 downto 1)
   );
end digital_dimmer;

architecture struct of digital_dimmer is

   signal clk_25 : std_logic;
   
   type target_type is array (2 downto 0) of unsigned(17 downto 0);
   type update_delay_type is array (2 downto 0) of unsigned(11 downto 0);
   
   signal target : target_type;
   signal update_delay : update_delay_type;

   signal code_strobe   : std_logic;
   signal code          : std_logic_vector(11 downto 0) := (others => '0');
   
   signal zero_detect : std_logic;
   
   signal triac_i : std_logic_vector(2 downto 0);
   
begin

   triac <= triac_i;
   
clock_1 : entity work.clock(rtl) port map (
   clk_50 => clk,
   clk1x  => open,
   clk_25 => clk_25,
   lock   => open
);

ir_decoder_1 : entity work.ir_decoder(rtl) port map (
   clk               => clk_25,
   reset             => reset,
   ir                => ir,
   code              => code,
   code_strobe       => code_strobe
);
   
controller_1 : entity work.controller(rtl) port map (
   clk               => clk_25,
   reset             => reset,
   code              => code,
   code_strobe       => code_strobe,
   target_0          => target(0),
   update_delay_0    => update_delay(0),
   target_1          => target(1),
   update_delay_1    => update_delay(1),
   target_2          => target(2),
   update_delay_2    => update_delay(2)
);
   
channel_gen : for i in 0 to 2 generate
   dimmer_chnl : entity work.dimmer_channel(struct) port map (
      clk               => clk_25,
      reset             => reset,
      zero_detect       => zero_detect,
      target            => target(i),
      update_delay      => update_delay(i),
      triac_cntrl       => triac_i(i)
   );
end generate channel_gen;
   
zero_detect_1 : entity work.zero_detect(rtl) port map (
   clk               => clk_25,
   reset             => reset,
   wave_pol          => wave_pol,
   zero_detect       => zero_detect
);

led(4 downto 1) <= code(8 downto 5);
--led(7 downto 5) <= triac_i(2 downto 0);
led(7 downto 5) <= "101";
end architecture struct;
      
      
      
      
      
      
      
      
      