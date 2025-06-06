-- File: top.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        vga_hsync : out STD_LOGIC;
        vga_vsync : out STD_LOGIC;
        vga_red   : out STD_LOGIC_VECTOR(3 downto 0);
        vga_green : out STD_LOGIC_VECTOR(3 downto 0);
        vga_blue  : out STD_LOGIC_VECTOR(3 downto 0)
    );
end top;

architecture Behavioral of top is
begin
    -- Placeholder for instantiations
end Behavioral;