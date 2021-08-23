
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


entity ir_decoder_tb is
end ir_decoder_tb;

architecture tb of ir_decoder_tb is
   type code_type is ('S', '1', '0', 'L', 'B');
   type code_vector_type is array (31 downto 0) of code_type;
   -- S = start, 1 = One, 0 = Zero, L = Long one (10 ms), B = Break long zero (10ms)
   signal clk : std_logic := '0';
   signal reset : std_logic := '1';
   signal ir  : std_logic := '0';
   signal code_strobe   : std_logic := '0';
   signal code          : std_logic_vector(11 downto 0);
   signal arm_capture   : std_logic := '0';
   signal captured_code : std_logic_vector(11 downto 0) := "101010101010";
   
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

procedure check_sequence( code            : in code_vector_type; 
                        correct_code      : in std_logic_vector(11 downto 0);
                        number_of_bits    : in integer;
                        signal ir         : out std_logic;
                        signal arm_capture: out std_logic ) is
begin
   wait for 1 us;
   arm_capture <= '1';
   wait for 1 us;
   arm_capture <= '0';

   wait for 1 ms;
   ir_sequence(code, number_of_bits, ir);

   wait for 1 us;
   assert (captured_code) = correct_code
   report "Incorrect result"
   severity error;
end procedure check_sequence;

begin


ir_decoder_1 : entity work.ir_decoder(rtl) port map (
      clk     => clk,
      reset   => reset,
      ir      => ir,
      code    => code,
      code_strobe => code_strobe
);

clk <= not clk after 20 ns when not simulation_done;

reset <= '1', '0' after 1 us;


-- Capture code from decoder to evaluate result from ir sequences
capture_p : process (clk)
begin
   if rising_edge(clk) then
      if code_strobe = '1' then
         captured_code <= code;
      elsif arm_capture = '1' then
         captured_code <= "101010101010";
      end if;
   end if;
end process capture_p;


-- Stimulus process
stim_p : process is
begin
   wait for 1 ms;

   -- Test single code
   check_sequence("0000000000000000000S111111100000", "111111100000", 13, ir, arm_capture);
   
   -- Test two consequtive sequences
   check_sequence("000000S001100110011S110011001100", "110011001100", 26, ir, arm_capture);

   -- Test interrupted sequence
   check_sequence("0000000000000S11111S110011001100", "110011001100", 19, ir, arm_capture);

   -- Test broken sequences
   check_sequence("0000000000000000000S11001100110B", "101010101010", 13, ir, arm_capture);

   -- Test long startbit
   check_sequence("000000000000000000LS111111100000", "111111100000", 14, ir, arm_capture);

   wait for 1 ms;
   simulation_done <= true;
   
   wait;

end process stim_p;
   
end architecture tb;
      
