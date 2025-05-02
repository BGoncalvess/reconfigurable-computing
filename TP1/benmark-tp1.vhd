library ieee;
use ieee.std_logic_1164.all;

entity tb_tp1 is
end entity;

architecture sim of tb_tp1 is

    -- Component declaration
    component tp1
        port (
            rst : in std_logic;
            clk : in std_logic;
            x   : in std_logic;
            y   : out std_logic
        );
    end component;

    -- Signals to connect to DUT
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal x   : std_logic := '0';
    signal y   : std_logic;

    -- Clock period
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the DUT
    uut: tp1
        port map (
            rst => rst,
            clk => clk,
            x   => x,
            y   => y
        );

    -- Clock process
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
    stim_proc: process
    begin
        -- Apply reset
        wait for 20 ns;
        rst <= '0';  -- Release reset

        -- Apply sequence "1 0 0 1 0 1"
        -- Wait for rising edge to apply each bit
        wait for clk_period;
        x <= '1';  -- 1

        wait for clk_period;
        x <= '0';  -- 0

        wait for clk_period;
        x <= '0';  -- 0

        wait for clk_period;
        x <= '1';  -- 1

        wait for clk_period;
        x <= '0';  -- 0

        wait for clk_period;
        x <= '1';  -- 1

        -- Wait a bit to see output
        wait for 50 ns;

        -- End simulation
        wait;
    end process;

end architecture;
