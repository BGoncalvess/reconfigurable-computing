library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controller_out is
  Port (
    clk      : in  std_logic;
    reset    : in  std_logic;
    en       : in  std_logic;
    rx       : in  std_logic;
    tx       : out  std_logic;
    data_out : out signed(15 downto 0)
  );
end controller_out;

architecture Behavioral of controller_out is

  constant DATA_SIZE : integer := 16;

  type state_type is (S_IDLE, S_DECRYPT, S_VALIDATE_SAMPLE);
  signal state : state_type := S_IDLE;

  -- Sinais da UART
  signal uart_data_out      : std_logic_vector(DATA_SIZE - 1 downto 0);
  signal uart_valid         : std_logic;
  signal encrypted_data_reg : std_logic_vector(DATA_SIZE - 1 downto 0) := (others => '0');

  -- Sinais da Desencriptação
  signal bit_index : integer range 0 to DATA_SIZE;
  signal cypher_in : std_logic;
  signal cypher_out: std_logic;
  signal cypher_en : std_logic := '0';

  -- **NOVO: Registador para construir o dado desencriptado completo**
  signal decrypted_sample_reg : signed(DATA_SIZE - 1 downto 0);

  -- Sinais de Controlo para o Filtro
  signal filter_sample_valid : std_logic := '0';
  signal filter_data_in      : signed(DATA_SIZE - 1 downto 0);
  signal filter_data_out     : signed(DATA_SIZE - 1 downto 0);

  -- Componentes
  component controller_in_encryption is
    Port (
      bit_in : in  std_logic;
      rst    : in  std_logic;
      clk    : in  std_logic;
      en     : in  std_logic;
      cypher : out std_logic
    );
  end component;

  component uart is
    Port (
      clk            : in  std_logic;
      reset          : in  std_logic;
      data_in        : in  std_logic_vector(DATA_SIZE - 1 downto 0);
      transmit_start : in  std_logic;
      transmit_out   : out std_logic;
      receive_in     : in  std_logic;
      data_out       : out std_logic_vector(DATA_SIZE - 1 downto 0);
      receive_valid  : out std_logic
    );
  end component;

  component fir_filter is
    generic (
      TAP_COUNT  : integer := 51;
      DATA_WIDTH : integer := 16
    );
    port (
      clk          : in  std_logic;
      reset        : in  std_logic;
      sample_valid : in  std_logic;
      data_in      : in  signed(DATA_WIDTH - 1 downto 0);
      data_out     : out signed(DATA_WIDTH - 1 downto 0)
    );
  end component;

begin

  uart_inst: uart
    port map(
      clk            => clk,
      reset          => reset,
      data_in        => (others => '0'),
      transmit_start => '0',
      transmit_out   => open,
      receive_in     => rx,
      data_out       => uart_data_out,
      receive_valid  => uart_valid
    );

  encryption_inst: controller_in_encryption
    port map(
      bit_in => cypher_in,
      rst    => reset,
      clk    => clk,
      en     => cypher_en,
      cypher => cypher_out
    );

  filter_inst: fir_filter
    generic map(
      TAP_COUNT  => 51,
      DATA_WIDTH => 16
    )
    port map(
      clk          => clk,
      reset        => reset,
      sample_valid => filter_sample_valid,
      data_in      => filter_data_in,
      data_out     => filter_data_out
    );

  data_out <= filter_data_out;

  controller_process: process(clk, reset)
  begin
    if reset = '1' then
      state                <= S_IDLE;
      bit_index            <= 0;
      cypher_en            <= '0';
      filter_sample_valid  <= '0';
      encrypted_data_reg   <= (others => '0');
      decrypted_sample_reg <= (others => '0');
      filter_data_in       <= (others => '0');

    elsif rising_edge(clk) then
      cypher_en           <= '0';
      filter_sample_valid <= '0';

      case state is
        when S_IDLE =>
          if uart_valid = '1' and en = '1' then
            encrypted_data_reg <= uart_data_out;
            bit_index          <= 0;
            state              <= S_DECRYPT;
          end if;

        -- 16 ciclos a desencriptar os bits um a um
        when S_DECRYPT =>
          cypher_en <= '1';
          cypher_in <= encrypted_data_reg(bit_index);
          -- Constrói o dado desencriptado bit a bit
          decrypted_sample_reg(bit_index) <= cypher_out;

          if bit_index = DATA_SIZE - 1 then
            -- Last bit has been decrypted. Validate the data.
            state <= S_VALIDATE_SAMPLE;
          else
            bit_index <= bit_index + 1;
          end if;

        -- Show the complete decrypted sample to the filter and 'sample_valid' to 1
        when S_VALIDATE_SAMPLE =>
          filter_data_in      <= decrypted_sample_reg;
          filter_sample_valid <= '1'; -- Ativa o filtro por UM ciclo
          state               <= S_IDLE; -- Volta imediatamente para o início

      end case;
    end if;
  end process;

end Behavioral;