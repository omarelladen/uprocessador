library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux16 is 
    port (
        entr0,entr1,entr2,entr3 : in unsigned (15 downto 0);
        sel : in unsigned (1 downto 0);
        
        mux_out : out unsigned (15 downto 0)
    );
end entity;

architecture a_mux16 of mux16 is
begin
    mux_out <= entr0 when sel = "00" else
              entr1 when sel = "01" else
              entr2 when sel = "10" else
              entr3 when sel = "11" else
              "0000000000000000"; 
end architecture;