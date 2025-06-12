library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
 
entity uart_tb is
end;
 
architecture bench of uart_tb is
 
  component uart
    Port (
      clk             : in  std_logic;
      reset           : in  std_logic;
      data_in         : in  std_logic_vector(7 downto 0);
      transmit_start  : in  std_logic;
      transmit_out    : out std_logic;
      receive_in      : in  std_logic;
      data_out        : out std_logic_vector(7 downto 0);
      receive_valid   : out std_logic
    );
  end component;
 
  signal clk: std_logic;
  signal reset: std_logic;
  signal data_in: std_logic_vector(7 downto 0);
  signal transmit_start: std_logic;
  signal transmit: std_logic;
  signal transmit2: std_logic;
  signal data_out: std_logic_vector(7 downto 0);
  signal receive_valid: std_logic ;
 
  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;
 
begin
 
  uut: uart port map ( clk            => clk,
                       reset          => reset,
                       data_in        => data_in,
                       transmit_start => transmit_start,
                       transmit_out   => transmit,
                       receive_in     => transmit,
                       data_out       => data_out,
                       receive_valid  => receive_valid );
 
  stimulus: process
  begin
 
    -- Put initialisation code here
 
    reset <= '1';
    wait for clock_period;
    reset <= '0';
    wait for clock_period;
 
    -- Put test bench stimulus code here
    data_in <= "10101010";  -- Example data to transmit
    wait for clock_period;
   
    transmit_start <= '1';
    wait for clock_period*11;    
   
    data_in <= "01010101";  -- Example data to transmit
    wait for clock_period*11;
	
	transmit_start <= '0';
	wait for clock_period;
	
	transmit <= '0';  -- start bit
	wait for clock_period;
	transmit <= '1';  -- dados
	wait for clock_period;
	transmit <= '0';
	wait for clock_period;
	transmit <= '1';
	wait for clock_period;
	transmit <= '0';
	wait for clock_period;
	transmit <= '1';
	wait for clock_period;
	transmit <= '0';
	wait for clock_period;
	transmit <= '1';
	wait for clock_period;
	transmit <= '0';  -- fim dados
	wait for clock_period;
	transmit <= '1';  -- parity
	wait for clock_period;
	transmit <= '1';  -- stop bit
	wait for clock_period;
	
	wait for clock_period * 10;
	
 
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