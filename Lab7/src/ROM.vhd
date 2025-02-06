library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
   port(
       endereco   : in unsigned(11 downto 0);
       rom_out    : out unsigned(18 downto 0) 
   );
end entity;

architecture a_ROM of ROM is
   type mem is array (0 to 127) of unsigned(18 downto 0);
   constant conteudo_rom : mem := (
      0 => B"0011_001_010_000000110",  --ld r2, 6
      1 => B"0011_001_011_000000010",  --ld r3, 2
      2 => B"0010_000_011_010_000000", --add r3, r2
      3 => B"0011_000_010_000000101",  --addi r2, 5
      4 => B"0011_001_100_000011110",  --ld r4, 30
                                       
      5 => B"0101_001_010_000000_100", --sw r2,(r4)
      6 => B"0101_000_001_000000_100", --lw r1,(r4)

      7 => B"0101_001_100_000001_011", --sw r4,(r3)
      8 => B"0101_000_010_000001_011", --lw r2,(r3)

      others => (others=>'0') --casos omissos => (zero em todos os bits) 
   );
   
begin
   rom_out <= conteudo_rom(to_integer(endereco)); --sem clk pra ler
end architecture;