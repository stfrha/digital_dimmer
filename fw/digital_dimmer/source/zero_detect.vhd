
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
-- Description:     This module monitors the the sign of the AC halfwave and detect
--                  when this sign changes indicateing a transition from one polarity
--                  to the other.
--                  In reality, because of the pol monitoring circuit, the positive
--                  halfwave will always be shorter then the negative. Therefore a 
--                  average measureing counter should be used to create two perfect
--                  halfwaves.
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

entity zero_detect is
   port (
      clk         : in std_logic;
      reset       : in std_logic;
      
      -- wave_pol shows the sign of the halfwave at any time. A one mean positive halfwave.
      -- A zero means negative halfwave. This means the when this signal transits from
      -- one state to the other the AC is crossing zero volt.
      wave_pol : in std_logic;
      
      -- zero_detect gives one (and only one) pulse when the zero detection circuit
      -- have detected the start of a new half-period.
      zero_detect  : out std_logic
   );
end zero_detect;

architecture rtl of zero_detect is
   signal wave_pol_r : std_logic;
   signal wave_pol_d : std_logic;
begin

zd_p : process (clk)
begin
   if rising_edge(clk) then
      zero_detect <= '0';
      wave_pol_r <= wave_pol;
      wave_pol_d <= wave_pol_r;
      
      if wave_pol_d /= wave_pol_r then
         zero_detect <= '1';
      end if;

      if reset = '1' then
         zero_detect <= '0';
      end if;
   end if;
end process zd_p;

end architecture rtl;
      
