library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

entity write_on_file is
    generic (
        DATA_LENGTH : integer := 32
    );
    Port (
        clk    : in std_logic;
        enable : in std_logic;
        data   : in signed(DATA_LENGTH - 1 downto 0)
    );
end write_on_file;

architecture Behavioral of write_on_file is
    file output_file : text open write_mode is "D:\reconfigurable-computing\TP3\scripts\filtered_output.txt";
    variable line_out : line;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if enable = '1' then
                write(line_out, integer'image(to_integer(data)));
                writeline(output_file, line_out);
            end if;
        end if;
    end process;
end Behavioral;
