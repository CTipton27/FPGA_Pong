-- File: score_keep.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity score_keep is
    Port (
        clk      : in STD_LOGIC; --25MHz, divide by 16,384
        rst      : in STD_LOGIC;
        score_p1 : in STD_LOGIC;
        score_p2 : in STD_LOGIC;
        an       : out STD_LOGIC_VECTOR (3 downto 0);
        seg      : out STD_LOGIC_VECTOR (6 downto 0)
    );
end score_keep;

architecture Behavioral of score_keep is
    signal counter     : unsigned (15 downto 0)     := (others => '0');
    signal score_p1_val : integer                   := 0;
    signal score_p2_val : integer                   := 0;
    signal digit_sel   : unsigned (1 downto 0);
    signal score_p1_prev, score_p2_prev : std_logic := '0';
    signal score_p1_rise, score_p2_rise : std_logic := '0';
    signal digit_val : integer range 0 to 9 := 0;
begin
	process(clk) is --Divides 25MHz clock by 65,536.
	begin
	   if rising_edge(clk) then
	       if counter = 65535 then
	           counter <= (others => '0');
    	   else
	          counter <= counter + 1;
	       end if;
	   end if;
	end process;
	digit_sel <= counter(15 downto 14); -- 2 bit clock which will decode into the an select
	
	process(digit_sel)
    begin
        case digit_sel is
            when "00" => an <= "1110"; -- digit 0 (right)
            when "01" => an <= "1101"; -- digit 1
            when "10" => an <= "1011"; -- digit 2
            when "11" => an <= "0111"; -- digit 3 (left)
            when others => an <= "1111";
        end case;
    end process;
    
	process(clk) --detects a score on behalf of p1 or p2
    begin
        if rising_edge(clk) then
            score_p1_rise <= score_p1 and not score_p1_prev;
            score_p2_rise <= score_p2 and not score_p2_prev;
    
            score_p1_prev <= score_p1;
            score_p2_prev <= score_p2;
        end if;
    end process;

    process(clk)--increments the scores of players at each score.
    begin
        if rising_edge(clk) then
            if rst = '1' then
                score_p1_val <= 0;
                score_p2_val <= 0;
            else
                if score_p1_rise = '1' then
                    score_p1_val <= (score_p1_val + 1) mod 100;
                end if;
                if score_p2_rise = '1' then
                    score_p2_val <= (score_p2_val + 1) mod 100;
                end if;
            end if;
        end if;
    end process;

    process(digit_sel, score_p1_val, score_p2_val) --determines which digit is being displayed
    begin
        case digit_sel is
            when "00" => digit_val <= score_p2_val mod 10;          -- p2 units
            when "01" => digit_val <= (score_p2_val / 10) mod 10;   -- p2 tens
            when "10" => digit_val <= score_p1_val mod 10;          -- p1 units
            when "11" => digit_val <= (score_p1_val / 10) mod 10;   -- p1 tens
            when others => digit_val <= 0;
        end case;
    end process;
    
	process(digit_val)
    begin
        case digit_val is
            when 0 => seg <= "1000000";
            when 1 => seg <= "1111001";
            when 2 => seg <= "0100100";
            when 3 => seg <= "0110000";
            when 4 => seg <= "0011001";
            when 5 => seg <= "0010010";
            when 6 => seg <= "0000010";
            when 7 => seg <= "1111000";
            when 8 => seg <= "0000000";
            when 9 => seg <= "0010000";
            when others => seg <= "0000001";
        end case;
    end process;
end Behavioral;