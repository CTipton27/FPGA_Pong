--File : keyboard_controller.vhd

--PS/2 Protol involves a Host and a Device. in this lab, the FPGA is the host, and the keyboard is the Device. Whenever a key is pressed or released, the device will provide a clock and a data signal. on the falling
--edge of this clock signal, the data line has the following structure:
--  Start bit (always 0)
--  Data bits (determines which key is pressed or released*)
--  Parity bit (the number of 1's in the data bits and the parity should be odd. so if data was "00000000" the parity will be 1, if the data is "00000001" the parity will be 0
--  End bit (always 1)
--This means that a total of 11 bits are sent on the falling edge of the device's clock. Note that whenever a key is not being sent, the clock remains high, which means 
--we do not need to worry about getting a ton of '0's though if this did happen, the parity would ensure the result is ignored regardless.
--* PS/2 Protocol has extended codes for certain characters. the up arrow, for example, has a code (in hexadecimal) of "E0 75" which is 2 scancodes long. In higher precision applications, 
--remembering this additional "E0" code is important, but in this lab, it is simply enough to look for the specific "75" code that the Up arrow has. 
--Lastly, the code "F0" is sent before any key when the key is released. This is sent as a "break" code, indicating that the held key is being released.

--When the full letter is extracted, we check if it was being pressed or released, and update P1 and P2 according to the change.
--For more information regarding PS/2 Protocol, visit "https://www.pcbheaven.com/wikipages/The_PS2_protocol/", quite a few features of the protocol were ignored for this lab!

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity keyboard_controller is
    Port (
        PS2Data     : in STD_LOGIC;
        PS2Clk      : in STD_LOGIC;
        P1          : out STD_LOGIC_VECTOR (1 downto 0); --MSB is HOLD (1 for hold, 0 for move), LSB is DIR(1 for up, 0 for down)
        P2          : out STD_LOGIC_VECTOR (1 downto 0);  --MSB is HOLD (1 for hold, 0 for move), LSB is DIR(1 for up, 0 for down)
        RESET       : out STD_LOGIC
        );
end keyboard_controller;

architecture Behavioral of keyboard_controller is
signal PS2Code : STD_LOGIC_VECTOR (10 downto 0) := (others => '0');
signal bitCounter : integer := 0;
signal parityCalc : std_logic;
signal wHeld      : boolean := false;
signal sHeld      : boolean := false;
signal rHeld      : boolean := false;
signal upHeld     : boolean := false;
signal downHeld   : boolean := false;
signal isBreak    : boolean := false;
begin
    --This logic checks to see if the number of 1's in the data bits are even or odd. to see this, imagine plugging in all '0's and seeing the result. flip 1 bit and look through the logic again.
    parityCalc <= PS2Code(1) xor PS2Code(2) xor PS2Code(3) xor PS2Code(4) xor 
                  PS2Code(5) xor PS2Code(6) xor PS2Code(7) xor PS2Code(8);
                  
    process(PS2Clk) is
    begin
        if (falling_edge(PS2Clk)) then
            PS2Code(bitCounter) <= PS2Data;
            if (bitCounter = 10) then --Full Code extracted, check for parity
                bitCounter <= 0;
                if (PS2Code(9) /= parityCalc) then --Parity check succeeded, figure out Code
                    if PS2Code (8 downto 1) = x"F0" then --Breaking key
                        isBreak <= true;
                    elsif isBreak then
                        case PS2Code(8 downto 1) is
                            when x"1D"  => wHeld    <= false;
                            when x"75"  => upHeld   <= false;
                            when x"72"  => downHeld <= false;
                            when x"1B"  => sHeld    <= false;
                            when x"2D"  => rHeld    <= false;
                            when others => null;
                        end case;
                        isBreak <= false;
                    else --Making key
                        case PS2Code(8 downto 1) is
                            when x"1D"  => wHeld    <= true;
                            when x"75"  => upHeld   <= true;
                            when x"72"  => downHeld <= true;
                            when x"1B"  => sHeld    <= true;
                            when x"2D"  => rHeld    <= true;
                            when others => null;
                        end case;
                    end if;
                end if;
            else 
                bitCounter <= bitCounter + 1;
            end if;
        end if;
    end process;
    
    --the '1' bit is HOLD, the '0' bit is direction. Up is 1, down is 0.
    P1(1) <= '1' when (wHeld = sHeld) else '0';
    P1(0) <= '1' when wHeld else '0'; --remember, wHeld is a bool. if wHeld doesn't equal sHeld, then if wHeld is true, only the w key is pressed, so the paddle should move up
    P2(1) <= '1' when (upHeld = downHeld) else '0';
    P2(0) <= '1' when upHeld else '0';
    RESET <= '1' when rHeld else '0';
end Behavioral;