--File : paddle.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity paddle is
    Port (
        frame    : in STD_LOGIC; --60fps
        video_on : in STD_LOGIC;
        p1      : in STD_LOGIC_VECTOR (1 downto 0);
        P2      : in STD_LOGIC_VECTOR (1 downto 0);
        pixel_x  : in STD_LOGIC_VECTOR (9 downto 0);
        pixel_y  : in STD_LOGIC_VECTOR (9 downto 0);
        color    : out STD_LOGIC_VECTOR (11 downto 0);
        paddle_on  : out STD_LOGIC
        );
end paddle;

architecture Behavioral of paddle is
constant paddle_length : integer := 64;
constant paddle_width  : integer := 12;
constant left_border   : integer := 19;
constant right_border  : integer := 599;
constant top_border    : integer := 9;
constant bottom_border : integer := 469;

signal left_paddle_y : unsigned (9 downto 0) := (others => '0');
signal right_paddle_y : unsigned (9 downto 0) := (others => '0');

begin
    process(frame) is
    begin
        if (rising_edge(frame)) then --Checks user inputs, moves paddles accordingly.
            case p1 is
                when "00" | "11" =>     null; --neither or both inputs pressed, cancel.
                when "01" => 
                    if (left_paddle_y >= top_border + 6) then
                        left_paddle_y <= left_paddle_y - 6;
                    end if;
                when "10" => 
                    if (left_paddle_y + paddle_length <= bottom_border - 6) then
                        left_paddle_y <= left_paddle_y + 6;
                    end if;
                when others => null; --Do nothing, paddles should remain still
            end case;
            case p2 is
                when "00" | "11" =>     null; --neither or both inputs pressed, cancel.
                when "01" => 
                if (right_paddle_y >= top_border + 6) then    
                    right_paddle_y <= right_paddle_y - 6;
                end if;
                when "10" => 
                if (right_paddle_y + paddle_length <= bottom_border - 6) then
                    right_paddle_y <= right_paddle_y + 6;
                end if;
                when others => null; --Do nothing, paddles should remain still
            end case;
        end if;
    end process;
    paddle_on <= '1' when (
        --Left Paddle
        to_integer(unsigned(pixel_x)) >= left_border and
        to_integer(unsigned(pixel_x)) < left_border + paddle_width and
        to_integer(unsigned(pixel_y)) >= to_integer(left_paddle_y) and
        to_integer(unsigned(pixel_y)) < to_integer(left_paddle_y) + paddle_length and
        
        --Right Paddle
        to_integer(unsigned(pixel_x)) >= right_border-paddle_width and
        to_integer(unsigned(pixel_x)) < right_border and
        to_integer(unsigned(pixel_y)) >= to_integer(right_paddle_y) and
        to_integer(unsigned(pixel_y)) < to_integer(right_paddle_y) + paddle_length
        ) else '0';
    
    color <= "111111111111";
end Behavioral;