
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
-- Description:     The clock is assumed to be on 25 MHz. This component decodes Sony SIRC
--                  12-bits IR-codes. The input is assumed to be demodulated (without
--                  38 kHz carrier) IR bit sequence. The adress is set to 17 (borrowed from
--                  an CD player.
--                  The IR decodeing is done by sample the ir input three times for each
--                  transition on the ir signal. One such length is 600us. Dividing this
--                  into three periods we get a period time of 200us.
--                  See http://www.sbprojects.com/knowledge/ir/sirc.htm for protocol.
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


entity ir_decoder is
   port (
      clk         : in std_logic;
      reset       : in std_logic;

      -- IR input
      ir          : in std_logic;

      code        : out std_logic_vector(11 downto 0);
      code_strobe : out std_logic
   );
end ir_decoder;

architecture rtl of ir_decoder is
   constant STEP_PERIOD : unsigned (12 downto 0) := to_unsigned(5000, 13); -- 200us period time with 25MHz clk
   signal period : unsigned (12 downto 0) := (others => '0');

   type bit_id_state_t is (IDLE, HIGH, LOW);
   signal bit_id_state : bit_id_state_t;

   --Get rid of pre reset metavalue warnings in simulator
   signal high_counter   : unsigned(4 downto 0) := (others => '0'); 
   signal low_counter   : unsigned(4 downto 0) := (others => '0'); 
   
   signal ir_r  : std_logic; -- Synchronization

   signal start  : std_logic := '0';
   signal one  : std_logic := '0';             
   signal zero : std_logic := '0';
   signal timeout : std_logic := '0';

   type decoder_state_t is (IDLE, COLLECTING);
   signal decoder_state : decoder_state_t;
   
   signal bit_counter : unsigned(3 downto 0) := to_unsigned(0, 4);
   
begin

bit_id_p : process (clk)
-- This process waits for pulses to occur and outputs the type of pulse when found. There
-- are three types of pulses, start, one and zero satisfying the following criteria:
-- Start: more then 10 samples of high followed by at least two samples of low.
-- one: between four to six samples of ones followed by at least two samples of low.
-- zero less then four samples of ones followed by at least two samples of low.
-- For each bit identified, a corresponding signal is pulsed for one clock cycle.
-- If any bit is found and identified and is followed by low for four samples a timeout is
-- pulsed.
begin
   if rising_edge(clk) then
      ir_r <= ir;             -- Synchronization
      
      -- Default these signals to always produce one cycle pulses when set to one later in
      -- process.
      start <= '0';            
      one <= '0';             
      zero <= '0';
      timeout <= '0';
      
      if period < STEP_PERIOD then
         period <= period + 1;
      else
         period <= to_unsigned(0, 13);

         case bit_id_state is
         when IDLE =>
            if ir_r = '1' then 
               high_counter <= to_unsigned(1,5);
               bit_id_state <= HIGH;
            else
               -- Only if low_counter is exactly three we send timeout. 
               if low_counter = 3 then 
                  timeout <= '1';
                  -- Increase one more count so we don't send multiple timeouts.
                  low_counter <= low_counter + 1; 
               elsif low_counter < 3 then
                  low_counter <= low_counter + 1;
               end if;
            end if;
         
         when HIGH =>
            if ir_r = '0' then
               low_counter <= to_unsigned(1, 5);
               bit_id_state <= LOW;
            else
               if high_counter <= 31 then
                  high_counter <= high_counter + 1;
               end if;
            end if;
         
         when LOW =>
            if low_counter >= 2 then 
               -- A bit is complete, now identify it
               if high_counter > 10 then 
                  start <= '1';
               elsif high_counter >= 4 and high_counter <= 6 then
                  one <= '1';
               else
                  zero <= '1';
               end if;

               -- A new pulse could begin now, so check for it before go to IDLE
               if ir_r = '1' then            
                  high_counter <= to_unsigned(1,5); 
                  bit_id_state <= HIGH;
               else
                  low_counter <= to_unsigned(0, 5);  -- Reuse this counter for timeout detection
                  bit_id_state <= IDLE;
               end if;

            elsif ir_r = '0' then
               low_counter <= low_counter + 1;
            else
               high_counter <= to_unsigned(1, 5);    -- Restart, discarding old pulse
               bit_id_state <= HIGH;
            end if;
         end case;
      end if;

      if reset = '1' then        -- Synchronous reset
--         ir_r <= '0';
         start <= '0';
         one <= '0';
         zero <= '0';
         timeout <= '0';
         bit_id_state <= IDLE;
         period <= to_unsigned(0, 13);
         high_counter <= to_unsigned(0,5);
         low_counter <= to_unsigned(0,5);
      end if;
   end if;

end process bit_id_p;

decoder_p : process (clk)
-- This process waits for a start bit. When received it starts to collect bits.
-- This is done until one of the follwing events happens:
-- 1. 12 bits have been received and the code is send out of this component.
-- 2. A timeout bit is received, in which case a new wait for a start bit is started
-- 3. A new start bit is received in which case a new sequence is started (the old discarded)
--
-- 
begin
   if rising_edge(clk) then
      -- Default zero, to produce one-cycle pulse when set to one later
      code_strobe <= '0';
      
      case decoder_state is
      when IDLE =>
         if start = '1' then
            decoder_state <= COLLECTING;
            bit_counter <= to_unsigned(0, 4);
         end if;
      when COLLECTING =>
         if bit_counter = 12 then
            code_strobe <= '1';
            decoder_state <= IDLE;
         elsif timeout = '1' then
            decoder_state <= IDLE;
         elsif start = '1' then
            bit_counter <= to_unsigned(0, 4);
         elsif one = '1' then
            code(11 - to_integer(bit_counter)) <= '1';
            bit_counter <= bit_counter + 1;
         elsif zero = '1' then
            code(11 - to_integer(bit_counter)) <= '0';
            bit_counter <= bit_counter + 1;
         end if;
      end case;

      if reset = '1' then        -- Synchronous reset, signal: "code" need no reset
         code <= "000000000000";
         bit_counter <= to_unsigned(0, 4);
         code_strobe <= '0';
         decoder_state <= IDLE;
      end if;
   end if;

end process decoder_p;

end architecture rtl;
      
