library ieee;
use ieee.std_logic_1164.all;

entity tp2_decrypt is
    port(
        bit_in : in std_logic;                  -- Input bit to decrypt 
        rst    : in std_logic;
        clk    : in std_logic;
        en     : in std_logic;
        bit_out  : out std_logic                   -- Output decrypted bit
    );
end tp2_decrypt;

architecture Behavioral of tp2_decrypt is
    signal key_bit : std_logic;

    component tp2_lfsr
        port(
            rst  : in std_logic;
            en   : in std_logic;
            clk  : in std_logic;
            seed : in std_logic_vector(7 downto 0);
            out_key  : out std_logic
        );
    end component;

    const seed : std_logic_vector(7 downto 0) := "10101010";

begin

    lfsr_instance: tp2_lfsr
        port map(
            rst  => rst,
            en   => en,
            clk  => clk,
            seed => seed,
            out_key  => key_bit
        );

    process(clk, rst, en, key_bit)
    begin
        if rst = '1' then
            cypher <= '0';
        elsif rising_edge(clk) then
            if en = '1' then
                cypher <= msg xor key_bit;
            end if;
        end if;
    end process;

end architecture;
