library ieee;
use ieee.std_logic_1164.all;

entity tp2_lfsr is
    port(
        clk  : in std_logic;
        rst  : in std_logic;
        en   : in std_logic;
        seed : in std_logic_vector(7 downto 0);
        out_key  : out std_logic
    );
end tp2_lfsr;


architecture Behavioral of tp2_lfsr is
    signal lfsr_state: std_logic_vector(7 downto 0);
    signal first_bit: std_logic := '0';

    begin
        process(clk, rst, en)
            begin
                if rst = '1' then
                    lfsr_state <= seed;
                    first_bit <= '0';
                elsif rising_edge(clk) then
                    if en = '1' then -- if enable is 1, shift all to the right
                        first_bit <= lfsr_state(7) xor lfsr_state(5) xor lfsr_state(4) xor lfsr_state(3);
                        lfsr_state <= lfsr_state(6 downto 0) & first_bit; --shift left and insert fb at LSB
                    end if;
                end if;
        end process;

        out_key <= lfsr_state(7);
            
end Behavioral;