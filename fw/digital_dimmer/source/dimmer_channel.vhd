
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
-- Description:     The clock is assumed to be on 25 MHz. One complete dimmer channel.
--                  Connecting one sequencer with one pw_modulator.
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

entity dimmer_channel is
   port (
      clk           : in std_logic;
      reset         : in std_logic;
      
      -- zero_detect should give one (and only one) single clk cycle pulse when the zero 
      -- detection circuit have detected the start of a new half-period.
      zero_detect   : in std_logic;

      -- Target duty cycle value, i.e. holds the pw of the selected light intesity
      target        : in unsigned(17 downto 0); -- [40 ns/lsb]
     
     -- Sets the speed of the change of the light intensity
      update_delay  : in unsigned(11 downto 0); -- [40 ns/lsb]
      
      -- Control signal to the triac of the dimmer channel
      triac_cntrl   : out std_logic
   );
end dimmer_channel;

architecture struct of dimmer_channel is
      -- duty_value holds the off-time of the triac half-period. The resolution is 40 ns/lsb.
      -- A value off 0 mean no off-time and thus, the light is on all the time. A half
      -- period time is 10 ms and hence the value of 250000 means no light.
   signal duty_value  : unsigned(17 downto 0); -- [40 ns/lsb]
      
begin
   sequencer_1 : entity work.sequencer port map (
      clk            => clk,
      reset          => reset,
      
      target         => target,
      update_delay   => update_delay,
      
      duty_cycle     => duty_value
   );
     
   pw_modulator_1 : entity work.pw_modulator port map (
      clk            => clk,
      reset          => reset,

      zero_detect    => zero_detect,
      
      duty_value     => duty_value,
      
      triac_cntrl    => triac_cntrl
   );
end architecture struct;
      
