library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use std.textio.ALL;

entity TB_MUX2_1_Dataflow is
end TB_MUX2_1_Dataflow;

architecture testbench of TB_MUX2_1_Dataflow is
    signal sel, a, b, y : STD_LOGIC;
    
    component MUX2_1_Dataflow
        Port ( sel : in STD_LOGIC;
               a, b : in STD_LOGIC;
               y : out STD_LOGIC);
    end component;
begin
    UUT: MUX2_1_Dataflow port map (sel => sel, a => a, b => b, y => y);

    process
    begin
        a <= '0'; b <= '1'; sel <= '0'; wait for 10 ns;
        sel <= '1'; wait for 10 ns;
        sel <= 'Z'; wait for 10 ns;
        sel <= 'U'; wait for 10 ns;
        wait;
    end process;
end testbench;

