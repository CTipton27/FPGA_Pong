--File : keyboard_controller.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity keyboard_controller is
    Port (
        PS2Data     : in STD_LOGIC;
        PS2Clk      : in STD_LOGIC;
        P1          : out STD_LOGIC_VECTOR (1 downto 0);
        P2          : out STD_LOGIC_VECTOR (1 downto 0)
        );
end keyboard_controller;

architecture Behavioral of keyboard_controller is
signal PS2Word : unsigned (10 downto 0) := (others => '0');
begin
    process(PS2Clk) is
    begin
        if (falling_edge(PS2Clk)) then
            
        end if;
    end process;
end Behavioral;