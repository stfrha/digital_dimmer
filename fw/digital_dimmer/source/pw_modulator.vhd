
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

entity pw_modulator is
   port (
      clk         : in std_logic;
      reset       : in std_logic;
      
      -- zero_detect should give one (and only one) pulse when the zero detection circuit
      -- have detected the start of a new half-period.
      zero_detect : in std_logic;
      
      -- duty_value holds the off-time of the triac half-period. The resolution is 40 ns/lsb.
      -- A value off 0 mean no off-time and thus, the light is on all the time. A half
      -- period time is 10 ms and hence the value of 250000 means no light.
      duty_value  : in unsigned(17 downto 0); -- [40 ns/lsb]

      triac_cntrl : out std_logic
   );
end pw_modulator;

architecture rtl of pw_modulator is

   constant MAX_COUNT : unsigned(17 downto 0) := to_unsigned(250000, 18);
   
   signal counter : unsigned(17 downto 0) := to_unsigned(0, 18);

begin

pw_p : process (clk)
-- The counter signal counter is used as a state holding signal for this process. When
-- counter is zero, the process awaits a pulse on the zero_detect signal indicating a 
-- new half period have started. This starts the counter.
-- Since counter is now non-zero the process continue to increase the counter until
-- it has reached the duty_cycle value. At this point the triac_cntrl signal is activiated
-- and the counter is reset. This again prompt the process to start waiting for a new 
-- period. If however the MAX_COUNT value is lower then duty_cycle, the light is completely
-- turned off and the triac_cntrl should not be activated.
begin
   if rising_edge(clk) then
      if counter = 0 then
         if zero_detect = '1' then     -- Wait for next half period
            counter <= counter + 1;
            if duty_value > 0 then        -- Zero means all light on, no interruption
               triac_cntrl <= '0';        -- Only turn off triac when new half-period starts
            end if;
         end if;
      elsif counter > duty_value then
         triac_cntrl <= '1';           -- Turn on light until the next half-period
         counter <= to_unsigned(0,18); -- Reset process
      elsif counter >= MAX_COUNT then
         counter <= to_unsigned(0,18); -- Reset process if MAX_COUNT is reached, no light
      else
         counter <= counter + 1;
      end if;   
      
      if reset = '1' then
         triac_cntrl <= '0';
         counter <= to_unsigned(0, 18);
      end if;
   end if;
end process pw_p;

end architecture rtl;
      
