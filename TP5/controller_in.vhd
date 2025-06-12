library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity controller_in is
    Port (
        clk    : in  std_logic;
        reset  : in  std_logic;
        en     : in  std_logic;
        rx     : in  std_logic;
        tx     : out std_logic
    );
end controller_in;
 
architecture Behavioral of controller_in is
 
    constant ROM_SIZE        : integer := 1000;
    constant ROM_ADDR_SIZE   : integer := 10;
    constant ROM_DATA_SIZE   : integer := 16;
    constant UART_DATA_SIZE  : integer := 16;
 
    type state_type is (
        READING,
        ENCRYPTING,
        COMPLETE_ENCRYPTING,
        UART_WAIT,
        DONE
    );
    signal state : state_type := READING;
 
    -- ROM
    signal rom_addr : unsigned(ROM_ADDR_SIZE - 1 downto 0) := (others => '0');
    signal rom_data : signed(ROM_DATA_SIZE - 1 downto 0)   := (others => '0');
 
    -- EncriptaÃ§Ã£o bitâ€aâ€bit
    signal bit_index     : integer range 0 to UART_DATA_SIZE - 1 := 15;
    signal encrypt_count : integer range 0 to UART_DATA_SIZE     := 0;
    signal cypher_in     : std_logic := '0';
    signal cypher_out    : std_logic := '0';
    signal cypher_en     : std_logic := '0';
 
    -- UART
    signal uart_in    : std_logic_vector(UART_DATA_SIZE - 1 downto 0) := (others => '0');
    signal tx_start   : std_logic := '0';
    signal uart_out   : std_logic_vector(UART_DATA_SIZE - 1 downto 0) := (others => '0');
    signal uart_valid : std_logic;
 
    component controller_in_rom is
        Port (
            addr     : in  unsigned(ROM_ADDR_SIZE - 1 downto 0);
            data_out : out signed(ROM_DATA_SIZE - 1 downto 0)
        );
    end component;
 
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
            clk             : in  std_logic;
            reset           : in  std_logic;
            data_in         : in  std_logic_vector(UART_DATA_SIZE - 1 downto 0);
            transmit_start  : in  std_logic;
            transmit_out    : out std_logic;
            receive_in      : in  std_logic;
            data_out        : out std_logic_vector(UART_DATA_SIZE - 1 downto 0);
            receive_valid   : out std_logic
        );
    end component;
 
begin
 
    rom_inst: controller_in_rom
        port map (
            addr     => rom_addr,
            data_out => rom_data
        );
 
    encryption_inst: controller_in_encryption
        port map (
            bit_in => cypher_in,
            rst    => reset,
            clk    => clk,
            en     => cypher_en,
            cypher => cypher_out
        );
 
    uart_inst: uart
        port map (
            clk            => clk,
            reset          => reset,
            data_in        => uart_in,
            transmit_start => tx_start,
            transmit_out   => tx,
            receive_in     => rx,
            data_out       => uart_out,
            receive_valid  => uart_valid
        );
 
    controller_process: process(clk, reset)
    begin
        if reset = '1' then
            rom_addr      <= (others => '0');
            bit_index     <= 15;
            encrypt_count <= 0;
            cypher_en     <= '0';
            tx_start      <= '0';
            state         <= READING;
        elsif rising_edge(clk) then
            case state is
 
                when READING =>
                    if en = '1' then
                        bit_index     <= 15;
                        encrypt_count <= 0;
                        cypher_en     <= '1';
                        cypher_in     <= std_logic(rom_data(15));
                        state         <= ENCRYPTING;
                    else
                        cypher_en <= '0';
                        tx_start  <= '0';
                    end if;
 
                when ENCRYPTING =>
                    if encrypt_count > 0 then
                        uart_in(bit_index + 1) <= cypher_out;
                    end if;
 
                    if bit_index > 0 then
                        cypher_in <= std_logic(rom_data(bit_index - 1));
                        bit_index <= bit_index - 1;
                    else
                        cypher_in <= std_logic(rom_data(0));
                        bit_index <= 0;
                    end if;
 
                    encrypt_count <= encrypt_count + 1;
 
                    if encrypt_count = UART_DATA_SIZE - 1 then
                        state <= COMPLETE_ENCRYPTING;
                    end if;
 
                when COMPLETE_ENCRYPTING =>
                    uart_in(0)  <= cypher_out;
                    cypher_en   <= '0';
                    tx_start    <= '1';
                    state       <= UART_WAIT;
 
                when UART_WAIT =>
                    if rom_addr = to_unsigned(ROM_SIZE - 1, ROM_ADDR_SIZE) then
                        rom_addr <= (others => '0');
                    else
                        rom_addr <= rom_addr + 1;
                    end if;
                    state <= DONE;
                when DONE =>
                    tx_start <= '0';
                    state <= READING;
                when others =>
                    state <= READING;
            end case;
        end if;
    end process;
 
end Behavioral;