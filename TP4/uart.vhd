library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity uart is
  Port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    data_in        : in  std_logic_vector(7 downto 0);
    transmit_start : in  std_logic;
    transmit_out   : out std_logic;
    receive_in     : in  std_logic;
    data_out       : out std_logic_vector(7 downto 0);
    receive_valid  : out std_logic
  );
end uart;

architecture Behavioral of uart is
  type state_type is (IDLE, START, DATA, PARITY, STOP);
  signal next_state_tx : state_type;
  signal next_state_rx : state_type;
  signal shift_reg_tx  : std_logic_vector(7 downto 0);
  signal shift_reg_rx  : std_logic_vector(7 downto 0);
  signal bit_count_tx  : integer range 0 to 7;
  signal bit_count_rx  : integer range 0 to 7;
  signal parity_bit_tx : std_logic;

begin

  uart_transmitter_inst: process(clk, reset)
  begin
    if reset = '1' then
      next_state_tx <= IDLE;
      transmit_out  <= '1';
      bit_count_tx  <= 0;
    elsif rising_edge(clk) then
      case next_state_tx is
        when IDLE =>
          if transmit_start = '1' then
            shift_reg_tx  <= data_in;
            bit_count_tx  <= 0;
            parity_bit_tx <= '0';
            next_state_tx <= START;
          else
            next_state_tx <= IDLE;
          end if;
        when START =>
          transmit_out  <= '0';
          next_state_tx <= DATA;
        when DATA =>
          -- Envia LSB primeiro (bit 0, depois 1, etc...
          transmit_out  <= shift_reg_tx(bit_count_tx);
          parity_bit_tx <= parity_bit_tx xor shift_reg_tx(bit_count_tx);
          if bit_count_tx = 7 then
            next_state_tx <= PARITY;
          else
            bit_count_tx  <= bit_count_tx + 1;
            next_state_tx <= DATA;
          end if;
        when PARITY =>
          transmit_out  <= parity_bit_tx;
          next_state_tx <= STOP;
        when STOP =>
          transmit_out  <= '1';
          next_state_tx <= IDLE;
        when others =>
          next_state_tx <= IDLE;
      end case;
    end if;
  end process;

  uart_receiver_inst: process(clk, reset)
  begin
    if reset = '1' then
      next_state_rx <= IDLE;
      receive_valid <= '0';
      data_out      <= (others => '0');
    elsif rising_edge(clk) then
      -- Garante que o 'valid' é um clk de 1 ciclo
      receive_valid <= '0';

      case next_state_rx is
        when IDLE =>
          if receive_in = '0' then
            bit_count_rx  <= 0;
            next_state_rx <= DATA;
          end if;
        when DATA =>
          shift_reg_rx(bit_count_rx) <= receive_in;
          if bit_count_rx = 7 then
            next_state_rx <= PARITY;
          else
            bit_count_rx  <= bit_count_rx + 1;
            next_state_rx <= DATA;
          end if;
        when PARITY =>
          -- Apenas espera um ciclo pelo bit de paridade
          next_state_rx <= STOP;
        when STOP =>
          -- Sinaliza que a receção está completa e válida
          receive_valid <= '1';
          data_out      <= shift_reg_rx;
          next_state_rx <= IDLE;
        when others =>
          next_state_rx <= IDLE;
      end case;
    end if;
  end process;

end Behavioral;