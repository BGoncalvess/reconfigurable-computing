library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity tb_tp1 is
end tb_tp1;

architecture testbench of tb_tp1 is
    signal rst, clk, x, y : std_logic := '0';
    
    constant clk_period : time := 10 ns;
    
    -- Instantiate the Unit Under Test (UUT)
    component tp1
        port(
            rst : in std_logic;
            clk : in std_logic;
            x : in std_logic;
            y : out std_logic
        );
    end component;
    
    begin
        uut: tp1 port map(
            rst => rst,
            clk => clk,
            x => x,
            y => y
        );
    
        -- Clock process
d    clk_process : process
        begin
            while now < 100 ns loop
                clk <= '0';
                wait for clk_period/2;
                clk <= '1';
                wait for clk_period/2;
            end loop;
            wait;
        end process;
    
        -- Stimulus process
        stim_process: process
        begin
            -- Reset FSM
            rst <= '1';
            wait for clk_period;
            rst <= '0';
            
            -- Apply input sequence "100101"
            x <= '1'; wait for clk_period;
            x <= '0'; wait for clk_period;
            x <= '0'; wait for clk_period;
            x <= '1'; wait for clk_period;
            x <= '0'; wait for clk_period;
            x <= '1'; wait for clk_period;
            
            -- Stop simulation
            wait;
        end process;
    
end testbench;