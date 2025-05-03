library ieee;
use ieee.std_logic_1164.all;

entity tp1 is
    port(
        rst : in std_logic;
        clk : in std_logic;
        x   : in std_logic;
        y   : out std_logic
    );
end entity tp1;

architecture tp1 of tp1 is
    type state_type is (s0, s1, s2, s3, s4, s5, s6);
    signal state, next_state : state_type; 
    signal y_reg : std_logic;
begin

    process(clk, rst)
    begin
        if rst = '1' then
            state <= s0;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    process(state, x)
    begin
        case state is
            when s0 => if x = '1' then next_state <= s1; else next_state <= s0; end if;
            when s1 => if x = '0' then next_state <= s2; else next_state <= s1; end if;
            when s2 => if x = '1' then next_state <= s1; else next_state <= s3; end if;
            when s3 => if x = '0' then next_state <= s0; else next_state <= s4; end if;
            when s4 => if x = '1' then next_state <= s1; else next_state <= s5; end if;
            when s5 => if x = '0' then next_state <= s3; else next_state <= s6; end if;
            when s6 => if x = '1' then next_state <= s1; else next_state <= s2; end if;
        end case;
    end process;

    y_reg <= '1' when state = s6 else '0';
    y <= y_reg;

end architecture tp1;
