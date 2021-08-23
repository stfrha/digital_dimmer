
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
-- Description:     Testbench for ir_decoder.vhd
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

entity dimmer_channel_tb is
end dimmer_channel_tb;

architecture tb of dimmer_channel_tb is
   signal clk : std_logic := '0';
   signal reset : std_logic := '1';

   signal zero_detect   : std_logic := '0';
   signal target        : unsigned(17 downto 0) := to_unsigned(250000, 18); -- [40 ns/lsb]
   signal update_delay  : unsigned(11 downto 0) := to_unsigned(1000, 12);   -- [40 ns/lsb]
   signal triac_cntrl   : std_logic;
   
   signal simulation_done : boolean := false;

begin


dimmer_channel_1 : entity work.dimmer_channel(struct) port map (
      clk            => clk,
      reset          => reset,
      zero_detect    => zero_detect,
      target         => target,
      update_delay   => update_delay,
      triac_cntrl    => triac_cntrl
);

clk <= not clk after 20 ns when not simulation_done;

reset <= '1', '0' after 1 us;

-- Stimulus process
sim_zero_detect_p : process
begin
   wait for 10 ms;
   wait until clk'event and clk = '1';
   zero_detect <= '1';
   wait until clk'event and clk = '1';
   zero_detect <= '0';
   if simulation_done then
      wait;
   end if;
end process sim_zero_detect_p;

-- Stimulus process
stim_p : process is
begin
   wait for 1 ms;
   
   wait for 40 ms;

   target <= to_unsigned(0, 18);    -- Set target for full light
   update_delay <= to_unsigned(50, 12);  --Make it 0.5s to get to full light.

   wait for 0.5001 sec;

   wait for 40 ms;
   simulation_done <= true;
   
   wait;

end process stim_p;
   
end architecture tb;
      
