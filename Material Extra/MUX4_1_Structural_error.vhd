library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX4_1_Structural is
    Port ( sel : in STD_LOGIC_VECTOR(1 downto 0);
           a, b, c, d : in STD_LOGIC;
           y : out STD_LOGIC);
end MUX4_1_Structural;

architecture Structural of MUX4_1_Structural is
    component MUX2_1
        Port ( sel : in STD_LOGIC;
               a, b : in STD_LOGIC;
               y : out STD_LOGIC);
    end component;

    signal m0_y, m1_y : STD_LOGIC;
begin
    -- First layer of multiplexers
    M0: MUX2_1 port map (sel => sel(0), a => a, b => b, y => m0_y);
    M1: MUX2_1 port map (sel => sel(0), a => c, b => d, y => m1_y);
    
    -- Second layer multiplexer
    M2: MUX2_1 port map (sel => sel(1), a => m0_y, b => m1_y, y => m1_y); -- ERROR: Should be "y => y"
end Structural;
