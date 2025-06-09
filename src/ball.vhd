--File : ball.vhd
--This one is a little finnicky, we look at the ball image, and ignore all black pixels
--leaving only the ball color behind.

--This code will take the current paddle positions, and on a clock pulse increment the ball's
--position and speed. if it would hit a paddle, it instead turns around. lastly, it recieves
--x and y positions of the vga signal, and will output ball_on if it is on the current pixel.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ball_controller is
    Port (
        clk : in STD_LOGIC; --25MHz
        p1y : in STD_LOGIC_VECTOR (9 downto 0);
        P2y : in STD_LOGIC_VECTOR (9 downto 0);
        pixel_x : in STD_LOGIC_VECTOR (9 downto 0);
        pixel_y : in STD_LOGIC_VECTOR (9 downto 0);
        color : out STD_LOGIC_VECTOR (11 downto 0);
        ball_on : out STD_LOGIC
        );
end ball_controller;

architecture Behavioral of ball_controller is
begin
    process(clk) is
    begin
        if (rising_edge(clk)) then
            
        end if;
    end process;
end Behavioral;