library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity tb_cipher is
end entity;

architecture bench of tb_cipher is

    -- Componente a testar (por exemplo, o decryption)
    component tp2_decrypt is
        port (
            seed   : in  std_logic_vector(7 downto 0);
            msg    : in  std_logic;
            rst    : in  std_logic;
            clk    : in  std_logic;
            en     : in  std_logic;
            cypher : out std_logic
        );
    end component;

    -- Sinais para interligar
    signal clk        : std_logic := '0';
    signal rst        : std_logic := '1';
    signal en         : std_logic := '0';
    signal seed       : std_logic_vector(7 downto 0) := "10110011";
    signal plaintext  : std_logic := '0';
    signal cypher_out : std_logic;
    signal stop_clock : boolean := false;

    constant clk_period : time := 10 ns;

begin

    -- Instância do módulo a testar
    uut: tp2_decrypt
        port map (
            seed   => seed,
            msg    => plaintext,
            rst    => rst,
            clk    => clk,
            en     => en,
            cypher => cypher_out
        );

    -- Geração de clock
    clock_process : process
    begin
        while not stop_clock loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Estímulos
    stimulus_process : process
    begin
        -- Reset inicial
        rst <= '1';
        en <= '0';
        plaintext <= '0';
        wait for clk_period;
        rst <= '0';
        wait for clk_period;

        -- Ativa o enable e começa a enviar bits
        en <= '1';

        plaintext <= '1';
        wait for clk_period;
        plaintext <= '0';
        wait for clk_period;
        plaintext <= '1';
        wait for clk_period;
        plaintext <= '0';
        wait for clk_period;
        plaintext <= '1';
        wait for clk_period;
        plaintext <= '0';
        wait for clk_period;
        plaintext <= '1';
        wait for clk_period;
        plaintext <= '0';
        wait for clk_period;

        -- Finaliza simulação
        stop_clock <= true;
        wait;
    end process;

end architecture;
