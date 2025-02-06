library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
	port( 
		clk, wr_en : in std_logic;
		endereco : in unsigned(15 downto 0);-------65536=2^16
		data_in : in unsigned(15 downto 0);
		data_out : out unsigned(15 downto 0) 
   );
end entity;

architecture a_RAM of RAM is
    type mem is array (0 to 65536) of unsigned(15 downto 0);
    signal conteudo_ram : mem;
begin
	process(clk,wr_en)
	begin
		if rising_edge(clk) then
			if wr_en='1' then
				conteudo_ram(to_integer(endereco)) <= data_in;
        	end if;
      	end if;
    end process;

	data_out <= conteudo_ram(to_integer(endereco));

end architecture;