library ieee;
use ieee.std_logic_1164.all;

entity tp2_lfsr is
    port(
        seed : in std_logic_vector(7 downto 0);
        en   : in std_logic;
        clk  : in std_logic;
        rst  : in std_logic;
        key  : out std_logic
    );
end entity tp2_lfsr;


architecture tp2_lfsr of tp2_lfsr is
    signal lfsr: std_logic_vector(7 downto 0);
    signal first_bit: std_logic;

    begin
        process(clk, rst)
            begin
                if rst = '1' then
                    lfsr <= seed;
                    first_bit <= '0';
                elsif rising_edge(clk) then
                    if en = '1' then -- if enable is 1, shift all to the right
                        first_bit <= lfsr(0) xor lfsr(4) xor lfsr(7);
                        lfsr <= lfsr(6 downto 0) & first_bit;
                    end if;
                end if;
        end process;

        key <= lfsr(0);
            
end architecture tp2_lfsr;