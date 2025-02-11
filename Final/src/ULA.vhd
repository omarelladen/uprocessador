library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
    port(
        op_a,op_b :  in unsigned(15 downto 0);
        op_sel : in unsigned(1 downto 0);
        ula_out : out unsigned(15 downto 0);
        z, n, v : out std_logic
    );
end entity;


architecture a_ULA of ULA is
component mux16 is 
port(
    entr0,entr1,entr2,entr3 : in unsigned (15 downto 0);
    sel : in unsigned (1 downto 0);
    mux_out : out unsigned (15 downto 0)
);
end component;

signal sum, sub, bitwise_or, bitwise_and, ula_out_s: unsigned (15 downto 0);

begin

    ula_out_s <= (op_a  +  op_b) when op_sel = "00" else
                 (op_a  -  op_b) when op_sel = "01" else
                 (op_a or  op_b) when op_sel = "10" else -----manter ???????????????????????????????????????
                 (op_a and op_b) when op_sel = "11" else -----manter ???????????????????????????????????????
                 "0000000000000000"; 

    --zero
    z <= '1' when ula_out_s = 0 else '0';

    --neg
    n <= ula_out_s(15);

    --overflow
    v <= '1' when (op_a(15) /= op_b(15)) and (op_a(15) /= ula_out_s(15)) else '0';


    ula_out <= ula_out_s;

end architecture;