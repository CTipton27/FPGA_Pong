library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ball is
    Port (
        frame    : in STD_LOGIC; -- 60fps
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
end ball;

architecture Behavioral of ball is
    constant paddle_length : integer := 64;
    constant paddle_width  : integer := 12;
    constant ball_height   : integer := 32;
    constant ball_width    : integer := 32;
    constant left_border   : integer := 19;
    constant right_border  : integer := 599;
    constant top_border    : integer := 9;
    constant bottom_border : integer := 469;
    constant ball_radius   : integer := ball_height / 2;
    constant ball_rsquared : integer := ball_radius**2;

    signal ball_x        : unsigned (9 downto 0) := to_unsigned(320,10);
    signal ball_y        : unsigned (9 downto 0) := to_unsigned(240,10);
    signal speed_x       : unsigned(2 downto 0)  := "010";  -- start at 2
    signal speed_y       : unsigned(2 downto 0)  := "001";
    signal dx            : STD_LOGIC := '1';  -- 1 = right
    signal dy            : STD_LOGIC := '1';  -- 1 = down
    signal count         : integer := 0;

    signal missed_ball   : std_logic := '0';
    signal ball_exited   : std_logic := '0';
    signal game_paused   : std_logic := '0';
    signal reset_counter : integer := 0;

begin

    process(frame, rst)
    begin
        if rst = '1' then
            ball_x        <= to_unsigned(320,10);
            ball_y        <= to_unsigned(240,10);
            dx            <= '1';
            dy            <= '1';
            speed_x       <= "010";
            speed_y       <= "001";
            count         <= 0;
            game_paused   <= '0';
            reset_counter <= 0;
            score_p1      <= '0';
            score_p2      <= '0';
            missed_ball   <= '0';
            ball_exited   <= '0';

        elsif rising_edge(frame) then
            -- Clear score output each frame
            score_p1 <= '0';
            score_p2 <= '0';

            if game_paused = '1' then
                reset_counter <= reset_counter + 1;
                if reset_counter >= 120 then
                    -- reset position and speed
                    ball_x        <= to_unsigned(320,10);
                    ball_y        <= to_unsigned(240,10);
                    dx            <= '1';
                    dy            <= '1';
                    speed_x       <= "010";
                    speed_y       <= "001";
                    count         <= 0;
                    reset_counter <= 0;
                    game_paused   <= '0';
                    missed_ball   <= '0';
                    ball_exited   <= '0';
                end if;

            elsif missed_ball = '1' then
                -- Let ball leave screen
                if ball_x < to_unsigned(left_border - ball_radius - 1, 10) or
                   ball_x > to_unsigned(right_border + ball_radius + 1, 10) then
                    ball_exited   <= '1';
                    game_paused   <= '1';
                    reset_counter <= 0;
                end if;

                -- Keep moving ball
                if dx = '1' then
                    ball_x <= ball_x + speed_x;
                else
                    ball_x <= ball_x - speed_x;
                end if;

                if dy = '1' then
                    ball_y <= ball_y + speed_y;
                else
                    ball_y <= ball_y - speed_y;
                end if;

            else
                -- Ball is active

                -- Wall and paddle collision
                case dx is
                    when '0' =>  -- moving left
                        if (ball_x - ball_radius <= to_unsigned(left_border, 10) + paddle_width) then
                            if (ball_y + to_unsigned(ball_height, 10) >= unsigned(p1y)) and
                               (ball_y <= unsigned(p1y) + to_unsigned(paddle_length, 10)) then
                                dx <= '1'; -- bounce right

                                -- Speed up
                                if speed_x < "101" then  -- max 5
                                    count <= count + 1;
                                    if count >= 5 then
                                        speed_x <= speed_x + 1;
                                        count   <= 0;
                                    end if;
                                end if;

                            else
                                missed_ball <= '1';
                                score_p2    <= '1';
                            end if;
                        end if;

                    when '1' =>  -- moving right
                        if (ball_x + ball_radius >= to_unsigned(right_border, 10) - paddle_width) then
                            if (ball_y + to_unsigned(ball_height, 10) >= unsigned(P2y)) and
                               (ball_y <= unsigned(P2y) + to_unsigned(paddle_length, 10)) then
                                dx <= '0'; -- bounce left

                                -- Speed up
                                if speed_y < "011" then  -- max 3
                                    count <= count + 1;
                                    if count >= 7 then
                                        speed_y <= speed_y + 1;
                                        count   <= 0;
                                    end if;
                                end if;

                            else
                                missed_ball <= '1';
                                score_p1    <= '1';
                            end if;
                        end if;

                    when others =>
                        null;
                end case;

                -- Vertical bounce
                if (ball_y - ball_radius <= to_unsigned(top_border, 10)) then
                    dy <= '1';
                elsif (ball_y + ball_radius >= to_unsigned(bottom_border, 10)) then
                    dy <= '0';
                end if;

                -- Move ball
                if dx = '1' then
                    ball_x <= ball_x + speed_x;
                else
                    ball_x <= ball_x - speed_x;
                end if;

                if dy = '1' then
                    ball_y <= ball_y + speed_y;
                else
                    ball_y <= ball_y - speed_y;
                end if;
            end if;
        end if;
    end process;

    -- Output if current pixel is part of ball
    ball_on <= '1' when (video_on = '1' and (
        (to_integer(unsigned(pixel_x)) - to_integer(ball_x))**2 +
        (to_integer(unsigned(pixel_y)) - to_integer(ball_y))**2
        <= ball_rsquared)) else '0';

end Behavioral;