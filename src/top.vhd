-- File: top.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC; --Will be a switch?
        p1  : in STD_LOGIC_VECTOR(1 downto 0);
        p2  : in STD_LOGIC_VECTOR (1 downto 0);
        Hsync : out STD_LOGIC;
        Vsync : out STD_LOGIC;
        vgaRed   : out STD_LOGIC_VECTOR(3 downto 0);
        vgaGreen : out STD_LOGIC_VECTOR(3 downto 0);
        vgaBlue  : out STD_LOGIC_VECTOR(3 downto 0)
    );
end top;

architecture Behavioral of top is
    -- 25 MHz clock
    signal clk25    : STD_LOGIC;
    signal pixel_x  : STD_LOGIC_VECTOR(9 downto 0);
    signal pixel_y  : STD_LOGIC_VECTOR(9 downto 0);
    signal video_on : STD_LOGIC;
    signal frame    : STD_LOGIC;

    component clock_divider
        Port (
            clk    : in  STD_LOGIC;
            rst    : in  STD_LOGIC;
            oclk   : out STD_LOGIC
        );
    end component;

    component vga_controller
        Port (
            clk     : in  STD_LOGIC;
            rst       : in  STD_LOGIC;
            hsync     : out STD_LOGIC;
            vsync     : out STD_LOGIC;
            video_on  : out STD_LOGIC;
            frame     : out STD_LOGIC;
            pixel_x   : out STD_LOGIC_VECTOR(9 downto 0);
            pixel_y   : out STD_LOGIC_VECTOR(9 downto 0)
        );
    end component;
begin
    clkdiv_inst : clock_divider
        port map (
            clk => clk,
            rst => rst,
            oclk  => clk25
        );

    vga_inst : vga_controller
        port map (
            clk     => clk25,
            rst       => rst,
            hsync     => Hsync,
            vsync     => Vsync,
            video_on  => video_on,
            frame     => frame,
            pixel_x   => pixel_x,
            pixel_y   => pixel_y
        );
            -- Output blue screen when video is active
    vgaRed   <= (others => '0');
    vgaGreen <= (others => '0');
    vgaBlue  <= "1111" when video_on = '1' else "0000";
    
end Behavioral;