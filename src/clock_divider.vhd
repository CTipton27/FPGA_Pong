-- File: clock_divider.vhd

--BASYS3 FPGA Runs at ~100MHz, divide by 4 with 50% duty cycle to 25MHz, for proper VGA timing.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    Port (
        clk : in  STD_LOGIC; --100MHz
        oclk: out STD_LOGIC); --25MHz
end clock_divider;

architecture Behavioral of clock_divider is
	signal counter : unsigned (1 downto 0) := "00";
begin
	process(clk) is
	begin
	   if rising_edge(clk) then
	       if counter = 3 then
	           counter <= "00";
    	   else
	          counter <= counter + 1;
	       end if;
	   end if;
	end process;
	
	oclk <= '0' when (counter < 2) else '1';
end Behavioral;