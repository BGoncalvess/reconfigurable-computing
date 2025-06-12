library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use IEEE.Std_Logic_Textio.all;
library std;
use std.textio.all;

entity filter_component_tb is
end;

architecture bench of filter_component_tb is

  component filter_component
    Port (
      clk      : in  std_logic;
      reset    : in  std_logic;
      en       : in  std_logic;
      data_out : out signed(15 downto 0)
    );
  end component;

  signal clk      : std_logic := '0';
  signal reset    : std_logic := '0';
  signal en       : std_logic := '0';
  signal data_out : signed(15 downto 0);

  constant clock_period : time := 10 ns;
  signal stop_the_clock : boolean := false;

  -- Number of clocks from en='1' until data_out is valid again
  constant TAP_CYCLES : integer := 52;
  signal cycle_count : integer range 0 to TAP_CYCLES-1 := 0;

  -- File declaration
  file filtered_file : text open write_mode is "D:/reconfigurable-computing/TP3/data/filtered_signal.txt";

begin

  uut: filter_component
    port map (
      clk      => clk,
      reset    => reset,
      en       => en,
      data_out => data_out
    );

  -- Stimulus: apply reset, then keep en='1'
  stimulus: process
  begin
    reset <= '1';
    wait for 5 ns;
    reset <= '0';
    wait for 5 ns;

    en <= '1';

    wait for clock_period * 1000000;
    stop_the_clock <= true;
    wait;
  end process;

  -- Clock generator
  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0';
      wait for clock_period / 2;
      clk <= '1';
      wait for clock_period / 2;
    end loop;
    wait;
  end process;

  -- Only write data_out once every TAP_CYCLES clocks
  writer: process(clk)
    variable outfile_line : line;
  begin
    if rising_edge(clk) then
      if en = '1' then
        if cycle_count = TAP_CYCLES - 1 then
          write(outfile_line, std_logic_vector(data_out));
          writeline(filtered_file, outfile_line);
          cycle_count <= 0;
        else
          cycle_count <= cycle_count + 1;
        end if;
      end if;
    end if;
  end process;

end architecture bench;
