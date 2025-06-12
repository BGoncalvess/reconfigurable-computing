library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.Std_Logic_Textio.all;
library std;
use std.textio.all;

entity final_project_tb is
end final_project_tb;

architecture bench of final_project_tb is

  component controller_in is
    Port (
      clk   : in  std_logic;
      reset : in  std_logic;
      en    : in  std_logic;
      rx    : in  std_logic;
      tx    : out std_logic
    );
  end component;

  component controller_out is
    Port (
      clk      : in  std_logic;
      reset    : in  std_logic;
      en       : in  std_logic;
      rx       : in  std_logic;
      data_out : out signed(15 downto 0)
    );
  end component;

  signal clk    : std_logic := '0';
  signal reset  : std_logic;
  signal en_in  : std_logic;
  signal en_out : std_logic;

  signal tx_link_rx : std_logic;

  -- Final data output from the receiver
  signal final_data_out : signed(15 downto 0);

  constant clock_period : time    := 10 ns;
  signal stop_the_clock : boolean := false;

  file output_file : text open write_mode is "D:/reconfigurable-computing/TP5/filtered_signal_output.txt";

-- Signal to store the previous output value and detect changes
  signal prev_data_out : signed(15 downto 0) := (others => '0');

begin

  Transmitter_UUT: controller_in
    port map(
      clk   => clk,
      reset => reset,
      en    => en_in,
      rx    => '1',
      tx    => tx_link_rx
    );

  Receiver_UUT: controller_out
    port map(
      clk      => clk,
      reset    => reset,
      en       => en_out,
      rx       => tx_link_rx,
      data_out => final_data_out
    );

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= not clk;
      wait for clock_period / 2;
    end loop;
    wait;
  end process;

  stimulus: process
  begin

    reset  <= '1';
    en_in  <= '0';
    en_out <= '0';
    wait for clock_period * 5;

    reset <= '0';
    wait for clock_period;

    en_in  <= '1';
    en_out <= '1';

    wait for clock_period * 20000;

    stop_the_clock <= true;
    wait;
  end process;


  file_writer_process: process(clk)
    variable file_line : line;
  begin
    if rising_edge(clk) then
        if reset = '0' then
            if final_data_out /= prev_data_out then
                write(file_line, std_logic_vector(final_data_out));
                writeline(output_file, file_line);
        end if;
      end if;

      -- Update the lasta value to compore to the next cicle
      prev_data_out <= final_data_out;
    end if;
  end process;

end bench;