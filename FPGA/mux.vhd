library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux is 
    port (
        entr0,entr1 : in std_logic;
        sel : in std_logic;
        mux_out : out std_logic
    );
end entity;

architecture a_mux of mux is
begin
    mux_out <= entr0 when sel = '0' else
               entr1 when sel = '1' else
               '0'; 
end architecture;