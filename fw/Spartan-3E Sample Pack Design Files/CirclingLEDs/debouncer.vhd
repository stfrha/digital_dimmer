--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:    16:30:12 04/13/05
-- Design Name:    
-- Module Name:    debouncer - Behavioral
-- Project Name:   
-- Target Device:  
-- Tool versions:  
-- Description:
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity debouncer is
    Port ( inp : in std_logic;
           oup : out std_logic;
           clk : in std_logic);
end debouncer;

architecture Behavioral of debouncer is
signal int : std_logic_vector(7 downto 0);
begin

debounce:process(clk) is
begin

if clk'event and clk = '1' then

	int <= int(6 downto 0)&inp; -- shift last 8 sample values

	if int(0)=inp and
		int(1)=inp and 
		int(2)=inp and 
		int(3)=inp and 
		int(4)=inp and 
		int(5)=inp and 
		int(6)=inp and 
		int(7)=inp then -- all samples constant
			oup <= inp;
	end if;
end if;

end process; 



end Behavioral;
