-- File: vga_controller.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_controller is
    Port (
        clk : in STD_LOGIC; --25MHz
        hsync : out STD_LOGIC;
        vsync : out STD_LOGIC;
        video_on : out STD_LOGIC;
        frame : out STD_LOGIC;
        pixel_x : out STD_LOGIC_VECTOR (9 downto 0);
        pixel_y : out STD_LOGIC_VECTOR (9 downto 0)
        );
end vga_controller;

architecture Behavioral of vga_controller is
--Students can go to "http://www.tinyvga.com/vga-timing/640x480@60Hz" to see timing signals, or they can be provided.
    constant H_Visible : integer := 640;
    constant H_FPorch  : integer := 16;
    constant H_Sync    : integer := 96;
    constant H_BPorch  : integer := 48;
    constant H_Total   : integer := 800;

    constant V_Visible : integer := 480;
    constant V_FPorch  : integer := 10;
    constant V_Sync    : integer := 2;
    constant V_BPorch  : integer := 33;
    constant V_Total   : integer := 525;
    
    signal H_Count : unsigned (9 downto 0) := (others => '0');
    signal V_Count : unsigned (9 downto 0) := (others => '0');

begin
    process(clk) is
    begin
        if rising_edge(clk) then
            if H_Count = H_Total - 1 then --'-1' since we are incrementing from '0'
                H_Count <= (others => '0') ;
                if V_Count = V_Total - 1 then
                    V_Count <= (others => '0');
                else
                    V_Count <= V_Count +1;
                end if;
            else
                H_Count <= H_Count + 1;
            end if;
        end if;        
    end process;
    
    --Active Low, treated as if visible was at '0' even though technically the back porch should be first. can be changed.
    --The reason we treat visible as '0' is mainly because that segregates the vectors into two clean sections, on and off,
    --Which allows for much nicer video_on logic, without compromising other logic.
    hsync <= '0' when ((H_Count >= H_Visible + H_FPorch) and (H_Count < H_Visible + H_FPorch + H_Sync)) else '1';
    vsync <= '0' when ((V_Count >= V_Visible + V_FPorch) and (V_Count < V_Visible + V_FPorch + V_Sync)) else '1';
    
    video_on <= '1' when (H_Count < H_Visible and V_Count < V_Visible) else '0';
    frame    <= '1' when (H_Count = H_Visible and V_Count = V_Visible) else '0';
    
    pixel_x <= std_logic_vector(H_Count);
    pixel_y <= std_logic_vector(V_Count);
        
end Behavioral;