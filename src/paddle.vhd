--File : paddle.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity paddle is
    Port (
        frame      : in STD_LOGIC; --60fps
        video_on   : in STD_LOGIC;
        rst        : in STD_LOGIC;
        p1         : in STD_LOGIC_VECTOR (1 downto 0);
        P2         : in STD_LOGIC_VECTOR (1 downto 0);
        pixel_x    : in STD_LOGIC_VECTOR (9 downto 0);
        pixel_y    : in STD_LOGIC_VECTOR (9 downto 0);
        paddle_on  : out STD_LOGIC;
        p1y        : out STD_LOGIC_VECTOR (9 downto 0);
        p2y        : out STD_LOGIC_VECTOR (9 downto 0)
        );
end paddle;

architecture Behavioral of paddle is
constant paddle_length : integer := 64;
constant paddle_width  : integer := 12;
constant left_border   : integer := 19;
constant right_border  : integer := 599;
constant top_border    : integer := 9;
constant bottom_border : integer := 469;
constant paddle_speed  : integer := 4;

signal left_paddle_y : unsigned (9 downto 0) := (others => '0');
signal right_paddle_y : unsigned (9 downto 0) := (others => '0');

begin
    process(frame,rst) is
    begin
        if (rst = '1') then
            left_paddle_y  <= to_unsigned(240-paddle_length/2, 10);
            right_paddle_y <= to_unsigned(240-paddle_length/2, 10);
        else
            if (rising_edge(frame)) then --Checks user inputs, moves paddles accordingly.
                case p1 is
                    when "10" | "11" =>     null; --neither or both inputs pressed, cancel.
                    when "01" => 
                        if (left_paddle_y >= to_unsigned(top_border + paddle_speed, left_paddle_y'length)) then
    
                            left_paddle_y <= left_paddle_y - paddle_speed;
                        end if;
                    when "00" => 
                        if (left_paddle_y + to_unsigned(paddle_length, left_paddle_y'length) <= 
                            to_unsigned(bottom_border - paddle_speed, left_paddle_y'length)) then
                            left_paddle_y <= left_paddle_y + paddle_speed;
                        end if;
                    when others => null; --Do nothing, paddles should remain still
                end case;
                case p2 is
                    when "10" | "11" =>     null; --neither or both inputs pressed, cancel.
                    when "01" => 
                    if (right_paddle_y >= to_unsigned(top_border + paddle_speed, right_paddle_y'length)) then
        
                        right_paddle_y <= right_paddle_y - paddle_speed;
                    end if;
                    when "00" => 
                    if (right_paddle_y + to_unsigned(paddle_length, right_paddle_y'length) <= 
                        to_unsigned(bottom_border - paddle_speed, right_paddle_y'length)) then
                        right_paddle_y <= right_paddle_y + paddle_speed;
                    end if;
                    when others => null; --Do nothing, paddles should remain still
                end case;
            end if;
        end if;
    end process;
    paddle_on <= '1' when (video_on = '1' and (
    -- Left Paddle
    (to_integer(unsigned(pixel_x)) >= left_border and
     to_integer(unsigned(pixel_x)) < left_border + paddle_width and
     to_integer(unsigned(pixel_y)) >= to_integer(left_paddle_y) and
     to_integer(unsigned(pixel_y)) < to_integer(left_paddle_y) + paddle_length)

    or

    -- Right Paddle
    (to_integer(unsigned(pixel_x)) >= right_border - paddle_width and
     to_integer(unsigned(pixel_x)) < right_border and
     to_integer(unsigned(pixel_y)) >= to_integer(right_paddle_y) and
     to_integer(unsigned(pixel_y)) < to_integer(right_paddle_y) + paddle_length)
)) else '0';


        
    p1y <= std_logic_vector(left_paddle_y);
    p2y <= std_logic_vector(right_paddle_y);
end Behavioral;