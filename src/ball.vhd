--File : ball.vhd
--This one is a little finnicky, we look at the ball image, and ignore all black pixels
--leaving only the ball color behind.

--This code will take the current paddle positions, and on a clock pulse increment the ball's
--position and speed. if it would hit a paddle, it instead turns around. lastly, it recieves
--x and y positions of the vga signal, and will output ball_on if it is on the current pixel.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ball is
    Port (
        frame    : in STD_LOGIC; --60fps
        video_on : in STD_LOGIC;
        p1y      : in STD_LOGIC_VECTOR (9 downto 0);
        P2y      : in STD_LOGIC_VECTOR (9 downto 0);
        pixel_x  : in STD_LOGIC_VECTOR (9 downto 0);
        pixel_y  : in STD_LOGIC_VECTOR (9 downto 0);
        color    : out STD_LOGIC_VECTOR (11 downto 0);
        ball_on  : out STD_LOGIC
        );
end ball;

architecture Behavioral of ball is
constant paddle_length : integer := 64;
constant ball_height   : integer := 32;
constant ball_width    : integer := 32;
constant left_border   : integer := 19;
constant right_border  : integer := 599;
constant top_border    : integer := 9;
constant bottom_border : integer := 469;
constant ball_radius   : integer := ball_height/2;
constant ball_rsquared : integer := ball_radius**2;

signal ball_x : unsigned (9 downto 0) := (others => '0');
signal ball_y : unsigned (9 downto 0) := (others => '0');
signal speed  : unsigned(2 downto 0)  := "001";  -- start at 1 pixel/frame
signal dx     : STD_LOGIC             := '1';   -- X direction (1 for right)
signal dy     : STD_LOGIC             := '1';   -- Y direction (1 for up)

begin
    process(frame) is
    begin
        if (rising_edge(frame)) then --Checks for collisions
            case dx is
                when '0' => -- Ball is moving left, check left border and P1 paddle
                    if (ball_x-(ball_width/2) <= to_unsigned(left_border, ball_x'length)) then -- Hit left wall
                        -- Check for collision with Player 1 paddle
                        if (ball_y + to_unsigned(ball_height, ball_y'length) >= unsigned(p1y)) and
                           (ball_y <= unsigned(p1y) + to_unsigned(paddle_length, p1y'length)) then
                            dx <= '1'; -- Bounce right
                            if speed < "101" then -- max speed = 5
                                speed <= speed + 1;
                            end if;
                        else
                            -- Ball missed paddle 1 - game over or score for P2
                            dx <= '1'; -- Temporary bounce if missed paddle
                        end if;
                    end if;
                when '1' => -- Ball is moving right, check right border and P2 paddle
                    if (ball_x+(ball_width/2)-1 >= to_unsigned(right_border, ball_x'length)) then -- Hit right wall
                        -- Check for collision with Player 2 paddle
                        if (ball_y + to_unsigned(ball_height, ball_y'length) >= unsigned(P2y)) and
                           (ball_y <= unsigned(P2y) + to_unsigned(paddle_length, P2y'length)) then
                            dx <= '0'; -- Bounce left
                        else
                            -- Ball missed paddle 2 - game over or score for P1
                            dx <= '0'; -- Temporary bounce if missed paddle
                        end if;
                    end if;

                when others =>
                    -- Should not happen with only '0' and '1' for dx
                    null;
            end case;
            
            -- Calculate next ball position
            if (dx = '1') then -- Moving right
                ball_x <= ball_x + speed;
            else -- Moving left
                ball_x <= ball_x - speed;
            end if;

            if (dy = '1') then -- Moving down
                ball_y <= ball_y + 1;
            else -- Moving up
                ball_y <= ball_y - 1;
            end if;
        end if;
    end process;
    ball_on <= '1' when (to_integer(signed(pixel_x)-signed(ball_x))**2 + to_integer(signed(pixel_y)-signed(ball_y)) <= ball_radius**2) else '0';
    
    color <= "111100000000";
end Behavioral;