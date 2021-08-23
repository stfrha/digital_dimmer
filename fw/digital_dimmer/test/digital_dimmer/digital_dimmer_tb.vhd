
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


entity digital_dimmer_tb is
end digital_dimmer_tb;

architecture tb of digital_dimmer_tb is
   type code_type is ('S', '1', '0', 'L', 'B');
   type code_vector_type is array (31 downto 0) of code_type;
   -- S = start, 1 = One, 0 = Zero, L = Long one (10 ms), B = Break long zero (10ms)

   signal clk : std_logic := '0';
   signal reset : std_logic := '1';
   signal ir  : std_logic := '0';
   signal wave_pol : std_logic := '0';
   signal triac    : std_logic_vector(2 downto 0);
   
   signal simulation_done : boolean := false;

procedure ir_sequence ( code              : in code_vector_type; 
                        number_of_bits    : in integer;
                        signal ir                : out std_logic) is
   variable hd : time; -- High delay
   variable ld : time; -- Low delay
begin
   for i in number_of_bits - 1 downto 0 loop
      case code(i) is
      when 'S' =>
         hd := 2.4 ms;
         ld := 0.6 ms;
      when '1' =>
         hd := 1.2 ms;
         ld := 0.6 ms;
      when '0' =>
         hd := 0.6 ms;
         ld := 0.6 ms;
      when 'L' =>
         hd := 10 ms;
         ld := 0 ms;
      when 'B' =>
         hd := 0 ms;
         ld := 10 ms;
      end case;

      if hd > 0 ms then
         ir <= '1';
         wait for hd;
      end if;
      
      if ld > 0 ms then
         ir <= '0';
         wait for ld;
      end if;
   end loop;
end procedure ir_sequence;

begin

digital_dimmer_1 : entity work.digital_dimmer(struct) port map (
      clk     => clk,
      reset   => reset,
      wave_pol=> wave_pol,
      triac    => triac,
      ir       => ir
);

clk <= not clk after 10 ns when not simulation_done;

reset <= '1', '0' after 100 us;

-- wave polarization process
wave_pol_p : process is
begin
   wait for 10 ms;
   wave_pol <= '1';
   wait for 10 ms;
   wave_pol <= '0';
   if simulation_done then
      wait;
   end if;
end process wave_pol_p;
   
-- Stimulus process
stim_p : process is
begin
   wait for 40 ms;

   -- Test single code
   ir_sequence("0000000000000000000S000001110001", 13, ir);

   wait for 0.5001 sec;
   simulation_done <= true;
   
   wait;
   
end process stim_p;
   
end architecture tb;
      
