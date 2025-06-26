-- File: top.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port (
        clk : in STD_LOGIC;
        PS2Clk : in STD_LOGIC;
        PS2Data: in STD_LOGIC;
        Hsync : out STD_LOGIC;
        Vsync : out STD_LOGIC;
        color : out STD_LOGIC_VECTOR(11 downto 0);
        an    : out STD_LOGIC_VECTOR(3 downto 0);
        seg   : out STD_LOGIC_VECTOR(6 downto 0)
    );
end top;

architecture Behavioral of top is
    -- 25 MHz clock
    signal clk25    : STD_LOGIC;
    signal rst      : STD_LOGIC;
    signal pixel_x  : STD_LOGIC_VECTOR(9 downto 0);
    signal pixel_y  : STD_LOGIC_VECTOR(9 downto 0);
    signal video_on : STD_LOGIC;
    signal draw_game: STD_LOGIC_VECTOR(1 downto 0);
    signal frame    : STD_LOGIC;
    signal P1       : STD_LOGIC_VECTOR(1 downto 0);
    signal P2       : STD_LOGIC_VECTOR(1 downto 0);
    signal p1y      : STD_LOGIC_VECTOR(9 downto 0);
    signal p2y      : STD_LOGIC_VECTOR(9 downto 0);
    signal score_p1 : STD_LOGIC;
    signal score_p2 : STD_LOGIC;

    component clock_divider
        Port (
            clk    : in  STD_LOGIC;
            oclk   : out STD_LOGIC
        );
    end component;
    
    component keyboard_controller
        Port (
            PS2Data     : in STD_LOGIC;
            PS2Clk      : in STD_LOGIC;
            P1          : out STD_LOGIC_VECTOR (1 downto 0); --MSB is HOLD (1 for hold, 0 for move), LSB is DIR(1 for up, 0 for down)
            P2          : out STD_LOGIC_VECTOR (1 downto 0);  --MSB is HOLD (1 for hold, 0 for move), LSB is DIR(1 for up, 0 for down)
            RESET       : out STD_LOGIC
        );
    end component;

    component vga_controller
        Port (
            clk     : in  STD_LOGIC;
            hsync     : out STD_LOGIC;
            vsync     : out STD_LOGIC;
            video_on  : out STD_LOGIC;
            frame     : out STD_LOGIC;
            pixel_x   : out STD_LOGIC_VECTOR(9 downto 0);
            pixel_y   : out STD_LOGIC_VECTOR(9 downto 0)
        );
    end component;
    
    component paddle
        Port(
            frame    : in STD_LOGIC; --60fps
            video_on : in STD_LOGIC;
            rst      : in STD_LOGIC;
            p1       : in STD_LOGIC_VECTOR (1 downto 0);
            P2       : in STD_LOGIC_VECTOR (1 downto 0);
            pixel_x  : in STD_LOGIC_VECTOR (9 downto 0);
            pixel_y  : in STD_LOGIC_VECTOR (9 downto 0);
            paddle_on: out STD_LOGIC;
            p1y      : out STD_LOGIC_VECTOR (9 downto 0);
            p2y      : out STD_LOGIC_VECTOR (9 downto 0)
        );
    end component;
    
    component ball
        Port (
            frame    : in STD_LOGIC; --60fps
            video_on : in STD_LOGIC;
            rst      : in STD_LOGIC;
            p1y      : in STD_LOGIC_VECTOR (9 downto 0);
            P2y      : in STD_LOGIC_VECTOR (9 downto 0);
            pixel_x  : in STD_LOGIC_VECTOR (9 downto 0);
            pixel_y  : in STD_LOGIC_VECTOR (9 downto 0);
            ball_on  : out STD_LOGIC;
            score_p1 : out STD_LOGIC;
            score_p2 : out STD_LOGIC
        );
    end component;
    
    component score_keep
        Port (
            clk      : in STD_LOGIC; --25MHz, divide by 16,384
            rst      : in STD_LOGIC;
            score_p1 : in STD_LOGIC;
            score_p2 : in STD_LOGIC;
            an       : out STD_LOGIC_VECTOR (3 downto 0);
            seg      : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;
    
    
begin
    clkdiv_inst : clock_divider
        port map (
            clk   => clk,
            oclk  => clk25
        );

    vga_inst : vga_controller
        port map (
            clk       => clk25,
            hsync     => Hsync,
            vsync     => Vsync,
            video_on  => video_on,
            frame     => frame,
            pixel_x   => pixel_x,
            pixel_y   => pixel_y
        );
     
    keyboard_controller_inst : keyboard_controller
        port map (
            PS2Data => PS2Data,
            PS2Clk  => PS2Clk,
            P1      => P1,
            P2      => P2,  
            RESET   => rst
        );
    
    paddle_inst : paddle
        port map (
            frame      => frame,
            video_on   => video_on,
            rst        => rst,
            p1         => P1,
            P2         => P2,
            pixel_x    => pixel_x,
            pixel_y    => pixel_y,
            paddle_on  => draw_game(1),
            p1y        => p1y,
            p2y        => p2y
        );
    
    ball_inst : ball
        port map(
            frame    => frame,
            video_on => video_on,
            rst      => rst,
            p1y      => p1y,
            P2y      => p2y,
            pixel_x  => pixel_x,
            pixel_y  => pixel_y,
            ball_on  => draw_game(0),
            score_p1 => score_p1,
            score_p2 => score_p2
        );
    
    score : score_keep
        port map(
            clk      => clk25,
            rst      => rst,
            score_p1 => score_p1,
            score_p2 => score_p2,
            an       => an,
            seg      => seg
        );
        
        with draw_game select
            color <= x"FFF" when "10",
                     x"F00" when "01",
                     x"444" when others;
    
end Behavioral;