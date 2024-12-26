library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
   port( endereco   : in unsigned(11 downto 0);
         rom_out       : out unsigned(18 downto 0) 
   );
end entity;

architecture a_ROM of ROM is
   type mem is array (0 to 127) of unsigned(18 downto 0);
   constant conteudo_rom : mem := (
      --0  => B"0000_000_000_000000000", --nop no inicio
      0  => B"0011_001_010_000000101",  --A. ld r2, 5
      1  => B"0011_001_011_000001000",  --B. ld r3, 8
      2  => B"0010_010_100_010_000000", --C. mov r4, r2
      3  => B"0010_000_100_011_000000",    --add r4, r3
      4  => B"0011_001_001_000000001",  --D. ld r1, 1
      5  => B"0010_001_100_001_000000",    --sub r4, r1
      6  => B"0001_000_000000010100",   --E. jump 20
      
      19 => B"0011_001_100_000000000",  --F. ld r4, 0 (n executada)
      20 => B"0010_010_010_100_000000", --G. (endereço 20) mov r2, r4
      21 => B"0001_000_000000000011",   --H. jump 3
      22 => B"0011_001_011_000000000",  --I. ld r3, 0 (n executada)
      others => (others=>'0') --casos omissos => (zero em todos os bits)
   );
   
begin
   rom_out <= conteudo_rom(to_integer(endereco)); --sem clk pra ler
end architecture;