library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity filter_rom is
    Port ( 
        addr : in unsigned(5 downto 0);
        data_out : out signed(15 downto 0)
    );
end filter_rom;

architecture Behavioral of filter_rom is 

    type coeff_array is array (0 to 50) of signed(15 downto 0);

    constant coeffs : coeff_array := (
        signed("1111111110101011"),
        signed("1111111110110001"),
        signed("1111111110110011"),
        signed("1111111110110101"),
        signed("1111111110111001"),
        signed("1111111111000100"),
        signed("1111111111011000"),
        signed("1111111111111010"),
        signed("0000000000101011"),
        signed("0000000001101111"),
        signed("0000000011000110"),
        signed("0000000100110000"),
        signed("0000000110101101"),
        signed("0000001000111011"),
        signed("0000001011011000"),
        signed("0000001101111111"),
        signed("0000010000101101"),
        signed("0000010011011101"),
        signed("0000010110001010"),
        signed("0000011000101101"),
        signed("0000011011000010"),
        signed("0000011101000100"),
        signed("0000011110101110"),
        signed("0000011111111100"),
        signed("0000100000101100"),
        signed("0000100000111101"),
        signed("0000100000101100"),
        signed("0000011111111100"),
        signed("0000011110101110"),
        signed("0000011101000100"),
        signed("0000011011000010"),
        signed("0000011000101101"),
        signed("0000010110001010"),
        signed("0000010011011101"),
        signed("0000010000101101"),
        signed("0000001101111111"),
        signed("0000001011011000"),
        signed("0000001000111011"),
        signed("0000000110101101"),
        signed("0000000100110000"),
        signed("0000000011000110"),
        signed("0000000001101111"),
        signed("0000000000101011"),
        signed("1111111111111010"),
        signed("1111111111011000"),
        signed("1111111111000100"),
        signed("1111111110111001"),
        signed("1111111110110101"),
        signed("1111111110110011"),
        signed("1111111110110001"),
        signed("1111111110101011") 
    );

begin
    data_out <= coeffs(to_integer(addr));
end Behavioral;
