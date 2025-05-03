library ieee;
use ieee.std_logic_1164.all;

entity tp2_decrypt is
    port(
        key: in std_logic_vector (7 downto 0); -- pass the seed to the LFSR
        msg: in std_logic;
        rst: in std_logic;
        clk: in std_logic;
        en: in std_logic;
        cypher: out std_logic;
    );

end entity tp2_decrypt;

architecture Behavioral of tp2_decrypt is

    component tp2_lfsr is

        port(
            seed: in std_std_logic_vector (7 downto 0);
            en: in std_logic;
            clk: in std_logic;
            rst: in std_logic;
            key: out std_logic
        );

    end component tp2_lfsr;

    signal key_bit : std_logic;

    begin
        lfsr_inst: tp2_lfsr
            port map(
                seed => seed,
                en => en,
                clk => clk,
                rst => rst,
                key => key_bit
            );
        
        -- Processo de desencriptação (XOR com a key stream)
        process(clk, rst)
        begin
            if rst = '1' then
                cypher <= '0';
            elsif rising_edge(clk) then
                if en = '1' then
                    cypher <= msg xor key_bit;
                else
                    cypher <= msg;
                end if;
            end if;
        end process;

    end architecture Behavioral;