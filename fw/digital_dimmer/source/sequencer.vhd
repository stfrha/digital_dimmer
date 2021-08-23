
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
-- Description:     The clock is assumed to be on 25 MHz.
--                  The following table gives update_delay values corresponding to
--                  the time it takes to go from no light to full light:
--                  Time            update_delay
--                  0.5s            50
--                  1s              100
--                  2s              200
--                  5s              500
--                  10s             1000
--                  30s             3000
--                  40.95s          4095 (max)
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

entity sequencer is
   port (
      clk         : in std_logic;
      reset       : in std_logic;
      
      target      : in unsigned(17 downto 0); -- [40 ns/lsb]
      update_delay: in unsigned(11 downto 0); -- [40 ns/lsb]
      
      duty_cycle  : out unsigned(17 downto 0) -- [40 ns/lsb]
   );
end sequencer;

architecture rtl of sequencer is

   signal duty_cycle_i : unsigned(17 downto 0) := (others => '0');
   signal delay_counter: unsigned(11 downto 0) := (others => '0');
   
begin
   seq_p : process (clk)
   begin
      if rising_edge(clk) then
         if delay_counter < update_delay then
            delay_counter <= delay_counter + 1;
         else
            delay_counter <= (others => '0');
            if target > duty_cycle_i then
               duty_cycle_i <= duty_cycle_i + 1;
            elsif target < duty_cycle_i then
               duty_cycle_i <= duty_cycle_i - 1;
            end if;
         end if;
         
         if reset = '1' then  -- Synchronous reset
            delay_counter <= (others => '0');
            duty_cycle_i <= to_unsigned(250000, 18);
         end if;
      end if;
   end process seq_p;
   
   duty_cycle <= duty_cycle_i;
   
end architecture rtl;
