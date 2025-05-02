library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_MUX4_1_Behavioral is
end TB_MUX4_1_Behavioral;

architecture testbench of TB_MUX4_1_Behavioral is
    signal sel : STD_LOGIC_VECTOR(1 downto 0);
    signal a, b, c, d, y : STD_LOGIC;
    
    component MUX4_1_Behavioral
        Port ( sel : in STD_LOGIC_VECTOR(1 downto 0);
               a, b, c, d : in STD_LOGIC;
               y : out STD_LOGIC);
    end component;
begin
    UUT: MUX4_1_Behavioral port map (sel => sel, a => a, b => b, c => c, d => d, y => y);

    process
    begin
        a <= '0'; b <= '1'; c <= '0'; d <= '1'; sel <= "00"; wait for 10 ns;
        sel <= "01"; wait for 10 ns;
        sel <= "10"; wait for 10 ns;
        sel <= "11"; wait for 10 ns;
        sel <= "XX"; wait for 10 ns;
        wait;
    end process;
end testbench;

