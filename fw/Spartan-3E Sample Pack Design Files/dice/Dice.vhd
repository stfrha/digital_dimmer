--------------------------------------------------------------------------------
-- Company: Digilent
-- Engineer: Mircea Dabacan
--
-- Create Date:    15:17:23 04/17/05
-- Design Name:    Spartan
-- Module Name:    Dice - Behavioral
-- Project Name:   Test 3SE
-- Target Device:  3S100E
-- Tool versions:  WebPack 7.1i
-- Description:	 Simulates a dice throw for each time the btn is released
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: Debug version (additional outputs include)
-- 
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Dice is
    Port ( clk : in std_logic;
           btn : in std_logic;
           led : out std_logic_vector(6 downto 0));
end Dice;

architecture Behavioral of Dice is

	signal divClk:std_logic; 
	signal DividerCounter: integer range 0 to 7;
	signal btnOld :std_logic;
	signal SequenceCounter: integer range 0 to 7;
	type Radix6CounterType is array (integer range 0 to 7) of integer range 0 to 5;
	signal Radix6Counter: Radix6CounterType;
--	signal CarryOut :std_logic_vector(7 downto 0);
	signal DisplayRegister: Radix6CounterType;
	signal TimerCounter: integer range 0 to 34999999;
	type StepLengthsType is array (integer range 0 to 7) of integer range 0 to 34999999;
	constant StepLengths: StepLengthsType:=
	(499999, 999999, 1499999, 1999999, 2499999, 2999999, 3499999, 0);

begin

	ClockDivider: process (clk)
	begin
		if clk'event and clk = '1' then
			DividerCounter <= DividerCounter + 1;
		end if;
	end process;

	divClk <= conv_std_logic_vector(DividerCounter,3)(2);

	Radix6CounterProc: process (divClk)
	begin
		if divClk'event and divClk = '1' then
			if Radix6Counter(0) /= 5 then	
				Radix6Counter(0) <= Radix6Counter(0) + 1;
			else
				Radix6Counter(0) <= 0;
				if Radix6Counter(1) /= 5 then	
					Radix6Counter(1) <= Radix6Counter(1) + 1;
				else
					Radix6Counter(1) <= 0;
					if Radix6Counter(2) /= 5 then	
						Radix6Counter(2) <= Radix6Counter(2) + 1;
					else
						Radix6Counter(2) <= 0;
						if Radix6Counter(3) /= 5 then	
							Radix6Counter(3) <= Radix6Counter(3) + 1;
						else
							Radix6Counter(3) <= 0;
							if Radix6Counter(4) /= 5 then	
								Radix6Counter(4) <= Radix6Counter(4) + 1;
							else
								Radix6Counter(4) <= 0;
								if Radix6Counter(5) /= 5 then	
									Radix6Counter(5) <= Radix6Counter(5) + 1;
								else
									Radix6Counter(5) <= 0;
									if Radix6Counter(6) /= 5 then	
										Radix6Counter(6) <= Radix6Counter(6) + 1;
									else
										Radix6Counter(6) <= 0;
										if Radix6Counter(7) /= 5 then	
											Radix6Counter(7) <= Radix6Counter(7) + 1;
										else
											Radix6Counter(7) <= 0;
										end if;
									end if;
								end if;
							end if;
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;

	SequenceProc: process (divClk, btn)
	begin
		if divClk'event and divClk = '1' then
			if btn = '1' then 		-- pressed button
				SequenceCounter <= 0;
			elsif TimerCounter = StepLengths(SequenceCounter) and  -- current step not yet ended
				SequenceCounter /= 7 then	-- released button and not last step
					SequenceCounter <= SequenceCounter + 1;
			end if;
		end if;

	end process;

	Timer: process (divClk)
	begin
		if divClk'event and divClk = '1' then
			if btn = '1' then 		-- pressed button
					TimerCounter <= 0;
			elsif TimerCounter = StepLengths(SequenceCounter) then  -- current step not yet ended
					TimerCounter <= 0;
			else  -- current step  ended
					TimerCounter <= TimerCounter + 1;		-- count
			end if;
		end if;
	end process;
			
	DisplayProc: process (divClk)
	begin
		if divClk'event and divClk = '1' then
			btnOld <= btn;
			if btnOld = '1' and btn	= '0' then
				DisplayRegister <= Radix6Counter;
			end if;
		end if;
	 end process;

	led <= "0001000" when	DisplayRegister(7-SequenceCounter) = 1 else
			 "1000001" when	DisplayRegister(7-SequenceCounter) = 2 else
			 "1001001" when	DisplayRegister(7-SequenceCounter) = 3 else
			 "1010101" when	DisplayRegister(7-SequenceCounter) = 4 else
			 "1011101" when	DisplayRegister(7-SequenceCounter) = 5 else
			 "1110111";

end Behavioral;
