library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity simple_ram is
    generic (
        MEM_DEPTH   : integer := 1024; -- número de posições da RAM
        DATA_BITS   : integer := 16;   -- largura dos dados em bits
        ADDR_BITS   : integer := 10    -- largura do endereço em bits
    );
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;         -- reset síncrono para zerar a RAM (opcional)
        we          : in  std_logic;         -- write enable
        addr        : in  unsigned(ADDR_BITS - 1 downto 0);
        data_in     : in  signed(DATA_BITS - 1 downto 0);
        data_out    : out signed(DATA_BITS - 1 downto 0)
    );
end simple_ram;

architecture rtl of simple_ram is

    -- Definição do array da RAM
    type memory_array is array (0 to MEM_DEPTH - 1) of signed(DATA_BITS - 1 downto 0);
    signal mem : memory_array := (others => (others => '0'));

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                -- opcional: zera toda a RAM no reset
                for i in 0 to MEM_DEPTH - 1 loop
                    mem(i) <= (others => '0');
                end loop;
                data_out <= (others => '0');
            else
                if we = '1' then
                    -- Escrita na RAM na posição addr
                    mem(to_integer(addr)) <= data_in;
                end if;

                -- Leitura assíncrona, sempre disponível
                data_out <= mem(to_integer(addr));
            end if;
        end if;
    end process;

end rtl;
