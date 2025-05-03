-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity tp1_tb is
end;

architecture bench of tp1_tb is

  component tp1
      port(
          rst : in std_logic;
          clk : in std_logic;
          x   : in std_logic;
          y   : out std_logic
      );
  end component;

  signal rst: std_logic;
  signal clk: std_logic;
  signal x: std_logic;
  signal y: std_logic ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: tp1 port map ( rst => rst,
                      clk => clk,
                      x   => x,
                      y   => y );

  stimulus: process
  begin

    -- Put initialisation code here

    rst <= '1';
    wait for 5 ns;
    rst <= '0';
    wait for 5 ns;

    -- Put test bench stimulus code here

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;