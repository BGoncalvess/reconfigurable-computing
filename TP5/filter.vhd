library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity fir_filter is
    generic (
        TAP_COUNT  : integer := 51;     -- Number of taps
        DATA_WIDTH : integer := 16     -- Width of input/output
    );
    port (
        clk          : in  std_logic;
        reset        : in  std_logic; 
        sample_valid : in  std_logic; 
        data_in      : in  signed(DATA_WIDTH-1 downto 0);
        data_out     : out signed(DATA_WIDTH-1 downto 0)
    );
end fir_filter;
 
architecture Behavioral of fir_filter is

    constant ACC_WIDTH : integer := DATA_WIDTH * 2;
 
    -- Coefficient ROM interface (6-bit address)
    component filter_rom is
        port (
            addr     : in  unsigned(5 downto 0);
            data_out : out signed(DATA_WIDTH-1 downto 0)
        );
    end component;
 
    -- History of last TAP_COUNT samples
    type sample_array is array(0 to TAP_COUNT-1) of signed(DATA_WIDTH-1 downto 0);
    signal sample_history : sample_array := (others => (others => '0'));
 
    -- Buffer all TAP_COUNT coefficients after reset
    signal coeff_buffer   : sample_array := (others => (others => '0'));
 
    -- Counter of how many samples we've ingested
    signal sample_count   : integer range 0 to TAP_COUNT := 0;
 
    -- Accumulator for convolution
    signal sum_acc        : signed(ACC_WIDTH-1 downto 0) := (others => '0');
 
    -- ROM address & data wires
    signal rom_addr       : unsigned(5 downto 0) := (others => '0');
    signal rom_data       : signed(DATA_WIDTH-1 downto 0);
 
begin
 
    -- Instantiate coefficient ROM
    coeff_rom_inst: filter_rom
        port map (
            addr     => rom_addr,
            data_out => rom_data
        );
        
    process(clk, reset)
    -- Perform FIR convolution
    variable acc_var : signed(ACC_WIDTH - 1 downto 0) := (others => '0');
    
    begin
        if reset = '1' then
            -- Clear all on reset
            sample_count   <= 0;
            sample_history <= (others => (others => '0'));
            coeff_buffer   <= (others => (others => '0'));
            sum_acc        <= (others => '0');
            data_out       <= (others => '0');
            rom_addr       <= (others => '0');
 
        elsif rising_edge(clk) then
            if sample_valid = '1' then
 
                if sample_count < TAP_COUNT then
                    -- Warm-up: load samples and fetch/store each coeff
                    sample_history(sample_count) <= data_in;
                    rom_addr <= to_unsigned(sample_count, rom_addr'length);
                    coeff_buffer(sample_count) <= rom_data;
                    sample_count <= sample_count + 1;
 
                else
                    -- Steady-state: shift history, ingest new, then convolve
 
                    -- Shift right, insert newest sample at index 0
                    sample_history(1 to TAP_COUNT-1) <= sample_history(0 to TAP_COUNT-2);
                    sample_history(0) <= data_in;
                    acc_var := (others => '0');
                    for i in 0 to TAP_COUNT-1 loop
                        acc_var := acc_var
                                   + sample_history(i)
                                   * coeff_buffer(i);
                    end loop;
                    -- Truncate accumulator to produce output
                    --data_out <= acc_var(ACC_WIDTH-1 downto ACC_WIDTH-DATA_WIDTH);
                    data_out <= resize(shift_right(acc_var, 15), 16);
 
                end if;
            end if;
        end if;
    end process;
 
end Behavioral;