library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
   port( clk, rd_en : in std_logic;
         endereco   : in unsigned(11 downto 0);
         dado       : out unsigned(18 downto 0) 
   );
end entity;

architecture a_ROM of ROM is
   type mem is array (0 to 127) of unsigned(18 downto 0);
   constant conteudo_rom : mem := (
      0  => "0000000000000000010",
      1  => "0000000100000000000",
      2  => B"0001_000_000000000110", --jump to 6
      3  => "0000000000000001000",
      4  => "0000000100000000000",
      5  => "0000000000000000010",
      6  => "0000000111100000011",
      7  => "0000000000000000010",
      8  => B"0001_000_000000000111", --jumpt to 7 (loop)
      9  => "0000000000000000000",
      10 => "0000000000000000000",
      others => (others=>'0') --casos omissos => (zero em todos os bits)
   );
   
begin
   process(clk)
   begin
      if(rd_en='1') then
         if (rising_edge(clk)) then
            dado <= conteudo_rom(to_integer(endereco));
         end if;
      end if;
   end process;
end architecture;