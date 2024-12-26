library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end;


architecture a_tb of tb is
    component ULA is
        port( op_a,op_b  :  in unsigned(15 downto 0);
            op_sel :  in unsigned(1 downto 0);
            ula_out : out unsigned(15 downto 0);
            z, n, v : out std_logic
        );
    end component;

    signal op_a,op_b,ula_out : unsigned(15 downto 0);
    signal op_sel : unsigned (1 downto 0);
    signal z, n, v : std_logic;

begin
    uut: ULA port map(  op_a  => op_a,
                        op_b  => op_b,
                        op_sel => op_sel,
                        ula_out => ula_out,
                        z => z,
                        n => n,
                        v => v);
    process
    begin

        op_a <= "0100111000100000";
		op_b <= "0000111000100000";
		op_sel <= "00";
		wait for 10 ns;
        op_a <= "0010010101000000";
		op_b <= "0001001110100000";
		op_sel <= "00";
		wait for 10 ns;

        op_a <= "0100111010000000";
		op_b <= "0001001110100000";
		op_sel <= "01";
		wait for 10 ns;
        op_a <= "1111100000100000";
		op_b <= "1111111110000010";
		op_sel <= "01";
		wait for 10 ns;


        op_a <= "0110111000100000"; --overflow pos - neg
		op_b <= "1110111000100000";
		op_sel <= "01";
		wait for 10 ns;
        op_a <= "0111110100000000"; --overflow pos - neg
		op_b <= "1111110011111000";
		op_sel <= "01";
		wait for 10 ns;

        op_a <= "1111111000100000"; --overflow neg - pos
		op_b <= "0111111001111111";
		op_sel <= "01"; 
		wait for 10 ns;
        op_a <= "1000000100000000"; --overflow neg - pos
		op_b <= "0000001111101000";
		op_sel <= "01"; 
		wait for 10 ns;


        op_a <= "0111111000100000"; --overflow sum pos
		op_b <= "0111111001111111";
		op_sel <= "00";
		wait for 10 ns;
        op_a <= "0111010111100000"; --overflow sum pos
		op_b <= "0010011100010000";
		op_sel <= "00";
		wait for 10 ns;

        op_a <= "1011111111111111"; --overflow sum neg
		op_b <= "1011111111111111";
		op_sel <= "00";
		wait for 10 ns;
        op_a <= "1001001101101000"; --overflow sum neg
		op_b <= "1101100011110000";
		op_sel <= "00";
		wait for 10 ns;

		op_a <= "0100111000100000"; --
		op_b <= "0100111000100000";
		op_sel <= "00";
		wait for 10 ns;
        op_a <= "0100111000100000"; --igual
		op_b <= "0100111000100000";
		op_sel <= "01";
        wait for 10 ns;
        op_a <= "1001110000110101"; --igual
		op_b <= "1001110000110101";
		op_sel <= "01";
		wait for 10 ns;

        op_a <= "0100101000100000";
		op_b <= "0100011010100000";
		op_sel <= "10";
		wait for 10 ns;
        op_a <= "0100101000100000";
		op_b <= "0100011010100000";
		op_sel <= "11";
		wait for 10 ns;
        wait;

    end process;
end architecture;
