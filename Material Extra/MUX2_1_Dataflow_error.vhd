library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX2_1_Dataflow is
    Port ( sel : in STD_LOGIC;
           a   : in STD_LOGIC;
           b   : in STD_LOGIC;
           y   : out STD_LOGIC);
end MUX2_1_Dataflow;

architecture Dataflow of MUX2_1_Dataflow is
begin
    -- ERROR: Missing 'when' in the select statement
    with sel select
        y <= a, '0' => b when '1';
end Dataflow;

