library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_filter_component is
end tb_filter_component;

architecture Behavioral of tb_filter_component is

    -- Sinais de teste
    signal clk       : std_logic := '0';
    signal rst       : std_logic := '1';
    signal en        : std_logic := '0';
    signal done_tb   : std_logic;
    signal out_addr_tb : unsigned(9 downto 0) := (others => '0');
    signal out_data_tb : signed(31 downto 0);

    constant clk_period : time := 10 ns;

    -- Instanciação do DUT (Device Under Test)
    component filter_component is
        Port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            en       : in  std_logic;
            done     : out std_logic;
            out_addr : in  unsigned(9 downto 0);
            out_data : out signed(31 downto 0)
        );
    end component;

begin

    uut: filter_component
        port map (
            clk      => clk,
            rst      => rst,
            en       => en,
            done     => done_tb,
            out_addr => out_addr_tb,
            out_data => out_data_tb
        );

    -- Clock (~50 MHz)
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    -- Processo de estímulo
    stim_proc: process
    begin
        -- 1) Inicia com reset
        rst <= '1';
        en  <= '0';
        wait for 50 ns;

        -- 2) Libera reset, ativa o filtro
        rst <= '0';
        en  <= '1';

        -- 3) Espera até que o filtro termine
        wait until done_tb = '1';
        wait for 20 ns;

        -- 4) Agora lê os resultados na RAM interna (ou em out_data_tb)
        for i in 0 to (1000 - 50) loop
            out_addr_tb <= to_unsigned(i, 10);
            wait for 20 ns;  
            report "Saída[" & integer'image(i) & "] = " & integer'image(to_integer(out_data_tb));
        end loop;

        -- 5) Acaba a simulação
        assert false report "Fim da simulação" severity failure;
    end process;

end Behavioral;
