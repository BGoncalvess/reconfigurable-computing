library ieee;
use ieee.std_logic_1164.all;

entity controller_in_encryption is
    port(
        bit_in : in std_logic;                  -- Input bit to decrypt 
        rst    : in std_logic;
        clk    : in std_logic;
        en     : in std_logic;
        cypher  : out std_logic                   -- Output decrypted bit
    );
end controller_in_encryption;

architecture Behavioral of controller_in_encryption is
    signal key_bit : std_logic;
    constant seed : std_logic_vector(7 downto 0) := "10000000";

    component tp2_lfsr
        port(
            rst  : in std_logic;
            en   : in std_logic;
            clk  : in std_logic;
            seed : in std_logic_vector(7 downto 0);
            out_key  : out std_logic
        );
    end component;

begin
	fsr_instance: tp2_lfsr
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
                cypher <= bit_in xor key_bit;
            end if;
        end if;
    end process;

end architecture;
