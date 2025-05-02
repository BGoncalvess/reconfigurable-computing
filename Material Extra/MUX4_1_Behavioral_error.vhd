library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX4_1_Behavioral is
    Port ( sel : in STD_LOGIC_VECTOR(1 downto 0);
           a, b, c, d : in STD_LOGIC;
           y : out STD_LOGIC);
end MUX4_1_Behavioral;

architecture Behavioral of MUX4_1_Behavioral is
begin
    process(sel, a, b, c, d)
    begin
        case sel is
            when "00" => y <= a;
            when "01" => y <= b;
            when "10" => y <= c;
            -- ERROR: Missing "others" case for "11", leading to inferred latches.
        end case;
    end process;
end Behavioral;
