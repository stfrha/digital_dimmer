--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:    15:42:18 08/22/05
-- Design Name:    
-- Module Name:    DemoWithStartUp - Behavioral
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
Library UNISIM;
use UNISIM.vcomponents.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DemoWithStartUp is
    Port ( clk : in std_logic;
           btn1 : in std_logic;
           led : out std_logic_vector(6 downto 0));
end DemoWithStartUp;

architecture Behavioral of DemoWithStartUp is

signal cnt: std_logic_vector(23 downto 0);
signal cnt2: std_logic_vector(2 downto 0);
signal pwm: std_logic_vector(5 downto 0);
signal btnDeb: std_logic:='1';


	COMPONENT debouncer
	PORT(
		inp : IN std_logic;
		clk : IN std_logic;          
		oup : OUT std_logic
		);
	END COMPONENT;


begin

   -- STARTUP_SPARTAN3E: Startup primitive for GSR, GTS, startup sequence
   --                 control and Multi-Boot Configuration. Spartan-3E
   -- Xilinx  HDL Language Template version 7.1i
   
   STARTUP_SPARTAN3E_inst : STARTUP_SPARTAN3E
   port map (
--      CLK => CLK,      -- Clock input for start-up sequence
--      MBT => not btnDeb -- Multi-Boot Trigger input
--      MBT => not btn1 -- Multi-Boot Trigger input
      MBT => not btn1 -- Multi-Boot Trigger input
   );
   
   -- End of STARTUP_SPARTAN3E_inst instantiation

 	Inst_debouncer: debouncer PORT MAP(
		inp => btn1,
		oup => btnDeb,
		clk => clk
	);
	  


	cnt_proc: process(clk)
	begin
		if clk'event and clk = '1' then
			cnt <= cnt + '1';
		end if;
	end process;

	cnt2_proc: process(cnt(23))
	begin
		if cnt(23)'event and cnt(23) = '1' then
			if cnt2 = "101" then
				cnt2 <= "000";
			else
				cnt2 <= cnt2 + '1';
			end if;
		end if;
	end process;

pwm(5) <= cnt(16);								  -- 50%
--pwm(4) <= cnt(16);						  -- 50% 
--pwm(3) <= cnt(16) and cnt (15);		  -- 25%
pwm(4) <= cnt(18) and cnt (17) and cnt (16);		  -- 12.5%
pwm(3) <= cnt(18) and cnt (17)and cnt (16)and cnt (15)and cnt (14) and cnt (13);		  -- 1%
pwm(2) <= '0';								  -- 0%
pwm(1) <= '0';								  -- 0%
pwm(0) <= '0';								  -- 0%


rotate: process(cnt2)
begin
   case cnt2 is 
      when "000" =>
         led(6) <= pwm(5);
         led(5) <= pwm(4);
         led(4) <= pwm(3);
         led(0) <= pwm(2);
         led(1) <= pwm(1);
         led(2) <= pwm(0);
      when "001" =>
         led(6) <= pwm(4);
         led(5) <= pwm(3);
         led(4) <= pwm(2);
         led(0) <= pwm(1);
         led(1) <= pwm(0);
         led(2) <= pwm(5);
      when "010" =>
         led(6) <= pwm(3);
         led(5) <= pwm(2);
         led(4) <= pwm(1);
         led(0) <= pwm(0);
         led(1) <= pwm(5);
         led(2) <= pwm(4);
      when "011" =>
         led(6) <= pwm(2);
         led(5) <= pwm(1);
         led(4) <= pwm(0);
         led(0) <= pwm(5);
         led(1) <= pwm(4);
         led(2) <= pwm(3);
      when "100" =>
         led(6) <= pwm(1);
         led(5) <= pwm(0);
         led(4) <= pwm(5);
         led(0) <= pwm(4);
         led(1) <= pwm(3);
         led(2) <= pwm(2);
      when others =>
         led(6) <= pwm(0);
         led(5) <= pwm(5);
         led(4) <= pwm(4);
         led(0) <= pwm(3);
         led(1) <= pwm(2);
         led(2) <= pwm(1);
   end case;
end process;
         led(3) <= '0';



end Behavioral;
