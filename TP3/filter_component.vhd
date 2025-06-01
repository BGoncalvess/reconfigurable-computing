library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity filter_component is
    Port (
        clk    : in std_logic;
        rst    : in std_logic;
        en  : in std_logic;
        done   : out std_logic;
        -- address to read filtered output (optional)
        out_addr : in unsigned(9 downto 0);
        out_data : out signed(31 downto 0)  -- filtered output width
    );
end filter_component;

architecture Behavioral of filter_component is

    -- Parameters
    constant FILTER_SIZE : integer := 50;
    constant SIGNAL_SIZE : integer := 1000;
    
    -- Address widths for ROMs (log2 size)
    constant ADDR_WIDTH_FILTER : integer := 6; -- enough for 51 coeffs
    constant ADDR_WIDTH_SIGNAL : integer := 10; -- enough for 1000 samples
    
    -- Data width
    constant DATA_WIDTH : integer := 16;

    -- FSM States
    type state_type is (INIT, CALC, DONE);
    signal state : state_type := INIT;

    -- Signals for ROM addresses
    signal filter_addr : unsigned(ADDR_WIDTH_FILTER-1 downto 0) := (others => '0');
    signal signal_addr : unsigned(ADDR_WIDTH_SIGNAL-1 downto 0) := (others => '0');

    -- Signals for ROM outputs
    signal filter_coeff : signed(DATA_WIDTH-1 downto 0);
    signal signal_sample : signed(DATA_WIDTH-1 downto 0);

    -- Storage for coeffs and samples in arrays
    type sample_array is array(0 to FILTER_SIZE) of signed(DATA_WIDTH-1 downto 0);
    signal coeff_array : sample_array := (others => (others => '0'));
    signal sample_array : sample_array := (others => (others => '0'));

    -- For convolution calculation
    signal acc : signed((DATA_WIDTH*2)-1 downto 0) := (others => '0');
    signal index : integer range 0 to SIGNAL_SIZE-FILTER_SIZE := 0;

    -- RAM to store output filtered values
    type ram_type is array(0 to SIGNAL_SIZE-FILTER_SIZE) of signed((DATA_WIDTH*2)-1 downto 0);
    signal output_ram : ram_type := (others => (others => '0'));

begin
    -- Instanciação dos módulos ROM (coeficientes + sinal)

    component filter_rom is
        Port (
            addr     : in unsigned(ADDR_WIDTH_FILTER-1 downto 0);
            data_out : out signed(DATA_WIDTH-1 downto 0)
        );
    end component;

    component signal_rom is
        Port (
            addr     : in unsigned(ADDR_WIDTH_SIGNAL-1 downto 0);
            data_out : out signed(DATA_WIDTH-1 downto 0)
        );
    end component;

    u_filter_rom: filter_rom
        port map (
            addr => filter_addr,
            data_out => filter_coeff
        );

    u_signal_rom: signal_rom
        port map (
            addr => signal_addr,
            data_out => signal_sample
        );

    -- FSM do filtro (INIT, CALC, DONE), usando “en” para habilitar as etapas

    process(clk, rst)
        variable conv_acc : signed((DATA_WIDTH*2)-1 downto 0);
    begin
        if rst = '1' then
            state <= INIT;
            filter_addr <= (others => '0');
            signal_addr <= (others => '0');
            index <= 0;
            acc <= (others => '0');
            done <= '0';
        elsif rising_edge(clk) then
            if en = '1' then
                case state is
                    when INIT =>
                        -- Load filter coefficients and initial samples
                        coeff_array(to_integer(filter_addr)) <= filter_coeff;
                        sample_array(to_integer(filter_addr)) <= signal_sample;

                        if filter_addr = FILTER_SIZE then
                            state <= CALC;
                            filter_addr <= (others => '0');
                            -- Avança o endereço do sinal para a primeira amostra “além” do bloco de inicialização
                            signal_addr <= to_unsigned(FILTER_SIZE+1, ADDR_WIDTH_SIGNAL);
                        else
                            filter_addr <= filter_addr + 1;
                            signal_addr <= signal_addr + 1;
                        end if;

                    when CALC =>
                        -- Perform convolution
                        conv_acc := (others => '0');
                        for i in 0 to FILTER_SIZE loop
                            conv_acc := conv_acc + (coeff_array(i) * sample_array(i));
                        end loop;
                        acc <= conv_acc;

                        -- Store result in RAM
                        output_ram(index) <= conv_acc;

                        -- Prepare for next sample: shift samples and read next
                        if index = SIGNAL_SIZE - FILTER_SIZE then
                            state <= DONE;
                            done <= '1';
                        else
                            index <= index + 1;
                            -- Shift samples left and read new one from ROM
                            sample_array <= sample_array(1 to FILTER_SIZE) & signal_sample;
                            signal_addr <= signal_addr + 1;
                        end if;

                    when DONE =>
                        -- Filter finished, do nothing or wait for reset
                        null;
                end case;
            end if; -- fim do “if en = '1'”
        end if;  -- fim do rising_edge(clk)
    end process;
    out_data <= output_ram(to_integer(out_addr));

end Behavioral;
