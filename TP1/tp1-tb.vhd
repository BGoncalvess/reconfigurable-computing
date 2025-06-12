library ieee;
use ieee.std_logic_1164.all;

entity tb_tp1 is
end entity;

architecture test of tb_tp1 is
    signal clk  : std_logic := '0';
    signal rst  : std_logic := '0';
    signal x    : std_logic := '0';
    signal y    : std_logic;

    constant clk_period : time := 10 ns;

    component tp1
        port(
            rst : in std_logic;
            clk : in std_logic;
            x   : in std_logic;
            y   : out std_logic
        );
    end component;

begin
    uut: tp1
        port map(
            rst => rst,
            clk => clk,
            x   => x,
            y   => y
        );

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        rst <= '1';
        wait for clk_period;
        rst <= '0';
        wait for clk_period;

        -- match: "100101"
        x <= '1';
        wait for clk_period;
        x <= '0';
        wait for clk_period;
        x <= '0';
        wait for clk_period;
        x <= '1';
        wait for clk_period;
        x <= '0';
        wait for clk_period;
        x <= '1';
        -- match: "10010100101"
        wait for clk_period;
        x <= '0';
        wait for clk_period;
        x <= '0';
        wait for clk_period;
        x <= '1';
        wait for clk_period;
        x <= '0';
        wait for clk_period;
        x <= '1';
        

	wait for clk_period;

        assert false report "End of simulation" severity failure;
    end process;
end architecture test;
