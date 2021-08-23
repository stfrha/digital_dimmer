
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

entity controller is
   port (
      clk            : in std_logic;
      reset          : in std_logic;

      code           : in std_logic_vector(11 downto 0);
      code_strobe    : in std_logic;
      
      target_0       : out unsigned(17 downto 0); -- [40 ns/lsb]
      update_delay_0 : out unsigned(11 downto 0); -- [40 ns/lsb]

      target_1       : out unsigned(17 downto 0); -- [40 ns/lsb]
      update_delay_1 : out unsigned(11 downto 0); -- [40 ns/lsb]

      target_2       : out unsigned(17 downto 0); -- [40 ns/lsb]
      update_delay_2 : out unsigned(11 downto 0)  -- [40 ns/lsb]
   );
end controller;

architecture rtl of controller is

   constant DEVICE_ADDRESS : std_logic_vector(4 downto 0) := "10001"; -- Adr 17 is a CD
begin
   seq_p : process (clk)
   begin
      if rising_edge(clk) then
         if code_strobe = '1' then
            if code(4 downto 0) = DEVICE_ADDRESS then
               case code(11 downto 5) is
               when "0000000" => -- Key 0 all off immediately
                  target_0       <= to_unsigned(250000, 18);
                  update_delay_0 <= to_unsigned(0, 12);
                  target_1       <= to_unsigned(250000, 18);
                  update_delay_1 <= to_unsigned(0, 12);
                  target_2       <= to_unsigned(250000, 18);
                  update_delay_2 <= to_unsigned(0, 12);
               when "0000001" => -- Key 1 all on immediately
                  target_0       <= to_unsigned(0, 18);
                  update_delay_0 <= to_unsigned(0, 12);
                  target_1       <= to_unsigned(0, 18);
                  update_delay_1 <= to_unsigned(0, 12);
                  target_2       <= to_unsigned(0, 18);
                  update_delay_2 <= to_unsigned(0, 12);
               when "0000010" => -- Key 2
               when "0000011" => -- Key 3 -- Beginning of movie 
                  target_0       <= to_unsigned(250000, 18);
                  update_delay_0 <= to_unsigned(1000, 12);
                  target_1       <= to_unsigned(250000, 18);
                  update_delay_1 <= to_unsigned(500, 12);
                  target_2       <= to_unsigned(250000, 18);
                  update_delay_2 <= to_unsigned(500, 12);
               when "0000100" => -- Key 4 Table light on
                  target_0       <= to_unsigned(250000, 18);
                  update_delay_0 <= to_unsigned(50, 12);
                  target_1       <= to_unsigned(0, 18);
                  update_delay_1 <= to_unsigned(50, 12);
                  target_2       <= to_unsigned(250000, 18);
                  update_delay_2 <= to_unsigned(50, 12);
               when "0000101" => -- Key 5
               when "0000110" => -- Key 6
               when "0000111" => -- Key 7 Table light off
                  target_0       <= to_unsigned(250000, 18);
                  update_delay_0 <= to_unsigned(50, 12);
                  target_1       <= to_unsigned(250000, 18);
                  update_delay_1 <= to_unsigned(50, 12);
                  target_2       <= to_unsigned(250000, 18);
                  update_delay_2 <= to_unsigned(50, 12);
               when "0001000" => -- Key 8
               when "0001001" => -- Key 9 -- End of movie
                  target_0       <= to_unsigned(167000, 18);
                  update_delay_0 <= to_unsigned(1000, 12);
                  target_1       <= to_unsigned(167000, 18);
                  update_delay_1 <= to_unsigned(1000, 12);
                  target_2       <= to_unsigned(250000, 18);
                  update_delay_2 <= to_unsigned(500, 12);
               when "0010000" => -- Key Channel +
               when "0010001" => -- Key Channel -
               when "0010010" => -- Key Volume +
               when "0010011" => -- Key Volume -
               when others =>
                  null;
               end case;
            end if;
         end if;
               
         if reset = '1' then  -- Synchronous reset
            target_0       <= to_unsigned(0, 18);
            update_delay_0 <= to_unsigned(500, 12);
            target_1       <= to_unsigned(0, 18);
            update_delay_1 <= to_unsigned(50, 12);
            target_2       <= to_unsigned(0, 18);
            update_delay_2 <= to_unsigned(100, 12);
         end if;
      end if;
   end process seq_p;
   
end architecture rtl;
