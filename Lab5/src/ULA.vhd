library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
   port(
        op_a,op_b  :  in unsigned(15 downto 0);
        op_sel :  in unsigned(1 downto 0);

        ula_out : out unsigned(15 downto 0);
        z, n, v : out std_logic
   );
end entity;


architecture a_ULA of ULA is

component mux16 is 
port (
    entr0,entr1,entr2,entr3 : in unsigned (15 downto 0);
    sel : in unsigned (1 downto 0);
    mux_out : out unsigned (15 downto 0)
);
end component;

signal sum, sub, bitwise_or, bitwise_and, mux_out_s: unsigned (15 downto 0);

begin
    mux : mux16 port map (
        entr0 => sum,
		entr1 => sub,
		entr2 => bitwise_or,
        entr3 => bitwise_and,
		sel => op_sel,
		mux_out => mux_out_s
    );

    sum <= op_a + op_b;
    sub <= op_a - op_b;
    bitwise_or <= op_a or op_b;
    bitwise_and <= op_a and op_b;

    z <= '1' when mux_out_s = 0 else
         '0';

    n <= mux_out_s(15);

    ula_out <= mux_out_s;

    -- overflow
    v <= '1' when (op_a(15) /= op_b(15)) and (op_a(15) /= mux_out_s(15)) else '0';

    
end architecture;